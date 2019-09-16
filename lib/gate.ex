defmodule Gate do
  @moduledoc """
   Write description
  """

  alias Gate.Validator
  alias Gate.Locale

  defstruct params: %{}, schema: %{}, errors: %{}, output: %{}

  def valid?(params, schema) when is_map(schema) do
    %Gate{params: params, schema: schema} |> validate()
  end

  def valid?(attribute, schema), do: Validator.validate(attribute, schema)

  defp validate(%{schema: schema} = result) when schema == %{} do
    if result.errors == %{} do
      {:ok, result.output}
    else
      {:error, result.errors}
    end
  end

  defp validate(tracker) do
    key = tracker.schema |> Map.keys() |> List.first()

    if Map.has_key?(tracker.params, key) do
      if is_map(tracker.schema[key]) do
        case validate(%{tracker | schema: tracker.schema[key], params: tracker.params[key], errors: %{}, output: %{}}) do
          {:ok, nested_params}    -> nested_valid(key, tracker, nested_params)
          {:error, nested_errors} -> nested_invalid(key, tracker, nested_errors)
        end
      else
        case Validator.validate(tracker.params[key], tracker.schema[key]) do
          true -> valid(key, tracker)
          error -> invalid(key, tracker, error)
        end
      end
    else
      if optional?(tracker.schema[key]) do
        validate(tracker |> delete(key))
      else
        missing(key, tracker)
      end
    end
  end

  defp nested_valid(key, tracker, nested_params) do
    validate(%{tracker |> delete(key) | output: tracker.output |> Map.put(key, nested_params)})
  end

  defp nested_invalid(key, tracker, nested_errors) do
    validate(%{tracker |> delete(key) | errors: tracker.errors |> Map.put(key, nested_errors)})
  end

  defp valid(key, tracker) do
    validate(%{tracker |> delete(key) | output: tracker.output |> Map.put(key, tracker.params[key])})
  end

  defp invalid(key, tracker, error) do
    validate(%{tracker |> delete(key) | errors: tracker.errors |> Map.put(key, error)})
  end

  defp missing(key, tracker) do
    validate(
      %{tracker |> delete(key) | errors: tracker.errors |> Map.put(key, Locale.get("missing"))})
  end

  defp optional?(validations) when is_list(validations), do: Enum.member?(validations, :optional)
  defp optional?(validation), do: validation == :optional

  defp delete(tracker, key), do: %{ tracker | schema: tracker.schema |> Map.delete(key)}
end

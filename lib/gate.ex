defmodule Gate do
  alias Gate.Validator
  alias Gate.Locale

  def valid?(param, schema, atomize \\ false)
  def valid?(params, schema, atomize) when is_map(schema) do
    validate(schema, params, %{}, %{}, atomize)
  end

  def valid?(attribute, schema, _atomize), do: Validator.validate(attribute, schema)

  defp validate(schema, _params, errors, new_params, _atomize) when schema == %{} do
    if errors == %{} do
      {:ok, new_params}
    else
      {:error, errors}
    end
  end

  defp validate(schema, params, errors, new_params, atomize) do
    key = schema |> Map.keys() |> List.first()

    if Map.has_key?(params, key) do
      if is_map(schema[key]) do
        case validate(schema[key], params[key], %{}, %{}, atomize) do
          {:ok, nested_params} ->
            nested_valid(key, schema, params, errors, new_params, nested_params, atomize)

          {:error, nested_errors} ->
            nested_invalid(key, schema, params, errors, nested_errors)
        end
      else
        case Validator.validate(params[key], schema[key]) do
          true -> valid(key, schema, params, errors, new_params, atomize)
          error -> invalid(key, schema, params, errors, error)
        end
      end
    else
      if optional?(schema[key]) do
        validate(schema |> Map.delete(key), params, errors, new_params, atomize)
      else
        missing(key, schema, params, errors)
      end
    end
  end

  defp nested_valid(key, schema, params, errors, new_params, nested_params, atomize) do
    validate(schema |> Map.delete(key), params, errors, new_params |> put(key, nested_params, atomize), atomize)
  end

  defp nested_invalid(key, schema, params, errors, nested_errors) do
    validate(schema |> Map.delete(key), params, errors |> Map.put(key, nested_errors), %{}, false)
  end

  defp valid(key, schema, params, errors, new_params, atomize) do
    validate(schema |> Map.delete(key), params, errors, new_params |> put(key, params[key], atomize), atomize)
  end

  defp invalid(key, schema, params, errors, error) do
    validate(schema |> Map.delete(key), params, errors |> Map.put(key, error), %{}, false)
  end

  defp missing(key, schema, params, errors) do
    validate(
      schema |> Map.delete(key),
      params,
      errors |> Map.put(key, Locale.get("missing")),
      %{},
      false
    )
  end

  defp put(target, key, new, true = _atomize), do: Map.put(target, String.to_atom(key), new)
  defp put(target, key, new, false = _atomize), do: Map.put(target, key, new)


  defp optional?(validations) when is_list(validations), do: Enum.member?(validations, :optional)
  defp optional?(validation), do: validation == :optional
end

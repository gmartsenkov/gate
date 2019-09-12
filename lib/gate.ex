defmodule Gate do
  alias Gate.Validator
  alias Gate.Locale

  def valid?(schema, params) do
    validate(schema, params, %{}, %{})
  end

  defp validate(schema, _params, errors, new_params) when schema == %{} do
    if errors == %{} do
      {:ok, new_params}
    else
      {:error, errors }
    end
  end

  defp validate(schema, params, errors, new_params) do
    key = schema |> Map.keys |> List.first

    if Map.has_key?(params, key) do
      if is_map(schema[key]) do
	case validate(schema[key], params[key], %{}, %{}) do
	  {:ok, nested_params} -> nested_valid(key, schema, params, errors, new_params, nested_params)
	  {:error, nested_errors} -> nested_invalid(key, schema, params, errors, nested_errors)
	end
      else
	case Validator.validate(params[key], schema[key]) do
	  true -> valid(key, schema, params, errors, new_params)
	  error -> invalid(key, schema, params, errors, error)
	end
      end
    else
      missing(key, schema, params, errors)
    end
  end

  defp nested_valid(key, schema, params, errors, new_params, nested_params) do
    validate(schema |> Map.delete(key), params, errors, new_params |> Map.put(key, nested_params))
  end

  defp nested_invalid(key, schema, params, errors, nested_errors) do
    validate(schema |> Map.delete(key), params, errors |> Map.put(key, nested_errors), %{})
  end

  defp valid(key, schema, params, errors, new_params) do
    validate(schema |> Map.delete(key), params, errors, new_params |> Map.put(key, params[key]))
  end

  defp invalid(key, schema, params, errors, error) do
    validate(schema |> Map.delete(key), params, errors |> Map.put(key, error), %{})
  end

  defp missing(key, schema, params, errors) do
    validate(schema |> Map.delete(key), params, errors |> Map.put(key, Locale.get("missing")), %{})
  end
end

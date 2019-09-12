defmodule ParamValidator do
  alias ParamValidator.Validator
  alias ParamValidator.Locale

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
	  {:ok, nested_params} ->
	    validate(schema |> Map.delete(key), params, errors, new_params |> Map.put(key, nested_params))
	  {:error, nested_errors} ->
	    validate(schema |> Map.delete(key), params, errors |> Map.put(key, nested_errors), new_params)
	end
      else
	case Validator.validate(params[key], schema[key]) do
	  true ->
	    validate(schema |> Map.delete(key), params, errors, new_params |> Map.put(key, params[key]))
	  error ->
	    validate(schema |> Map.delete(key), params, errors |> Map.put(key, error), new_params)
	end
      end
    else
      validate(schema |> Map.delete(key), params, errors |> Map.put(key, Locale.get("missing")), new_params)
    end
  end
end

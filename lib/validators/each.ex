defmodule Gate.Validators.Each do
  @moduledoc false

  alias Gate.Locale

  defmacro __using__(_opts) do
    quote do
      def validate([head|tail] = value, {:each, option}) when is_map(option) do
	validate_list(value, 0, option, %{})
      end

      def validate([head|tail] = value, {:each, option}) do
	with true <- validate(head, option)
	  do
	  validate(tail, {:each, option})
	end
      end

      def validate([], {:each, _option}), do: true
      def validate(value, {:each, _options}), do: Locale.get("list", value)

      defp validate_list([head|tail], num, option, errors) do
	case Gate.valid?(head, option) do
	  {:ok, _params} -> validate_list(tail, num + 1, option, errors)
	  {:error, new_error} ->
	    validate_list(tail, num + 1, option, errors |> Map.put("#{num}", new_error))
	end
      end

      defp validate_list([], num, option, errors) when errors == %{}, do: true
      defp validate_list([], num, option, errors) when errors != %{}, do: errors
    end
  end
end

defmodule Gate.Validators.Each do
  @moduledoc false

  alias Gate.Locale

  defmacro __using__(_opts) do
    quote do
      def validate([head|tail] = value, {:each, option}) when is_map(option) do
	case Gate.valid?(head, option) do
	  {:ok, _params} -> true
	  {:error, errors} -> errors
	end
      end

      def validate([head|tail] = value, {:each, option}) do
	with true <- validate(head, option)
	  do
	  validate(tail, {:each, option})
	end
      end

      def validate([], {:each, _option}), do: true
      def validate(value, {:each, _options}), do: Locale.get("list", value)
    end
  end
end

defmodule Gate.Validators.Generic do
  alias Gate.Locale

  defmacro __using__(_opts) do
    quote do
      def validate(value, {:equal, expected}) do
        if value == expected, do: true, else: Locale.get("equal", [value, expected])
      end

      def validate(value, {:not_equal, expected}) do
        if value != expected,
          do: true,
          else: Locale.get("not_equal", [value, expected])
      end

      def validate(value, {:include, list}) do
        if Enum.member?(list, value),
          do: true,
          else: Locale.get("include", [value, list])
      end

      def validate(value, {:custom, function }) when is_function(function) do
	case function.(value) do
	  {:locale, name, args} -> Locale.get(name, args)
	  value -> value
	end
      end
    end
  end
end

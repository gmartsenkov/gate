defmodule ParamValidator.Validators.Generic do
  alias ParamValidator.Locale

  defmacro __using__(opts) do
    quote do
      def validate(value, {:equal, expected}) do
	if value == expected, do: true, else: Locale.get_and_replace("equal", [value, expected])
      end

      def validate(value, {:not_equal, expected}) do
	if value != expected, do: true, else: Locale.get_and_replace("not_equal", [value, expected])
      end

      def validate(value, {:include, list}) do
	if Enum.member?(list, value), do: true, else: Locale.get_and_replace("include", [value, list])
      end

    end
  end
end

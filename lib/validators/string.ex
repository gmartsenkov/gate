defmodule Gate.Validators.String do
  alias Gate.Locale

  defmacro __using__(_opts) do
    quote do
      def validate(value, {:regex, reg_expression}) do
	if Regex.match?(reg_expression, value), do: true, else: Locale.get("regex", [value])
      end
    end
  end
end

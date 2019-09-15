defmodule Gate.Validators.String do
  @moduledoc false

  alias Gate.Locale

  defmacro __using__(_opts) do
    quote do
      def validate(value, {:regex, reg_expression}) do
        if Regex.match?(reg_expression, value), do: true, else: Locale.get("regex", [value])
      end

      def validate(value, {:regex, reg_expression, custom_locale}) do
        if Regex.match?(reg_expression, value), do: true, else: Locale.get(custom_locale, [value])
      end
    end
  end
end

defmodule Gate.Validators.String do
  alias Gate.Locale

  def validate(value, {:regex, reg_expression}) do
    if Regex.match?(reg_expression, value), do: true, else: Locale.get_and_replace("regex", [value])
  end
end

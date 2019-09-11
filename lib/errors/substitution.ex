defmodule ParamValidator.Errors.Substitution do
  alias ParamValidator.Errors.Format

  def substitute(text, [value|tail]) do
    String.replace(text, "{}", "#{Format.call(value)}", global: false)
    |> substitute(tail)
  end

  def substitute(text, []), do: text
end

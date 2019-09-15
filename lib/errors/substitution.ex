defmodule Gate.Errors.Substitution do
  @moduledoc false
  alias Gate.Errors.Format

  def substitute(text, [value | tail]) do
    String.replace(text, "{}", "#{Format.call(value)}", global: false)
    |> substitute(tail)
  end

  def substitute(text, []), do: text

  def substitute(text, value) do
    String.replace(text, "{}", "#{Format.call(value)}", global: false)
  end
end

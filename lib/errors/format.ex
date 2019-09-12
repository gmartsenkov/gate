defmodule Gate.Errors.Format do
  def call([_h|_t] = value), do: "[#{Enum.join(value, ", ")}]"
  def call(value), do: value
end

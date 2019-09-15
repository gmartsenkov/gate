defmodule Gate.Errors.Format do
  @moduledoc false

  def call([_h | _t] = value), do: "[#{Enum.join(value, ", ")}]"
  def call(value), do: value
end

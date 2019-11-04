defmodule Gate.Validators.Numbers do
  @moduledoc false

  alias Gate.Locale

  defmacro __using__(_opts) do
    quote do
      def validate(value, {:greater_then, target}) do
	with true <- validate(value, :number) do
	  if value > target, do: true, else: Locale.get("greater_then", [value, target])
	end
      end
    end
  end
end

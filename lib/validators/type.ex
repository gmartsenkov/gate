defmodule Gate.Validators.Type do
  @moduledoc false
  alias Gate.Locale

  defmacro __using__(_opts) do
    quote do
      def validate(value, :int), do: if(is_integer(value), do: true, else: Locale.get("int", value))
      def validate(value, :str), do: if(is_binary(value), do: true, else: Locale.get("str", value))
      def validate(value, :float), do: if(is_float(value), do: true, else: Locale.get("float", value))
      def validate(value, :list), do: if(is_list(value), do: true, else: Locale.get("list", value))
      def validate(value, :atom), do: if(is_atom(value), do: true, else: Locale.get("atom", value))
      def validate(value, :bool), do: if(is_boolean(value), do: true, else: Locale.get("bool", value))
      def validate(value, :map), do: if(is_map(value), do: true, else: Locale.get("map", value))
      def validate(value, :tuple), do: if(is_tuple(value), do: true, else: Locale.get("tuple", value))
      def validate(value, :optional), do: true
    end
  end
end

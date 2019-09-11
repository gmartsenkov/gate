defmodule ParamValidator.Validators.Type do
  alias ParamValidator.Locale
  def validate(value, :int), do: if is_integer(value), do: true, else: Locale.get("int")
  def validate(value, :str), do: if is_binary(value), do: true, else: Locale.get("str")
  def validate(value, :float), do: if is_float(value), do: true, else: Locale.get("float")
  def validate(value, :list), do: if is_list(value), do: true, else: Locale.get("list")
  def validate(value, :atom), do: if is_atom(value), do: true, else: Locale.get("atom")
  def validate(value, :bool), do: if is_boolean(value), do: true, else: Locale.get("bool")
  def validate(value, :map), do: if is_map(value), do: true, else: Locale.get("map")
  def validate(value, :tuple), do: if is_tuple(value), do: true, else: Locale.get("tuple")
end

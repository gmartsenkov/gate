defmodule Gate.Validator do
  use Gate.Validators.Type
  use Gate.Validators.Generic

  def validate(value, validations, result \\ [])

  def validate(value, [head | tail], result) do
    validate(value, tail, result |> List.insert_at(-1, validate(value, head)))
  end

  def validate(_value, [], result) do
    errors = result |> Enum.filter(&(&1 != true))
    if errors == [], do: true, else: errors
  end
end

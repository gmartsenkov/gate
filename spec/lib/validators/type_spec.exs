defmodule ParamValidator.Validators.TypeSpec do
  use ESpec

  @type_tests [
    %{ type: :int, valid_value: 1, wrong_value: "string", error: "Value is not an integer" },
    %{ type: :str, valid_value: "string", wrong_value: 1, error: "Value is not a string" },
    %{ type: :float, valid_value: 1.5, wrong_value: 1, error: "Value is not a float" },
    %{ type: :list, valid_value: [], wrong_value: 1, error: "Value is not an array" },
    %{ type: :atom, valid_value: :a, wrong_value: 1, error: "Value is not an atom" },
    %{ type: :bool, valid_value: true, wrong_value: nil, error: "Value is not a boolean" },
    %{ type: :map, valid_value: %{}, wrong_value: 1, error: "Value is not a hash" }
  ]

  Enum.map(@type_tests, fn(data) ->
    context "when value is an #{data.type}" do
      it "returns true" do
	expect(described_module().validate(unquote(Macro.escape(data.valid_value)), unquote(data.type)))
	|> to(eq true)
      end
    end

    context "when value is not an #{data.type}" do
      it "returns the error" do
	expect(described_module().validate(unquote(data.wrong_value), unquote(data.type)))
	|> to(eq unquote(data.error))
      end
    end
  end)
end

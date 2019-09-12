defmodule ParamValidator.ValidatorSpec do
  use ESpec

  describe "validate with a list" do
    subject do: described_module().validate(value(), validations())

    let :value, do: "test"

    context "when validations don't pass" do
      let :validations, do: [:int, {:equal, 5}, {:equal, "test"}]

      it "concatenates the errors correctly" do
	expect subject()
	|> to(eq ["Value is not an integer", "test is not equal to 5"])
      end
    end

    context "when validations don't pass" do
      let :validations, do: [:str, {:equal, "test"}]

      it "concatenates the errors correctly" do
	expect subject()
	|> to(eq true)
      end
    end
  end
end

defmodule ParamValidator.Validators.StringSpec do
  use ESpec

  subject do: described_module()

  describe "regex" do
    context "when the value matches the regural expression" do
      it "returns true" do
	expect(subject().validate("aba", {:regex, ~r/aba/}))
	|> to(eq true)
      end
    end

    context "when the value does not match the regural expression" do
      it "returns true" do
	expect(subject().validate("abd", {:regex, ~r/aba/}))
	|> to(eq "abd does not match the regural expression")
      end
    end
  end
end

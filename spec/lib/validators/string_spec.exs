defmodule Gate.Validators.StringSpec do
  use ESpec
  use Gate.Validators.String

  describe "regex" do
    context "when the value matches the regural expression" do
      it "returns true" do
	expect(validate("aba", {:regex, ~r/aba/}))
	|> to(eq true)
      end
    end

    context "when the value does not match the regural expression" do
      it "returns true" do
	expect(validate("abd", {:regex, ~r/aba/}))
	|> to(eq "abd does not match the regural expression")
      end
    end

    context "when a custom locale is passed" do
      it "returns true" do
	expect(validate("abd", {:regex, ~r/aba/, "insecure_password"}))
	|> to(eq "Password needs to be at least 8 characters")
      end
    end
  end
end

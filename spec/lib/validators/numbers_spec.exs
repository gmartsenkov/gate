defmodule Gate.Validators.NumbersSpec do
  use ESpec
  use Gate.Validators.Type
  use Gate.Validators.Numbers

  describe "greater_then" do
    context "when value passed is not an integer" do
      it "returns the correct error" do
	expect(validate("str", {:greater_then, 10}))
	|> to(eq "Value is not a number")
      end
    end

    context "when value is greater then the target" do
      it "returns true" do
	expect(validate(11, {:greater_then, 10}))
	|> to(eq true)
      end
    end

    context "when value is not greater then the target" do
      it "returns true" do
	expect(validate(9, {:greater_then, 10}))
	|> to(eq "9 is not greater then 10")
      end
    end
  end
end

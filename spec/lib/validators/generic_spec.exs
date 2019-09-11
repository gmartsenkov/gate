defmodule ParamValidator.Validators.GenericSpec do
  use ESpec

  subject do: described_module()

  describe "equal" do
    context "when values match" do
      it "returns true" do
	expect(subject().validate(1, {:equal, 1}))
	|> to(eq true)
      end
    end

    context "when values don't match" do
      it "returns false" do
	expect(subject().validate(1, {:equal, 2}))
	|> to(eq "1 is not equal to 2")
      end
    end
  end

  describe "not_equal" do
    context "when values don't match" do
      it "returns true" do
	expect(subject().validate(1, {:not_equal, 2}))
	|> to(eq true)
      end
    end

    context "when values match" do
      it "returns false" do
	expect(subject().validate(1, {:not_equal, 1}))
	|> to(eq "1 is equal to 1")
      end
    end
  end

  describe "include" do
    context "when value is part of the list" do
      it "returns true" do
	expect(subject().validate("b", {:include, ["a","b","c"]}))
	|> to(eq true)
      end
    end

    context "when value is part of the list" do
      it "returns true" do
	expect(subject().validate("d", {:include, ["a","b","c"]}))
	|> to(eq "d is not part of [a, b, c]")
      end
    end
  end
end

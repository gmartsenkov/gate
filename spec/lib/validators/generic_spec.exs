defmodule Gate.Validators.GenericSpec do
  use ESpec
  use Gate.Validators.Generic

  describe "equal" do
    context "when values match" do
      it "returns true" do
	expect(validate(1, {:equal, 1}))
	|> to(eq true)
      end
    end

    context "when values don't match" do
      it "returns false" do
	expect(validate(1, {:equal, 2}))
	|> to(eq "1 is not equal to 2")
      end
    end
  end

  describe "not_equal" do
    context "when values don't match" do
      it "returns true" do
	expect(validate(1, {:not_equal, 2}))
	|> to(eq true)
      end
    end

    context "when values match" do
      it "returns false" do
	expect(validate(1, {:not_equal, 1}))
	|> to(eq "1 is equal to 1")
      end
    end
  end

  describe "include" do
    context "when value is part of the list" do
      it "returns true" do
	expect(validate("b", {:include, ["a","b","c"]}))
	|> to(eq true)
      end
    end

    context "when value is part of the list" do
      it "returns true" do
	expect(validate("d", {:include, ["a","b","c"]}))
	|> to(eq "d is not part of [a, b, c]")
      end
    end
  end

  describe "custom" do
    let :custom_func do
      fn(val) ->
	if val == 1, do: true, else: "Custom error"
      end
    end

    context "when value matches" do
      it "returns true" do
	expect(validate(1, {:custom, custom_func()}))
	|> to(eq true)
      end
    end

    context "when value does not match" do
      it "returns the error" do
	expect(validate(2, {:custom, custom_func()}))
	|> to(eq "Custom error")
      end
    end

    context "when func returns a locale on missmatch" do
      let :custom_func do
	fn(val) ->
	  if val == 1, do: true, else: {:locale, "custom_func", val}
	end
      end

      context "when value matches" do
	it "returns true" do
	  expect(validate(1, {:custom, custom_func()}))
	  |> to(eq true)
	end
      end

      context "when value does not match" do
	it "returns the error" do
	  expect(validate(2, {:custom, custom_func()}))
	  |> to(eq "2 does not match 1")
	end
      end
    end
  end
end

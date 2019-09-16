defmodule Gate.Validators.EachSpec do
  use ESpec
  use Gate.Validators.Each
  use Gate.Validators.Type
  use Gate.Validators.Generic

  describe "each" do
    context "when the value is not a list" do
      it "returns the correct error" do
	expect(validate(1, {:each, :int}))
	|> to(eq ("Value is not a list"))
      end
    end

    context "when value is a list" do
      context "when value match the requirement" do
	it "returns true" do
	  expect(validate([1,2,3], {:each, :int}))
	  |> to(eq true)
	end
      end

      context "when value does not match the requirement" do
	it "returns the correct error" do
	  expect(validate([1,"str",3], {:each, :int}))
	  |> to(eq "Value is not an integer")
	end
      end

      context "works with include rule" do
	context "when value match the requirement" do
	  it "returns true" do
	    expect(validate(["a", "b"], {:each, {:include, ["a", "b", "c"]} }))
	    |> to(eq true)
	  end
	end

	context "when value does not match the requirement" do
	  it "returns the correct error" do
	    expect(validate(["z", "b"], {:each, {:include, ["a", "b", "c"]} }))
	    |> to(eq "z is not part of [a, b, c]")
	  end
	end
      end

      context "works with custom functions" do
	let :custom_func do
	  fn(val) ->
	    if val == 1, do: true, else: "Custom error"
	  end
	end

	context "when value match the requirement" do
	  it "returns true" do
	    expect(validate([1,1,1], {:each, {:custom, custom_func()} }))
	    |> to(eq true)
	  end
	end

	context "when value does not match the requirement" do
	  it "returns the correct error" do
	    expect(validate([1,1,3], {:each, {:custom, custom_func()} }))
	    |> to(eq "Custom error")
	  end
	end
      end

      context "when passing a map" do
	context "when value match the requirement" do
	  it "returns true" do
	    inner = %{"id" => :int, "type"=> {:equal, "user"}}
	    expect(validate([%{"id" => 1, "type" => "user"}], {:each, inner}))
	    |> to(eq true)
	  end
	end

	context "when value match the requirement" do
	  it "returns true" do
	    inner = %{"id" => :int, "type"=> {:equal, "user"}}
	    expect(validate([%{"id" => 1, "type" => "admin"}], {:each, inner}))
	    |> to(eq %{"type" => "admin is not equal to user"})
	  end
	end
      end
    end
  end
end

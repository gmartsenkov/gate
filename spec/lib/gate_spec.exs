defmodule GateSpec do
  use ESpec

  describe "valid?" do
    subject do: described_module().valid?(params(), schema())

    let :schema do
      %{
	"int" => [:int, {:equal, 1}],
	"string" => :str,
	"boolean1" => :optional,
	"boolean2" => [:bool, :optional],
	"users" => {:each,
          %{ "id" => :int, "type" => {:equal, "user"}}
        },
	"nested" => %{
	  "float" => :float,
	  "nested2" => %{
	    "list" => :list,
	    "required" => :int
	  }
	}
      }
    end

    context "when params are valid" do
      let :params do
	%{
	  "int" => 1,
	  "string" => "test",
	  "extra" => "won't be included",
	  "users" => [%{"id" => 1, "type" => "user" }],
	  "nested" => %{
	    "float" => 1.5,
	    "extra" => "won't be included",
	    "nested2" => %{
	      "extra" => "won't be included",
	      "list" => [1,2,3],
	      "required" => 2
	    }
	  }
	}
      end

      let :expected do
	%{
	  "int" => 1,
	  "string" => "test",
	  "users" => [%{"id" => 1, "type" => "user" }],
	  "nested" => %{
	    "float" => 1.5,
	    "nested2" => %{
	      "list" => [1,2,3],
	      "required" => 2
	    }
	  }
	}
      end

      it "returns ok and the params" do
	expect(subject())
	|> to(eq {:ok, expected()})
      end
    end

    context "when params are invalid" do
      let :params do
	%{
	  "int" => "fail",
	  "string" => 1,
	  "boolean2" => 2,
	  "extra" => "won't be included",
	  "users" => [
	    %{ "id" => 1, "type" => "admin" },
	    %{ "id" => 2, "type" => "admin" }
	  ],
	  "nested" => %{
	    "float" => 1,
	    "extra" => "won't be included",
	    "nested2" => %{
	      "extra" => "won't be included",
	      "list" => 1
	    }
	  }
	}
      end

      let :expected do
	%{
	  "int" => ["Value is not an integer", "fail is not equal to 1"],
	  "string" => "Value is not a string",
	  "boolean2" => ["Value is not a boolean"],
	  "users" => %{"type" => "admin is not equal to user"},
	  "nested" => %{
	    "float" => "Value is not a float",
	    "nested2" => %{"list" => "Value is not a list", "required" => "Is missing"}
	  }
	}
      end

      it "returns ok and the params" do
	expect(subject())
	|> to(eq {:error, expected()})
      end
    end

    context "when validating a single value" do
      context "when valid" do
	it "returns true" do
	  expect(described_module().valid?(2, [:int, {:equal, 2}]))
	  |> to(eq true)
	end
      end

      context "when valid" do
	it "returns true" do
	  expect(described_module().valid?("test", [:int, {:equal, 2}]))
	  |> to(eq ["Value is not an integer", "test is not equal to 2"])
	end
      end
    end
  end
end

defmodule ParamValidatorSpec do
  use ESpec

  describe "valid?" do
    subject do: described_module().valid?(schema(), params())

    let :schema do
      %{
	"int" => [:int, {:equal, 1}],
	"string" => :str,
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
	  "extra" => "won't be included",
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
	  "nested" => %{
	    "float" => "Value is not a float",
	    "nested2" => %{"list" => "Value is not an array", "required" => "Is missing"}
	  }
	}
      end

      it "returns ok and the params" do
	expect(subject())
	|> to(eq {:error, expected()})
      end
    end
  end
end

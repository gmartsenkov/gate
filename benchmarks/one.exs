schema =
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

valid_params =
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

invalid_params =
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

Benchee.run(
  %{
    "Valid" => fn -> Gate.valid?(schema, valid_params) end,
    "Invalid" => fn -> Gate.valid?(schema, invalid_params) end,
  },
  time: 10,
  memory_time: 2
)

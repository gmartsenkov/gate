# Gate

This is a simple API for validating data structures, mostly from user input like web forms or API requests.

Example:

```elixir
  @schema %{
    "name" => :str
    "age" => :int,
	"gender" => {:include, ["male", "female"]},
	"more_info" => %{
	  "telefone" => [:str, {:regex, ~r/custom_regex/}],
	  "address" => [:optional, :str]
	}
  }
  
  form_data = %{
	"name" => "Jon",
	"age" => 21,
	"gender" => "male",
	"exra_field" => "something", # It'll be ignored
	"more_info" => %{
	  "telefone" => "custom_regex",
	}
  }
  
  Gate.valid?(form_data, @schema)
  # { 
  #   :ok, 
  #   %{
  #    	"name" => "Jon",
  # 	"age" => 21,
  #	    "gender" => "male",
  #     "more_info" => %{
  #	      "telefone" => "custom_regex",
  #	    }
  #   } 
  # }
```


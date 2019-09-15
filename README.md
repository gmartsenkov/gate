# Gate

This is a simple API for validating data structures, mostly from user input like web forms or API requests.

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)

## Installation

the package can be installed
by adding `gate` to your list of dependencies in `mix.exs` and run `mix deps.get`:

```elixir
def deps do
  [
    {:gate, "~> 0.1.1"}
  ]
end
```

## Usage
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
  #     "name" => "Jon",
  #     "age" => 21,
  #     "gender" => "male",
  #     "more_info" => %{
  #       "telefone" => "custom_regex",
  #     }
  #   } 
  # }
```


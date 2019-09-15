# Gate

This is a simple API for validating data structures, mostly from user input like web forms or API requests.

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Rules](#rules)
- [Custom Rules](#custom-rules)

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

## Rules

Type checks available:
* `:int`
* `:str`
* `:float`
* `:list`
* `:atom`
* `:bool`
* `:map`
* `:tuple`

**You can make an attribute optional with `:optional`**

More advanced rules are:
* `{ :equal, 5 }` will check if the value is equal to 5
* `{ :not_equal, 5 }` will check if the value is not equal to 5
* `{ :include, ["option1", "option2"]}` will check if the value is in the List
* `{ :regex, ~r/custom_regex/ }` will try and match the value against the Regex

## Custom Rules

Example custom rule without the use of locales:
```elixir
  def custom_rule do
    fn(value) ->
      if value == 1, do: true, else: "Value not equal to 1"
    end
  end
```

If you want to make use of the locales you can do something like:
```elixir
  def custom_rule do
    fn(value) ->
      if value == 1, do: true, else: { :locale, "locale_name" }
      # If you want to use the value in the locale 
      # you can pass it as a third argument like
      # if value == 1, do: true, else: { :locale, "locale_name", value }
    end
  end
```

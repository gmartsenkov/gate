# Gate

This is a simple API for validating data structures, mostly from user input like web forms or API requests.

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Rules](#rules)
- [Custom Rules](#custom-rules)
- [Error Messages](#error-messages)

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

**You can validate a field with multiple rules by using a list - `[:str, {:equal, "spaghetti"}, {:custom, custom_rule()}]`**
## Custom Rules

Example custom rule without the use of locales:
```elixir
  def custom_rule do
    fn(value) ->
      if value == 1, do: true, else: "Value not equal to 1"
    end
  end
  
  Gate.valid(1, {:custom, custom_rule()})
  # true
  Gate.valid(2, {:custom, custom_rule()})
  # "Value not equal to 1"
```

If you want to make use of custom ([Locales](#error-messages)) you can do something like:
```elixir
  def custom_rule do
    fn(value) ->
      if value == 1, do: true, else: { :locale, "custom_rule1" }
      # If you want to use the value in the locale 
      # you can pass it as a third argument like
      # if value == 1, do: true, else: { :locale, "custom_rule1", value }
    end
  end
```

## Error messages
The default error messages are defined in [here](https://github.com/gmartsenkov/gate/blob/master/assets/default_locale.json).
They can be overriden by specifying your custom locale file in your `config/config.exs`

``` elixir
# config/config.exs

use Mix.Config
config :gate, locale_file: "assets/locale.json"
```
Example `locale.json`
``` json
{
  "int": "This will override the default int type check error",
  "custom_rule1": "Value does not match custom_rule1",
}
```
Example custom locale that changes the default `:int` rule and also expose the value:
``` json
{
  "int": "{} is not an integer"
}
```
`{}` will be replaced with the value that is being validated
``` elixir
  Gate.valid?("not an integer", :int)
  # "not an integer is not an integer"
```


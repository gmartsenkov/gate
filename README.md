# Gate
[![Hex.pm](https://img.shields.io/hexpm/v/gate.svg)](https://hex.pm/packages/gate)
[![CircleCI](https://circleci.com/gh/gmartsenkov/gate.svg?style=svg)](https://circleci.com/gh/gmartsenkov/gate)

This is a simple API for validating data structures, mostly from user input like web forms or API requests.

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Rules](#rules)
- [Custom Rules](#custom-rules)
- [Error Messages](#error-messages)
- [Licence](#licence)

## Installation

the package can be installed
by adding `gate` to your list of dependencies in `mix.exs` and run `mix deps.get`:

```elixir
def deps do
  [
    {:gate, "~> 0.1.9"}
  ]
end
```

## Usage
Gate's error message handling requires a JSON parser, a decoder must be set in `config/config.exs`

``` elixir
# config/config.exs

use Mix.Config
config :gate, decoder: Poison
```

Example:
```elixir
  @schema %{
    "name" => :str
    "age" => :int,
    "gender" => {:include, ["male", "female"]},
    "pet_names" => {:each, :str},
    "more_info" => %{
      "telefone" => [:str, {:regex, ~r/custom_regex/}],
      "address" => [:optional, :str]
    },
    "relationships" => {:each,
      %{ "id" => :int, "type" => {:equal, "user" } }
    }
  }

  form_data = %{
    "name" => "Jon",
    "age" => 21,
    "gender" => "male",
    "pet_names" => ["jekyll", "hyde"],
    "exra_field" => "something", # It'll be ignored
    "more_info" => %{
      "telefone" => "custom_regex",
    },
    "relationships" => [
      %{ "id" => 1, "type" => "user" },
      %{ "id" => 2, "type" => "user" }
    ]
  }
  
  Gate.valid?(form_data, @schema)
  # { 
  #   :ok, 
  #   %{
  #     "name" => "Jon",
  #     "age" => 21,
  #     "gender" => "male",
  #     "pet_names" => ["jekyll", "hyde"],
  #     "more_info" => %{
  #       "telefone" => "custom_regex",
  #     },
  #    "relationships" => [
  #      %{ "id" => 1, "type" => "user" },
  #      %{ "id" => 2, "type" => "user" }
  #    ]
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
* `:number`

**You can make an attribute optional with `:optional`**

More advanced rules are:
* `{ :equal, 5 }` will check if the value is equal to 5
* `{ :not_equal, 5 }` will check if the value is not equal to 5
* `{ :include, ["option1", "option2"]}` will check if the value is in the List
* `{ :regex, ~r/custom_regex/ }` will try and match the value against the Regex

**You can validate a field with multiple rules by using a list - `[:str, {:equal, "spaghetti"}, {:custom, custom_rule()}]`**

If you wanna check the value of each element in a list you can use `{:each, rule}` for example:
* `{:each, :int}` - will check if all elements are integers
* `{:each, {:include, ["a", "list", "of", "options"]}}` - will check that each value is in the list
* `{:each, %{ "id" => :int} }` - when you pass a map it'll check all elements against that map
## Custom Rules

Example custom rule without the use of locales:
```elixir
  def custom_rule do
    fn(value) ->
      if value == 1, do: true, else: "Value not equal to 1"
    end
  end
  
  Gate.valid?(1, {:custom, custom_rule()})
  # true
  Gate.valid?(2, {:custom, custom_rule()})
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
They can be overridden by specifying your custom locale file in your `config/config.exs`

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
  Gate.valid?("spaghetti", :int)
  # "spaghetti is not an integer"
```

## License

[MIT](LICENSE) &copy; gmartsenkov

defmodule Gate.Locale do
  @moduledoc false
  alias Gate.Errors.Substitution

  @self __MODULE__

  def start_link() do
    Agent.start_link(&locales/0, name: @self)
  end

  def get(key, values \\ []) do
    Agent.get(@self, & &1[key]) |> Substitution.substitute(values)
  end

  defp locales do
    Map.merge(default_locale(), custom_locale_file())
  end

  defp default_locale do
    %{
      "int" => "Value is not an integer",
      "str" => "Value is not a string",
      "float" => "Value is not a float",
      "list" => "Value is not a list",
      "atom" => "Value is not an atom",
      "bool" => "Value is not a boolean",
      "map" => "Value is not a hash",
      "tuple" => "Value is not a tupple",
      "equal" => "{} is not equal to {}",
      "not_equal" => "{} is equal to {}",
      "include" => "{} is not part of {}",
      "regex" => "{} does not match the regural expression",
      "greater_then" => "{} is not greater then {}",
      "missing" => "Is missing",
      "number" => "Value is not a number"
    }
  end

  defp custom_locale_file do
    case Application.fetch_env(:gate, :locale_file) do
      :error -> %{}
      {:ok, file_path} -> file_path |> read_locale_file
    end
  end

  defp read_locale_file(path) do
    path
    |> File.read!()
    |> decoder().decode!()
  end

  def decoder do
    decoder = Application.fetch_env!(:gate, :decoder)
    validate_decoder!(decoder)
    decoder
  end

  defp validate_decoder!(module) do
    unless Code.ensure_compiled?(module) and function_exported?(module, :decode!, 1) do
      raise ArgumentError,
        "invalid :json_decoder option"
    end
  end
end

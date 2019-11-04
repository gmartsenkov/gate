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
    Map.merge(default_locale_file(), custom_locale_file())
  end

  defp default_locale_file do
    "../default_locale.json"
    |> Path.expand(__ENV__.file)
    |> read_locale_file
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

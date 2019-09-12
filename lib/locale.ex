defmodule Gate.Locale do
  alias Gate.Errors.Substitution

  @self __MODULE__

  def start_link() do
    Agent.start_link(&locales/0, name: @self)
  end

  def get(key) do
    Agent.get(@self, & &1[key])
  end

  def get_and_replace(key, values) do
    get(key) |> Substitution.substitute(values)
  end

  defp locales do
    Map.merge(default_locale_file(), custom_locale_file())
  end

  defp default_locale_file do
    "../assets/default_locale.json"
    |> read_locale_file
  end

  defp custom_locale_file do
    Application.fetch_env!(:param_validator, :locale_file)
    |> read_locale_file
  end

  defp read_locale_file(path) do
    path
    |> Path.expand(__DIR__)
    |> File.read!()
    |> Poison.decode!()
  end
end

defmodule Gate.Locale do
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
    "../../assets/default_locale.json"
    |> Path.expand(__ENV__.file)
    |> read_locale_file
  end

  defp custom_locale_file do
    case Application.fetch_env(:param_validator, :locale_file) do
      :error -> %{}
      {:ok, file_path} -> file_path |> Path.expand(__DIR__) |> read_locale_file
    end
  end

  defp read_locale_file(path) do
    path
    |> File.read!()
    |> Poison.decode!()
  end
end

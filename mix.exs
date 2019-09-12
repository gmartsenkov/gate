defmodule Gate.MixProject do
  use Mix.Project

  def project do
    [
      app: :param_validator,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [espec: :test],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: { Gate.Application, [] },
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1"},
      {:espec, "~> 1.7.0", only: :test},
    ]
  end
end

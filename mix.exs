defmodule Gate.MixProject do
  use Mix.Project

  def project do
    [
      app: :gate,
      description: "Validate parameters against a schema",
      package: package(),
      version: "0.1.6",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [espec: :test],
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Gate.Application, []},
      extra_applications: [:logger]
    ]
  end

  def package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/gmartsenkov/gate"},
      files:
      ~w(mix.exs README.md lib)
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, ">= 0.0.0", optional: true},
      {:espec, "~> 1.7.0", only: :test},
      {:benchee, "~> 1.0", only: :dev},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp docs do
    [
      logo: "assets/images/docs_logo.png"
    ]
  end
end

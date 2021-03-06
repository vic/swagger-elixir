defmodule Swagger.Mixfile do
  use Mix.Project

  def project do
    [app: :swagger,
     version: "0.0.1",
     elixir: "~> 1.2.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :yaml_elixir]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
   [{:poison, "~> 1.5"},
    {:plug, "~> 1.1.5"},
    {:params, "~> 1.1.0"},
    {:yaml_elixir, "~> 1.2.0"},
    {:yamerl, github: "yakaz/yamerl"},
    {:mix_test_watch, "~> 0.2", only: :dev},
    {:credo, "~> 0.1.9", only: :dev},
    {:cowboy, "~> 1.0"}]
  end
end

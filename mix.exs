defmodule Contacts.MixProject do
  use Mix.Project

  def project do
    [
      app: :contacts,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      deps: deps(),
      dialyzer: [plt_add_deps: :transitive],
      aliases: aliases(),
    ]
  end

  defp aliases do
    [ 
     test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:prometheus_ex, :prometheus_plugs, :logger, :postgrex, :ecto, :plug_cowboy],
      mod: {Contacts.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:prometheus_ecto, "~> 1.3.0"},
      {:prometheus_ex, "~> 3.0"},
      {:prometheus_plugs, "~> 1.1.1"},
      {:earmark, "~> 1.2", only: :dev},
      {:ex_doc, "~> 0.19", only: :dev},
      {:distillery, "~> 2.0"},
      {:postgrex, ">= 0.11.1"},
      {:excoveralls, "~> 0.10", only: :test},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false},      
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false},
      {:ecto, "~> 2.2"},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 3.1"}
    ]
  end
end

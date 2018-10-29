defmodule Pta.MixProject do
  use Mix.Project

  def project do
    [
      app: :pta,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Pta.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # TODO: remove override: true once guardian supports 1.4
      {:phoenix, ">= 1.4.0-rc", override: true},
      {:phoenix_pubsub, ">= 1.1.0"},
      {:phoenix_ecto, ">= 3.5.0"},
      {:phoenix_html, ">= 2.12.0"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, ">= 0.16.0"},
      {:jason, ">= 1.1.0"},
      {:plug_cowboy, ">= 2.0.0"},
      {:comeonin, ">= 4.1.0"},
      {:argon2_elixir, ">= 1.3.0"},
      {:guardian, ">= 1.1.0"},
      {:scrivener_ecto, ">= 1.3.0"},
      {:bamboo, ">= 1.1.0"},
      {:bamboo_smtp, ">= 1.6.0"},
      {:paper_trail, ">= 0.8.0"},
      {:distillery, ">= 2.0.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "run priv/repo/test_seeds.exs", "test"]
    ]
  end
end

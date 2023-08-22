defmodule Atomic.MixProject do
  use Mix.Project

  def project do
    [
      app: :atomic,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      preferred_cli_env: [check: :test]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Atomic.Application, []},
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
      {:phoenix, "~> 1.6.14"},

      # core
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.17.5"},

      # database
      {:ecto_sql, "~> 3.6"},
      {:phoenix_ecto, "~> 4.4"},
      {:postgrex, ">= 0.0.0"},

      # security
      {:bcrypt_elixir, "~> 3.0"},

      # uploads
      {:waffle_ecto, "~> 0.0"},
      {:waffle, "~> 1.1"},

      # mailer
      {:phoenix_html, "~> 3.0"},
      {:swoosh, "~> 1.5"},
      {:phoenix_swoosh, "~> 1.0"},

      # frontend
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},
      {:flop, "~> 0.17.0"},
      {:icons, "~> 0.7.1"},
      {:esbuild, "~> 0.4", runtime: Mix.env() == :dev},

      # monitoring
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:phoenix_live_dashboard, "~> 0.6"},

      # utilities
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},

      # plugs
      {:plug_cowboy, "~> 2.5"},

      # testing
      {:faker, "~> 0.17", only: [:dev, :test]},
      {:ex_machina, "~> 2.7.0"},
      {:floki, ">= 0.30.0", only: :test},

      # tools
      {:timex, "~> 3.0"},
      {:qrcode_ex, "~> 0.1.1"},
      {:pdf_generator, "~>0.6.2"},
      {:quantum, "~> 3.0"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "ecto.seed"],
      "ecto.seed": ["run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"],
      lint: ["credo -C default"],
      check: [
        "clean",
        "deps.unlock --check-unused",
        "compile",
        "format --check-formatted",
        "deps.unlock --check-unused",
        "test",
        "lint"
      ]
    ]
  end
end

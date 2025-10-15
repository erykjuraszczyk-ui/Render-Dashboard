defmodule RenderDashboard.MixProject do
  use Mix.Project

  def project do
    [
      app: :render_dashboard,
      version: "0.1.0",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      compilers: [:phoenix_live_view] ++ Mix.compilers(),
      listeners: [Phoenix.CodeReloader]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {RenderDashboard.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  def cli do
    [
      preferred_envs: [precommit: :test]
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
    {:phoenix, "~> 1.8.1"},
    {:phoenix_html, "~> 4.0"},
    {:phoenix_live_view, "~> 1.0"},
    {:phoenix_live_dashboard, "~> 0.8"},
    {:esbuild, "~> 0.5", runtime: Mix.env() == :dev},
    {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
    {:gettext, "~> 0.20"},
    {:jason, "~> 1.2"},
    {:plug, "~> 1.15"},
    {:plug_cowboy, "~> 2.7"},
    {:bandit, "~> 1.4"},

    # --- OpenTelemetry / tracing/metrics ---
    {:opentelemetry, "~> 1.4", override: true},
    {:opentelemetry_api, "~> 1.4"},
    {:opentelemetry_exporter, "~> 1.8"},
    {:opentelemetry_phoenix, "~> 2.0"}
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
      setup: ["deps.get", "assets.setup", "assets.build"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["compile", "tailwind render_dashboard", "esbuild render_dashboard"],
      "assets.deploy": [
        "tailwind render_dashboard --minify",
        "esbuild render_dashboard --minify",
        "phx.digest"
      ],
      precommit: ["compile --warning-as-errors", "deps.unlock --unused", "format", "test"]
    ]
  end
end

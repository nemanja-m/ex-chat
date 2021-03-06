defmodule ChatApp.Mixfile do
  use Mix.Project

  def project do
    [app: :chat_app,
     version: "0.0.1",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [
      mod: {ChatApp, []},
      applications: [
        :phoenix,
        :phoenix_html,
        :phoenix_pubsub,
        :cowboy,
        :logger,
        :gettext,
        :tackle,
        :httpoison
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [
      {:phoenix, "~> 1.2.1"},
      {:phoenix_html, "~> 2.9.3"},
      {:phoenix_pubsub, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:tackle, github: "renderedtext/ex-tackle"},
      {:httpoison, "~> 0.11.1"}
   ]
  end
end

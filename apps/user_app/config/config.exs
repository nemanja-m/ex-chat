use Mix.Config

# General application configuration
config :user_app,
  ecto_repos: [UserApp.Repo]

# Configures the endpoint
config :user_app, UserApp.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Uf4xRe8WBRUaWN7On4kYFQpmXHcUA4p3JWLHmHCz2WDpxtTd8r7z3dheFTngwYp2",
  render_errors: [view: UserApp.ErrorView, accepts: ~w(json)],
  pubsub: [name: UserApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "UserApp",
  ttl: { 30, :days },
  verify_issuer: true,
  serializer: UserApp.GuardianSerializer

# Set master node alias
config :user_app,
  master_alias: System.get_env("MASTER_ALIAS") || "Mars"

import_config "#{Mix.env}.exs"

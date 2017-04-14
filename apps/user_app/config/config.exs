# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
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

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

use Mix.Config

# Configures the endpoint
config :chat_app, ChatApp.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DdXGhkegl2dRO8W8TD2Tk/xDHP2Pp4zkypRABk962KG00/N+Zv65oO79EiXanipO",
  render_errors: [view: ChatApp.ErrorView, accepts: ~w(json)],
  pubsub: [name: ChatApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure master node
config :chat_app, :master_node,
  url: System.get_env("MASTER_NODE_URL") || "http://localhost:3000/api"

config :chat_app,
  alias:  System.get_env("ALIAS")  || "Mars", # Configure this node alias. Default value is 'Mars'.
  master: System.get_env("MASTER") || "true"  # Set this flag to true if this node is master. Default is true.

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

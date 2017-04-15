use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :user_app, UserApp.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Confgure postgres db
db_username = System.get_env("DATABASE_POSTGRESQL_USERNAME") || "developer"
db_password = System.get_env("DATABASE_POSTGRESQL_PASSWORD") || "developer"

config :guardian, Guardian,
  secret_key: "DuWKWhfeBuho78bfbBTz/Hl4/LfcR+2bzoiy9A1SC/JjBNPlMXbn9QCqK1JhaTRz"

# Configure your database
config :user_app, UserApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: db_username,
  password: db_password,
  database: "user_app_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

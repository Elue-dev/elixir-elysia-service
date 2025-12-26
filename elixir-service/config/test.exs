import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :subscriptions, Subscriptions.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "subscriptions_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :subscriptions, SubscriptionsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Nfqryl7A+VoV3p3sGE/YhsMQlnsDe3ndJ2IpQ6+fHoJnYRb/ugXB9JsSafamE6iw",
  server: false

# In test we don't send emails
config :subscriptions, Subscriptions.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

import Config

config :subscriptions, Subscriptions.Repo,
  username: "postgres",
  password: System.get_env("PG_USER_PASS"),
  hostname: "localhost",
  database: "subscriptions_dev",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :subscriptions, SubscriptionsWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: String.to_integer(System.get_env("PORT") || "4000")],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "Iu5Qn4tASBqjCi5ZLFQkbGn922UHEJ/CI5Xo2HrZTuE/zrGwUwPLhZqiWHP945pF",
  watchers: []

config :subscriptions, dev_routes: true

config :logger, :default_formatter, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :swoosh, :api_client, false

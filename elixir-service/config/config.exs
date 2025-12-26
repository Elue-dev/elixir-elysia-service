import Config

config :subscriptions,
  ecto_repos: [Subscriptions.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

config :subscriptions, SubscriptionsWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: SubscriptionsWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Subscriptions.PubSub,
  live_view: [signing_salt: "x/ZsHQNV"]

config :subscriptions, Subscriptions.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: System.get_env("SENDGRID_API_KEY"),
  hackney_opts: [
    recv_timeout: :timer.minutes(1)
  ]

# config :subscriptions, Subscriptions.Mailer, sandbox: true

# config :subscriptions, Subscriptions.Mailer, adapter: Swoosh.Adapters.Local

config :subscriptions, Oban,
  repo: Subscriptions.Repo,
  queues: [default: 10, scheduled: 5, mailers: 10],
  plugins: [
    Oban.Plugins.Pruner,
    {Oban.Plugins.Cron,
     crontab: [
       # every minute
       {"* * * * *", Subscriptions.Workers.ExpireSubscriptions}
       # every hour
       # {"0 * * * *", Subscriptions.Workers.ExpireSubscriptions}
     ]}
  ]

config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"

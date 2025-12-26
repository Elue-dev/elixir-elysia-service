defmodule Subscriptions.Repo do
  use Ecto.Repo,
    otp_app: :subscriptions,
    adapter: Ecto.Adapters.Postgres
end

defmodule Subscriptions.Workers.SubscriptionExpiredEmail do
  use Oban.Worker,
    queue: :mailers,
    max_attempts: 5,
    unique: [fields: [:args], period: 60 * 60 * 24]

  alias Subscriptions.Mailer
  alias Subscriptions.Mailer.Email

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"email" => email}}) do
    Email.subscription_expired_email(email)
    |> Mailer.deliver_now!()

    Logger.info("Expiration email sent to #{email}")

    :ok
  end
end

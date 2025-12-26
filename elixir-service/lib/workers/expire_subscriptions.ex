defmodule Subscriptions.Workers.ExpireSubscriptions do
  use Oban.Worker, queue: :default, max_attempts: 1

  alias Subscriptions.Billing
  alias Subscriptions.Workers.SubscriptionExpiredEmail

  require Logger

  # @impl Oban.Worker
  # def perform(_job) do
  #   Logger.info("subscriptions worker ran...")
  #   now = DateTime.utc_now()

  #   case Billing.expire_subscriptions_ending_before(now) do
  #     {count, _} when count > 0 ->
  #       Logger.info("Expired #{count} subscription(s)")
  #       :ok

  #     {0, _} ->
  #       Logger.debug("No subscriptions to expire")
  #       :ok
  #   end
  # end

  @impl Oban.Worker
  def perform(_job) do
    Logger.info("subscriptions worker ran...")

    now = DateTime.utc_now()
    subscriptions = Billing.subscriptions_to_expire(now)
    Logger.debug("SUBSCRIPTIONSSS: #{inspect(subscriptions)}")

    case subscriptions do
      [] ->
        Logger.debug("No subscriptions to expire")
        :ok

      subs ->
        ids = Enum.map(subs, & &1.subscription.id)
        Billing.expire_subscriptions(ids)

        Enum.each(subs, fn %{email: email} ->
          %{"email" => email}
          |> SubscriptionExpiredEmail.new()
          |> Oban.insert!()
        end)

        Logger.info("Expired #{length(ids)} subscription(s)")
        :ok
    end
  end
end

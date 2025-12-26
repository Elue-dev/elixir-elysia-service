defmodule SubscriptionsWeb.SubscriptionJSON do
  alias Subscriptions.Schema.Subscription

  @doc """
  Renders a list of subscriptions.
  """
  def index(%{subscriptions: subscriptions}) do
    %{data: for(subscription <- subscriptions, do: data(subscription))}
  end

  @doc """
  Renders a single subscription.
  """
  def show(%{subscription: subscription}) do
    %{data: data(subscription)}
  end

  defp data(%Subscription{} = subscription) do
    %{
      id: subscription.id,
      plan: subscription.plan,
      price: subscription.price,
      status: subscription.status,
      started_at: subscription.started_at,
      ends_at: subscription.ends_at
    }
  end
end

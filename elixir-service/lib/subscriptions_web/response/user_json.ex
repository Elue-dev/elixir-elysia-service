defmodule SubscriptionsWeb.UserJSON do
  alias Subscriptions.Schema.User
  alias Subscriptions.Schema.Subscription

  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  def show(%{user: user}) do
    %{
      data: %{
        user: data(user),
        subscriptions: for(subscription <- user.subscriptions, do: subs(subscription))
      }
    }
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      email_verified: user.email_verified,
      image: user.image,
      created_at: NaiveDateTime.to_iso8601(user.created_at) <> "Z",
      updated_at: NaiveDateTime.to_iso8601(user.updated_at) <> "Z"
    }
  end

  defp subs(%Subscription{} = subscription) do
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

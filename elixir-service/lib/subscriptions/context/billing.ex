defmodule Subscriptions.Billing do
  import Ecto.Query, warn: false
  alias Subscriptions.Repo

  alias Subscriptions.Schema.Subscription
  alias Subscriptions.Schema.User

  def list_subscriptions do
    Repo.all(Subscription)
  end

  def get_subscription(id), do: Repo.get(Subscription, id)

  def create_subscription(attrs) do
    %Subscription{}
    |> Subscription.changeset(attrs)
    |> Repo.insert()
  end

  def update_subscription(%Subscription{} = subscription, attrs) do
    subscription
    |> Subscription.changeset(attrs)
    |> Repo.update()
  end

  def expire_subscriptions_ending_before(datetime) do
    from(s in Subscription,
      where: s.status == "active",
      where: s.ends_at <= ^datetime
    )
    |> Repo.update_all(
      set: [
        status: "cancelled",
        updated_at: DateTime.utc_now()
      ]
    )
  end

  def subscriptions_to_expire(datetime) do
    from(s in Subscription,
      join: u in User,
      on: u.id == s.user_id,
      where: s.status == "active",
      where: s.ends_at <= ^datetime,
      select: %{subscription: s, email: u.email}
    )
    |> Repo.all()
  end

  def expire_subscriptions(subscription_ids) do
    from(s in Subscription,
      where: s.id in ^subscription_ids
    )
    |> Repo.update_all(
      set: [
        status: "cancelled",
        updated_at: DateTime.utc_now()
      ]
    )
  end
end

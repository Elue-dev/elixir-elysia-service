defmodule SubscriptionsWeb.SubscriptionController do
  use SubscriptionsWeb, :controller

  alias Subscriptions.Billing
  alias Subscriptions.Schema.Subscription
  alias Subscriptions.Mailer
  alias Subscriptions.Mailer.Email

  action_fallback SubscriptionsWeb.FallbackController

  def subscribe(conn, params) do
    IO.puts("conn.assigns.current_user.id: #{conn.assigns.current_user.id}")

    params =
      params
      |> Map.put("user_id", conn.assigns.current_user.id)

    with {:ok, %Subscription{} = subscription} <- Billing.create_subscription(params) do
      Task.start(fn ->
        Email.subscription_successful_email(subscription.plan, subscription.ends_at)
        |> Mailer.deliver_now!()
      end)

      conn
      |> put_status(:created)
      |> render(:show, subscription: subscription)
    end
  end

  def get_subscription(conn, %{"id" => id} = _params) do
    case Billing.get_subscription(id) do
      nil ->
        conn |> put_status(:not_found) |> render(%{message: "Subscription not found"})

      sub ->
        render(conn, :show, subscription: sub)
    end
  end
end

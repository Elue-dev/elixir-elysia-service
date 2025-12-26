defmodule Subscriptions.BillingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Subscriptions.Billing` context.
  """

  @doc """
  Generate a subscription.
  """
  def subscription_fixture(attrs \\ %{}) do
    {:ok, subscription} =
      attrs
      |> Enum.into(%{
        ends_at: ~U[2025-12-23 19:50:00Z],
        plan: "some plan",
        price: 42,
        started_at: ~U[2025-12-23 19:50:00Z],
        status: "some status"
      })
      |> Subscriptions.Billing.create_subscription()

    subscription
  end
end

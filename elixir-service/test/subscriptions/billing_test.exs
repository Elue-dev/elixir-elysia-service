defmodule Subscriptions.BillingTest do
  use Subscriptions.DataCase

  alias Subscriptions.Billing

  describe "subscriptions" do
    alias Subscriptions.Billing.Subscription

    import Subscriptions.BillingFixtures

    @invalid_attrs %{status: nil, started_at: nil, plan: nil, price: nil, ends_at: nil}

    test "list_subscriptions/0 returns all subscriptions" do
      subscription = subscription_fixture()
      assert Billing.list_subscriptions() == [subscription]
    end

    test "get_subscription!/1 returns the subscription with given id" do
      subscription = subscription_fixture()
      assert Billing.get_subscription!(subscription.id) == subscription
    end

    test "create_subscription/1 with valid data creates a subscription" do
      valid_attrs = %{status: "some status", started_at: ~U[2025-12-23 19:50:00Z], plan: "some plan", price: 42, ends_at: ~U[2025-12-23 19:50:00Z]}

      assert {:ok, %Subscription{} = subscription} = Billing.create_subscription(valid_attrs)
      assert subscription.status == "some status"
      assert subscription.started_at == ~U[2025-12-23 19:50:00Z]
      assert subscription.plan == "some plan"
      assert subscription.price == 42
      assert subscription.ends_at == ~U[2025-12-23 19:50:00Z]
    end

    test "create_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_subscription(@invalid_attrs)
    end

    test "update_subscription/2 with valid data updates the subscription" do
      subscription = subscription_fixture()
      update_attrs = %{status: "some updated status", started_at: ~U[2025-12-24 19:50:00Z], plan: "some updated plan", price: 43, ends_at: ~U[2025-12-24 19:50:00Z]}

      assert {:ok, %Subscription{} = subscription} = Billing.update_subscription(subscription, update_attrs)
      assert subscription.status == "some updated status"
      assert subscription.started_at == ~U[2025-12-24 19:50:00Z]
      assert subscription.plan == "some updated plan"
      assert subscription.price == 43
      assert subscription.ends_at == ~U[2025-12-24 19:50:00Z]
    end

    test "update_subscription/2 with invalid data returns error changeset" do
      subscription = subscription_fixture()
      assert {:error, %Ecto.Changeset{}} = Billing.update_subscription(subscription, @invalid_attrs)
      assert subscription == Billing.get_subscription!(subscription.id)
    end

    test "delete_subscription/1 deletes the subscription" do
      subscription = subscription_fixture()
      assert {:ok, %Subscription{}} = Billing.delete_subscription(subscription)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_subscription!(subscription.id) end
    end

    test "change_subscription/1 returns a subscription changeset" do
      subscription = subscription_fixture()
      assert %Ecto.Changeset{} = Billing.change_subscription(subscription)
    end
  end
end

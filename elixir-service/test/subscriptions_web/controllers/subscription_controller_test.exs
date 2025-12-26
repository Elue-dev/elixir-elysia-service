defmodule SubscriptionsWeb.SubscriptionControllerTest do
  use SubscriptionsWeb.ConnCase

  import Subscriptions.BillingFixtures
  alias Subscriptions.Billing.Subscription

  @create_attrs %{
    status: "some status",
    started_at: ~U[2025-12-23 19:50:00Z],
    plan: "some plan",
    price: 42,
    ends_at: ~U[2025-12-23 19:50:00Z]
  }
  @update_attrs %{
    status: "some updated status",
    started_at: ~U[2025-12-24 19:50:00Z],
    plan: "some updated plan",
    price: 43,
    ends_at: ~U[2025-12-24 19:50:00Z]
  }
  @invalid_attrs %{status: nil, started_at: nil, plan: nil, price: nil, ends_at: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all subscriptions", %{conn: conn} do
      conn = get(conn, ~p"/api/subscriptions")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create subscription" do
    test "renders subscription when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/subscriptions", subscription: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/subscriptions/#{id}")

      assert %{
               "id" => ^id,
               "ends_at" => "2025-12-23T19:50:00Z",
               "plan" => "some plan",
               "price" => 42,
               "started_at" => "2025-12-23T19:50:00Z",
               "status" => "some status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/subscriptions", subscription: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update subscription" do
    setup [:create_subscription]

    test "renders subscription when data is valid", %{conn: conn, subscription: %Subscription{id: id} = subscription} do
      conn = put(conn, ~p"/api/subscriptions/#{subscription}", subscription: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/subscriptions/#{id}")

      assert %{
               "id" => ^id,
               "ends_at" => "2025-12-24T19:50:00Z",
               "plan" => "some updated plan",
               "price" => 43,
               "started_at" => "2025-12-24T19:50:00Z",
               "status" => "some updated status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, subscription: subscription} do
      conn = put(conn, ~p"/api/subscriptions/#{subscription}", subscription: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete subscription" do
    setup [:create_subscription]

    test "deletes chosen subscription", %{conn: conn, subscription: subscription} do
      conn = delete(conn, ~p"/api/subscriptions/#{subscription}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/subscriptions/#{subscription}")
      end
    end
  end

  defp create_subscription(_) do
    subscription = subscription_fixture()

    %{subscription: subscription}
  end
end

defmodule SubscriptionsWeb.UserController do
  use SubscriptionsWeb, :controller

  alias Subscriptions.Accounts
  alias Subscriptions.Schema.User

  action_fallback SubscriptionsWeb.FallbackController

  def register(conn, params) do
    with {:ok, %User{} = user} <- Accounts.create_user(params) do
      conn
      |> put_status(:created)
      |> render(:show, user: user)
    end
  end

  def list(conn, _params) do
    users = Accounts.list_users()

    conn
    |> put_status(:ok)
    |> render(:index, users: users)
  end

  def me(conn, _params) do
    user = conn.assigns.current_user

    conn
    |> put_status(:ok)
    |> render(:show, user: user)
  end
end

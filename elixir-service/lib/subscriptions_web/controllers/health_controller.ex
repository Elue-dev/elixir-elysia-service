defmodule SubscriptionsWeb.HealthController do
  use SubscriptionsWeb, :controller

  def ping(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{message: "pong"})
  end
end

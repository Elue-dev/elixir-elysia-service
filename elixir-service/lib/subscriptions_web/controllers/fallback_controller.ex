defmodule SubscriptionsWeb.FallbackController do
  use SubscriptionsWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: SubscriptionsWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> json(%{error: "not found"})
  end

  def call(conn, {:error, :invalid_token}) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "invalid_token"})
  end
end

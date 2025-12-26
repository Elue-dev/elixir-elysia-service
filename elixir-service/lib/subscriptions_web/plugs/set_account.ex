defmodule Subscriptions.Plugs.SetAccount do
  import Plug.Conn
  alias Subscriptions.Auth.Guardian

  require Logger

  def init(_opts), do: []

  def call(conn, _opts) do
    if conn.assigns[:current_user], do: halt(conn)

    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        case Guardian.verify_user_token(token) do
          {:ok, user} ->
            Logger.debug("current user: #{inspect(user)}")
            assign(conn, :current_user, user)

          :error ->
            assign(conn, :current_user, nil)
        end

      _ ->
        assign(conn, :current_user, nil)
    end
  end
end

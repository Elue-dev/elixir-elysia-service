defmodule Subscriptions.Auth.Guardian do
  use Guardian, otp_app: :subscriptions

  alias Subscriptions.Accounts
  alias Subscriptions.Schema.User

  def subject_for_token(%User{id: id}, _claims), do: {:ok, id}

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user(id) do
      nil -> {:error, :invalid_token}
      user -> {:ok, user}
    end
  end

  def verify_user_token(token) do
    case decode_and_verify(token, %{}) do
      {:ok, claims} ->
        case resource_from_claims(claims) do
          {:ok, user} -> {:ok, user}
          {:error, _} -> :error
        end

      {:error, _} ->
        :error
    end
  end
end

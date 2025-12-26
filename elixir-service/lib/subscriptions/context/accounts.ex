defmodule Subscriptions.Accounts do
  import Ecto.Query, warn: false
  alias Subscriptions.Repo

  alias Subscriptions.Schema.User

  def list_users do
    Repo.all(User)
  end

  def get_user(id) do
    User
    |> where(id: ^id)
    |> preload([:subscriptions])
    |> Repo.one()
  end

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end
end

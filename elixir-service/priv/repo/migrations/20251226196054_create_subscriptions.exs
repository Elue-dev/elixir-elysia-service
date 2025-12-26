defmodule Subscriptions.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :plan, :string
      add :price, :integer
      add :status, :string
      add :started_at, :utc_datetime
      add :ends_at, :utc_datetime
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:subscriptions, [:user_id])
  end
end

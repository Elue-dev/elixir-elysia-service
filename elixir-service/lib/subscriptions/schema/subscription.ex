defmodule Subscriptions.Schema.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @plans ~w(basic advanced enterprise)
  # @subscription_duration_days 30

  @schema_prefix nil

  schema "subscriptions" do
    field :plan, :string
    field :price, :integer
    field :status, :string
    field :started_at, :utc_datetime
    field :ends_at, :utc_datetime
    field :user_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:plan, :user_id, :price, :status, :started_at, :ends_at])
    |> validate_required([:plan])
    |> validate_inclusion(:plan, @plans)
    |> put_subscription_defaults()
  end

  defp put_subscription_defaults(changeset) do
    plan = get_field(changeset, :plan)

    now =
      DateTime.utc_now()
      |> DateTime.truncate(:second)

    changeset
    |> put_change(:price, plan_price(plan))
    |> maybe_put_status_default()
    |> put_change(:started_at, now)
    |> put_change(:ends_at, DateTime.add(now, 1 * 60, :second))
  end

  defp plan_price("basic"), do: 500
  defp plan_price("advanced"), do: 1_500
  defp plan_price("enterprise"), do: 3_000
  defp plan_price(_), do: nil

  defp maybe_put_status_default(changeset) do
    case get_field(changeset, :status) do
      nil -> put_change(changeset, :status, "active")
      _ -> changeset
    end
  end
end

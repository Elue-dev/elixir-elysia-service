defmodule Subscriptions.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SubscriptionsWeb.Telemetry,
      Subscriptions.Repo,
      {Oban, Application.fetch_env!(:subscriptions, Oban)},
      {DNSCluster, query: Application.get_env(:subscriptions, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Subscriptions.PubSub},
      SubscriptionsWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Subscriptions.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    SubscriptionsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule SubscriptionsWeb.Router do
  use SubscriptionsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Subscriptions.Auth.Pipeline
    plug Subscriptions.Plugs.SetAccount
  end

  scope "/api", SubscriptionsWeb do
    pipe_through :api

    post "/ping", HealthController, :ping
    post "/users", UserController, :register
  end

  scope "/api", SubscriptionsWeb do
    pipe_through [:api, :auth]

    get "/users", UserController, :list
    get "/me", UserController, :me
    get "/subscriptions/:id", SubscriptionController, :get_subscription
    post "/subscribe", SubscriptionController, :subscribe
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:subscriptions, :dev_routes) do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

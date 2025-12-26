defmodule Subscriptions.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :subscriptions,
    module: Subscriptions.Auth.Guardian,
    error_handler: Subscriptions.Auth.GuardianErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end

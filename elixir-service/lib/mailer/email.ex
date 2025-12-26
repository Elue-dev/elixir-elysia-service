defmodule Subscriptions.Mailer.Email do
  import Bamboo.Email

  alias Subscriptions.Mailer.Layout

  @from "jorib36077@arugy.com"

  def welcome_email(email) do
    title = "Welcome to Subscriptions"

    body =
      """
      <p>Hi 👋</p>

      <p>Thanks for joining <strong>Subscriptions</strong>.</p>

      <p>You can now manage your plan and enjoy full access.</p>
      """

    new_email(
      to: email,
      from: @from,
      subject: title,
      html_body: Layout.html(title, body),
      text_body: Layout.text(title, "Thanks for joining Subscriptions.")
    )
  end

  def subscription_successful_email(plan, ends_at) do
    title = "Wohoo!. Subscription activated 🎉"

    body =
      """
      <p>Your <strong>#{plan}</strong> plan is now active.</p>

      <p>
        <strong>Ends on:</strong><br/>
        #{format_datetime(ends_at)}
      </p>

      <p>Thanks for choosing us!</p>
      """

    new_email(
      to: @from,
      from: @from,
      subject: title,
      html_body: Layout.html(title, body),
      text_body:
        Layout.text(
          title,
          "Your #{plan} plan is active and ends on #{format_datetime(ends_at)}."
        )
    )
  end

  def subscription_expired_email(email) do
    title = "Notice of expired subscription"

    body =
      """
      <p>Your subscription has expired.</p>

      <p>Please renew to continue enjoying our services.</p>
      """

    new_email(
      to: email,
      from: @from,
      subject: title,
      html_body: Layout.html(title, body),
      text_body: Layout.text(title, "Your subscription has expired. Please renew.")
    )
  end

  defp format_datetime(datetime) do
    datetime
    |> DateTime.to_date()
    |> Date.to_string()
  end
end

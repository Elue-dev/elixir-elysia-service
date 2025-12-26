defmodule Subscriptions.Mailer.Layout do
  def html(title, body) do
    """
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>#{title}</title>
      </head>
      <body style="margin:0;padding:0;background:#f6f9fc;font-family:Arial,Helvetica,sans-serif;">
        <table width="100%" cellpadding="0" cellspacing="0">
          <tr>
            <td align="center">
              <table width="600" cellpadding="0" cellspacing="0" style="background:#ffffff;margin:40px 0;border-radius:8px;overflow:hidden;">
                <tr>
                  <td style="padding:24px;text-align:center;background:#111827;color:#ffffff;">
                    <h1 style="margin:0;font-size:20px; color: white">Subscriptions</h1>
                  </td>
                </tr>

                <tr>
                  <td style="padding:32px;color:#374151;font-size:14px;line-height:1.6;">
                    #{body}
                  </td>
                </tr>

                <tr>
                  <td style="padding:16px;text-align:center;color:#9ca3af;font-size:12px;">
                    © #{Date.utc_today().year} Subscriptions. All rights reserved.
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </body>
    </html>
    """
  end

  def text(title, body) do
    """
    #{title}
    ==============================

    #{body}

    --
    Subscriptions
    """
  end
end

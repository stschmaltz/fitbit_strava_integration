defmodule FitbitStravaIntegrationWeb.BaseOAuthController do
  use FitbitStravaIntegrationWeb, :controller
  require Logger

  @spec authorize(Plug.Conn.t(), module()) :: Plug.Conn.t()
  def authorize(conn, oauth_module) do
    Logger.info("Initiating authorization for #{inspect(oauth_module)}")
    client = oauth_module.client()
    url = oauth_module.authorize_url!(client)

    redirect(conn, external: url)
  end

  @spec callback(Plug.Conn.t(), map, module(), String.t()) :: Plug.Conn.t()
  def callback(conn, %{"code" => code}, oauth_module, cookie_prefix) do
    Logger.info("Received callback from #{inspect(oauth_module)}")
    client = oauth_module.client()

    try do
      client = oauth_module.get_token_from_client(client, code: code)
      Logger.info("Successfully acquired token for #{inspect(oauth_module)}")

      conn
      |> put_resp_cookie("#{cookie_prefix}_token", client.token.access_token, encrypt: true)
      |> put_resp_cookie("#{cookie_prefix}_refresh_token", client.token.refresh_token,
        encrypt: true
      )
      |> put_resp_cookie("#{cookie_prefix}_token_expires_at", to_string(client.token.expires_at),
        encrypt: true
      )
      |> redirect(to: get_session(conn, :return_to) || "/")
    rescue
      e in OAuth2.Error ->
        Logger.error("Failed to authorize with #{inspect(oauth_module)}: #{inspect(e)}")

        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Failed to authorize with #{inspect(oauth_module)}: #{e.reason}"})

      unexpected ->
        Logger.error(
          "Unexpected error during #{inspect(oauth_module)} authorization: #{inspect(unexpected)}"
        )

        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "An unexpected error occurred during authorization"})
    end
  end
end

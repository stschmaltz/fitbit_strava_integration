defmodule FitbitStravaIntegrationWeb.Fitbit.OauthController do
  use FitbitStravaIntegrationWeb, :controller
  alias FitbitStravaIntegration.Fitbit.FitbitOauth

  require Logger

  @spec authorize(Plug.Conn.t(), map) :: Plug.Conn.t()
  def authorize(conn, _params) do
    Logger.info("Initiating Fitbit authorization")
    client = FitbitOauth.client()
    url = FitbitOauth.authorize_url!(client)

    redirect(conn, external: url)
  end

  @spec callback(Plug.Conn.t(), map) :: Plug.Conn.t()
  def callback(conn, %{"code" => code}) do
    Logger.info("Received callback from Fitbit")
    client = FitbitOauth.client()

    try do
      client = FitbitOauth.get_token_from_client(client, code: code)
      Logger.info("Successfully acquired Fitbit token")

      conn
      |> put_resp_cookie("fitbit_token", client.token.access_token, encrypt: true)
      |> put_resp_cookie("fitbit_refresh_token", client.token.refresh_token, encrypt: true)
      |> put_resp_cookie("fitbit_token_expires_at", to_string(client.token.expires_at),
        encrypt: true
      )
      |> redirect(to: get_session(conn, :return_to) || "/")
    rescue
      e in OAuth2.Error ->
        Logger.error("Failed to authorize with Fitbit: #{inspect(e)}")

        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Failed to authorize with Fitbit: #{e.reason}"})

      unexpected ->
        Logger.error("Unexpected error during Fitbit authorization: #{inspect(unexpected)}")

        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "An unexpected error occurred during authorization"})
    end
  end
end

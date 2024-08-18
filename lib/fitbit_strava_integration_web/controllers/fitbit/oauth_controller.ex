defmodule FitbitStravaIntegrationWeb.Fitbit.OauthController do
  use FitbitStravaIntegrationWeb, :controller
  alias FitbitStravaIntegration.FitbitOauth

  require Logger

  def authorize(conn, _params) do
    Logger.info("Initiating Fitbit authorization")
    client = FitbitOauth.client()
    url = FitbitOauth.authorize_url!(client)

    redirect(conn, external: url)
  end

  def callback(conn, %{"code" => code}) do
    Logger.info("Received callback from Fitbit")
    client = FitbitOauth.client()

    case FitbitOauth.get_token!(client, code: code) do
      %{token: token} ->
        conn
        |> put_resp_cookie("fitbit_token", token.access_token, encrypt: true)
        |> put_resp_cookie("fitbit_refresh_token", token.refresh_token, encrypt: true)
        |> put_resp_cookie("fitbit_token_expires_at", to_string(token.expires_at), encrypt: true)
        |> json(%{message: "Authorization successful"})

      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Failed to authorize with Fitbit"})
    end
  end
end

defmodule FitbitStravaIntegrationWeb.StravaTokenPlug do
  import Plug.Conn
  alias FitbitStravaIntegrationWeb.OAuthTokenHandler
  alias FitbitStravaIntegration.Strava.StravaOAuth

  @spec init(any()) :: any()
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def call(conn, _opts) do
    cookie_keys = ~w(strava_token strava_refresh_token strava_token_expires_at)
    OAuthTokenHandler.handle_token(conn, StravaOAuth, cookie_keys, :strava_token)
  end
end

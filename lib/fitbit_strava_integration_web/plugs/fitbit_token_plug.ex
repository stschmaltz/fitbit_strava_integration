defmodule FitbitStravaIntegrationWeb.FitbitTokenPlug do
  import Plug.Conn
  alias FitbitStravaIntegrationWeb.OAuthTokenHandler
  alias FitbitStravaIntegration.Fitbit.FitbitOAuth

  @spec init(any()) :: any()
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def call(conn, _opts) do
    cookie_keys = ~w(fitbit_token fitbit_refresh_token fitbit_token_expires_at)
    OAuthTokenHandler.handle_token(conn, FitbitOAuth, cookie_keys, :fitbit_token)
  end
end

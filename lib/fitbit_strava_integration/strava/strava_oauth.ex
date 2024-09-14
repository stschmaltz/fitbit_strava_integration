defmodule FitbitStravaIntegration.Strava.StravaOAuth do
  use FitbitStravaIntegration.OAuth.Default,
    client_id: Dotenv.Env.get(Dotenv.load(), "STRAVA_CLIENT_ID"),
    client_secret: Dotenv.Env.get(Dotenv.load(), "STRAVA_CLIENT_SECRET"),
    redirect_uri: "http://localhost:4000/api/strava/callback",
    site: "https://www.strava.com",
    auth_url: "/api/strava/auth",
    authorize_url: "/oauth/authorize",
    token_url: "/oauth/token",
    provider: "Strava"

  @impl true
  def authorize_url!(client) do
    scope = "read,activity:read_all"
    authorize_url!(client, scope)
  end
end

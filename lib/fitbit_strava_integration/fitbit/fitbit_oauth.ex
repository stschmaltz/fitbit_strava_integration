defmodule FitbitStravaIntegration.Fitbit.FitbitOAuth do
  use FitbitStravaIntegration.OAuth.Default,
    client_id: Dotenv.Env.get(Dotenv.load(), "FITBIT_CLIENT_ID"),
    client_secret: Dotenv.Env.get(Dotenv.load(), "FITBIT_CLIENT_SECRET"),
    redirect_uri: "http://localhost:4000/api/fitbit/callback",
    site: "https://api.fitbit.com",
    auth_url: "/api/fitbit/auth",
    provider: "Fitbit"

  @impl true
  def authorize_url!(client) do
    scope = "activity cardio_fitness heartrate location nutrition profile sleep social weight"
    OAuth2.Client.authorize_url!(client, scope: scope)
  end
end

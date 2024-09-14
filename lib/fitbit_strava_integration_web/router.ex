defmodule FitbitStravaIntegrationWeb.Router do
  use FitbitStravaIntegrationWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :fitbit_auth do
    plug FitbitStravaIntegrationWeb.FitbitTokenPlug
  end

  pipeline :strava_auth do
    plug FitbitStravaIntegrationWeb.StravaTokenPlug
  end

  scope "/api", FitbitStravaIntegrationWeb do
    pipe_through [:api, :fitbit_auth]

    get "/fitbit/profile", Fitbit.ApiController, :profile
    get "/fitbit/activities", Fitbit.ApiController, :activities
  end

  scope "/api", FitbitStravaIntegrationWeb do
    pipe_through :api

    get "/fitbit/auth", Fitbit.OAuthController, :authorize
    get "/fitbit/callback", Fitbit.OAuthController, :callback

    get "/strava/auth", Strava.OAuthController, :authorize
    get "/strava/callback", Strava.OAuthController, :callback
  end
end

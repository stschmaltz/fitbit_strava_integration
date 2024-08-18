defmodule FitbitStravaIntegrationWeb.Router do
  use FitbitStravaIntegrationWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :fitbit_auth do
    plug FitbitStravaIntegrationWeb.FitbitTokenPlug
  end

  scope "/api", FitbitStravaIntegrationWeb do
    pipe_through [:api, :fitbit_auth]

    # Add routes that need Fitbit authentication here
    get "/fitbit/profile", Fitbit.ApiController, :profile
  end

  scope "/api", FitbitStravaIntegrationWeb do
    pipe_through :api

    get "/fitbit/auth", Fitbit.OauthController, :authorize
    get "/fitbit/callback", Fitbit.OauthController, :callback
  end
end

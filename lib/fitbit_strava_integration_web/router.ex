defmodule FitbitStravaIntegrationWeb.Router do
  use FitbitStravaIntegrationWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FitbitStravaIntegrationWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FitbitStravaIntegrationWeb do
    pipe_through :api

    get "/fitbit/auth", Fitbit.OauthController, :authorize
    get "/fitbit/callback", Fitbit.OauthController, :callback
  end
end

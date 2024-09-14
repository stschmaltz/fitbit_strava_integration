defmodule FitbitStravaIntegrationWeb.Strava.OAuthController do
  use FitbitStravaIntegrationWeb, :controller
  alias FitbitStravaIntegration.Strava.StravaOAuth
  alias FitbitStravaIntegrationWeb.BaseOAuthController

  def authorize(conn, params) do
    BaseOAuthController.authorize(conn, StravaOAuth)
  end

  def callback(conn, params) do
    BaseOAuthController.callback(conn, params, StravaOAuth, "strava")
  end
end

defmodule FitbitStravaIntegrationWeb.Fitbit.OAuthController do
  use FitbitStravaIntegrationWeb, :controller
  alias FitbitStravaIntegration.Fitbit.FitbitOAuth
  alias FitbitStravaIntegrationWeb.BaseOAuthController

  def authorize(conn, params) do
    BaseOAuthController.authorize(conn, FitbitOAuth)
  end

  def callback(conn, params) do
    BaseOAuthController.callback(conn, params, FitbitOAuth, "fitbit")
  end
end

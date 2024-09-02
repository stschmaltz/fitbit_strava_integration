defmodule FitbitStravaIntegration.Fitbit.FitbitApi do
  @http_client Application.compile_env(
                 :fitbit_strava_integration,
                 :http_client,
                 FitbitStravaIntegration.HTTPClient.ApiHelper
               )

  @base_url "https://api.fitbit.com/1"

  def get_profile(token) do
    @http_client.get("#{@base_url}/user/-/profile.json", token)
  end
end

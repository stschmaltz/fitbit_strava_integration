defmodule FitbitStravaIntegration.Fitbit.FitbitApi do
  alias FitbitStravaIntegration.ApiHelper

  @base_url "https://api.fitbit.com/1"

  def get_profile(token) do
    ApiHelper.get("#{@base_url}/user/-/profile.json", token)
  end
end

defmodule FitbitStravaIntegration.Fitbit.FitbitApi do
  alias FitbitStravaIntegration.ApiHelper

  @base_url "https://api.fitbit.com/1"

  @spec get_profile(any()) ::
          {:error, HTTPoison.Error.t()}
          | {:ok,
             %{
               :__struct__ => HTTPoison.AsyncResponse | HTTPoison.Response,
               optional(:body) => any(),
               optional(:headers) => list(),
               optional(:id) => reference(),
               optional(:request) => HTTPoison.Request.t(),
               optional(:request_url) => any(),
               optional(:status_code) => integer()
             }}
  def get_profile(token) do
    ApiHelper.get("#{@base_url}/user/-/profile.json", token)
  end
end

defmodule FitbitStravaIntegration.HTTPClient.MockApiHelper do
  @behaviour FitbitStravaIntegration.HTTPClient.Behaviour

  @impl FitbitStravaIntegration.HTTPClient.Behaviour
  def get(url, token, headers \\ []) do
    FitbitStravaIntegration.HTTPClient.MockApiHelper.get(url, token, headers)
  end

  @impl FitbitStravaIntegration.HTTPClient.Behaviour
  def process_request_headers(headers, token) do
    [{"Authorization", "Bearer #{token}"} | headers]
  end
end

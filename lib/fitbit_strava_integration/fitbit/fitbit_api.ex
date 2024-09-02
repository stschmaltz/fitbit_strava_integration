defmodule FitbitStravaIntegration.Fitbit.FitbitApi do
  @http_client Application.compile_env(
                 :fitbit_strava_integration,
                 :http_client,
                 FitbitStravaIntegration.HTTPClient.ApiHelper
               )

  @base_url "https://api.fitbit.com/1"

  @key_mapping %{
    after_date: "afterDate",
    sort: "sort",
    offset: "offset",
    limit: "limit"
  }

  def get_profile(token) do
    @http_client.get("#{@base_url}/user/-/profile.json", token)
  end

  def get_activities(token, opts \\ []) do
    defaults = [
      after_date: Date.utc_today() |> Date.to_string(),
      sort: "desc",
      offset: 0,
      limit: 100
    ]

    opts = Keyword.merge(defaults, opts)

    params =
      opts
      |> Keyword.take(Map.keys(@key_mapping))
      |> Keyword.update!(:after_date, &to_string/1)
      |> Enum.map(fn {key, val} -> {Map.get(@key_mapping, key, Atom.to_string(key)), val} end)
      |> Enum.into(%{})

    url = "#{@base_url}/user/-/activities/list.json"
    url_with_params = "#{url}?#{URI.encode_query(params)}"

    @http_client.get(url_with_params, token)
  end
end

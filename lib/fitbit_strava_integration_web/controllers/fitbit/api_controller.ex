defmodule FitbitStravaIntegrationWeb.Fitbit.ApiController do
  use FitbitStravaIntegrationWeb, :controller
  alias FitbitStravaIntegration.Fitbit.FitbitApi

  @spec profile(Plug.Conn.t(), map) :: Plug.Conn.t()
  def profile(conn, _params) do
    IO.puts("Fetching Fitbit profile #{inspect(conn)}")
    token = conn.assigns.fitbit_token

    case FitbitApi.get_profile(token) do
      {:ok, profile} ->
        json(conn, profile)

      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Failed to fetch profile", reason: reason})
    end
  end

  def activities(conn, _params) do
    token = conn.assigns.fitbit_token
    # set date to 7 days ago
    after_date = Date.utc_today() |> Date.add(-7) |> Date.to_string()

    case FitbitApi.get_activities(token, after_date: after_date) do
      {:ok, activities} ->
        IO.puts("DATA: #{inspect(activities)}")

        json(conn, activities)

      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Failed to fetch activities", reason: reason})
    end
  end
end

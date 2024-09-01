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
end

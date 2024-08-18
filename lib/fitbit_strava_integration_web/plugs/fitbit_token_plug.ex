defmodule FitbitStravaIntegrationWeb.FitbitTokenPlug do
  import Plug.Conn
  alias FitbitStravaIntegration.Fitbit.FitbitOauth

  def init(opts), do: opts

  def call(conn, _opts) do
    IO.puts("Checking for valid Fitbit token")

    case get_valid_api_token(conn) do
      {:ok, token} ->
        IO.puts("Fitbit token is valid #{token}")
        assign(conn, :fitbit_token, token)

      _ ->
        conn
        |> put_session(:return_to, conn.request_path)
        |> Phoenix.Controller.redirect(to: "/api/fitbit/auth")
        |> halt()
    end
  end

  defp get_valid_api_token(conn) do
    conn =
      fetch_cookies(conn,
        encrypted: ~w(fitbit_token fitbit_refresh_token fitbit_token_expires_at)
      )

    access_token = conn.cookies["fitbit_token"]
    refresh_token = conn.cookies["fitbit_refresh_token"]

    expires_at =
      conn.cookies["fitbit_token_expires_at"]

    cond do
      is_nil(access_token) ->
        :error

      token_expired?(expires_at) ->
        refresh_token(conn, refresh_token)

      true ->
        {:ok, access_token}
    end
  end

  def token_expired?(expires_at) do
    case expires_at do
      nil ->
        true

      expires_at when is_binary(expires_at) ->
        case Integer.parse(expires_at) do
          {int_expires_at, _} ->
            System.system_time(:second) > int_expires_at

          :error ->
            true
        end

      _ ->
        true
    end
  end

  def refresh_token(conn, refresh_token) do
    case FitbitOauth.refresh_token(refresh_token) do
      {:ok, token} ->
        conn
        |> put_resp_cookie("fitbit_token", token.access_token, encrypt: true)
        |> put_resp_cookie("fitbit_refresh_token", token.refresh_token, encrypt: true)
        |> put_resp_cookie("fitbit_token_expires_at", to_string(token.expires_at), encrypt: true)

        {:ok, token.access_token}

      _ ->
        :error
    end
  end
end

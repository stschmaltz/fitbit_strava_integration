defmodule FitbitStravaIntegrationWeb.FitbitTokenPlug do
  import Plug.Conn
  alias FitbitStravaIntegration.Fitbit.FitbitOauth
  require Logger

  @spec init(any()) :: any()
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def call(conn, _opts) do
    Logger.info("Checking for valid Fitbit token")

    case get_valid_api_token(conn) do
      {:ok, token, updated_conn} ->
        Logger.info("Fitbit token is valid")
        assign(updated_conn, :fitbit_token, token)

      {:error, reason} ->
        handle_error(conn, reason)
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
      is_nil(access_token) or is_nil(refresh_token) ->
        {:error, :missing_tokens}

      token_expired?(expires_at) ->
        refresh_token(conn, refresh_token)

      true ->
        {:ok, access_token, conn}
    end
  end

  @spec token_expired?(any()) :: boolean()
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

  @spec refresh_token(any(), any()) ::
          {:error, :refresh_token_failed | :unexpected_error, any()} | {:ok, any(), Plug.Conn.t()}
  def refresh_token(conn, refresh_token) do
    try do
      token = FitbitOauth.refresh_token(refresh_token)

      conn =
        conn
        |> put_resp_cookie("fitbit_token", token.access_token, encrypt: true)
        |> put_resp_cookie("fitbit_refresh_token", token.refresh_token, encrypt: true)
        |> put_resp_cookie("fitbit_token_expires_at", to_string(token.expires_at), encrypt: true)

      {:ok, token.access_token, conn}
    rescue
      e in OAuth2.Error ->
        Logger.error("Failed to refresh Fitbit token: #{inspect(e)}")
        {:error, :refresh_token_failed, conn}

      unexpected ->
        Logger.error("Unexpected error during Fitbit token refresh: #{inspect(unexpected)}")
        {:error, :unexpected_error, conn}
    end
  end

  defp handle_error(conn, reason) do
    log_error(reason)

    conn
    |> put_session(:return_to, conn.request_path)
    |> Phoenix.Controller.redirect(to: "/api/fitbit/auth")
    |> halt()
  end

  defp log_error(:missing_tokens), do: Logger.error("Missing Fitbit tokens")
  defp log_error(:refresh_token_failed), do: Logger.error("Failed to refresh Fitbit token")

  defp log_error(reason),
    do: Logger.error("Fitbit token authentication error: #{inspect(reason)}")
end

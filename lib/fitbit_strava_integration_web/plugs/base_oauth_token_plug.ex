defmodule FitbitStravaIntegrationWeb.OAuthTokenHandler do
  import Plug.Conn
  require Logger

  @spec handle_token(Plug.Conn.t(), module(), [String.t()], atom()) :: Plug.Conn.t()
  def handle_token(conn, oauth_module, cookie_keys, assign_key) do
    Logger.info("Checking for valid OAuth token")

    case get_valid_api_token(conn, oauth_module, cookie_keys) do
      {:ok, token, updated_conn} ->
        Logger.info("#{assign_key} token is valid")
        assign(updated_conn, assign_key, token)

      {:error, reason} ->
        handle_error(conn, oauth_module, reason)
    end
  end

  defp get_valid_api_token(conn, oauth_module, cookie_keys) do
    conn =
      fetch_cookies(conn,
        encrypted: cookie_keys
      )

    access_token = conn.cookies[Enum.at(cookie_keys, 0)]
    refresh_token = conn.cookies[Enum.at(cookie_keys, 1)]
    expires_at = conn.cookies[Enum.at(cookie_keys, 2)]

    cond do
      is_nil(access_token) or is_nil(refresh_token) ->
        {:error, :missing_tokens}

      token_expired?(expires_at) ->
        refresh_token(conn, oauth_module, refresh_token, cookie_keys)

      true ->
        {:ok, access_token, conn}
    end
  end

  defp token_expired?(expires_at) do
    case expires_at do
      nil ->
        true

      expires_at when is_binary(expires_at) ->
        case Integer.parse(expires_at) do
          {int_expires_at, _} -> System.system_time(:second) > int_expires_at
          :error -> true
        end

      _ ->
        true
    end
  end

  defp refresh_token(conn, oauth_module, refresh_token, cookie_keys) do
    try do
      token = oauth_module.refresh_token(refresh_token)

      conn =
        conn
        |> put_resp_cookie(Enum.at(cookie_keys, 0), token.access_token, encrypt: true)
        |> put_resp_cookie(Enum.at(cookie_keys, 1), token.refresh_token, encrypt: true)
        |> put_resp_cookie(Enum.at(cookie_keys, 2), to_string(token.expires_at), encrypt: true)

      {:ok, token.access_token, conn}
    rescue
      e in OAuth2.Error ->
        Logger.error("Failed to refresh OAuth token: #{inspect(e)}")
        {:error, :refresh_token_failed, conn}

      unexpected ->
        Logger.error("Unexpected error during OAuth token refresh: #{inspect(unexpected)}")
        {:error, :unexpected_error, conn}
    end
  end

  defp handle_error(conn, oauth_module, reason) do
    log_error(reason)

    conn
    |> put_session(:return_to, conn.request_path)
    |> Phoenix.Controller.redirect(to: oauth_module.auth_url())
    |> halt()
  end

  defp log_error(:missing_tokens), do: Logger.error("Missing OAuth tokens")
  defp log_error(:refresh_token_failed), do: Logger.error("Failed to refresh OAuth token")
  defp log_error(reason), do: Logger.error("OAuth token authentication error: #{inspect(reason)}")
end

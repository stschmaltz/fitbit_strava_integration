defmodule FitbitStravaIntegration.Fitbit.FitbitOauth do
  @env Dotenv.load()

  @fitbit_client_id Dotenv.Env.get(@env, "FITBIT_CLIENT_ID")
  @fitbit_client_secret Dotenv.Env.get(@env, "FITBIT_CLIENT_SECRET")
  @redirect_uri "http://localhost:4000/api/fitbit/callback"
  @site "https://api.fitbit.com"

  @spec client() :: OAuth2.Client.t()
  def client do
    IO.puts("Creating Fitbit OAuth2 client")

    IO.puts("Client ID: #{@fitbit_client_id}")
    IO.puts("Client Secret: #{@fitbit_client_secret}")
    IO.puts("Redirect URI: #{@redirect_uri}")
    IO.puts("Site: #{@site}")

    OAuth2.Client.new(
      strategy: OAuth2.Strategy.AuthCode,
      client_id: @fitbit_client_id,
      client_secret: @fitbit_client_secret,
      redirect_uri: @redirect_uri,
      site: @site,
      authorize_url: "/oauth2/authorize",
      token_url: "/oauth2/token"
    )
    |> OAuth2.Client.put_serializer("application/json", Jason)
  end

  @spec authorize_url!(OAuth2.Client.t()) :: binary()
  def authorize_url!(client) do
    IO.puts("Generating Fitbit authorization URL")

    OAuth2.Client.authorize_url!(client,
      scope:
        "activity cardio_fitness electrocardiogram heartrate location nutrition oxygen_saturation profile respiratory_rate settings sleep social temperature weight"
    )
  end

  @spec get_token_from_client(OAuth2.Client.t()) :: OAuth2.Client.t()
  def get_token_from_client(client, params \\ [], headers \\ []) do
    OAuth2.Client.get_token!(client, params, headers)
  end

  def refresh_token(refresh_token) do
    refresh_client =
      OAuth2.Client.new(
        strategy: OAuth2.Strategy.Refresh,
        client_id: @fitbit_client_id,
        client_secret: @fitbit_client_secret,
        redirect_uri: @redirect_uri,
        site: @site,
        authorize_url: "/oauth2/authorize",
        token_url: "/oauth2/token",
        params: %{"refresh_token" => refresh_token}
      )

    get_token_from_client(refresh_client)
  end
end

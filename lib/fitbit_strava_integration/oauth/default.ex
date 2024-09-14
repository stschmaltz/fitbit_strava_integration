defmodule FitbitStravaIntegration.OAuth.Default do
  defmacro __using__(opts) do
    quote do
      @behaviour FitbitStravaIntegration.OAuth.Behavior

      @client_id Keyword.fetch!(unquote(opts), :client_id)
      @client_secret Keyword.fetch!(unquote(opts), :client_secret)
      @redirect_uri Keyword.fetch!(unquote(opts), :redirect_uri)
      @site Keyword.fetch!(unquote(opts), :site)
      @authorize_url Keyword.get(unquote(opts), :authorize_url, "/oauth2/authorize")
      @token_url Keyword.get(unquote(opts), :token_url, "/oauth2/token")
      @auth_url Keyword.get(unquote(opts), :auth_url)

      def client do
        OAuth2.Client.new(
          strategy: OAuth2.Strategy.AuthCode,
          client_id: @client_id,
          client_secret: @client_secret,
          redirect_uri: @redirect_uri,
          site: @site,
          authorize_url: @authorize_url,
          token_url: @token_url
        )
        |> OAuth2.Client.put_serializer("application/json", Jason)
      end

      def authorize_url!(client, scope) do
        OAuth2.Client.authorize_url!(client, scope: scope)
      end

      def get_token_from_client(client, params \\ [], headers \\ []) do
        OAuth2.Client.get_token!(client, params, headers)
      end

      def refresh_token(refresh_token) do
        client =
          OAuth2.Client.new(
            strategy: OAuth2.Strategy.Refresh,
            client_id: @client_id,
            client_secret: @client_secret,
            site: @site,
            token_url: @token_url,
            params: %{"refresh_token" => refresh_token}
          )

        OAuth2.Client.get_token!(client)
      end

      def auth_url() do
        @auth_url
      end
    end
  end
end

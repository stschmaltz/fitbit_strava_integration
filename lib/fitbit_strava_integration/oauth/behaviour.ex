defmodule FitbitStravaIntegration.OAuth.Behavior do
  @callback client() :: OAuth2.Client.t()
  @callback authorize_url!(OAuth2.Client.t()) :: binary()
  @callback get_token_from_client(OAuth2.Client.t(), String.t()) ::
              OAuth2.Client.t() | {:error, any()}
  @callback refresh_token(String.t()) :: OAuth2.Client.t() | {:error, any()}
end

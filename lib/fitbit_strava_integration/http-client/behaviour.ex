defmodule FitbitStravaIntegration.HTTPClient.Behaviour do
  @callback get(url :: String.t(), token :: String.t(), headers :: list()) ::
              {:ok, map()} | {:error, atom() | {integer(), String.t()}}

  @callback process_request_headers(headers :: list(), token :: String.t()) :: list()
end

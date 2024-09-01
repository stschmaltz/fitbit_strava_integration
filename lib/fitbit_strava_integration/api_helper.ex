defmodule FitbitStravaIntegration.ApiHelper do
  use HTTPoison.Base

  @spec process_request_headers(any(), any()) :: nonempty_maybe_improper_list()
  def process_request_headers(headers, token) do
    [{"Authorization", "Bearer #{token}"} | headers]
  end

  def get(url, token, headers \\ []) do
    HTTPoison.get(url, process_request_headers(headers, token))
    |> handle_response()
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, Jason.decode!(body)}
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 401}}) do
    {:error, :unauthorized}
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code, body: body}}) do
    {:error, {status_code, body}}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end

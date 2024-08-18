defmodule FitbitStravaIntegration.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    IO.puts("Starting FitbitStravaIntegration application #{Mix.env()}")

    unless Mix.env() == :prod do
      Dotenv.load()
      Mix.Task.run("loadconfig")
    end

    children = [
      FitbitStravaIntegrationWeb.Telemetry,
      {DNSCluster,
       query: Application.get_env(:fitbit_strava_integration, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FitbitStravaIntegration.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FitbitStravaIntegration.Finch},
      # Start a worker by calling: FitbitStravaIntegration.Worker.start_link(arg)
      # {FitbitStravaIntegration.Worker, arg},
      # Start to serve requests, typically the last entry
      FitbitStravaIntegrationWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FitbitStravaIntegration.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FitbitStravaIntegrationWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

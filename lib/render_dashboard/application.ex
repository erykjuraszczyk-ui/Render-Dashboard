defmodule RenderDashboard.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RenderDashboardWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:render_dashboard, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: RenderDashboard.PubSub},
      # Start a worker by calling: RenderDashboard.Worker.start_link(arg)
      # {RenderDashboard.Worker, arg},
      # Start to serve requests, typically the last entry
      RenderDashboardWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RenderDashboard.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RenderDashboardWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule Parent.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ParentWeb.Telemetry,
      Parent.Repo,
      {DNSCluster, query: Application.get_env(:parent, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Parent.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Parent.Finch},
      # Start a worker by calling: Parent.Worker.start_link(arg)
      # {Parent.Worker, arg},
      # Start to serve requests, typically the last entry
      ParentWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Parent.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ParentWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule InnoTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      InnoTest.Repo,
      # Start the Telemetry supervisor
      InnoTestWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: InnoTest.PubSub},
      # Start the Endpoint (http/https)
      InnoTestWeb.Endpoint,
      InnoTest.ParseWorker,
      InnoTest.FetchWorker,
      :hackney_pool.child_spec(:rss_pool, [timeout: 15000, max_connections: 10])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InnoTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    InnoTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

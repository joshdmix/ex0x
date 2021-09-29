defmodule Ex0x.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Ex0x.Repo,
      # Start the Telemetry supervisor
      Ex0xWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Ex0x.PubSub},
      # Start the Endpoint (http/https)
      Ex0xWeb.Endpoint
      # Start a worker by calling: Ex0x.Worker.start_link(arg)
      # {Ex0x.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ex0x.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Ex0xWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

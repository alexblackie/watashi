defmodule Watashi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Watashi.Worker.start_link(arg)
      # {Watashi.Worker, arg}
      {Bandit, plug: Watashi.Router, port: port()},
      Watashi.ArticleRepository
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Watashi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp port do
    Application.get_env(:watashi, :router_port, 4000)
  end
end

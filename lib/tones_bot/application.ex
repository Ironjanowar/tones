defmodule TonesBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    token = ExGram.Config.get(:ex_gram, :token)

    children = [
      ExGram,
      {TonesBot.Bot, [method: :polling, token: token]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TonesBot.Supervisor]

    case Supervisor.start_link(children, opts) do
      {:ok, _} = ok ->
        Logger.info("TonesBot started")
        ok

      err ->
        Logger.error("Error starting TonesBot")
        err
    end
  end
end

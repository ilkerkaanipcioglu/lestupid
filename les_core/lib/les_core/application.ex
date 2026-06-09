defmodule LesCore.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      if start_http_server?() do
        [
          {Plug.Cowboy, scheme: :http, plug: LesCore.HTTP.Router, options: [port: port()]}
        ]
      else
        []
      end

    Supervisor.start_link(children, strategy: :one_for_one, name: LesCore.Supervisor)
  end

  defp start_http_server? do
    System.get_env("LES_CORE_START_SERVER", "true") != "false"
  end

  defp port do
    case System.get_env("PORT", "4000") do
      value when is_binary(value) ->
        case Integer.parse(value) do
          {port, _} -> port
          :error -> 4000
        end
    end
  end
end

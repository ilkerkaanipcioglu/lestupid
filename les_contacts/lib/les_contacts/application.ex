defmodule LesContacts.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      if start_http_server?() do
        [
          {Plug.Cowboy, scheme: :http, plug: LesContacts.HTTP.Router, options: [port: port()]}
        ]
      else
        []
      end

    Supervisor.start_link(children, strategy: :one_for_one, name: LesContacts.Supervisor)
  end

  defp start_http_server? do
    System.get_env("LES_CONTACTS_START_SERVER", "true") != "false"
  end

  defp port do
    case System.get_env("PORT", "4004") do
      value when is_binary(value) ->
        case Integer.parse(value) do
          {port, _} -> port
          :error -> 4004
        end
    end
  end
end

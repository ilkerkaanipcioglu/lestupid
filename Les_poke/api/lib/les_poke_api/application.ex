defmodule LesPokeApi.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LesPokeApi.Repo,
      {DNSCluster, query: Application.get_env(:les_poke_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LesPokeApi.PubSub},
      LesPokeApiWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: LesPokeApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    LesPokeApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

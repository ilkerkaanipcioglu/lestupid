defmodule LesMatchApi.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LesMatchApi.Repo,
      {DNSCluster, query: Application.get_env(:les_match_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LesMatchApi.PubSub},
      LesMatchApiWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: LesMatchApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    LesMatchApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

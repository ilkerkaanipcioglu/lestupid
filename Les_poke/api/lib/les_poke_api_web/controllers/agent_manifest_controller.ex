defmodule LesPokeApiWeb.AgentManifestController do
  use LesPokeApiWeb, :controller

  alias LesPokeApi.Ecosystem

  def show(conn, _params) do
    json(conn, Ecosystem.manifest(LesPokeApiWeb.Endpoint.url()))
  end
end

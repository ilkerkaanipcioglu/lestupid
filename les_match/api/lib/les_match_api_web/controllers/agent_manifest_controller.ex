defmodule LesMatchApiWeb.AgentManifestController do
  use LesMatchApiWeb, :controller

  alias LesMatchApi.Ecosystem

  def show(conn, _params) do
    json(conn, Ecosystem.manifest(LesMatchApiWeb.Endpoint.url()))
  end
end

defmodule LesMatchApiWeb.HealthController do
  use LesMatchApiWeb, :controller

  alias LesMatchApi.Ecosystem

  def show(conn, _params) do
    json(conn, Ecosystem.health())
  end
end

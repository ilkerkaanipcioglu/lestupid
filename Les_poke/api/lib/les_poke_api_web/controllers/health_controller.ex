defmodule LesPokeApiWeb.HealthController do
  use LesPokeApiWeb, :controller

  alias LesPokeApi.Ecosystem

  def show(conn, _params) do
    json(conn, Ecosystem.health())
  end
end

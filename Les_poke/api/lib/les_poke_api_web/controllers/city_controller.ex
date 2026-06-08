defmodule LesPokeApiWeb.CityController do
  use LesPokeApiWeb, :controller

  alias LesPokeApi.Catalog

  def index(conn, _params) do
    json(conn, %{data: Catalog.list_cities()})
  end
end

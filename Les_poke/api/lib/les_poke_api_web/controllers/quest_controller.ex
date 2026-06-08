defmodule LesPokeApiWeb.QuestController do
  use LesPokeApiWeb, :controller

  alias LesPokeApi.Catalog

  def index(conn, params) do
    json(conn, %{data: Catalog.list_quests(params)})
  end

  def show(conn, %{"id" => id}) do
    case Catalog.get_quest(id) do
      nil -> send_resp(conn, :not_found, "")
      quest -> json(conn, %{data: quest})
    end
  end
end

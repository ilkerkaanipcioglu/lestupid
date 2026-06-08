defmodule LesMatchApiWeb.OpportunityController do
  use LesMatchApiWeb, :controller

  alias LesMatchApi.Matching

  def create(conn, params) do
    conn
    |> put_status(:created)
    |> json(Matching.create_opportunity(params))
  end
end

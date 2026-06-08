defmodule LesMatchApiWeb.SafetyController do
  use LesMatchApiWeb, :controller

  alias LesMatchApi.Matching

  def report(conn, params) do
    conn
    |> put_status(:accepted)
    |> json(Matching.record_decision("report", params))
  end
end

defmodule LesMatchApiWeb.MatchController do
  use LesMatchApiWeb, :controller

  alias LesMatchApi.Matching

  def preview(conn, params) do
    json(conn, Matching.preview(params))
  end

  def accept(conn, params) do
    json(conn, Matching.record_decision("accept", params))
  end

  def reject(conn, params) do
    json(conn, Matching.record_decision(Map.get(params, "action", "reject"), params))
  end
end

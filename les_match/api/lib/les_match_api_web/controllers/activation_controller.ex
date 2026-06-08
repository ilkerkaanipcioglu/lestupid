defmodule LesMatchApiWeb.ActivationController do
  use LesMatchApiWeb, :controller

  alias LesMatchApi.Identity

  def identity_status(conn, params) do
    json(conn, Identity.status(params))
  end

  def index(conn, params) do
    json(conn, Identity.list_activations(params))
  end

  def create(conn, params) do
    conn
    |> put_status(:created)
    |> json(Identity.activate(params))
  end

  def update(conn, %{"product_id" => product_id} = params) do
    json(conn, Identity.update(product_id, params))
  end

  def delete(conn, %{"product_id" => product_id} = params) do
    json(conn, Identity.revoke(product_id, params))
  end
end

defmodule LesPokeApiWeb.CheckInController do
  use LesPokeApiWeb, :controller

  alias LesPokeApi.CheckIns

  def create(conn, params) do
    case CheckIns.create(params) do
      {:ok, response} ->
        conn
        |> put_status(:created)
        |> json(response)

      {:error, {:unknown_privacy_level, level}} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: %{code: "unknown_privacy_level", detail: level}})
    end
  end
end

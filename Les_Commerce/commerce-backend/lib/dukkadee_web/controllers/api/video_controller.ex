defmodule DukkadeeWeb.Api.VideoController do
  use DukkadeeWeb, :controller

  alias Dukkadee.Tutorials

  def index(conn, params) do
    videos =
      if store_id = params["store_id"] do
        Tutorials.list_store_videos(store_id)
      else
        Tutorials.list_videos()
      end
      |> Dukkadee.Repo.preload(:products)

    render(conn, :index, videos: videos)
  end

  def show(conn, %{"id" => id}) do
    video = Tutorials.get_video_with_products(id)

    if video do
      render(conn, :show, video: video)
    else
      conn
      |> put_status(:not_found)
      |> put_view(DukkadeeWeb.ErrorJSON)
      |> render(:"404")
    end
  end
end

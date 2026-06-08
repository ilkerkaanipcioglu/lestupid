defmodule Dukkadee.Tutorials do
  @moduledoc """
  The Tutorials context. Handles DIY videos and product/material checklists.
  """

  import Ecto.Query, warn: false
  alias Dukkadee.Repo
  alias Dukkadee.Tutorials.Video
  alias Dukkadee.Products.Product

  @doc """
  Returns the list of videos.
  """
  def list_videos do
    Repo.all(Video)
  end

  @doc """
  Returns the list of videos for a specific store.
  """
  def list_store_videos(store_id) do
    Video
    |> where([v], v.store_id == ^store_id)
    |> Repo.all()
  end

  @doc """
  Gets a single video.
  """
  def get_video(id), do: Repo.get(Video, id)

  @doc """
  Gets a single video and preloads its products (materials & finished goods).
  """
  def get_video_with_products(id) do
    Video
    |> Repo.get(id)
    |> Repo.preload(:products)
  end

  @doc """
  Creates a video.
  """
  def create_video(attrs \\ %{}) do
    %Video{}
    |> Video.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a video.
  """
  def update_video(%Video{} = video, attrs) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a video.
  """
  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  @doc """
  Links a product/material to a video.
  """
  def add_product_to_video(video_id, product_id) do
    video = get_video_with_products(video_id)
    product = Repo.get(Product, product_id)

    if video && product do
      # Avoid duplicate associations
      unless Enum.any?(video.products, fn p -> p.id == product.id end) do
        video
        |> Repo.preload(:products)
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:products, [product | video.products])
        |> Repo.update()
      else
        {:ok, video}
      end
    else
      {:error, :not_found}
    end
  end

  @doc """
  Unlinks a product/material from a video.
  """
  def remove_product_from_video(video_id, product_id) do
    video = get_video_with_products(video_id)

    if video do
      new_products = Enum.reject(video.products, fn p -> p.id == product_id end)

      video
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:products, new_products)
      |> Repo.update()
    else
      {:error, :not_found}
    end
  end
end

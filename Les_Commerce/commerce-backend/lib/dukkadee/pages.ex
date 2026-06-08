defmodule Dukkadee.Pages do
  @moduledoc """
  The Pages context.
  """

  import Ecto.Query, warn: false
  alias Dukkadee.Repo
  alias Dukkadee.Pages.Page

  @doc """
  Returns the list of pages.
  """
  def list_pages do
    Repo.all(Page)
  end

  @doc """
  Returns the list of pages for a specific store.
  """
  def list_store_pages(store_id) do
    Page
    |> where([p], p.store_id == ^store_id)
    |> Repo.all()
  end

  @doc """
  Returns the list of published pages for a specific store.
  """
  def list_published_store_pages(store_id) do
    Page
    |> where([p], p.store_id == ^store_id and p.is_published == true)
    |> Repo.all()
  end

  @doc """
  Gets a single page.
  """
  def get_page(id), do: Repo.get(Page, id)

  @doc """
  Gets a page by slug for a specific store.
  """
  def get_store_page_by_slug(store_id, slug) do
    Page
    |> where([p], p.store_id == ^store_id and p.slug == ^slug)
    |> Repo.one()
  end

  @doc """
  Creates a page.
  """
  def create_page(attrs \\ %{}) do
    %Page{}
    |> Page.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a page.
  """
  def update_page(%Page{} = page, attrs) do
    page
    |> Page.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a page.
  """
  def delete_page(%Page{} = page) do
    Repo.delete(page)
  end

  @doc """
  Publishes a page.
  """
  def publish_page(%Page{} = page) do
    update_page(page, %{is_published: true})
  end

  @doc """
  Unpublishes a page.
  """
  def unpublish_page(%Page{} = page) do
    update_page(page, %{is_published: false})
  end
end

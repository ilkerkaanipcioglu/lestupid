defmodule Dukkadee.Stores do
  @moduledoc """
  The Stores context.
  """

  import Ecto.Query, warn: false
  alias Dukkadee.Repo

  alias Dukkadee.Stores.Store

  @doc """
  Returns the list of stores.
  """
  def list_stores do
    Repo.all(Store)
  end

  @doc """
  Returns a paginated list of stores.
  
  ## Options
    * :page - Page number (default: 1)
    * :per_page - Number of items per page (default: 12)
  """
  def list_stores_paginated(opts \\ []) do
    page = Keyword.get(opts, :page, 1)
    per_page = Keyword.get(opts, :per_page, 12)
    
    query = from s in Store,
      order_by: [desc: s.inserted_at]
    
    Repo.paginate(query, page: page, page_size: per_page)
  end

  @doc """
  Returns the list of featured stores.
  """
  def list_featured_stores(limit \\ 6) do
    # In the future, this could be based on store ratings, activity or paid promotion
    query = from s in Store,
      order_by: [desc: s.inserted_at],
      limit: ^limit
    
    Repo.all(query)
  end

  @doc """
  Returns the list of stores owned by a specific user.
  """
  def list_stores_by_owner(user_id) do
    query = from s in Store,
      where: s.user_id == ^user_id,
      order_by: [desc: s.inserted_at]
    
    Repo.all(query)
  end

  @doc """
  Gets a store owned by a specific user.
  
  Returns nil if the store doesn't exist or is not owned by the specified user.
  """
  def get_store_by_owner(store_id, user_id) do
    query = from s in Store,
      where: s.id == ^store_id and s.user_id == ^user_id
    
    Repo.one(query)
  end

  @doc """
  Gets a single store.
  """
  def get_store(id), do: Repo.get(Store, id)

  @doc """
  Gets a single store by slug.
  """
  def get_store_by_slug(slug) do
    Repo.get_by(Store, slug: slug)
  end

  @doc """
  Gets a single store by slug, raises an error if not found.
  """
  def get_store_by_slug!(slug) do
    query = from s in Store, where: s.slug == ^slug
    Repo.one!(query)
  end

  @doc """
  Gets a single store by domain.
  """
  def get_store_by_domain(domain) do
    query = from s in Store, where: s.domain == ^domain
    Repo.one(query)
  end

  @doc """
  Creates a store.
  """
  def create_store(attrs \\ %{}) do
    %Store{}
    |> Store.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a store.
  """
  def update_store(%Store{} = store, attrs) do
    store
    |> Store.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a store.
  """
  def delete_store(%Store{} = store) do
    Repo.delete(store)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking store changes.
  """
  def change_store(%Store{} = store, attrs \\ %{}) do
    Store.changeset(store, attrs)
  end

  @doc """
  Search stores by name or description.
  """
  def search_stores(query) do
    wildcard_query = "%#{query}%"
    
    from(s in Store,
      where: ilike(s.name, ^wildcard_query) or ilike(s.description, ^wildcard_query)
    )
    |> Repo.all()
  end
  
  @doc """
  Search stores with pagination.
  
  ## Options
    * :query - Search string
    * :page - Page number (default: 1)
    * :per_page - Number of items per page (default: 12)
  """
  def search_stores_paginated(search_query, opts \\ []) do
    page = Keyword.get(opts, :page, 1)
    per_page = Keyword.get(opts, :per_page, 12)
    
    wildcard_query = "%#{search_query}%"
    
    query = from s in Store,
      where: ilike(s.name, ^wildcard_query) or ilike(s.description, ^wildcard_query),
      order_by: [desc: s.inserted_at]
    
    Repo.paginate(query, page: page, page_size: per_page)
  end
  
  @doc """
  Filter stores by criteria.
  """
  def filter_stores(criteria \\ %{}) do
    base_query = from(s in Store)
    
    query = Enum.reduce(criteria, base_query, fn
      {:name, name}, query when is_binary(name) and name != "" ->
        where(query, [s], ilike(s.name, ^"%#{name}%"))
      
      {:description, description}, query when is_binary(description) and description != "" ->
        where(query, [s], ilike(s.description, ^"%#{description}%"))
      
      {_, _}, query -> query
    end)
    
    Repo.all(query)
  end
end

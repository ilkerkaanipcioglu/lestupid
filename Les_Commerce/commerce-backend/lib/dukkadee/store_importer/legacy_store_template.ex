defmodule Dukkadee.StoreImporter.LegacyStoreTemplate do
  @moduledoc """
  The StoreImporter.LegacyStoreTemplate context.
  This module handles the management of store templates.
  """

  import Ecto.Query, warn: false
  
  # Get the repo from config, defaulting to Dukkadee.Repo
  def repo, do: Application.get_env(:dukkadee, :repo, Dukkadee.Repo)
  
  # Get the Stores module from config, defaulting to Dukkadee.Stores
  def stores_module, do: Application.get_env(:dukkadee, :stores_module, Dukkadee.Stores)

  # These aliases are commented out for now but will be used in the full implementation
  # alias Dukkadee.Stores.Store
  # alias Dukkadee.Products
  # alias Dukkadee.Pages
  alias Dukkadee.StoreImporter.Templates.InklessismoreTemplate

  @doc """
  Returns the list of available templates.
  """
  def list_templates do
    # Query the templates table
    query = from t in "templates",
      select: %{
        id: t.id,
        name: t.name,
        description: t.description,
        primary_color: t.primary_color,
        secondary_color: t.secondary_color,
        accent_color: t.accent_color,
        inserted_at: t.inserted_at,
        updated_at: t.updated_at
      }
    
    # Execute the query
    repo().all(query)
  end

  @doc """
  Gets a single template by ID.

  Raises `Ecto.NoResultsError` if the Template does not exist.
  """
  def get_template!(id) do
    # Get the template by ID
    repo().get("templates", id)
  end
  
  @doc """
  Gets a template by ID.
  Returns {:ok, template} if found, {:error, reason} otherwise.
  """
  def get_template(id) do
    template = repo().get("templates", id)
    
    if template do
      {:ok, template}
    else
      {:error, "Template not found"}
    end
  end

  @doc """
  Creates a template.
  """
  def create_template(attrs \\ %{}) do
    # Create a changeset for the template
    %Ecto.Changeset{data: %{}, changes: attrs, valid?: true}
    |> repo().insert()
  end

  @doc """
  Updates a template.
  """
  def update_template(template, attrs) do
    # Update the template with the given attributes
    %Ecto.Changeset{data: template, changes: attrs, valid?: true}
    |> repo().update()
  end

  @doc """
  Deletes a template.
  """
  def delete_template(template) do
    repo().delete(template)
  end

  @doc """
  Applies a template to create a new store.
  """
  def apply_template(template_id, store_attrs) do
    # Get the template
    template = get_template!(template_id)

    # Create store with template attributes
    store_attrs = Map.merge(store_attrs, %{
      primary_color: template.primary_color,
      secondary_color: template.secondary_color,
      accent_color: template.accent_color
    })

    # Create the store
    case stores_module().create_store(store_attrs) do
      {:ok, store} ->
        # Apply template-specific setup (products, pages, etc.)
        case template.name do
          "InklessIsMore" ->
            InklessismoreTemplate.apply_to_store(store)
          _ ->
            {:ok, store}
        end
      error ->
        error
    end
  end

  @doc """
  Creates a store from a legacy website.
  """
  def create_from_legacy(legacy_url, store_attrs) do
    # Extract data from legacy website
    {:ok, legacy_data} = Dukkadee.StoreImporter.LegacyStoreImporter.extract_from_url(legacy_url)

    # Create store with extracted attributes
    store_attrs = Map.merge(store_attrs, %{
      primary_color: legacy_data.primary_color,
      secondary_color: legacy_data.secondary_color,
      accent_color: legacy_data.accent_color
    })

    # Create the store
    case stores_module().create_store(store_attrs) do
      {:ok, store} ->
        # Import products and pages from legacy data
        Dukkadee.StoreImporter.LegacyStoreImporter.import_products(legacy_data.products, store.id)
        Dukkadee.StoreImporter.LegacyStoreImporter.import_pages(legacy_data.pages, store.id)
        {:ok, store}
      error ->
        error
    end
  end

  @doc """
  Creates a template from a legacy website.
  """
  def create_template_from_legacy_site(legacy_url, user_id) do
    # Extract data from legacy website
    with {:ok, legacy_data} <- Dukkadee.StoreImporter.LegacyStoreImporter.extract_from_url(legacy_url) do
      # Create basic store attributes
      store_attrs = %{
        name: "New Store from Legacy",
        slug: "new-store-from-legacy",
        user_id: user_id,
        primary_color: legacy_data.primary_color,
        secondary_color: legacy_data.secondary_color,
        accent_color: legacy_data.accent_color
      }
      
      create_from_legacy(legacy_url, store_attrs)
    end
  end
end

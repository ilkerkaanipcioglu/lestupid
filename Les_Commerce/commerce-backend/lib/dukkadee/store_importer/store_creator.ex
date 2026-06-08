defmodule Dukkadee.StoreImporter.StoreCreator do
  @moduledoc """
  Module for creating stores from templates or legacy sites.
  This module provides functionality to create new stores based on
  existing templates or by importing legacy sites.
  """

  alias Dukkadee.Stores
  alias Dukkadee.StoreImporter.LegacyStoreImporter
  alias Dukkadee.StoreImporter.LegacyStoreTemplate
  alias Dukkadee.StoreImporter.Templates.InklessismoreTemplate

  @doc """
  Create a store from a template.
  """
  def create_store_from_template(template_id, store_attrs, user_id) do
    case template_id do
      "template_inklessismore" ->
        InklessismoreTemplate.apply_template(store_attrs, user_id)
      _ ->
        with {:ok, template} <- LegacyStoreTemplate.get_template(template_id),
             store_data <- apply_template_to_store_data(template, store_attrs),
             {:ok, store} <- Stores.create_store(Map.put(store_data, :user_id, user_id)) do
          {:ok, store}
        else
          {:error, reason} -> {:error, reason}
        end
    end
  end

  @doc """
  Create a store by importing a legacy site.
  """
  def create_store_from_legacy_site(url, user_id) do
    LegacyStoreImporter.import_store(url, user_id)
  end

  @doc """
  Create a store from a local legacy site directory.
  """
  def create_store_from_local_legacy_site(site_path, store_attrs, user_id) do
    # Extract store name from the site path
    store_name = extract_store_name_from_path(site_path)
    
    # Merge with provided store attributes
    store_attrs = Map.merge(%{name: store_name}, store_attrs)
    
    # If it's inklessismore, use the specific template
    if String.contains?(site_path, "inklessismore") do
      create_store_from_template("template_inklessismore", store_attrs, user_id)
    else
      # Otherwise, try to create a generic template from the site
      with {:ok, template} <- LegacyStoreTemplate.create_template_from_legacy_site(site_path, "#{store_name} Template"),
           {:ok, store} <- create_store_from_template(template.id, store_attrs, user_id) do
        {:ok, store}
      else
        {:error, reason} -> {:error, reason}
      end
    end
  end

  @doc """
  List all available templates.
  """
  def list_templates do
    LegacyStoreTemplate.list_templates()
  end

  # Private functions

  defp apply_template_to_store_data(template, store_attrs) do
    # Apply template settings to store attributes
    Map.merge(store_attrs, %{
      theme: template.theme,
      template_id: template.id
    })
  end

  defp extract_store_name_from_path(site_path) do
    # Extract the store name from the path
    # e.g., "d:/DEV/AFRICA_ECOMMERCE/legacy_sites/inklessismore-ke" -> "Inklessismore"
    site_path
    |> String.split("/")
    |> List.last()
    |> String.split("-")
    |> List.first()
    |> String.capitalize()
  end
end

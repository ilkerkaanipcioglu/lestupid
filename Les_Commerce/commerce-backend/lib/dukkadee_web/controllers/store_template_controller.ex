defmodule DukkadeeWeb.StoreTemplateController do
  use DukkadeeWeb, :controller

  alias Dukkadee.StoreImporter.LegacyStoreTemplate
  alias Dukkadee.StoreImporter.StoreCreator
  alias Dukkadee.Stores

  def index(conn, _params) do
    templates = LegacyStoreTemplate.list_templates()
    render(conn, :index, templates: templates)
  end

  def show(conn, %{"id" => template_id}) do
    case LegacyStoreTemplate.get_template(template_id) do
      {:ok, template} ->
        render(conn, :show, template: template)
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Template not found")
        |> redirect(to: ~p"/store_templates")
    end
  end

  def new(conn, %{"template_id" => template_id}) do
    case LegacyStoreTemplate.get_template(template_id) do
      {:ok, template} ->
        changeset = Stores.Store.changeset(%Stores.Store{}, %{})
        render(conn, :new, changeset: changeset, template: template)
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Template not found")
        |> redirect(to: ~p"/store_templates")
    end
  end

  def create(conn, %{"store" => store_params, "template_id" => template_id}) do
    current_user = conn.assigns.current_user
    store_params = Map.put(store_params, "user_id", current_user.id)

    case Stores.create_store(store_params) do
      {:ok, store} ->
        conn
        |> put_flash(:info, "Store created successfully from template.")
        |> redirect(to: ~p"/stores/#{store}")
      {:error, %Ecto.Changeset{} = changeset} ->
        {:ok, template} = LegacyStoreTemplate.get_template(template_id)
        render(conn, :new, changeset: changeset, template: template)
    end
  end

  def import_legacy(conn, _params) do
    render(conn, :import_legacy)
  end

  def create_from_legacy(conn, %{"legacy_site" => %{"path" => path, "store_name" => name}}) do
    current_user = conn.assigns.current_user
    store_attrs = %{name: name}

    case StoreCreator.create_store_from_local_legacy_site(path, store_attrs, current_user.id) do
      {:ok, store} ->
        conn
        |> put_flash(:info, "Store created successfully from legacy site.")
        |> redirect(to: ~p"/stores/#{store}")
      {:error, reason} ->
        conn
        |> put_flash(:error, "Failed to create store: #{reason}")
        |> render(:import_legacy)
    end
  end
end

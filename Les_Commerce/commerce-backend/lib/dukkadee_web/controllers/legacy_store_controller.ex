defmodule DukkadeeWeb.LegacyStoreController do
  use DukkadeeWeb, :controller
  
  alias Dukkadee.StoreImporter.LegacyStoreImporter
  
  @doc """
  Handle the legacy store import request.
  This endpoint receives the legacy store URL and initiates the import process.
  """
  def import(conn, %{"url" => url}) do
    # In a real implementation, this would be the authenticated user's ID
    user_id = "user_123"
    
    case LegacyStoreImporter.import_store(url, user_id) do
      {:ok, store} ->
        conn
        |> put_flash(:info, "Store imported successfully! Your new store is being set up with modern design.")
        |> json(%{
          success: true,
          store_id: store.id,
          store_name: store.name,
          products_count: 10,
          pages_count: 5,
          redirect_url: "/dashboard/stores/#{store.id}"
        })
        
      {:error, reason} ->
        conn
        |> put_flash(:error, "Failed to import store: #{reason}")
        |> json(%{
          success: false,
          error: reason
        })
    end
  end
  
  @doc """
  Show the import progress page.
  This page displays the progress of the import process.
  """
  def progress(conn, %{"id" => id}) do
    # In a real implementation, this would fetch the import job status
    # For now, we'll just render a progress page with mock data
    
    render(conn, "progress.html", %{
      job_id: id,
      store_name: "Imported Store",
      progress: 75,
      current_step: "Importing products",
      steps_completed: 3,
      total_steps: 5
    })
  end
end

defmodule Dukkadee.StoreImporter.ImportReport do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "import_reports" do
    field :products_count, :integer, default: 0
    field :pages_count, :integer, default: 0
    field :images_count, :integer, default: 0
    field :forms_count, :integer, default: 0
    field :redirects_count, :integer, default: 0
    field :warnings_count, :integer, default: 0
    field :errors_count, :integer, default: 0
    field :duration_seconds, :integer
    field :summary, :string
    field :details, :map

    belongs_to :import_job, Dukkadee.StoreImporter.ImportJob
    belongs_to :store, Dukkadee.Stores.Store

    timestamps()
  end

  @doc """
  Creates a changeset for a new import report.
  """
  def changeset(import_report, attrs) do
    import_report
    |> cast(attrs, [:products_count, :pages_count, :images_count, :forms_count, 
                   :redirects_count, :warnings_count, :errors_count, 
                   :duration_seconds, :summary, :details, :import_job_id, :store_id])
    |> validate_required([:import_job_id, :store_id])
  end

  @doc """
  Gets the import report for a specific job.
  """
  def for_job_query(job_id) do
    from r in __MODULE__,
      where: r.import_job_id == ^job_id
  end

  @doc """
  Gets the import report for a specific store.
  """
  def for_store_query(store_id) do
    from r in __MODULE__,
      where: r.store_id == ^store_id
  end

  @doc """
  Generates a human-readable summary of the import report.
  """
  def generate_summary(report) do
    """
    Import Summary:
    - #{report.products_count} products imported
    - #{report.pages_count} pages created
    - #{report.images_count} images processed
    - #{report.forms_count} forms set up
    - #{report.redirects_count} redirects created
    - #{report.warnings_count} warnings
    - #{report.errors_count} errors
    - Completed in #{format_duration(report.duration_seconds)}
    """
  end

  @doc """
  Formats duration in seconds to a human-readable string.
  """
  def format_duration(seconds) when is_integer(seconds) do
    minutes = div(seconds, 60)
    remaining_seconds = rem(seconds, 60)
    
    cond do
      minutes > 0 -> "#{minutes}m #{remaining_seconds}s"
      true -> "#{seconds}s"
    end
  end
  def format_duration(_), do: "unknown duration"
end

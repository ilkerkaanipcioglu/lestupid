defmodule Dukkadee.StoreImporter.ImportJob do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "import_jobs" do
    field :source_url, :string
    field :status, Ecto.Enum, values: [:pending, :in_progress, :completed, :failed]
    field :progress, :integer, default: 0
    field :current_step, :string
    field :steps_completed, :integer, default: 0
    field :total_steps, :integer, default: 5
    field :error_message, :string
    field :completed_at, :utc_datetime

    belongs_to :user, Dukkadee.Accounts.User
    belongs_to :store, Dukkadee.Stores.Store

    timestamps()
  end

  @doc """
  Creates a changeset for a new import job.
  """
  def changeset(import_job, attrs) do
    import_job
    |> cast(attrs, [:source_url, :status, :progress, :current_step, :steps_completed, :total_steps, :error_message, :completed_at, :user_id, :store_id])
    |> validate_required([:source_url, :status, :user_id])
    |> validate_url(:source_url)
  end

  @doc """
  Updates the progress of an import job.
  """
  def update_progress_changeset(import_job, attrs) do
    import_job
    |> cast(attrs, [:status, :progress, :current_step, :steps_completed, :error_message, :completed_at, :store_id])
    |> validate_required([:status, :progress])
    |> validate_inclusion(:progress, 0..100)
  end

  @doc """
  Validates that a URL is properly formatted.
  """
  def validate_url(changeset, field) do
    validate_change(changeset, field, fn _, url ->
      case URI.parse(url) do
        %URI{scheme: nil} ->
          [{field, "is missing a scheme (e.g. https://)"}]
        %URI{host: nil} ->
          [{field, "is missing a host"}]
        %URI{scheme: scheme} when scheme not in ["http", "https"] ->
          [{field, "scheme must be http or https"}]
        _ ->
          []
      end
    end)
  end

  @doc """
  Gets a list of recent import jobs for a user.
  """
  def recent_jobs_query(user_id, limit \\ 10) do
    from j in __MODULE__,
      where: j.user_id == ^user_id,
      order_by: [desc: j.inserted_at],
      limit: ^limit
  end

  @doc """
  Gets active import jobs for a user.
  """
  def active_jobs_query(user_id) do
    from j in __MODULE__,
      where: j.user_id == ^user_id and j.status in [:pending, :in_progress],
      order_by: [desc: j.inserted_at]
  end
end

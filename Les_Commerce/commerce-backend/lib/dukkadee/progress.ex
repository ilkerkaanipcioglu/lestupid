defmodule Dukkadee.Progress do
  @moduledoc """
  The Progress context handles treatment progress tracking for tattoo removal customers.
  """

  import Ecto.Query, warn: false
  alias Dukkadee.Repo
  alias Dukkadee.Progress.TreatmentProgress

  @doc """
  Returns the list of treatment_progress for a specific customer.

  ## Examples

      iex> list_customer_progress(customer_id)
      [%TreatmentProgress{}, ...]

  """
  def list_customer_progress(customer_id) do
    TreatmentProgress
    |> where([p], p.customer_id == ^customer_id)
    |> order_by([p], [desc: p.updated_at])
    |> Repo.all()
    |> Repo.preload(:product)
  end

  @doc """
  Gets a single treatment_progress.

  Raises `Ecto.NoResultsError` if the Treatment progress does not exist.

  ## Examples

      iex> get_treatment_progress!(123)
      %TreatmentProgress{}

      iex> get_treatment_progress!(456)
      ** (Ecto.NoResultsError)

  """
  def get_treatment_progress!(id), do: Repo.get!(TreatmentProgress, id) |> Repo.preload(:product)

  @doc """
  Creates a treatment_progress.

  ## Examples

      iex> create_treatment_progress(%{field: value})
      {:ok, %TreatmentProgress{}}

      iex> create_treatment_progress(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_treatment_progress(attrs \\ %{}) do
    %TreatmentProgress{}
    |> TreatmentProgress.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a treatment_progress.

  ## Examples

      iex> update_treatment_progress(treatment_progress, %{field: new_value})
      {:ok, %TreatmentProgress{}}

      iex> update_treatment_progress(treatment_progress, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_treatment_progress(%TreatmentProgress{} = treatment_progress, attrs) do
    treatment_progress
    |> TreatmentProgress.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Increment the current session count for a treatment progress record.
  This is typically done after each completed appointment.
  """
  def increment_session(%TreatmentProgress{} = treatment_progress) do
    current = treatment_progress.current_session
    update_treatment_progress(treatment_progress, %{current_session: current + 1})
  end

  @doc """
  Deletes a treatment_progress.

  ## Examples

      iex> delete_treatment_progress(treatment_progress)
      {:ok, %TreatmentProgress{}}

      iex> delete_treatment_progress(treatment_progress)
      {:error, %Ecto.Changeset{}}

  """
  def delete_treatment_progress(%TreatmentProgress{} = treatment_progress) do
    Repo.delete(treatment_progress)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking treatment_progress changes.

  ## Examples

      iex> change_treatment_progress(treatment_progress)
      %Ecto.Changeset{data: %TreatmentProgress{}}

  """
  def change_treatment_progress(%TreatmentProgress{} = treatment_progress, attrs \\ %{}) do
    TreatmentProgress.changeset(treatment_progress, attrs)
  end

  @doc """
  Mark a treatment progress as completed.
  """
  def complete_treatment(%TreatmentProgress{} = treatment_progress) do
    update_treatment_progress(treatment_progress, %{
      status: "completed",
      completion_percentage: 100
    })
  end

  @doc """
  Updates the current photo for a treatment progress.
  This is typically done during check-ins to track visual progress.
  """
  def update_progress_photo(%TreatmentProgress{} = treatment_progress, photo_path) do
    update_treatment_progress(treatment_progress, %{current_photo: photo_path})
  end

  @doc """
  Get all active treatment progress entries.
  """
  def list_active_treatments do
    TreatmentProgress
    |> where([p], p.status == "active")
    |> order_by([p], [desc: p.updated_at])
    |> Repo.all()
    |> Repo.preload([:product])
  end
end

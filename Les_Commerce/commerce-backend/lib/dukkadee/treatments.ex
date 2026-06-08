defmodule Dukkadee.Treatments do
  @moduledoc """
  The Treatments context.
  """

  import Ecto.Query, warn: false
  alias Dukkadee.Repo

  alias Dukkadee.Treatments.Treatment
  alias Dukkadee.Treatments.TreatmentSession

  @doc """
  Returns the list of treatments for a specific customer.

  ## Examples

      iex> list_customer_treatments(customer_id)
      [%Treatment{}, ...]

  """
  def list_customer_treatments(customer_id) when is_binary(customer_id) do
    list_customer_treatments(String.to_integer(customer_id))
  end
  
  def list_customer_treatments(customer_id) do
    Treatment
    |> where([t], t.customer_id == ^customer_id)
    |> order_by([t], desc: t.started_at)
    |> preload(:sessions)
    |> Repo.all()
  end

  @doc """
  Gets a single treatment.

  Raises `Ecto.NoResultsError` if the Treatment does not exist.

  ## Examples

      iex> get_treatment!(123)
      %Treatment{}

      iex> get_treatment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_treatment!(id) do
    Treatment
    |> Repo.get!(id)
    |> Repo.preload(:sessions)
  end
  
  @doc """
  Gets a single treatment with customer validation.
  
  Returns {:error, :not_found} if treatment doesn't exist or doesn't belong to customer.
  """
  def get_customer_treatment(id, customer_id) do
    treatment = 
      Treatment
      |> where([t], t.id == ^id and t.customer_id == ^customer_id)
      |> Repo.one()
      |> Repo.preload(:sessions)
      
    if treatment do
      {:ok, treatment}
    else
      {:error, :not_found}
    end
  end

  @doc """
  Creates a treatment.

  ## Examples

      iex> create_treatment(%{field: value})
      {:ok, %Treatment{}}

      iex> create_treatment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_treatment(attrs \\ %{}) do
    %Treatment{}
    |> Treatment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a treatment.

  ## Examples

      iex> update_treatment(treatment, %{field: new_value})
      {:ok, %Treatment{}}

      iex> update_treatment(treatment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_treatment(%Treatment{} = treatment, attrs) do
    treatment
    |> Treatment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a treatment.

  ## Examples

      iex> delete_treatment(treatment)
      {:ok, %Treatment{}}

      iex> delete_treatment(treatment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_treatment(%Treatment{} = treatment) do
    Repo.delete(treatment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking treatment changes.

  ## Examples

      iex> change_treatment(treatment)
      %Ecto.Changeset{data: %Treatment{}}

  """
  def change_treatment(%Treatment{} = treatment, attrs \\ %{}) do
    Treatment.changeset(treatment, attrs)
  end
  
  # Treatment Sessions
  
  @doc """
  Gets a single treatment session.
  """
  def get_session!(id), do: Repo.get!(TreatmentSession, id)
  
  @doc """
  Creates a treatment session.
  """
  def create_session(attrs \\ %{}) do
    %TreatmentSession{}
    |> TreatmentSession.changeset(attrs)
    |> Repo.insert()
  end
  
  @doc """
  Updates a treatment session.
  """
  def update_session(%TreatmentSession{} = session, attrs) do
    # If we're marking a session as completed, we need to update the parent treatment
    updated_session =
      session
      |> TreatmentSession.changeset(attrs)
      |> Repo.update()
      
    case updated_session do
      {:ok, session} ->
        if Map.get(attrs, "completed_at") && !session.treatment.completed_at do
          treatment = get_treatment!(session.treatment_id)
          completed_count = Enum.count(treatment.sessions, & &1.completed_at)
          
          treatment_updates = %{
            "completed_sessions" => completed_count,
            "current_photo" => Map.get(attrs, "after_photo") || treatment.current_photo
          }
          
          # If all sessions are complete, mark the treatment as complete
          treatment_updates = if completed_count >= treatment.total_sessions do
            Map.put(treatment_updates, "completed_at", NaiveDateTime.utc_now())
          else
            treatment_updates
          end
          
          update_treatment(treatment, treatment_updates)
        end
        
        updated_session
        
      error -> error
    end
  end
  
  @doc """
  Deletes a treatment session.
  """
  def delete_session(%TreatmentSession{} = session) do
    Repo.delete(session)
  end
  
  @doc """
  Returns an `%Ecto.Changeset{}` for tracking session changes.
  """
  def change_session(%TreatmentSession{} = session, attrs \\ %{}) do
    TreatmentSession.changeset(session, attrs)
  end
end

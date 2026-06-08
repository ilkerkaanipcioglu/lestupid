defmodule Dukkadee.Progress.TreatmentProgress do
  use Ecto.Schema
  import Ecto.Changeset

  schema "treatment_progress" do
    field :customer_id, :id
    field :treatment_area, :string
    field :start_date, :date
    field :current_session, :integer, default: 1
    field :total_sessions, :integer
    field :completion_percentage, :integer
    field :initial_photo, :string
    field :current_photo, :string
    field :next_appointment_date, :utc_datetime
    field :notes, :string
    field :status, :string, default: "active" # active, completed, discontinued
    
    belongs_to :product, Dukkadee.Products.Product
    
    timestamps()
  end

  def changeset(treatment_progress, attrs) do
    treatment_progress
    |> cast(attrs, [:customer_id, :treatment_area, :start_date, :current_session, :total_sessions, 
                  :completion_percentage, :initial_photo, :current_photo, :next_appointment_date, 
                  :notes, :status, :product_id])
    |> validate_required([:customer_id, :treatment_area, :start_date, :product_id])
    |> validate_inclusion(:status, ["active", "completed", "discontinued"])
    |> calculate_completion_percentage()
  end
  
  # Calculate the percentage complete based on current session vs total sessions
  defp calculate_completion_percentage(changeset) do
    current = get_field(changeset, :current_session)
    total = get_field(changeset, :total_sessions)
    
    if current && total && total > 0 do
      percentage = min(round(current / total * 100), 100)
      put_change(changeset, :completion_percentage, percentage)
    else
      changeset
    end
  end
end

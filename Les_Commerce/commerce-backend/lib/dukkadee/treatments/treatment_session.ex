defmodule Dukkadee.Treatments.TreatmentSession do
  use Ecto.Schema
  import Ecto.Changeset

  schema "treatment_sessions" do
    field :session_number, :integer
    field :scheduled_at, :utc_datetime
    field :completed_at, :utc_datetime
    field :before_photo, :string
    field :after_photo, :string
    field :notes, :string
    field :next_appointment, :utc_datetime
    field :next_appointment_id, :integer
    field :technician_name, :string
    field :session_duration_minutes, :integer
    
    belongs_to :treatment, Dukkadee.Treatments.Treatment
    
    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:session_number, :scheduled_at, :completed_at, :before_photo, 
                   :after_photo, :notes, :next_appointment, :next_appointment_id, 
                   :technician_name, :session_duration_minutes, :treatment_id])
    |> validate_required([:session_number, :treatment_id])
  end
end

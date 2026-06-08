defmodule Dukkadee.Treatments.Treatment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "treatments" do
    field :tattoo_name, :string
    field :package_name, :string
    field :started_at, :utc_datetime
    field :completed_at, :utc_datetime
    field :total_sessions, :integer
    field :completed_sessions, :integer
    field :before_photo, :string
    field :current_photo, :string
    field :notes, :string
    field :next_appointment, :utc_datetime
    field :next_appointment_id, :integer
    
    belongs_to :customer, Dukkadee.Customers.Customer
    has_many :sessions, Dukkadee.Treatments.TreatmentSession
    
    timestamps()
  end

  @doc false
  def changeset(treatment, attrs) do
    treatment
    |> cast(attrs, [:tattoo_name, :package_name, :started_at, :completed_at, 
                   :total_sessions, :completed_sessions, :before_photo, 
                   :current_photo, :notes, :next_appointment, :next_appointment_id, 
                   :customer_id])
    |> validate_required([:tattoo_name, :package_name, :started_at, 
                         :total_sessions, :completed_sessions, :customer_id])
  end
end

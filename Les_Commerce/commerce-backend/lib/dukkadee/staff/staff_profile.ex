defmodule Dukkadee.Staff.StaffProfile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "staff_profiles" do
    field :name, :string
    field :position, :string
    field :bio, :string
    field :photo, :string
    field :certifications, {:array, :string}
    field :specialties, {:array, :string}
    field :featured, :boolean, default: false
    field :email, :string
    field :display_order, :integer, default: 999
    
    belongs_to :store, Dukkadee.Stores.Store
    
    timestamps()
  end

  def changeset(staff_profile, attrs) do
    staff_profile
    |> cast(attrs, [:name, :position, :bio, :photo, :certifications, :specialties, :featured, :email, :display_order, :store_id])
    |> validate_required([:name, :position, :bio, :store_id])
    |> unique_constraint([:name, :store_id])
  end
end

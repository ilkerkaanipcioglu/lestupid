defmodule Dukkadee.Testimonials.Testimonial do
  use Ecto.Schema
  import Ecto.Changeset

  schema "testimonials" do
    field :name, :string
    field :customer_image, :string
    field :content, :string
    field :rating, :integer
    field :service_type, :string
    field :is_approved, :boolean, default: false
    field :featured, :boolean, default: false
    field :date, :date
    
    belongs_to :store, Dukkadee.Stores.Store
    belongs_to :customer, Dukkadee.Customers.Customer, foreign_key: :customer_id
    
    timestamps()
  end

  def changeset(testimonial, attrs) do
    testimonial
    |> cast(attrs, [:name, :customer_image, :content, :rating, :service_type, :is_approved, :featured, :store_id, :customer_id, :date])
    |> validate_required([:name, :content, :rating, :store_id])
    |> validate_inclusion(:rating, 1..5)
    |> validate_length(:content, min: 10, max: 1000)
    |> set_date_if_not_provided()
  end
  
  defp set_date_if_not_provided(changeset) do
    case get_field(changeset, :date) do
      nil -> put_change(changeset, :date, Date.utc_today())
      _ -> changeset
    end
  end
end

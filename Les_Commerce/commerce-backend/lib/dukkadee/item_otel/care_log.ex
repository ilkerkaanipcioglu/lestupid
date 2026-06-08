defmodule Dukkadee.ItemOtel.CareLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "item_care_logs" do
    field :care_type, :string
    field :notes, :string
    field :performed_at, :naive_datetime
    field :provider_id, :string
    field :certificate_id, :string

    belongs_to :item, Dukkadee.ItemOtel.Item

    timestamps()
  end

  def changeset(care_log, attrs) do
    care_log
    |> cast(attrs, [:care_type, :notes, :performed_at, :provider_id, :certificate_id, :item_id])
    |> validate_required([:care_type, :performed_at, :item_id])
    |> validate_inclusion(:care_type, ["cleaning", "repair", "tire_rotation", "waxing", "general_maintenance"])
  end
end

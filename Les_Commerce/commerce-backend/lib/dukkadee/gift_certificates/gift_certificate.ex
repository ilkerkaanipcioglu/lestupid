defmodule Dukkadee.GiftCertificates.GiftCertificate do
  use Ecto.Schema
  import Ecto.Changeset
  
  schema "gift_certificates" do
    field :code, :string
    field :amount, :decimal
    field :currency, :string
    field :recipient_name, :string
    field :recipient_email, :string
    field :sender_name, :string
    field :sender_email, :string
    field :message, :string
    field :status, :string, default: "active" # active, redeemed, expired
    field :issued_at, :utc_datetime
    field :expires_at, :utc_datetime
    field :redeemed_at, :utc_datetime
    
    belongs_to :store, Dukkadee.Stores.Store
    
    timestamps()
  end
  
  def changeset(gift_certificate, attrs) do
    gift_certificate
    |> cast(attrs, [:amount, :currency, :recipient_name, :recipient_email, :sender_name, :sender_email, :message, :status, :store_id, :issued_at, :expires_at, :redeemed_at])
    |> validate_required([:amount, :currency, :recipient_name, :recipient_email, :sender_name, :store_id])
    |> validate_number(:amount, greater_than: 0)
    |> validate_format(:recipient_email, ~r/@/)
    |> validate_format(:sender_email, ~r/@/)
    |> validate_inclusion(:status, ["active", "redeemed", "expired"])
    |> maybe_generate_code()
    |> maybe_set_expiration()
  end
  
  defp maybe_generate_code(changeset) do
    case get_field(changeset, :code) do
      nil ->
        # Generate a 10-character unique code
        code = :crypto.strong_rand_bytes(5)
               |> Base.encode32()
               |> String.slice(0, 10)
               |> String.upcase()
        
        put_change(changeset, :code, code)
        
      _ ->
        changeset
    end
  end
  
  defp maybe_set_expiration(changeset) do
    case get_field(changeset, :expires_at) do
      nil ->
        # Set expiration to 1 year from now
        expires_at = DateTime.utc_now() |> DateTime.add(365, :day)
        put_change(changeset, :expires_at, expires_at)
        
      _ ->
        changeset
    end
  end
end

defmodule Dukkadee.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :password_confirmation, :string, virtual: true
    field :confirmed_at, :naive_datetime
    field :is_admin, :boolean, default: false
    
    has_many :stores, Dukkadee.Stores.Store, foreign_key: :owner_id
    
    timestamps()
  end

  @doc """
  A user changeset for registration.
  """
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_email()
    |> validate_password()
    |> validate_confirmation(:password, message: "does not match password")
    |> hash_password()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Dukkadee.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 80)
  end

  defp hash_password(changeset) do
    password = get_change(changeset, :password)

    if password && changeset.valid? do
      # For development without bcrypt, we're using a simple approach:
      password_hash = Base.encode64(:crypto.hash(:sha256, password))
      
      put_change(changeset, :password_hash, password_hash)
    else
      changeset
    end
  end
end

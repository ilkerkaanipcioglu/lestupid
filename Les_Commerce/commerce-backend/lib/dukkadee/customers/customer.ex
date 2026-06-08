defmodule Dukkadee.Customers.Customer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dukkadee.Customers.Customer

  schema "customers" do
    field :email, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :naive_datetime
    
    field :first_name, :string
    field :last_name, :string
    field :phone, :string
    field :profile_photo, :string
    field :date_of_birth, :date
    field :address, :string
    field :city, :string
    field :country, :string
    field :postal_code, :string
    field :preferences, :map
    
    has_many :appointments, Dukkadee.Appointments.Appointment
    has_many :treatment_progress, Dukkadee.Progress.TreatmentProgress
    
    timestamps()
  end

  @doc """
  A customer changeset for registration.
  """
  def registration_changeset(customer, attrs, opts \\ []) do
    customer
    |> cast(attrs, [:email, :password, :first_name, :last_name, :phone])
    |> validate_email()
    |> validate_password(opts)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Dukkadee.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 72)
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If you are using Bcrypt or Pbkdf2, use Argon2 instead
      |> put_change(:hashed_password, Argon2.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  A customer changeset for updating the profile.
  """
  def profile_changeset(%Customer{} = customer, attrs) do
    customer
    |> cast(attrs, [:first_name, :last_name, :phone, :profile_photo, :date_of_birth, 
                  :address, :city, :country, :postal_code, :preferences])
    |> validate_required([:first_name, :last_name])
  end

  @doc """
  A customer changeset for changing the password.
  """
  def password_changeset(customer, attrs, opts \\ []) do
    customer
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(customer) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(customer, confirmed_at: now)
  end

  @doc """
  Verifies the password.
  """
  def valid_password?(%Customer{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Argon2.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Argon2.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end
end

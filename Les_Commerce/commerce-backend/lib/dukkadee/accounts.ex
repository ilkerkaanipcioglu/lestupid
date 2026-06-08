defmodule Dukkadee.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Dukkadee.Repo
  alias Dukkadee.Accounts.User

  @doc """
  Returns the list of users.
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.
  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Gets a single user by email.
  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Registers a user.
  """
  def register_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  def change_user_registration(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Gets a user by email and password.
  """
  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = get_user_by_email(email)
    if user && valid_password?(user, password), do: user
  end

  @doc """
  Validates a user's password.
  """
  def valid_password?(%User{password_hash: password_hash} = _user, password)
      when is_binary(password_hash) and is_binary(password) do
    # For development without bcrypt:
    password_hash == Base.encode64(:crypto.hash(:sha256, password))
  end

  def valid_password?(_, _) do
    false
  end

  @doc """
  Delivers confirmation instructions to the user.
  """
  def deliver_user_confirmation_instructions(user, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    # For development, we'll just return ok without sending emails
    {:ok, %{to: user.email, url: confirmation_url_fun.("fake-token")}}
  end

  @doc """
  Confirms a user.
  """
  def confirm_user(token) do
    # For development, we'll just confirm any token
    case get_user_by_session_token(token) do
      nil ->
        :error
      user ->
        update_user(user, %{confirmed_at: NaiveDateTime.utc_now()})
    end
  end

  @doc """
  Generates a session token for a user.
  """
  def generate_user_session_token(user) do
    token = Base.encode64("#{user.id}:#{:rand.uniform(1_000_000)}")
    
    # In development, we'll just return the token without storing it
    token
  end

  @doc """
  Gets a user by session token.
  """
  def get_user_by_session_token(token) when is_binary(token) do
    case Base.decode64(token) do
      {:ok, decoded} ->
        [user_id, _] = String.split(decoded, ":", parts: 2)
        get_user(String.to_integer(user_id))
      _ ->
        nil
    end
  end

  @doc """
  Deletes the session token.
  """
  def delete_user_session_token(token) when is_binary(token) do
    # In development, we'll just return :ok
    :ok
  end

  @doc """
  Authenticates a user.
  """
  def authenticate_user(email, password) do
    user = get_user_by_email(email)
    
    if user && valid_password?(user, password) do
      {:ok, user}
    else
      {:error, :invalid_credentials}
    end
  end
end

# lib/dukkadee/accounts/user.ex
defmodule Dukkadee.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :is_admin, :boolean, default: false
    
    has_many :stores, Dukkadee.Stores.Store
    
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    # In a real app, use a proper password hashing library like Bcrypt
    hash = :crypto.hash(:sha256, password) |> Base.encode16()
    put_change(changeset, :password_hash, hash)
  end
  
  defp hash_password(changeset), do: changeset
end

# lib/dukkadee/stores/store.ex
defmodule Dukkadee.Stores.Store do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stores" do
    field :name, :string
    field :slug, :string
    field :domain, :string
    field :description, :string
    field :logo_url, :string
    field :theme, :string, default: "default"
    
    belongs_to :user, Dukkadee.Accounts.User
    has_many :products, Dukkadee.Products.Product
    has_many :pages, Dukkadee.Pages.Page
    
    timestamps()
  end

  def changeset(store, attrs) do
    store
    |> cast(attrs, [:name, :slug, :domain, :description, :logo_url, :theme, :user_id])
    |> validate_required([:name, :slug, :user_id])
    |> unique_constraint(:slug)
    |> unique_constraint(:domain)
    |> generate_slug()
  end
  
  defp generate_slug(%Ecto.Changeset{valid?: true, changes: %{name: name}} = changeset) do
    slug = name 
      |> String.downcase() 
      |> String.replace(~r/[^a-z0-9\s]/, "") 
      |> String.replace(~r/\s+/, "-")
    
    if get_field(changeset, :slug) do
      changeset
    else
      put_change(changeset, :slug, slug)
    end
  end
  
  defp generate_slug(changeset), do: changeset
end

# lib/dukkadee/products/product.ex
defmodule Dukkadee.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :description, :string
    field :price, :decimal
    field :currency, :string, default: "USD"
    field :images, {:array, :string}, default: []
    field :requires_appointment, :boolean, default: false
    field :is_published, :boolean, default: true
    field :category, :string
    field :tags, {:array, :string}, default: []
    
    belongs_to :store, Dukkadee.Stores.Store
    has_many :variants, Dukkadee.Products.Variant
    has_many :appointments, Dukkadee.Appointments.Appointment
    
    timestamps()
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :price, :currency, :images, :requires_appointment, :is_published, :category, :tags, :store_id])
    |> validate_required([:name, :price, :store_id])
  end
end

# lib/dukkadee/products/variant.ex
defmodule Dukkadee.Products.Variant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "product_variants" do
    field :name, :string
    field :sku, :string
    field :price, :decimal
    field :options, :map, default: %{}
    field :stock, :integer, default: 0
    
    belongs_to :product, Dukkadee.Products.Product
    
    timestamps()
  end

  def changeset(variant, attrs) do
    variant
    |> cast(attrs, [:name, :sku, :price, :options, :stock, :product_id])
    |> validate_required([:name, :product_id])
  end
end

# lib/dukkadee/appointments/appointment.ex
defmodule Dukkadee.Appointments.Appointment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "appointments" do
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :customer_name, :string
    field :customer_email, :string
    field :customer_phone, :string
    field :status, :string, default: "scheduled" # scheduled, confirmed, cancelled, completed
    field :notes, :string
    
    belongs_to :product, Dukkadee.Products.Product
    
    timestamps()
  end

  def changeset(appointment, attrs) do
    appointment
    |> cast(attrs, [:start_time, :end_time, :customer_name, :customer_email, :customer_phone, :status, :notes, :product_id])
    |> validate_required([:start_time, :end_time, :customer_name, :customer_email, :product_id])
  end
end

# lib/dukkadee/pages/page.ex
defmodule Dukkadee.Pages.Page do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pages" do
    field :title, :string
    field :slug, :string
    field :content, :string
    field :is_published, :boolean, default: true
    
    belongs_to :store, Dukkadee.Stores.Store
    
    timestamps()
  end

  def changeset(page, attrs) do
    page
    |> cast(attrs, [:title, :slug, :content, :is_published, :store_id])
    |> validate_required([:title, :content, :store_id])
    |> generate_slug()
  end
  
  defp generate_slug(%Ecto.Changeset{valid?: true, changes: %{title: title}} = changeset) do
    slug = title 
      |> String.downcase() 
      |> String.replace(~r/[^a-z0-9\s]/, "") 
      |> String.replace(~r/\s+/, "-")
    
    if get_field(changeset, :slug) do
      changeset
    else
      put_change(changeset, :slug, slug)
    end
  end
  
  defp generate_slug(changeset), do: changeset
end

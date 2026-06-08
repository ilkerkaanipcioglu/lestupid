# lib/dukkadee/accounts.ex
defmodule Dukkadee.Accounts do
  import Ecto.Query, warn: false
  alias Dukkadee.Repo
  alias Dukkadee.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)
  
  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
  
  # Simple authentication function (in production use a proper auth library)
  def authenticate_user(email, password) do
    user = get_user_by_email(email)
    
    if user && verify_password(user, password) do
      {:ok, user}
    else
      {:error, :invalid_credentials}
    end
  end
  
  defp verify_password(%User{password_hash: password_hash}, password) do
    hash = :crypto.hash(:sha256, password) |> Base.encode16()
    password_hash == hash
  end
end

# lib/dukkadee/stores.ex
defmodule Dukkadee.Stores do
  import Ecto.Query, warn: false
  alias Dukkadee.Repo
  alias Dukkadee.Stores.Store

  def list_stores do
    Repo.all(Store)
  end

  def list_user_stores(user_id) do
    Store
    |> where([s], s.user_id == ^user_id)
    |> Repo.all()
  end

  def get_store!(id), do: Repo.get!(Store, id)
  
  def get_store_by_slug(slug) do
    Repo.get_by(Store, slug: slug)
  end
  
  def get_store_by_domain(domain) do
    Repo.get_by(Store, domain: domain)
  end

  def create_store(attrs \\ %{}) do
    %Store{}
    |> Store.changeset(attrs)
    |> Repo.insert()
  end

  def update_store(%Store{} = store, attrs) do
    store
    |> Store.changeset(attrs)
    |> Repo.update()
  end

  def delete_store(%Store{} = store) do
    Repo.delete(store)
  end

  def change_store(%Store{} = store, attrs \\ %{}) do
    Store.changeset(store, attrs)
  end
end

# lib/dukkadee/products.ex
defmodule Dukkadee.Products do
  import Ecto.Query, warn: false
  alias Dukkadee.Repo
  alias Dukkadee.Products.{Product, Variant}

  # Product functions
  def list_products do
    Repo.all(Product)
  end
  
  def list_store_products(store_id) do
    Product
    |> where([p], p.store_id == ^store_id)
    |> where([p], p.is_published == true)
    |> Repo.all()
  end
  
  def list_marketplace_products do
    Product
    |> where([p], p.is_published == true)
    |> preload(:store)
    |> Repo.all()
  end
  
  def search_products(query) do
    term = "%#{query}%"
    
    Product
    |> where([p], p.is_published == true)
    |> where([p], ilike(p.name, ^term) or ilike(p.description, ^term))
    |> or_where([p], ^query in p.tags)
    |> preload(:store)
    |> Repo.all()
  end

  def get_product!(id), do: Repo.get!(Product, id) |> Repo.preload([:variants, :store])

  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end
  
  # Variant functions
  def list_product_variants(product_id) do
    Variant
    |> where([v], v.product_id == ^product_id)
    |> Repo.all()
  end

  def get_variant!(id), do: Repo.get!(Variant, id)

  def create_variant(attrs \\ %{}) do
    %Variant{}
    |> Variant.changeset(attrs)
    |> Repo.insert()
  end

  def update_variant(%Variant{} = variant, attrs) do
    variant
    |> Variant.changeset(attrs)
    |> Repo.update()
  end

  def delete_variant(%Variant{} = variant) do
    Repo.delete(variant)
  end
end

# lib/dukkadee/appointments.ex
defmodule Dukkadee.Appointments do
  import Ecto.Query, warn: false
  alias Dukkadee.Repo
  alias Dukkadee.Appointments.Appointment

  def list_appointments do
    Repo.all(Appointment)
  end
  
  def list_product_appointments(product_id) do
    Appointment
    |> where([a], a.product_id == ^product_id)
    |> Repo.all()
  end
  
  def get_appointment!(id), do: Repo.get!(Appointment, id)

  def create_appointment(attrs \\ %{}) do
    %Appointment{}
    |> Appointment.changeset(attrs)
    |> Repo.insert()
  end

  def update_appointment(%Appointment{} = appointment, attrs) do
    appointment
    |> Appointment.changeset(attrs)
    |> Repo.update()
  end

  def delete_appointment(%Appointment{} = appointment) do
    Repo.delete(appointment)
  end
  
  def change_appointment(%Appointment{} = appointment, attrs \\ %{}) do
    Appointment.changeset(appointment, attrs)
  end
  
  def get_available_slots(product_id, date) do
    # This is a simplified version - in a real app, you'd need more sophisticated logic
    start_of_day = Date.to_beginning_of_day(date)
    end_of_day = Date.to_end_of_day(date)
    
    # Get booked slots
    booked_slots = 
      Appointment
      |> where([a], a.product_id == ^product_id)
      |> where([a], a.start_time >= ^start_of_day and a.start_time < ^end_of_day)
      |> where([a], a.status != "cancelled")
      |> select([a], {a.start_time, a.end_time})
      |> Repo.all()
      |> MapSet.new()
    
    # Generate all possible slots (hourly in this example)
    all_slots = 
      Enum.map(9..17, fn hour -> 
        start_time = DateTime.new!(date, Time.new!(hour, 0, 0), "Etc/UTC") 
        end_time = DateTime.new!(date, Time.new!(hour + 1, 0, 0), "Etc/UTC")
        {start_time, end_time}
      end)
      |> MapSet.new()
    
    # Return available slots
    all_slots
    |> MapSet.difference(booked_slots)
    |> MapSet.to_list()
  end
end

# lib/dukkadee/pages.ex
defmodule Dukkadee.Pages do
  import Ecto.Query, warn: false
  alias Dukkadee.Repo
  alias Dukkadee.Pages.Page

  def list_pages do
    Repo.all(Page)
  end
  
  def list_store_pages(store_id) do
    Page
    |> where([p], p.store_id == ^store_id)
    |> where([p], p.is_published == true)
    |> Repo.all()
  end

  def get_page!(id), do: Repo.get!(Page, id)
  
  def get_store_page(store_id, slug) do
    Repo.get_by(Page, store_id: store_id, slug: slug, is_published: true)
  end

  def create_page(attrs \\ %{}) do
    %Page{}
    |> Page.changeset(attrs)
    |> Repo.insert()
  end

  def update_page(%Page{} = page, attrs) do
    page
    |> Page.changeset(attrs)
    |> Repo.update()
  end

  def delete_page(%Page{} = page) do
    Repo.delete(page)
  end
  
  def change_page(%Page{} = page, attrs \\ %{}) do
    Page.changeset(page, attrs)
  end
end

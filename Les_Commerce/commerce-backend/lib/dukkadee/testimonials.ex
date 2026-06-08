defmodule Dukkadee.Testimonials do
  @moduledoc """
  The Testimonials context.
  """

  import Ecto.Query, warn: false
  alias Dukkadee.Repo

  alias Dukkadee.Testimonials.Testimonial

  @doc """
  Returns the list of testimonials.
  """
  def list_testimonials do
    Repo.all(Testimonial)
  end

  @doc """
  Returns the list of testimonials for a specific store.
  """
  def list_testimonials_by_store(store_id) do
    Testimonial
    |> where([t], t.store_id == ^store_id)
    |> where([t], t.is_approved == true)
    |> order_by([t], desc: t.inserted_at)
    |> Repo.all()
  end

  @doc """
  Returns the most recent testimonials for a specific store.
  """
  def list_recent_testimonials_by_store(store_id, limit \\ 3) do
    Testimonial
    |> where([t], t.store_id == ^store_id)
    |> where([t], t.is_approved == true)
    |> order_by([t], desc: t.inserted_at)
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Returns a paginated list of testimonials for a specific store.
  """
  def list_testimonials_by_store_paginated(store_id, params \\ %{}) do
    page = Map.get(params, "page", "1") |> String.to_integer()
    per_page = Map.get(params, "per_page", "10") |> String.to_integer()
    
    Testimonial
    |> where([t], t.store_id == ^store_id)
    |> where([t], t.is_approved == true)
    |> order_by([t], desc: t.inserted_at)
    |> Repo.paginate(page: page, page_size: per_page)
  end

  @doc """
  Gets a single testimonial.
  """
  def get_testimonial(id), do: Repo.get(Testimonial, id)

  @doc """
  Gets a single testimonial or raises an error if not found.
  """
  def get_testimonial!(id), do: Repo.get!(Testimonial, id)

  @doc """
  Creates a testimonial.
  """
  def create_testimonial(attrs \\ %{}) do
    %Testimonial{}
    |> Testimonial.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a testimonial.
  """
  def update_testimonial(%Testimonial{} = testimonial, attrs) do
    testimonial
    |> Testimonial.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a testimonial.
  """
  def delete_testimonial(%Testimonial{} = testimonial) do
    Repo.delete(testimonial)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking testimonial changes.
  """
  def change_testimonial(%Testimonial{} = testimonial, attrs \\ %{}) do
    Testimonial.changeset(testimonial, attrs)
  end

  @doc """
  Approve a testimonial.
  """
  def approve_testimonial(%Testimonial{} = testimonial) do
    update_testimonial(testimonial, %{is_approved: true})
  end

  @doc """
  Reject a testimonial.
  """
  def reject_testimonial(%Testimonial{} = testimonial) do
    update_testimonial(testimonial, %{is_approved: false})
  end

  @doc """
  Get average rating for a store.
  """
  def get_store_average_rating(store_id) do
    Testimonial
    |> where([t], t.store_id == ^store_id)
    |> where([t], t.is_approved == true)
    |> select([t], avg(t.rating))
    |> Repo.one()
    |> case do
      nil -> 0.0
      avg -> Decimal.to_float(avg)
    end
  end
end

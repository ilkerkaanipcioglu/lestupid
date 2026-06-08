defmodule DukkadeeWeb.StoreController do
  use DukkadeeWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def products(conn, _params) do
    render(conn, :products)
  end

  def product_details(conn, %{"id" => id}) do
    # In a real implementation, we would fetch the product from the database
    render(conn, :product_details, id: id)
  end

  def category_products(conn, %{"category" => category}) do
    # In a real implementation, we would fetch products by category
    render(conn, :category_products, category: category)
  end

  def search(conn, %{"q" => query}) do
    # In a real implementation, we would search for products
    render(conn, :search, query: query)
  end

  def page(conn, %{"slug" => slug}) do
    # In a real implementation, we would fetch the page by slug
    render(conn, :page, slug: slug)
  end

  def book_appointment(conn, %{"product_id" => product_id}) do
    # In a real implementation, we would handle appointment booking
    render(conn, :book_appointment, product_id: product_id)
  end
end

defmodule DukkadeeWeb.Api.ProductController do
  use DukkadeeWeb, :controller

  alias Dukkadee.Products

  action_fallback DukkadeeWeb.Api.FallbackController

  def index(conn, params) do
    products =
      cond do
        store_id = params["store_id"] ->
          if type = params["type"] do
            Products.list_store_products_by_type(store_id, type)
          else
            Products.list_store_products(store_id)
          end

        type = params["type"] ->
          Products.list_marketplace_products_by_type(type)

        true ->
          Products.list_products()
      end

    render(conn, :index, products: products)
  end

  def show(conn, %{"id" => id}) do
    product = Products.get_product_with_variants(id)

    if product do
      render(conn, :show, product: product)
    else
      conn
      |> put_status(:not_found)
      |> put_view(DukkadeeWeb.ErrorJSON)
      |> render(:"404")
    end
  end
end

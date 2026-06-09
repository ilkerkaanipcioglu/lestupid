defmodule DukkadeeWeb.Api.EcosystemController do
  use DukkadeeWeb, :controller

  def health(conn, _params) do
    json(conn, %{
      data: %{
        product_id: "lescommerce-core",
        service: "dukkadee",
        status: "ok",
        ecosystem: "LesTupid",
        discovery: [
          "/api/health",
          "/api/ecosystem/endpoints",
          "/api/products",
          "/api/videos",
          "/api/appointments",
          "/api/itemotel/items",
          "/.well-known/lestupid-app.json"
        ]
      }
    })
  end

  def endpoints(conn, _params) do
    base_url = base_url(conn)

    json(conn, %{
      data: %{
        product_id: "lescommerce-core",
        endpoint_groups: %{
          catalog: [
            endpoint("products_index", "GET", "#{base_url}/api/products",
              roles: ["marketplace", "quick_commerce", "catalog"],
              query: %{
                "store_id" => "Filter by merchant store ID",
                "type" => "Filter by type (finished_good | material | service)"
              }
            ),
            endpoint("product_show", "GET", "#{base_url}/api/products/:id",
              roles: ["marketplace", "catalog"],
              response: "Product with variants and schema_metadata"
            )
          ],
          diy: [
            endpoint("videos_index", "GET", "#{base_url}/api/videos",
              roles: ["diy_marketplace", "creator_craft_drop"],
              query: %{"store_id" => "Filter by creator store ID"}
            ),
            endpoint("video_show", "GET", "#{base_url}/api/videos/:id",
              roles: ["diy_marketplace", "creator_craft_drop"],
              response: "VideoObject-style tutorial with related products"
            )
          ],
          booking: [
            endpoint("appointments_create", "POST", "#{base_url}/api/appointments",
              roles: ["service_booking", "merchant_storefront"],
              request: %{
                "appointment" => %{
                  "product_id" => "Service or usta product ID",
                  "customer_name" => "Customer full name",
                  "customer_email" => "Customer email",
                  "customer_phone" => "Customer phone",
                  "start_time" => "ISO 8601 UTC start",
                  "end_time" => "ISO 8601 UTC end",
                  "notes" => "Project or booking notes"
                }
              }
            )
          ],
          itemotel: [
            endpoint("itemotel_items_index", "GET", "#{base_url}/api/itemotel/items",
              roles: ["item_custody", "circular_commerce"],
              query: %{"owner_identity_id" => "Scoped owner identity"}
            ),
            endpoint("itemotel_items_create", "POST", "#{base_url}/api/itemotel/items", roles: [
              "item_custody",
              "seasonal_storage"
            ]),
            endpoint("itemotel_item_show", "GET", "#{base_url}/api/itemotel/items/:id",
              roles: ["item_custody", "circular_commerce"]
            ),
            endpoint("itemotel_request_care", "POST", "#{base_url}/api/itemotel/items/:id/care",
              roles: ["item_care"]
            ),
            endpoint("itemotel_list", "POST", "#{base_url}/api/itemotel/items/:id/list",
              roles: ["circular_commerce", "marketplace_listing"]
            ),
            endpoint("itemotel_unlist", "POST", "#{base_url}/api/itemotel/items/:id/unlist",
              roles: ["circular_commerce", "marketplace_listing"]
            ),
            endpoint("itemotel_recall", "POST", "#{base_url}/api/itemotel/items/:id/recall",
              roles: ["item_custody", "return_logistics"]
            )
          ]
        }
      }
    })
  end

  defp endpoint(id, method, url, options) do
    %{
      id: id,
      method: method,
      url: url,
      roles: Keyword.get(options, :roles, []),
      query: Keyword.get(options, :query, %{}),
      request: Keyword.get(options, :request, %{}),
      response: Keyword.get(options, :response, "JSON")
    }
  end

  defp base_url(conn) do
    "#{Atom.to_string(conn.scheme)}://#{conn.host}:#{conn.port}"
  end
end

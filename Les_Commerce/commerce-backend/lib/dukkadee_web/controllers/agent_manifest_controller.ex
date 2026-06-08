defmodule DukkadeeWeb.AgentManifestController do
  use DukkadeeWeb, :controller

  def show(conn, _params) do
    # Get current host info for base URL
    base_url = DukkadeeWeb.Endpoint.url()

    manifest = %{
      "schema_version" => "1.0",
      "name" => "DIYABI - Headless & Multi-Tenant Creator Commerce Platform",
      "description" => "Autonomous AI Agent friendly directory for procuring materials, hiring DIY artisans (ustas), and watching interactive video checklists.",
      "brand" => "eny",
      "design_system" => %{
        "typography" => %{
          "ui" => "Inter",
          "heading" => "Syne",
          "code" => "JetBrains Mono"
        },
        "color_theme" => "Dark Glassmorphism",
        "primary_hsl" => "hsl(247, 67%, 59%)"
      },
      "agent_capabilities" => %{
        "semantic_metadata" => "JSON-LD (Schema.org) embedded in all responses",
        "discovery" => true,
        "autonomous_booking" => true,
        "headless_checkout" => true
      },
      "endpoints" => %{
        "products_directory" => %{
          "url" => "#{base_url}/api/products",
          "method" => "GET",
          "query_parameters" => %{
            "store_id" => "Filter by merchant store ID",
            "type" => "Filter by type (finished_good | material | service)"
          },
          "response_format" => "JSON-LD Product/GovernmentService array"
        },
        "diy_tutorials" => %{
          "url" => "#{base_url}/api/videos",
          "method" => "GET",
          "query_parameters" => %{
            "store_id" => "Filter by creator store ID"
          },
          "response_format" => "JSON-LD VideoObject with material check-lists"
        },
        "autonomous_booking" => %{
          "url" => "#{base_url}/api/appointments",
          "method" => "POST",
          "payload" => %{
            "appointment" => %{
              "product_id" => "ID of the service/usta product",
              "customer_name" => "Customer name string",
              "customer_email" => "Customer email address",
              "customer_phone" => "Customer telephone number",
              "start_time" => "ISO 8601 UTC date-time of slot start",
              "end_time" => "ISO 8601 UTC date-time of slot end",
              "notes" => "Specific project briefing or instructions"
            }
          },
          "response_format" => "JSON-LD Reservation confirmation details"
        }
      },
      "well_known" => [
        "#{base_url}/.well-known/ai-agent.json",
        "#{base_url}/agent-manifest.json"
      ]
    }

    json(conn, manifest)
  end
end

defmodule LesCore.HTTP.Router do
  @moduledoc """
  Minimal HTTP surface for the Les Core contract.
  """

  use Plug.Router

  alias LesCore.{Activations, Ecosystem, Events}

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  get "/api/health" do
    json(conn, 200, %{data: Ecosystem.health()})
  end

  get "/api/identity/status" do
    json(conn, 200, Activations.identity_status(conn.params))
  end

  get "/api/activations" do
    activations = Activations.list_activations(conn.params)

    response = %{
      "data" => activations.data,
      "meta" => activations.meta,
      "app_activations" => Enum.map(activations.data, &activation_payload/1),
      "channels" => Enum.map(default_channels(), &channel_payload/1)
    }

    json(conn, 200, response)
  end

  post "/api/activations/apps/:product_id" do
    params = Map.merge(conn.params, body_params(conn))

    case Activations.activate_app(product_id, params) do
      {:ok, response} ->
        json(conn, 201, %{
          "data" => response.data,
          "activation" => activation_payload(response.data)
        })

      {:error, {:unknown_product_id, unknown_product_id}} ->
        json(conn, 422, %{
          "error" => %{"code" => "unknown_product_id", "product_id" => unknown_product_id}
        })
    end
  end

  post "/api/activations/channels/:channel_id" do
    params = Map.merge(conn.params, body_params(conn))
    {:ok, response} = Activations.activate_channel(channel_id, params)

    json(conn, 201, %{
      "data" => response.data,
      "channel" => channel_payload(response.data)
    })
  end

  post "/api/opportunity-events" do
    params = body_params(conn)

    case Events.record_opportunity_event(params) do
      {:ok, event} ->
        json(conn, 201, %{
          "data" => event,
          "event" => event_payload(event)
        })

      {:error, {:unknown_event_type, event_type}} ->
        json(conn, 422, %{
          "error" => %{"code" => "unknown_event_type", "event_type" => event_type}
        })

      {:error, {:unknown_source_app, source_app}} ->
        json(conn, 422, %{
          "error" => %{"code" => "unknown_source_app", "source_app" => source_app}
        })

      {:error, {:unknown_privacy_level, privacy_level}} ->
        json(conn, 422, %{
          "error" => %{"code" => "unknown_privacy_level", "privacy_level" => privacy_level}
        })

      {:error, :private_payload_not_allowed_in_shared_event} ->
        json(conn, 422, %{
          "error" => %{"code" => "private_payload_not_allowed_in_shared_event"}
        })

      {:error, :payload_must_be_map} ->
        json(conn, 422, %{
          "error" => %{"code" => "payload_must_be_map"}
        })
    end
  end

  post "/api/check-ins" do
    params = body_params(conn)

    case Events.record_check_in(params) do
      {:ok, event} ->
        json(conn, 201, %{
          "data" => event,
          "event" => event_payload(event)
        })

      {:error, {:unknown_event_type, event_type}} ->
        json(conn, 422, %{
          "error" => %{"code" => "unknown_event_type", "event_type" => event_type}
        })

      {:error, {:unknown_source_app, source_app}} ->
        json(conn, 422, %{
          "error" => %{"code" => "unknown_source_app", "source_app" => source_app}
        })

      {:error, {:unknown_privacy_level, privacy_level}} ->
        json(conn, 422, %{
          "error" => %{"code" => "unknown_privacy_level", "privacy_level" => privacy_level}
        })

      {:error, :private_payload_not_allowed_in_shared_event} ->
        json(conn, 422, %{
          "error" => %{"code" => "private_payload_not_allowed_in_shared_event"}
        })

      {:error, :payload_must_be_map} ->
        json(conn, 422, %{
          "error" => %{"code" => "payload_must_be_map"}
        })
    end
  end

  get "/.well-known/lestupid-app.json" do
    json(conn, 200, Ecosystem.manifest(base_url(conn)))
  end

  get "/agent-manifest.json" do
    json(conn, 200, Ecosystem.manifest(base_url(conn)))
  end

  match _ do
    json(conn, 404, %{error: %{code: "not_found"}})
  end

  defp json(conn, status, body) do
    body = Jason.encode!(body)

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(status, body)
  end

  defp base_url(conn) do
    "#{Atom.to_string(conn.scheme)}://#{conn.host}:#{conn.port}"
  end

  defp body_params(%Plug.Conn{body_params: %Plug.Conn.Unfetched{}}), do: %{}
  defp body_params(%Plug.Conn{body_params: body_params}) when is_map(body_params), do: body_params

  defp activation_payload(activation) do
    %{
      "productId" => activation.product_id,
      "status" => activation.status,
      "permissions" => activation.permissions
    }
  end

  defp channel_payload(channel) do
    %{
      "channelId" => channel.channel_id,
      "status" => channel.status,
      "allowedApps" => Map.get(channel, :allowed_apps, [])
    }
  end

  defp event_payload(event) do
    %{
      "eventId" => event.event_id,
      "eventType" => event.event_type,
      "sourceApp" => event.source_app,
      "identityId" => event.identity_id,
      "privacyLevel" => event.privacy_level,
      "payload" => event.payload
    }
  end

  defp default_channels do
    [
      %{
        channel_id: "place",
        status: "activated",
        allowed_apps: ["les-core", "les-go", "les-poke", "les-wait", "les-certification"]
      },
      %{
        channel_id: "trust",
        status: "activated",
        allowed_apps: ["les-core", "les-go", "les-certification", "les-itemotel"]
      },
      %{
        channel_id: "matchmaking",
        status: "available",
        allowed_apps: ["les-match", "les-go"]
      },
      %{
        channel_id: "travel",
        status: "activated",
        allowed_apps: [
          "les-go",
          "les-travel",
          "les-contacts",
          "lescommerce",
          "les-harmonica",
          "les-care",
          "les-ai"
        ]
      }
    ]
  end
end

defmodule LesPokeApi.Ecosystem do
  @moduledoc """
  LesTupid ecosystem metadata for Les Poke.

  This module keeps product identity, certification intent and public discovery
  endpoints in one place so the API, tests and static manifest stay aligned.
  """

  @product_id "les-poke"
  @name "Les Poke"
  @version "0.1.0"

  def product_id, do: @product_id
  def name, do: @name
  def version, do: @version

  def health do
    %{
      status: "ok",
      service: "les_poke_api",
      product_id: @product_id,
      ecosystem: "LesTupid",
      version: @version,
      discovery: [
        "/agent-manifest.json",
        "/.well-known/ai-agent.json",
        "/.well-known/lestupid-app.json"
      ]
    }
  end

  def manifest(base_url) do
    %{
      schema_version: "lestupid.app_manifest.v1",
      product_id: @product_id,
      name: @name,
      service: "les_poke_api",
      version: @version,
      status: "internal_candidate",
      directory: "Les_poke",
      summary: "Mobile-first real-world city quest and memory layer for Kadikoy and Nairobi.",
      ecosystem_roles: [
        "city_memory",
        "real_world_quest",
        "loyalty_points_source",
        "live_local_discovery",
        "checkin_signal_source",
        "place_candidate_signal",
        "event_signal_source"
      ],
      certification: %{
        registry_id: @product_id,
        route:
          "certify safe public-space quests, opt-in live discovery, clear points, and local memory stewardship",
        human_review_required: true
      },
      identity_activation: %{
        model: "shared_lestupid_identity",
        registration: "handled_by_lestupid_identity_layer",
        app_activation_required: true,
        activation_product_id: @product_id,
        activation_permissions: [
          "quest_profile",
          "city_selection",
          "location_for_quests",
          "loyalty_points"
        ],
        user_controls: ["activate", "pause", "revoke", "export"]
      },
      runtime_modes: [
        "standalone_app",
        "ecosystem_activated_app"
      ],
      portability: %{
        standalone_ready: true,
        ecosystem_activation_optional: true,
        extraction_difficulty: "low",
        data_owner: "app",
        required_adapters: [],
        optional_adapters: [
          "identity_adapter",
          "activation_adapter",
          "channel_adapter",
          "match_opportunity_adapter",
          "certification_adapter",
          "loyalty_adapter",
          "les_block_adapter",
          "ai_adapter"
        ],
        export_required: true,
        separation_rule:
          "Les Poke can run as a city quest app without Les Match, Les Commerce, or Les Wait; ecosystem features become optional integrations."
      },
      platform_strategy: %{
        delivery_model: "simple_fast_flexible_api_first",
        mobile_web: "responsive_pwa_first",
        mobile_app: "expo_when_native_city_quest_install_is_needed",
        desktop_app: "web_pwa_first",
        admin_ops: "web_dashboard_when_api_exists"
      },
      value_layer: %{
        source_of_truth: "local_or_lestupid_core_ledger",
        web3_role: "optional_proof_and_portability",
        wallet_required: false,
        adapter: "les_block_adapter",
        supported_value_events: [
          "la_earned",
          "le_earned",
          "lo_earned",
          "lale_completed",
          "quest_completed",
          "point_earned",
          "badge_earned",
          "place_candidate_signal",
          "certificate_proof_requested"
        ],
        rules: [
          "quest_play_without_wallet",
          "private_location_data_never_published_on_chain",
          "mint_requires_explicit_consent",
          "points_do_not_override_safety_or_queue_rules",
          "reward_rules_must_be_transparent"
        ]
      },
      integrations: %{
        les_match: %{
          ready: true,
          use_cases: [
            "check-in based compatible people discovery",
            "concert, travel, and local event match opportunities",
            "quest interest to participant matching",
            "venue check-ins as lestupid place candidate signals"
          ],
          opportunity_events: [
            "check_in",
            "quest_interest",
            "event_plan",
            "travel_plan"
          ],
          interaction_channels: [
            "place",
            "travel",
            "event",
            "hobby"
          ],
          requires_les_match_activation: true
        },
        lescommerce: %{
          ready: true,
          use_cases: [
            "quest rewards for local merchants",
            "city discovery campaigns",
            "walk-to-store missions"
          ]
        },
        les_wait: %{
          ready: true,
          use_cases: [
            "nearby queue-safe micro quests",
            "breathable waiting walks",
            "hospital or service-area wayfinding prompts"
          ]
        },
        les_certification: %{
          ready: true,
          registry_id: @product_id
        },
        les_ai: %{
          ready: true,
          optional: true,
          use_cases: [
            "quest idea generation",
            "local story summary",
            "place evidence summary",
            "city safety review draft"
          ]
        },
        agentandbot: %{
          ready: true,
          optional: true,
          published_outside_lestupid: true,
          use_cases: [
            "KADRO agent-led city quest assistance",
            "agent-generated field note drafts",
            "agent-to-quest task suggestions"
          ]
        },
        les_block: %{
          ready: false,
          optional: true,
          adapter: "les_block_adapter",
          use_cases: [
            "quest completion proof",
            "badge proof",
            "place candidate proof",
            "point proof"
          ]
        }
      },
      match_opportunity_policy: %{
        source_events: [
          "check_in",
          "quest_interest",
          "event_plan",
          "travel_plan",
          "place_candidate_signal",
          "agent_field_note"
        ],
        requires_les_match_activation: true,
        both_sides_matchmaking_required_for_people: true,
        agent_matches_must_be_labeled: true,
        private_location_precision: "coarse_or_user_approved"
      },
      agent_capabilities: %{
        discovery: true,
        semantic_metadata: true,
        city_filtering: true,
        quest_lookup: true,
        health_check: true
      },
      endpoints: %{
        health: %{
          method: "GET",
          url: "#{base_url}/api/health"
        },
        cities: %{
          method: "GET",
          url: "#{base_url}/api/cities"
        },
        quests: %{
          method: "GET",
          url: "#{base_url}/api/quests",
          query_parameters: %{
            city_id: "Filter quests by city id, for example kadikoy or nairobi"
          }
        },
        quest_detail: %{
          method: "GET",
          url: "#{base_url}/api/quests/:id"
        },
        manifest: %{
          method: "GET",
          url: "#{base_url}/agent-manifest.json"
        }
      },
      well_known: [
        "#{base_url}/agent-manifest.json",
        "#{base_url}/.well-known/ai-agent.json",
        "#{base_url}/.well-known/lestupid-app.json"
      ]
    }
  end
end

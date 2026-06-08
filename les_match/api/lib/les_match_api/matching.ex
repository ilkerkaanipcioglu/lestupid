defmodule LesMatchApi.Matching do
  @moduledoc """
  Static first-pass matchmaking read model.

  The MVP keeps matching explainable and deterministic until a database-backed
  model exists. Every candidate exposes score parts and safety metadata.
  """

  @candidates [
    %{
      id: "local-quest-walk",
      type: "quest_to_participant",
      title: "Local quest walk",
      target: "Les Poke",
      summary: "A nearby city-memory walk for someone who wants light discovery.",
      score: 86,
      score_parts: %{
        intent_fit: 35,
        proximity: 24,
        ecosystem_value: 17,
        safety_fit: 10
      },
      explanation: [
        "Matches discovery intent",
        "Uses a public-space quest",
        "Does not require personal contact"
      ],
      safety: %{
        opt_in_required: true,
        paid_placement: false,
        sensitive_inference_used: false,
        human_review_required: false
      }
    },
    %{
      id: "queue-safe-coffee-errand",
      type: "wait_state_to_action",
      title: "Queue-safe coffee errand",
      target: "les_wait",
      summary: "A short nearby action while waiting without losing queue state.",
      score: 78,
      score_parts: %{
        intent_fit: 28,
        proximity: 22,
        ecosystem_value: 18,
        safety_fit: 10
      },
      explanation: [
        "Matches waiting context",
        "Keeps the user near the service area",
        "Avoids forced app-only participation"
      ],
      safety: %{
        opt_in_required: true,
        paid_placement: false,
        sensitive_inference_used: false,
        human_review_required: false
      }
    },
    %{
      id: "honest-local-offer",
      type: "person_to_merchant",
      title: "Honest local offer",
      target: "LesCommerce",
      summary: "A merchant or service match that must label any paid placement.",
      score: 72,
      score_parts: %{
        intent_fit: 30,
        proximity: 15,
        ecosystem_value: 17,
        safety_fit: 10
      },
      explanation: [
        "Matches commerce intent",
        "Requires clear price and offer metadata",
        "Paid placement must be labeled"
      ],
      safety: %{
        opt_in_required: true,
        paid_placement: true,
        paid_placement_label_required: true,
        sensitive_inference_used: false,
        human_review_required: true
      }
    },
    %{
      id: "shared-car-interest",
      type: "shared_interest",
      title: "Shared car interest",
      target: "les_match",
      summary: "A car share can become an opt-in introduction to people who like the same car.",
      score: 81,
      score_parts: %{
        intent_fit: 32,
        shared_interest: 24,
        ecosystem_value: 15,
        safety_fit: 10
      },
      explanation: [
        "Both sides activated matchmaking",
        "The shared object matches a declared interest",
        "No profile is exposed before mutual interest"
      ],
      opportunity: %{
        source_app: "future_lestupid_apps",
        source_event: "share",
        topic: "car",
        channel_id: "car"
      },
      safety: %{
        opt_in_required: true,
        both_sides_matchmaking_required: true,
        paid_placement: false,
        sensitive_inference_used: false,
        human_review_required: false
      }
    },
    %{
      id: "concert-travel-circle",
      type: "event_or_travel",
      title: "Concert or trip circle",
      target: "les_match",
      summary:
        "People going to the same concert, route, holiday, or city can meet if they opt in.",
      score: 84,
      score_parts: %{
        intent_fit: 34,
        time_place_overlap: 25,
        ecosystem_value: 15,
        safety_fit: 10
      },
      explanation: [
        "Matches a declared event or travel plan",
        "Time and place overlap",
        "Introductions require explicit user action"
      ],
      opportunity: %{
        source_app: "Les_poke",
        source_event: "event_plan",
        topic: "concert_or_travel",
        channel_id: "travel"
      },
      safety: %{
        opt_in_required: true,
        both_sides_matchmaking_required: true,
        paid_placement: false,
        sensitive_inference_used: false,
        human_review_required: false
      }
    },
    %{
      id: "student-sponsor-match",
      type: "sponsor_or_mentor",
      title: "Student sponsor match",
      target: "les_match",
      summary: "University people can meet sponsors for education, travel, work, or projects.",
      score: 79,
      score_parts: %{
        intent_fit: 31,
        support_relevance: 23,
        ecosystem_value: 15,
        safety_fit: 10
      },
      explanation: [
        "Matches a declared support need",
        "Sponsor type matches education, travel, job, or project intent",
        "Human review can be required for sensitive sponsorship flows"
      ],
      opportunity: %{
        source_app: "future_lestupid_apps",
        source_event: "sponsor_need",
        topic: "university_support",
        channel_id: "education"
      },
      safety: %{
        opt_in_required: true,
        both_sides_matchmaking_required: true,
        paid_placement: false,
        sensitive_inference_used: false,
        human_review_required: true
      }
    },
    %{
      id: "place-checkin-match",
      type: "checkin_opportunity",
      title: "Place check-in match",
      target: "les_match",
      summary:
        "A check-in can suggest compatible people and also mark the venue as a lestupid place candidate.",
      score: 76,
      score_parts: %{
        intent_fit: 26,
        place_overlap: 24,
        ecosystem_value: 16,
        safety_fit: 10
      },
      explanation: [
        "Both users checked in or showed interest in the same place",
        "The venue can become a lestupid candidate through repeated demand",
        "Nearby matching stays opt-in"
      ],
      opportunity: %{
        source_app: "Les_poke",
        source_event: "check_in",
        topic: "lestupid_place_candidate",
        channel_id: "place"
      },
      safety: %{
        opt_in_required: true,
        both_sides_matchmaking_required: true,
        paid_placement: false,
        sensitive_inference_used: false,
        human_review_required: true
      }
    },
    %{
      id: "instagram-interest-signal",
      type: "shared_interest",
      title: "Instagram interest signal",
      target: "les_match",
      summary:
        "A user-approved Instagram signal can become an explainable shared-interest opportunity.",
      score: 74,
      score_parts: %{
        intent_fit: 27,
        social_signal_fit: 22,
        ecosystem_value: 15,
        safety_fit: 10
      },
      explanation: [
        "Uses only user-approved social signals",
        "Matches a declared topic or creator interest",
        "Private messages are not imported by default"
      ],
      opportunity: %{
        source_app: "instagram",
        source_event: "social_signal",
        topic: "approved_post_interest",
        channel_id: "instagram"
      },
      safety: %{
        opt_in_required: true,
        both_sides_matchmaking_required: true,
        paid_placement: false,
        private_messages_imported: false,
        sensitive_inference_used: false,
        human_review_required: false
      }
    },
    %{
      id: "shopping-wishlist-match",
      type: "person_to_merchant",
      title: "Shopping wishlist match",
      target: "LesCommerce",
      summary:
        "A marketplace wishlist can produce offers, repair/resale options, and compatible communities.",
      score: 73,
      score_parts: %{
        intent_fit: 29,
        commerce_signal_fit: 21,
        ecosystem_value: 13,
        safety_fit: 10
      },
      explanation: [
        "Matches a user-approved shopping signal",
        "Can suggest offers or repair/resale before pushing new purchase",
        "Paid placement must be labeled"
      ],
      opportunity: %{
        source_app: "shopping_marketplace",
        source_event: "wishlist",
        topic: "product_interest",
        channel_id: "shopping_marketplace"
      },
      safety: %{
        opt_in_required: true,
        both_sides_matchmaking_required: true,
        paid_placement: true,
        paid_placement_label_required: true,
        sensitive_inference_used: false,
        human_review_required: true
      }
    },
    %{
      id: "university-affiliation-sponsor",
      type: "sponsor_or_mentor",
      title: "University affiliation sponsor",
      target: "les_match",
      summary:
        "A verified university affiliation can create mentor, sponsor, travel, internship, job, or project opportunities.",
      score: 82,
      score_parts: %{
        intent_fit: 31,
        affiliation_fit: 24,
        ecosystem_value: 17,
        safety_fit: 10
      },
      explanation: [
        "Uses an explicit university affiliation channel",
        "Sponsor or mentor intent matches the student's declared need",
        "Sensitive sponsorship flows can require human review"
      ],
      opportunity: %{
        source_app: "university_affiliation",
        source_event: "sponsor_need",
        topic: "education_travel_job_project_support",
        channel_id: "university_affiliation"
      },
      safety: %{
        opt_in_required: true,
        both_sides_matchmaking_required: true,
        verified_affiliation_preferred: true,
        paid_placement: false,
        sensitive_inference_used: false,
        human_review_required: true
      }
    },
    %{
      id: "kadro-agent-workflow-mentor",
      type: "person_to_agent",
      title: "KADRO workflow mentor",
      target: "agentandbot.com",
      summary:
        "A clearly labeled KADRO AI agent can help a user, student, merchant, or creator with a task or workflow.",
      score: 77,
      score_parts: %{
        intent_fit: 30,
        capability_fit: 22,
        ecosystem_value: 15,
        safety_fit: 10
      },
      explanation: [
        "The candidate is labeled as an AI agent",
        "Agent capability matches the declared task",
        "The user can reject, mute, or report the suggestion"
      ],
      opportunity: %{
        source_app: "agentandbot_kadro",
        source_event: "agent_capability",
        topic: "workflow_or_mentor_need",
        channel_id: "agent_persona"
      },
      safety: %{
        opt_in_required: true,
        agent_identity_label_required: true,
        presented_as_human: false,
        paid_placement: false,
        sensitive_inference_used: false,
        human_review_required: true
      }
    }
  ]

  def preview(params \\ %{}) do
    type = Map.get(params, "type")

    candidates =
      case type do
        nil -> @candidates
        value -> Enum.filter(@candidates, &(&1.type == value))
      end

    %{
      data: candidates,
      meta: %{
        product_id: "les-match",
        opt_in_required: true,
        explainable_recommendations: true,
        paid_placement_must_be_labeled: true,
        decision_controls: ["accept", "reject", "mute", "block", "report"]
      }
    }
  end

  def record_decision(action, params) do
    %{
      data: %{
        action: action,
        match_id: Map.get(params, "match_id"),
        status: "recorded",
        reversible: action in ["reject", "mute"],
        human_review_required: action in ["block", "report"]
      }
    }
  end

  def create_opportunity(params) do
    %{
      data: %{
        id: Map.get(params, "opportunity_id") || "demo-opportunity",
        source_app: Map.get(params, "source_app"),
        source_event: Map.get(params, "source_event"),
        topic: Map.get(params, "topic"),
        channel_id: Map.get(params, "channel_id"),
        channel_activation_required: true,
        status: "opportunity_recorded",
        requires_match_activation: true,
        both_sides_matchmaking_required: true,
        next_step: "preview_explainable_candidates"
      }
    }
  end
end

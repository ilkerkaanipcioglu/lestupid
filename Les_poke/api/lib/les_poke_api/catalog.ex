defmodule LesPokeApi.Catalog do
  @moduledoc """
  Read model for the first quest catalog.

  The first skeleton serves static seed-like data. The structs and API shape are
  intentionally close to the future database resources.
  """

  alias LesPokeApi.Catalog.{City, Quest}

  @cities [
    %City{
      id: "kadikoy",
      name: "Kadikoy",
      country: "Turkiye",
      center: %{latitude: 40.9903, longitude: 29.0275}
    },
    %City{
      id: "nairobi",
      name: "Nairobi",
      country: "Kenya",
      center: %{latitude: -1.2864, longitude: 36.8172}
    }
  ]

  @quests [
    %Quest{
      id: "kadikoy-moda-pier",
      city_id: "kadikoy",
      title: "Moda Pier Angle",
      description: "Stand near the pier and match the old coastline viewpoint.",
      memory: "Moda's shoreline has shifted through ferries, tea gardens and long evening walks.",
      type: :photo_prompt,
      points: 40,
      location: %{latitude: 40.9787, longitude: 29.0248}
    },
    %Quest{
      id: "kadikoy-bahariye-sound",
      city_id: "kadikoy",
      title: "Bahariye Street Sound",
      description: "Find the busiest crossing and notice one street sound.",
      memory: "Bahariye is one of Kadikoy's everyday stages.",
      type: :question,
      points: 30,
      location: %{latitude: 40.9872, longitude: 29.0287}
    },
    %Quest{
      id: "kadikoy-cafe-reels-brief",
      city_id: "kadikoy",
      title: "Cafe reels promotion quest",
      description: "Create a short cafe route video for a labeled local campaign.",
      memory:
        "Les Poke turns a Les Go place moment into a playable creator task. Les Commerce keeps the paid brief, reward terms and affiliate disclosure.",
      type: :creator_promotion,
      points: 75,
      source_app: "les_go",
      sponsor_label: "Sponsored brief",
      commerce_handoff: "Open Les Commerce brief: cafe route reels, story set, reward terms.",
      safety_labels: [
        "paid_label_required",
        "creator_can_decline",
        "no_hidden_location_trail"
      ],
      action_label: "Review brief",
      location: %{latitude: 40.9854, longitude: 29.0308}
    },
    %Quest{
      id: "nairobi-city-market",
      city_id: "nairobi",
      title: "City Market Clue",
      description: "Walk around the market edge and choose the object that repeats most.",
      memory: "Nairobi City Market carries a layered rhythm of craft, food and movement.",
      type: :question,
      points: 40,
      location: %{latitude: -1.2814, longitude: 36.8189}
    },
    %Quest{
      id: "nairobi-uhuru-park",
      city_id: "nairobi",
      title: "Uhuru Park Pause",
      description: "Visit the park and find a quiet viewpoint back toward the city.",
      memory: "Uhuru Park is a civic pause inside the city.",
      type: :visit,
      points: 30,
      location: %{latitude: -1.2888, longitude: 36.8144}
    },
    %Quest{
      id: "nairobi-campus-tour-live",
      city_id: "nairobi",
      title: "Campus tour live quest",
      description: "Host a short live walk for students, visitors or a certified sponsor.",
      memory:
        "Campus creator tasks must stay clear: public spaces, clear sponsorship, no people matching unless Les Match is explicitly active.",
      type: :creator_promotion,
      points: 80,
      source_app: "les_go",
      sponsor_label: "Optional sponsor",
      commerce_handoff:
        "Open Les Commerce campaign terms: campus tour, travel sponsor or student offer.",
      safety_labels: [
        "minor_safe_context",
        "public_space_only",
        "match_opt_in_separate"
      ],
      action_label: "See sponsor terms",
      location: %{latitude: -1.2798, longitude: 36.8167}
    },
    %Quest{
      id: "nairobi-graduate-launch-circle",
      city_id: "nairobi",
      title: "Graduate launch circle",
      description: "Turn one campus day into CV, mentor, gig and travel-ready proof signals.",
      memory:
        "The viral university loop should help a student or new graduate find dignified paths: field notes, tutoring, creator coverage, peer delivery, sponsor prep and safe travel planning.",
      type: :question,
      points: 70,
      source_app: "les_go",
      sponsor_label: "Student launch",
      commerce_handoff:
        "Les Commerce may host safe gigs; Les Match mentor/sponsor discovery stays opt-in.",
      safety_labels: [
        "no_exploitation",
        "no_sexual_service_marketplace",
        "student_controls_visibility"
      ],
      action_label: "Start launch",
      location: %{latitude: -1.2806, longitude: 36.8159}
    }
  ]

  def list_cities, do: @cities

  def list_quests(filters \\ %{}) do
    city_id = Map.get(filters, "city_id") || Map.get(filters, :city_id)

    case city_id do
      nil -> @quests
      value -> Enum.filter(@quests, &(&1.city_id == value))
    end
  end

  def get_quest(id), do: Enum.find(@quests, &(&1.id == id))
end

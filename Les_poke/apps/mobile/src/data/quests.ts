export type CityId = "kadikoy" | "nairobi";

export type City = {
  id: CityId;
  name: string;
  country: string;
  center: {
    latitude: number;
    longitude: number;
  };
};

export type QuestType =
  | "visit"
  | "question"
  | "photo_prompt"
  | "creator_promotion";

export type Quest = {
  id: string;
  cityId: CityId;
  title: string;
  description: string;
  memory: string;
  type: QuestType;
  points: number;
  sourceApp?: "les_poke" | "les_go" | "lescommerce";
  sponsorLabel?: string;
  commerceHandoff?: string;
  safetyLabels?: string[];
  actionLabel?: string;
  location: {
    latitude: number;
    longitude: number;
  };
};

export type LiveEvent = {
  id: string;
  cityId: CityId;
  title: string;
  host: string;
  description: string;
  platform: "tiktok" | "instagram";
  externalUrl: string;
  distanceLabel: string;
  location: {
    latitude: number;
    longitude: number;
  };
  viewers: number;
  questId?: string;
  campaignLabel?: string;
  commerceHandoff?: string;
};

export const CITIES: City[] = [
  {
    id: "kadikoy",
    name: "Kadikoy",
    country: "Turkiye",
    center: {
      latitude: 40.9903,
      longitude: 29.0275
    }
  },
  {
    id: "nairobi",
    name: "Nairobi",
    country: "Kenya",
    center: {
      latitude: -1.2864,
      longitude: 36.8172
    }
  }
];

export const QUESTS: Quest[] = [
  {
    id: "kadikoy-moda-pier",
    cityId: "kadikoy",
    title: "Moda Pier Angle",
    description: "Stand near the pier and match the old coastline viewpoint.",
    memory: "Moda's shoreline has shifted through ferries, tea gardens and long evening walks. This quest opens the first memory layer of the district.",
    type: "photo_prompt",
    points: 40,
    location: {
      latitude: 40.9787,
      longitude: 29.0248
    }
  },
  {
    id: "kadikoy-bahariye-sound",
    cityId: "kadikoy",
    title: "Bahariye Street Sound",
    description: "Find the busiest crossing and notice one street sound.",
    memory: "Bahariye is one of Kadikoy's everyday stages: tram bells, bookstores, side streets and meeting points.",
    type: "question",
    points: 30,
    location: {
      latitude: 40.9872,
      longitude: 29.0287
    }
  },
  {
    id: "kadikoy-yeldegirmeni-mural",
    cityId: "kadikoy",
    title: "Yeldegirmeni Mural Walk",
    description: "Visit a mural street and unlock the neighborhood art note.",
    memory: "Yeldegirmeni mixes apartment memory, street art, small cafes and old railway textures.",
    type: "visit",
    points: 35,
    location: {
      latitude: 40.9966,
      longitude: 29.0319
    }
  },
  {
    id: "kadikoy-cafe-reels-brief",
    cityId: "kadikoy",
    title: "Cafe reels promotion quest",
    description: "Create a short cafe route video for a labeled local campaign.",
    memory: "Les Poke turns a Les Go place moment into a playable creator task. Les Commerce keeps the paid brief, reward terms and affiliate disclosure.",
    type: "creator_promotion",
    points: 75,
    sourceApp: "les_go",
    sponsorLabel: "Sponsored brief",
    commerceHandoff: "Open Les Commerce brief: cafe route reels, story set, reward terms.",
    safetyLabels: [
      "paid_label_required",
      "creator_can_decline",
      "no_hidden_location_trail"
    ],
    actionLabel: "Review brief",
    location: {
      latitude: 40.9854,
      longitude: 29.0308
    }
  },
  {
    id: "kadikoy-diy-product-demo",
    cityId: "kadikoy",
    title: "DIY product demo quest",
    description: "Film a maker, material seller or ready-made product demo from a DIY page.",
    memory: "A DIY video can create commerce around materials, masters and finished goods. Les Poke adds the creator challenge layer without owning checkout.",
    type: "creator_promotion",
    points: 65,
    sourceApp: "lescommerce",
    sponsorLabel: "Commerce-linked",
    commerceHandoff: "Open Les Commerce DIY: product video, parts, makers, finished sellers.",
    safetyLabels: [
      "commerce_terms_visible",
      "affiliate_disclosure",
      "content_rights_confirmed"
    ],
    actionLabel: "Open campaign",
    location: {
      latitude: 40.9905,
      longitude: 29.0279
    }
  },
  {
    id: "nairobi-city-market",
    cityId: "nairobi",
    title: "City Market Clue",
    description: "Walk around the market edge and choose the object that repeats most.",
    memory: "Nairobi City Market carries a layered rhythm of craft, food, movement and quick negotiations.",
    type: "question",
    points: 40,
    location: {
      latitude: -1.2814,
      longitude: 36.8189
    }
  },
  {
    id: "nairobi-uhuru-park",
    cityId: "nairobi",
    title: "Uhuru Park Pause",
    description: "Visit the park and find a quiet viewpoint back toward the city.",
    memory: "Uhuru Park is a civic pause inside the city, used for rest, gatherings and public memory.",
    type: "visit",
    points: 30,
    location: {
      latitude: -1.2888,
      longitude: 36.8144
    }
  },
  {
    id: "nairobi-railway-memory",
    cityId: "nairobi",
    title: "Railway Memory Frame",
    description: "Capture a present-day frame near the railway heritage zone.",
    memory: "The railway shaped Nairobi's growth and still gives the city one of its strongest historical anchors.",
    type: "photo_prompt",
    points: 45,
    location: {
      latitude: -1.2921,
      longitude: 36.8274
    }
  },
  {
    id: "nairobi-campus-tour-live",
    cityId: "nairobi",
    title: "Campus tour live quest",
    description: "Host a short live walk for students, visitors or a certified sponsor.",
    memory: "Campus creator tasks must stay clear: public spaces, clear sponsorship, no people matching unless Les Match is explicitly active.",
    type: "creator_promotion",
    points: 80,
    sourceApp: "les_go",
    sponsorLabel: "Optional sponsor",
    commerceHandoff: "Open Les Commerce campaign terms: campus tour, travel sponsor or student offer.",
    safetyLabels: [
      "minor_safe_context",
      "public_space_only",
      "match_opt_in_separate"
    ],
    actionLabel: "See sponsor terms",
    location: {
      latitude: -1.2798,
      longitude: 36.8167
    }
  },
  {
    id: "nairobi-graduate-launch-circle",
    cityId: "nairobi",
    title: "Graduate launch circle",
    description: "Turn one campus day into CV, mentor, gig and travel-ready proof signals.",
    memory: "The viral university loop should help a student or new graduate find dignified paths: field notes, tutoring, creator coverage, peer delivery, sponsor prep and safe travel planning.",
    type: "question",
    points: 70,
    sourceApp: "les_go",
    sponsorLabel: "Student launch",
    commerceHandoff: "Les Commerce may host safe gigs; Les Match mentor/sponsor discovery stays opt-in.",
    safetyLabels: [
      "no_exploitation",
      "no_sexual_service_marketplace",
      "student_controls_visibility"
    ],
    actionLabel: "Start launch",
    location: {
      latitude: -1.2806,
      longitude: 36.8159
    }
  }
];

export const LIVE_EVENTS: LiveEvent[] = [
  {
    id: "kadikoy-moda-sunset-live",
    cityId: "kadikoy",
    questId: "kadikoy-moda-pier",
    title: "Moda sunset walk",
    host: "Local explorer",
    description: "A short live walk from the pier to the tea gardens.",
    platform: "instagram",
    externalUrl: "https://www.instagram.com/",
    distanceLabel: "420m away",
    location: {
      latitude: 40.9794,
      longitude: 29.0258
    },
    viewers: 18
  },
  {
    id: "kadikoy-cafe-creator-live",
    cityId: "kadikoy",
    questId: "kadikoy-cafe-reels-brief",
    title: "Cafe creator walk",
    host: "Reels maker",
    description: "A labeled creator promotion live walk for a local cafe route.",
    platform: "instagram",
    externalUrl: "https://www.instagram.com/",
    distanceLabel: "300m away",
    location: {
      latitude: 40.9859,
      longitude: 29.0311
    },
    viewers: 9,
    campaignLabel: "Sponsored live",
    commerceHandoff: "Les Commerce owns brief, payout and affiliate terms."
  },
  {
    id: "nairobi-market-pulse",
    cityId: "nairobi",
    questId: "nairobi-city-market",
    title: "Market pulse",
    host: "City guide",
    description: "Live notes from the edge of City Market.",
    platform: "tiktok",
    externalUrl: "https://www.tiktok.com/live",
    distanceLabel: "650m away",
    location: {
      latitude: -1.282,
      longitude: 36.8198
    },
    viewers: 24
  },
  {
    id: "nairobi-campus-creator-live",
    cityId: "nairobi",
    questId: "nairobi-campus-tour-live",
    title: "Campus guide live",
    host: "Student creator",
    description: "A public campus walk for visitors, sponsors and student opportunities.",
    platform: "tiktok",
    externalUrl: "https://www.tiktok.com/live",
    distanceLabel: "520m away",
    location: {
      latitude: -1.2795,
      longitude: 36.8173
    },
    viewers: 16,
    campaignLabel: "Creator quest",
    commerceHandoff: "Commercial terms stay outside the public quest feed."
  },
  {
    id: "nairobi-launch-circle-live",
    cityId: "nairobi",
    questId: "nairobi-graduate-launch-circle",
    title: "Graduate launch circle",
    host: "Campus mentor crew",
    description: "Live launch room for CV, gigs, sponsor prep and Turkiye travel readiness.",
    platform: "instagram",
    externalUrl: "https://www.instagram.com/",
    distanceLabel: "inside campus",
    location: {
      latitude: -1.2807,
      longitude: 36.8162
    },
    viewers: 31,
    campaignLabel: "Student launch",
    commerceHandoff: "Mentor/sponsor matching requires explicit Les Match activation."
  }
];

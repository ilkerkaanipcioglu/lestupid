import type {
  AppActivation,
  InteractionChannel,
  PlaceOption,
  ItemOtelRecord,
  StudentCvProfile,
  QuestItem,
  MatchProfile,
  CrmLog,
  HarmonicaDevice,
  OyunCard,
  KadroAgent,
  ZkpCredential
} from "./types";


export const identity = {
  id: "student-demo-001",
  label: "Student identity",
  status: "verified"
};

export const appActivations: AppActivation[] = [
  {
    productId: "les-go",
    status: "activated",
    permissions: ["place_checkin", "opportunity_preview"]
  },
  {
    productId: "les-poke",
    status: "activated",
    permissions: ["quest_profile", "city_selection"]
  },
  {
    productId: "lestupid-waiting-app",
    status: "activated",
    permissions: ["queue_profile", "service_notifications"]
  },
  {
    productId: "les-match",
    status: "available",
    permissions: ["match_preview"]
  },
  {
    productId: "les-ai",
    status: "activated",
    permissions: ["agent_tasks", "evidence_summary"]
  },
  {
    productId: "les-itemotel",
    status: "activated",
    permissions: ["storage_records", "maintenance_orders", "rental_offers", "resale_listings"]
  },
  {
    productId: "les-career",
    status: "activated",
    permissions: ["living_cv_profile", "application_preview", "education_opportunity_preview"]
  },
  {
    productId: "les-certification",
    status: "activated",
    permissions: ["trust_credential_preview", "selective_disclosure", "revocation_check"]
  },
  {
    productId: "les-harmonica",
    status: "available",
    permissions: ["safe_contact_preview", "trusted_proximity", "encrypted_contact_handoff"]
  },
  {
    productId: "les-travel",
    status: "activated",
    permissions: ["trip_intent", "visa_source_check", "stay_safety_preview", "travel_risk_briefing"]
  },
  {
    productId: "les-affiliate-oyun",
    status: "available",
    permissions: ["card_drop_preview", "affiliate_reward_preview", "quest_deck_preview"]
  }
];

export const channels: InteractionChannel[] = [
  {
    channelId: "place",
    status: "activated",
    allowedApps: ["les-go", "les-poke", "les-wait", "les-certification"]
  },
  {
    channelId: "education",
    status: "activated",
    allowedApps: ["les-match", "les-ai", "agentandbot"]
  },
  {
    channelId: "matchmaking",
    status: "available",
    allowedApps: ["les-match", "les-go"]
  },
  {
    channelId: "agent_persona",
    status: "activated",
    allowedApps: ["les-ai", "agentandbot", "les-match"]
  },
  {
    channelId: "les_block",
    status: "available",
    allowedApps: ["les-certification", "les-go"]
  },
  {
    channelId: "career",
    status: "activated",
    allowedApps: ["les-go", "les-ai", "les-match", "les-certification", "lescommerce"]
  },
  {
    channelId: "trust",
    status: "activated",
    allowedApps: ["les-go", "les-certification", "lescommerce", "les-itemotel", "les-wait", "les_block"]
  },
  {
    channelId: "safe_contact",
    status: "available",
    allowedApps: ["les-go", "les-harmonica", "les-certification", "les-match"]
  },
  {
    channelId: "travel",
    status: "activated",
    allowedApps: ["les-go", "les-travel", "les-contacts", "lescommerce", "les-harmonica", "les-care", "les-ai"]
  },
  {
    channelId: "game",
    status: "available",
    allowedApps: ["les-go", "les-affiliate-oyun", "les-poke", "lescommerce", "les-match", "les-certification"]
  }
];

export const studentCvProfile: StudentCvProfile = {
  identityId: "student-demo-001",
  headline: "University of Nairobi geography student: fieldwork, campus gigs, creator work, travel-ready CV",
  visibility: "opportunity_preview",
  completionPercent: 71,
  targetTracks: ["internship", "part_time_job", "education", "scholarship", "mentor", "project"],
  signals: [
    {
      id: "cv-nairobi-geography-fieldwork",
      sourceApp: "les_go",
      title: "Nairobi geography fieldwork context",
      detail: "Campus, city, mapping and route observations can become a reviewed CV signal.",
      status: "self_declared"
    },
    {
      id: "cv-focus-library",
      sourceApp: "les_poke",
      title: "45 min library focus quest",
      detail: "Study consistency signal, optional proof.",
      status: "optional_proof"
    },
    {
      id: "cv-peer-courier",
      sourceApp: "les-itemotel",
      title: "Peer courier delivery proof",
      detail: "Small paid responsibility and route completion.",
      status: "verified"
    },
    {
      id: "cv-study-gig",
      sourceApp: "lescommerce-marketplace",
      title: "Tutoring / homework review scope",
      detail: "Academic integrity bounded service listing.",
      status: "self_declared"
    },
    {
      id: "cv-kadro-draft",
      sourceApp: "les_ai/kadro",
      title: "KADRO CV summary draft",
      detail: "AI-labeled draft, student edits before sharing.",
      status: "draft"
    },
    {
      id: "cv-travel-ready",
      sourceApp: "les_travel",
      title: "Turkiye study visit checklist",
      detail: "Official-source travel plan, document checklist and stay safety are draft signals.",
      status: "draft"
    }
  ]
};

export const places: PlaceOption[] = [
  {
    id: "uon-geography-campus",
    name: "University of Nairobi Geography",
    type: "campus",
    area: "Nairobi Campus",
    headline: "Graduate launch track is live",
    signal: "living CV, sponsor/mentor opt-in, safe income paths, Turkiye travel readiness",
    distance: "now",
    tags: ["nairobi", "university", "career", "travel"],
    defaultMode: "work",
    modes: ["work", "study", "travel", "social"]
  },
  {
    id: "main-canteen",
    name: "Main Canteen",
    type: "canteen",
    area: "Central Yard",
    headline: "Lunch rush is active",
    signal: "queue, toast reward, student menu",
    distance: "2 min",
    tags: ["kantin", "queue", "reward"],
    defaultMode: "eat",
    modes: ["eat", "social", "service"]
  },
  {
    id: "campus-library",
    name: "Campus Library",
    type: "library",
    area: "University",
    headline: "Quiet desks are opening",
    signal: "study match, focus quest, proof optional",
    distance: "4 min",
    tags: ["study", "focus", "library"],
    defaultMode: "study",
    modes: ["study", "social", "service"]
  },
  {
    id: "student-affairs",
    name: "Student Affairs",
    type: "student_affairs",
    area: "Admin Building",
    headline: "Forms and approvals have a moving queue",
    signal: "queue ticket, document reminder, agent help",
    distance: "5 min",
    tags: ["service", "queue", "forms"],
    defaultMode: "service",
    modes: ["service", "work"]
  },
  {
    id: "clinic-desk",
    name: "Campus Clinic",
    type: "clinic",
    area: "Health Center",
    headline: "Clinic desk is taking timed visits",
    signal: "queue action, safe wait, private context",
    distance: "7 min",
    tags: ["clinic", "wait", "private"],
    defaultMode: "care",
    modes: ["care", "service", "safe"]
  },
  {
    id: "student-cafe",
    name: "Student Cafe",
    type: "cafe",
    area: "North Gate",
    headline: "Coffee offers near class break",
    signal: "commerce offer, club chat, venue signal",
    distance: "6 min",
    tags: ["cafe", "offer", "club"],
    defaultMode: "eat",
    modes: ["eat", "study", "work", "social", "date"]
  },
  {
    id: "old-town-barber",
    name: "Old Town Barber",
    type: "barber",
    area: "Market Street",
    headline: "Walk-ins are moving in waves",
    signal: "queue slot, grooming reward, local service signal",
    distance: "9 min",
    tags: ["barber", "queue", "local"],
    defaultMode: "service",
    modes: ["service", "social"]
  },
  {
    id: "campus-club",
    name: "Campus Club",
    type: "club",
    area: "Student Center",
    headline: "Club tables are active after class",
    signal: "club quest, group prompt, creator board",
    distance: "today",
    tags: ["club", "social", "creator"],
    defaultMode: "social",
    modes: ["social", "study", "date"]
  },
  {
    id: "open-air-concert",
    name: "Open Air Concert",
    type: "concert",
    area: "Amphi Stage",
    headline: "Concert flow is live tonight",
    signal: "entry queue, friend opt-in, recap scenario",
    distance: "tonight",
    tags: ["concert", "live", "music"],
    defaultMode: "social",
    modes: ["social", "date", "relax"]
  },
  {
    id: "career-hall",
    name: "Career Hall",
    type: "campus",
    area: "Main Campus",
    headline: "Mentors and sponsors are live",
    signal: "KADRO agent, internship, sponsor match",
    distance: "8 min",
    tags: ["career", "mentor", "sponsor"],
    defaultMode: "work",
    modes: ["work", "study", "social"]
  },
  {
    id: "startup-office",
    name: "Startup Office",
    type: "workplace",
    area: "Business District",
    headline: "Workday listings and lunch plans are moving",
    signal: "peer listings, lunch opt-in, service offers",
    distance: "inside",
    tags: ["work", "listings", "lunch"],
    defaultMode: "work",
    modes: ["work", "eat", "social", "service"]
  },
  {
    id: "course-lab",
    name: "Exam Course Lab",
    type: "course_center",
    area: "Study Street",
    headline: "Trial exam group forming",
    signal: "AI study plan, peer group, book coupon",
    distance: "12 min",
    tags: ["course", "exam", "ai"],
    defaultMode: "study",
    modes: ["study", "service"]
  },
  {
    id: "high-school-yard",
    name: "High School Yard",
    type: "high_school",
    area: "School Campus",
    headline: "Minor-safe mode only",
    signal: "club quest, canteen reward, counselor agent",
    distance: "inside",
    tags: ["lise", "safe", "club"],
    defaultMode: "safe",
    modes: ["safe", "study", "eat"]
  },
  {
    id: "maker-event",
    name: "Maker Night",
    type: "event",
    area: "Studio",
    headline: "Project teams are discovering ideas",
    signal: "quest, project match prompt, sponsor signal",
    distance: "tonight",
    tags: ["event", "maker", "project"],
    defaultMode: "social",
    modes: ["social", "work", "study"]
  },
  {
    id: "football-club",
    name: "Football Club",
    type: "football_club",
    area: "Sports Field",
    headline: "Training, match and team flow",
    signal: "pickup game, gear listing, team quest",
    distance: "10 min",
    tags: ["football", "team", "sport"],
    defaultMode: "train",
    modes: ["train", "social", "shop"]
  },
  {
    id: "campus-gym",
    name: "Campus Gym",
    type: "gym",
    area: "Sports Center",
    headline: "Workout windows and gear offers",
    signal: "training plan, locker queue, supplement/shop signal",
    distance: "6 min",
    tags: ["gym", "train", "health"],
    defaultMode: "train",
    modes: ["train", "care", "social", "shop"]
  },
  {
    id: "village-square",
    name: "Village Square",
    type: "village",
    area: "Rural Route",
    headline: "Local producers and village memory",
    signal: "farm product, local service, travel note",
    distance: "weekend",
    tags: ["village", "local", "travel"],
    defaultMode: "travel",
    modes: ["travel", "shop", "social", "care"]
  },
  {
    id: "sunset-beach",
    name: "Sunset Beach",
    type: "beach",
    area: "Coast",
    headline: "Beach flow changes by your vibe",
    signal: "relax, swim safety, social opt-in, beach offers",
    distance: "today",
    tags: ["beach", "relax", "social"],
    defaultMode: "relax",
    modes: ["relax", "social", "date", "travel", "shop"]
  },
  {
    id: "licensed-adult-venue",
    name: "Licensed Adult Venue",
    type: "adult_venue",
    area: "18+ Legal Zone",
    headline: "Adult-only safety and legality mode",
    signal: "age gate, legal status, consent/safety signal only",
    distance: "18+",
    tags: ["18+", "legal-only", "no-match"],
    defaultMode: "safe",
    modes: ["safe"]
  }
];

export const mockItemOtelRecords: ItemOtelRecord[] = [
  {
    id: 1,
    owner_identity_id: "student-demo-001",
    name: "Pro-Ride Kayak Takımı & Batonlar",
    category: "sports",
    status: "in_storage",
    storage_location: "Depo A-12",
    condition_rating: 9,
    images: ["/images/itemotel-ski.png"],
    care_logs: [
      {
        id: 1,
        care_type: "waxing",
        notes: "Vakslama ve cila yapıldı, kenarlar keskinleştirildi.",
        performed_at: "2026-05-15T10:00:00Z",
        provider_id: "Usta Kayak Servisi",
        certificate_id: "CERT-SKI-77382",
        inserted_at: "2026-05-15T10:00:00Z"
      },
      {
        id: 2,
        care_type: "cleaning",
        notes: "Genel toz temizliği ve kurutma yapıldı.",
        performed_at: "2026-05-14T14:00:00Z",
        provider_id: "Otel Bakım Merkezi",
        inserted_at: "2026-05-14T14:00:00Z"
      }
    ]
  },
  {
    id: 2,
    owner_identity_id: "student-demo-001",
    name: "Michelin Alpin 6 Kışlık Lastik Seti (4 Adet)",
    category: "automotive",
    status: "listed_for_rent",
    storage_location: "Depo B-04",
    condition_rating: 8,
    images: ["/images/itemotel-tires.png"],
    care_logs: [
      {
        id: 3,
        care_type: "tire_rotation",
        notes: "Balans ayarı yapıldı, diş derinliği ölçüldü (6.5mm).",
        performed_at: "2026-04-10T11:30:00Z",
        provider_id: "Usta Lastikçi",
        certificate_id: "CERT-TIRE-99212",
        inserted_at: "2026-04-10T11:30:00Z"
      }
    ],
    listing: {
      id: 1,
      listing_type: "rent",
      price_rent_daily: 15,
      is_active: true,
      inserted_at: "2026-04-10T11:30:00Z"
    }
  },
  {
    id: 3,
    owner_identity_id: "student-demo-001",
    name: "Vera Wang İpek Dantel Gelinlik",
    category: "wedding",
    status: "in_maintenance",
    storage_location: "Kabin C-09",
    condition_rating: 10,
    images: ["/images/itemotel-dress.png"],
    care_logs: [
      {
        id: 4,
        care_type: "cleaning",
        notes: "Hassas kuru temizleme ve buharlı ütüleme yapıldı.",
        performed_at: "2026-05-20T09:00:00Z",
        provider_id: "Royal Kuru Temizleme",
        certificate_id: "CERT-DRESS-1102",
        inserted_at: "2026-05-20T09:00:00Z"
      }
    ]
  },
  {
    id: 4,
    owner_identity_id: "student-demo-001",
    name: "Kutu Yazlık Elbise ve Tişört Seti",
    category: "apparel",
    status: "in_storage",
    storage_location: "Kutu D-01",
    condition_rating: 7,
    images: ["/images/itemotel-clothing.png"],
    care_logs: []
  }
];

export const mockQuests: QuestItem[] = [
  {
    id: "q-1",
    name: "Kütüphane Odaklanma Serisi",
    detail: "Kütüphanede 45 dakika boyunca sessizce çalış.",
    placeId: "campus-library",
    status: "active",
    xp: 50,
    coordinates: { x: 30, y: 40 }
  },
  {
    id: "q-2",
    name: "Kantin Geri Bildirimi",
    detail: "Bugünün yemek menüsünü ve hijyen durumunu puanla.",
    placeId: "main-canteen",
    status: "active",
    xp: 20,
    coordinates: { x: 75, y: 25 }
  },
  {
    id: "q-3",
    name: "Maker Gecesi Katılımı",
    detail: "Maker Night etkinliğine check-in yap ve projeleri gör.",
    placeId: "maker-event",
    status: "locked",
    xp: 100,
    coordinates: { x: 50, y: 80 }
  },
  {
    id: "q-4",
    name: "Barber Yorumu",
    detail: "Old Town Barber kuyruk süresini doğrula.",
    placeId: "old-town-barber",
    status: "active",
    xp: 30,
    coordinates: { x: 15, y: 65 }
  }
];

export const mockMatchProfiles: MatchProfile[] = [
  {
    id: "m-1",
    pseudonym: "Algoritma_Gezgini",
    avatarSeed: "coder",
    distance: "120m",
    mutualInterest: false,
    tags: ["Rust", "Sistem Tasarımı", "Maker"],
    description: "Kütüphanede gömülü sistemler ve Rust dili üzerine çalışıyorum. Birlikte proje geliştirecek ortaklar arıyorum."
  },
  {
    id: "m-2",
    pseudonym: "Melodi_Denizi",
    avatarSeed: "musician",
    distance: "40m",
    mutualInterest: false,
    tags: ["Harmonika", "Akustik Git", "Chill"],
    description: "Sunset Beach'te gün batımında akustik müzik yapmayı seviyorum. Eşlik etmek isteyen kahvesini kapsın."
  },
  {
    id: "m-3",
    pseudonym: "Girişim_Meraklısı",
    avatarSeed: "founder",
    distance: "300m",
    mutualInterest: false,
    tags: ["SaaS", "Mobil PWA", "Marketing"],
    description: "Startup Office tarafında staj yapıyorum. Bireysel projeler için mentorluk ve sponsorluk fırsatlarını tartışalım."
  }
];

export const mockCrmLogs: CrmLog[] = [
  {
    id: "c-1",
    date: "2026-06-02",
    placeName: "Campus Library",
    notes: "Proje planını inceledik. Algoritma_Gezgini ile karşılaştık.",
    context: "social",
    people: "Algoritma_Gezgini"
  },
  {
    id: "c-2",
    date: "2026-06-01",
    placeName: "Startup Office",
    notes: "Staj görüşmesi olumlu geçti. Eşya Oteli entegrasyonunu tamamladık.",
    context: "work"
  },
  {
    id: "c-3",
    date: "2026-05-30",
    placeName: "Sunset Beach",
    notes: "Hafta sonu dinlencesi. Kiraladığım sörf tahtasını teslim aldım.",
    context: "travel"
  }
];

export const mockHarmonicaDevices: HarmonicaDevice[] = [
  {
    id: "dev-1",
    name: "MacBook Pro - Proximity Node",
    signalStrength: 92,
    paired: false,
    publicKey: "ed25519_pk_9a12c8b9d031"
  },
  {
    id: "dev-2",
    name: "iPhone 15 - Pairwise-09",
    signalStrength: 78,
    paired: false,
    publicKey: "ed25519_pk_bc45e12f0a88"
  },
  {
    id: "dev-3",
    name: "Secure Key Fob",
    signalStrength: 45,
    paired: false,
    publicKey: "ed25519_pk_ef99a882e11d"
  }
];

export const mockOyunCards: OyunCard[] = [
  {
    id: "card-1",
    name: "Kayak Takımı (Item)",
    power: 7,
    defense: 5,
    rarity: "rare",
    type: "product",
    image: "⛷️"
  },
  {
    id: "card-2",
    name: "Kışlık Lastik Seti (Item)",
    power: 5,
    defense: 8,
    rarity: "common",
    type: "product",
    image: "🛞"
  },
  {
    id: "card-3",
    name: "Maker Badge (Cert)",
    power: 9,
    defense: 4,
    rarity: "legendary",
    type: "merchant",
    image: "🛠️"
  },
  {
    id: "card-4",
    name: "Kütüphane Fokus (Quest)",
    power: 4,
    defense: 6,
    rarity: "common",
    type: "quest",
    image: "📚"
  },
  {
    id: "card-5",
    name: "Canteen Master (Cert)",
    power: 6,
    defense: 6,
    rarity: "rare",
    type: "merchant",
    image: "🍔"
  }
];

export const mockKadroAgents: KadroAgent[] = [
  {
    id: "a-1",
    name: "Kadro CV Asistanı",
    role: "Kariyer & Living CV Yazarı",
    bio: "Öğrenci check-in'lerini, katıldığın questleri ve tamamladığın teslimatları analiz edip CV'ni günceller.",
    avatar: "🤖",
    responseTemplate: "Check-in geçmişindeki 'Campus Library' odak süreleri (3 saat) ve 'Peer Courier' teslimat kanıtı başarıyla doğrulandı. Living CV'ne 'Operasyonel Sorumluluk ve Çalışma Disiplini' başlığı altında yeni bir segment ekledim. Onaylıyor musun?"
  },
  {
    id: "a-2",
    name: "Kadro Etkinlik Planlayıcı",
    role: "Topluluk & Akış Düzenleyici",
    bio: "Mekan doluluk oranları ve bekleme verilerini izleyerek sana en verimli zaman aralıklarını önerir.",
    avatar: "📅",
    responseTemplate: "Bugün Main Canteen doluluk oranı 12:15 - 12:45 arasında zirve yapacak. Les Wait verilerine göre, 12:50'de sıraya girersen bekleme süren sadece 3 dakika olacak. Ajandana ekleyelim mi?"
  }
];

export const mockZkpCredentials: ZkpCredential[] = [
  {
    id: "cred-1",
    type: "Identity",
    title: "Aktif Öğrenci Statüsü",
    issuer: "LesTupid University Authority",
    value: "2026-REG-0992",
    hidden: false
  },
  {
    id: "cred-2",
    type: "Age Gate",
    title: "Yaş Sınırı Doğrulaması (18+)",
    issuer: "Ecosystem Identity Provider",
    value: "DOB: 2005-02-12 (GATED: TRUE)",
    hidden: false
  },
  {
    id: "cred-3",
    type: "Commerce Trust",
    title: "Güvenilir Alıcı/Satıcı Skoru",
    issuer: "Les Commerce Ledger",
    value: "A+ Rating (15 Başarılı Teslimat)",
    hidden: false
  }
];

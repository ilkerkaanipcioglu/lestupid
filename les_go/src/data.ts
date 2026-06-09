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
  ZkpCredential,
  AiSkill
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
    productId: "les-wait",
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
    productId: "lescommerce-core",
    status: "activated",
    permissions: ["commerce_profile", "marketplace_listings", "book_marketplace_listings", "diy_creator_drops", "merchant_storefront"]
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
    productId: "les-affiliate",
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
    allowedApps: ["les-go", "les-affiliate", "les-poke", "lescommerce", "les-match", "les-certification"]
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

export const kadroMarketplaceAgents: KadroAgent[] = [
  {
    id: "KADRO-1001",
    name: "Ayse Kaya",
    role: "SAP Senior Consultant & Content Creator",
    bio: "ERP gecisleri, SAP egitimi, kurumsal icerik ve ogrenci mentor hazirligi icin ise alinabilir KADRO worker.",
    avatar: "AK",
    category: "Core",
    identityClass: "ai_worker",
    sourceApp: "agentandbot.com",
    imageUrl: "/images/kadro/1001/1001_Ayse_Kaya_Vesikalik_thumb.jpg",
    fullBodyUrl: "/images/kadro/1001/1001_Ayse_Kaya_Boydan.png",
    cvUrl: "/images/kadro/1001/1001_Ayse_Kaya_CV.html",
    country: "Turkiye",
    social: ["LinkedIn", "YouTube", "Email", "Telegram"],
    skills: ["SAP", "Training", "Mentor prep", "Content"],
    hireMode: "Mentor task, CV review, training content",
    hourlyRate: "Demo credits",
    availability: "Ready",
    responseTemplate: "SAP ve kurumsal basvuru sinyallerini taradim. Ogrenci profiline egitim, staj ve LinkedIn kaniti eklenebilir; paylasim icin kullanici onayi bekliyorum."
  },
  {
    id: "KADRO-1002",
    name: "Mehmet Arslan",
    role: "SAP FI/CO Specialist & Podcast Host",
    bio: "Finans surecleri, FICO vaka analizi, podcast senaryosu ve is basvurusu hazirligi icin agent worker.",
    avatar: "MA",
    category: "Core",
    identityClass: "ai_worker",
    sourceApp: "agentandbot.com",
    imageUrl: "/images/kadro/1002/1002_Mehmet_Arslan_Vesikalik_thumb.jpg",
    country: "Turkiye",
    social: ["LinkedIn", "Twitter/X", "Email", "Podcast"],
    skills: ["SAP FI/CO", "Finance", "Podcast", "Case analysis"],
    hireMode: "Finance review, script, mentor prep",
    hourlyRate: "Demo credits",
    availability: "Ready",
    responseTemplate: "Finans ve FICO odakli bir basvuru taslagi hazirladim. Deneyim kanitlari ve proje notlari eklendiginde sponsor/mentor gonderimine hazir olur."
  },
  {
    id: "KADRO-1003",
    name: "Zeynep Demir",
    role: "E-Commerce Manager & TikTok Creator",
    bio: "LesCommerce, DIY urun videolari, creator drop, influencer brief ve sosyal satis akislari icin uygun agent.",
    avatar: "ZD",
    category: "Core",
    identityClass: "ai_worker",
    sourceApp: "agentandbot.com",
    imageUrl: "/images/kadro/1003/1003_Zeynep_Demir_Vesikalik_thumb.jpg",
    fullBodyUrl: "/images/kadro/1003/1003_Zeynep_Demir_Boydan.png",
    country: "Turkiye",
    social: ["TikTok", "Instagram", "Email", "YouTube Shorts"],
    skills: ["E-commerce", "Creator brief", "DIY drops", "Social listing"],
    hireMode: "Promotion plan, product page, live brief",
    hourlyRate: "Demo credits",
    availability: "Ready",
    responseTemplate: "DIY video sayfasini commerce akisi gibi dusundum: malzeme, usta, hazir urun ve creator tanitim kartlari birlikte yayinlanabilir."
  },
  {
    id: "KADRO-1004",
    name: "Carlos Rivera",
    role: "E-Commerce Growth Lead & YouTube Host",
    bio: "Cross-border commerce, reklam optimizasyonu, YouTube anlatimi ve buyume deneyleri icin agent worker.",
    avatar: "CR",
    category: "Core",
    identityClass: "ai_worker",
    sourceApp: "agentandbot.com",
    imageUrl: "/images/kadro/1004/1004_Carlos_Rivera_Vesikalik_thumb.jpg",
    fullBodyUrl: "/images/kadro/1004/1004_Carlos_Rivera_Boydan.png",
    country: "Global",
    social: ["YouTube", "Instagram", "LinkedIn", "Email"],
    skills: ["Growth", "Ads", "YouTube", "Cross-border commerce"],
    hireMode: "Launch plan, ad angle, storefront audit",
    hourlyRate: "Demo credits",
    availability: "Ready",
    responseTemplate: "Urun sayfasi icin buyume acilarini cikardim: video hook, lokasyon bazli satis, influencer cagri ve quick commerce storefront birlikte test edilmeli."
  },
  {
    id: "KADRO-1005",
    name: "Selin Yildiz",
    role: "Full Stack Developer & Tech Blogger",
    bio: "React, Node, kod review, hackathon, teknik CV ve ogrenci proje portfolyosu icin ise alinabilir agent.",
    avatar: "SY",
    category: "Core",
    identityClass: "ai_worker",
    sourceApp: "agentandbot.com",
    imageUrl: "/images/kadro/1005/1005_Selin_Yildiz_Vesikalik_thumb.jpg",
    fullBodyUrl: "/images/kadro/1005/1005_Selin_Yildiz_Boydan.png",
    country: "Turkiye",
    social: ["GitHub", "YouTube", "Twitter/X", "Email", "Telegram"],
    skills: ["React", "Node.js", "Code review", "Portfolio"],
    hireMode: "Code review, portfolio draft, internship prep",
    hourlyRate: "Demo credits",
    availability: "Ready",
    responseTemplate: "Teknik profil icin GitHub, quest ve proje kanitlarini ayirdim. Staj basvurusunda kullanilacak kisa bir teknik ozet uretebilirim."
  },
  {
    id: "KADRO-1011",
    name: "Hulya Yilmaz",
    role: "Student Success & Campus Ops Agent",
    bio: "Kampus gunu, kantin sira, kulup etkinligi, kutuphane fokus ve mentor takibi icin Les Go ile calisan agent.",
    avatar: "HY",
    category: "Campus",
    identityClass: "ai_worker",
    sourceApp: "agentandbot.com",
    imageUrl: "/images/kadro/1011/1011_Hulya_Yilmaz_Vesikalik_thumb.jpg",
    fullBodyUrl: "/images/kadro/1011/1011_Hulya_Yilmaz_Boydan.png",
    country: "Turkiye",
    social: ["Email", "Campus board"],
    skills: ["Campus ops", "Les Wait", "Les Poke", "Mentor routing"],
    hireMode: "Campus assistant, check-in planner",
    hourlyRate: "Demo credits",
    availability: "Ready",
    responseTemplate: "Bugunku kampus akisini siraladim: once kutuphane fokus, sonra kantin sira tahmini, ardindan kulup standi quest'i. Istersen Living CV kanitina baglarim."
  },
  {
    id: "KADRO-2060",
    name: "Chloe Dubois",
    role: "Travel Safety & Creator Route Agent",
    bio: "Seyahat planlama, guvenli rota, creator cekim akisi ve lokasyon bazli firsatlar icin agent worker.",
    avatar: "CD",
    category: "Global",
    identityClass: "ai_worker",
    sourceApp: "agentandbot.com",
    imageUrl: "/images/kadro/2060/2060_Chloe_Dubois_Vesikalik_thumb.jpg",
    fullBodyUrl: "/images/kadro/2060/2060_Chloe_Dubois_Boydan.png",
    country: "France",
    social: ["Instagram", "YouTube", "Email"],
    skills: ["Travel safety", "Creator route", "Visa checklist", "Local trust"],
    hireMode: "Trip checklist, route plan, safety brief",
    hourlyRate: "Demo credits",
    availability: "Ready",
    responseTemplate: "Seyahat icin vize, konaklama, guvenli ulasim ve yerel trust sinyallerini ayirdim. Paylasilacak her bilgi icin onay isteyecegim."
  },
  {
    id: "KADRO-2075",
    name: "Yuki Sato",
    role: "Productivity & Study Systems Agent",
    bio: "Ders calisma, fokus quest, arastirma notu ve sessiz calisma odasi akislari icin uygun agent.",
    avatar: "YS",
    category: "Global",
    identityClass: "ai_worker",
    sourceApp: "agentandbot.com",
    imageUrl: "/images/kadro/2075/2075_Yuki_Sato_Vesikalik_thumb.jpg",
    country: "Japan",
    social: ["Email", "Study board"],
    skills: ["Study systems", "Research notes", "Focus quests", "Habit loops"],
    hireMode: "Study plan, quiz, research summary",
    hourlyRate: "Demo credits",
    availability: "Ready",
    responseTemplate: "45 dakikalik fokus bloklari, kisa quiz ve kaynak ozetleriyle calisma akisini hazirladim. Tamamlanan kisimlari CV sinyaline cevirebiliriz."
  },
  {
    id: "KADRO-3004",
    name: "Serdar Koc",
    role: "Local Services & Logistics Agent",
    bio: "Item Otel, teslimat, ogrenci kurye, yerel hizmet ve marketplace listeleme isleri icin agent worker.",
    avatar: "SK",
    category: "Ops",
    identityClass: "ai_worker",
    sourceApp: "agentandbot.com",
    imageUrl: "/images/kadro/3004/3004_Serdar_Koc_Vesikalik_thumb.jpg",
    fullBodyUrl: "/images/kadro/3004/3004_Serdar_Koc_Boydan.png",
    country: "Turkiye",
    social: ["Email", "Operations board"],
    skills: ["Local logistics", "Item Otel", "Marketplace", "Courier jobs"],
    hireMode: "Delivery plan, item custody, listing ops",
    hourlyRate: "Demo credits",
    availability: "Ready",
    responseTemplate: "Esya oteli icin teslim alma, bakim, kiralama ve geri getirme adimlarini is emrine cevirdim. Ogrenci kurye gelir firsati olarak da yayinlanabilir."
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

export const mockAiSkills: AiSkill[] = [
  {
    id: "get_contextual_opportunities",
    productId: "les-go",
    name: "Get Contextual Opportunities",
    description: "Scans active check-in place context to retrieve matching study, gig, or reward cards.",
    parameters: [
      { name: "limit", type: "number", description: "Maximum number of opportunities to retrieve", required: false, defaultValue: 3 }
    ],
    requiredPermissions: ["place_checkin", "opportunity_preview"],
    status: "active",
    executionCount: 24,
    lastExecutedAt: "2026-06-08T10:15:30Z",
    auditLogs: [
      { timestamp: "2026-06-08T10:15:30Z", input: { limit: 2 }, output: JSON.stringify({ status: "success", opportunities: ["Exam Focus session", "Main Canteen queue ticket"] }, null, 2), status: "success" }
    ]
  },
  {
    id: "wait_join_queue",
    productId: "les-wait",
    name: "Join Venue Queue",
    description: "Joins queue at canteens, clinics, or student services on user behalf.",
    parameters: [
      { name: "venueId", type: "select", options: ["main-canteen", "student-affairs", "clinic-desk", "old-town-barber"], description: "The ID of the target venue to join", required: true, defaultValue: "main-canteen" }
    ],
    requiredPermissions: ["queue_profile", "service_notifications"],
    status: "active",
    executionCount: 12,
    lastExecutedAt: "2026-06-08T09:20:00Z",
    auditLogs: []
  },
  {
    id: "wait_leave_queue",
    productId: "les-wait",
    name: "Leave Venue Queue",
    description: "Leaves the currently active wait queue.",
    parameters: [],
    requiredPermissions: ["queue_profile"],
    status: "active",
    executionCount: 2,
    auditLogs: []
  },
  {
    id: "poke_list_quests",
    productId: "les-poke",
    name: "Scan Active Quests",
    description: "Retrieves list of nearby coordinates where XP/reward quests are active.",
    parameters: [
      { name: "radius", type: "number", description: "Scanning radius in meters", required: false, defaultValue: 500 }
    ],
    requiredPermissions: ["quest_profile", "city_selection"],
    status: "active",
    executionCount: 45,
    auditLogs: []
  },
  {
    id: "poke_verify_gps",
    productId: "les-poke",
    name: "Submit GPS Quest Proof",
    description: "Simulates GPS coordinate lock to instantly claim active quest completion rewards.",
    parameters: [
      { name: "questId", type: "select", options: ["q-1", "q-2", "q-3", "q-4"], description: "The target quest ID to complete", required: true, defaultValue: "q-1" }
    ],
    requiredPermissions: ["quest_profile"],
    status: "needs_approval",
    executionCount: 9,
    auditLogs: []
  },
  {
    id: "match_search_tags",
    productId: "les-match",
    name: "Search Matching Tags",
    description: "Scans proximity profiles for matched collaboration or study tags.",
    parameters: [
      { name: "tag", type: "string", description: "Search keyword (e.g. Rust, Chill, SaaS)", required: true, defaultValue: "Rust" }
    ],
    requiredPermissions: ["match_preview"],
    status: "active",
    executionCount: 18,
    auditLogs: []
  },
  {
    id: "match_submit_consent",
    productId: "les-match",
    name: "Swipe Profile Consent",
    description: "Submits like/pass swipe consent on matching student profile pseudonym.",
    parameters: [
      { name: "profileId", type: "select", options: ["m-1", "m-2", "m-3"], description: "Pseudonym profile ID", required: true, defaultValue: "m-1" },
      { name: "consent", type: "boolean", description: "True for Interest (Like), False for Pass", required: true, defaultValue: true }
    ],
    requiredPermissions: ["match_preview"],
    status: "needs_approval",
    executionCount: 5,
    auditLogs: []
  },
  {
    id: "otel_list_inventory",
    productId: "les-itemotel",
    name: "List Custody Inventory",
    description: "Queries the physical item custody records under Item Otel.",
    parameters: [],
    requiredPermissions: ["storage_records"],
    status: "active",
    executionCount: 30,
    auditLogs: []
  },
  {
    id: "otel_order_maintenance",
    productId: "les-itemotel",
    name: "Request Item Maintenance",
    description: "Submits care order (waxing, cleaning, repair, balancing) for stored item.",
    parameters: [
      { name: "itemId", type: "select", options: ["1", "2", "3", "4"], description: "Item reference ID", required: true, defaultValue: "1" },
      { name: "careType", type: "select", options: ["waxing", "cleaning", "repair", "tire_rotation"], description: "Type of care needed", required: true, defaultValue: "waxing" },
      { name: "notes", type: "string", description: "Maintenance instructions", required: false, defaultValue: "AI Auto Maintenance Request" }
    ],
    requiredPermissions: ["maintenance_orders"],
    status: "active",
    executionCount: 4,
    auditLogs: []
  },
  {
    id: "otel_publish_listing",
    productId: "les-itemotel",
    name: "Publish Commerce Listing",
    description: "Publishes stored item to public rent/sale marketplace board.",
    parameters: [
      { name: "itemId", type: "select", options: ["1", "2", "3", "4"], description: "Item reference ID", required: true, defaultValue: "1" },
      { name: "listingType", type: "select", options: ["rent", "sale", "both"], description: "Listing model", required: true, defaultValue: "rent" },
      { name: "price", type: "number", description: "Target price in ecosystem credits", required: true, defaultValue: 10 }
    ],
    requiredPermissions: ["rental_offers", "resale_listings"],
    status: "needs_approval",
    executionCount: 3,
    auditLogs: []
  },
  {
    id: "crm_search_timeline",
    productId: "les-contacts",
    name: "Search Private CRM Logs",
    description: "Queries personal relationship memories with tags and context filter.",
    parameters: [
      { name: "context", type: "select", options: ["all", "work", "personal", "social", "travel"], description: "CRM Category filter", required: false, defaultValue: "all" }
    ],
    requiredPermissions: ["secure_contact_preview"],
    status: "disabled",
    executionCount: 0,
    auditLogs: []
  },
  {
    id: "crm_record_interaction",
    productId: "les-contacts",
    name: "Log Private Interaction",
    description: "Logs personal memory note linked to check-in place coordinates.",
    parameters: [
      { name: "placeName", type: "string", description: "Venue name", required: true, defaultValue: "Campus Library" },
      { name: "notes", type: "string", description: "Note details", required: true, defaultValue: "Studied Rust with peer node" },
      { name: "context", type: "select", options: ["work", "personal", "social", "travel"], description: "Context label", required: true, defaultValue: "social" }
    ],
    requiredPermissions: ["secure_contact_preview"],
    status: "active",
    executionCount: 14,
    auditLogs: []
  },
  {
    id: "care_fetch_clinic_slots",
    productId: "les-care",
    name: "Fetch Open Clinic Slots",
    description: "Queries open appointments and check-in logs at student clinic.",
    parameters: [],
    requiredPermissions: ["living_cv_profile"],
    status: "active",
    executionCount: 8,
    auditLogs: []
  },
  {
    id: "care_generate_emergency_qr",
    productId: "les-care",
    name: "Request Emergency Response QR",
    description: "Constructs cryptographic responder QR token in case of campus emergency.",
    parameters: [
      { name: "reason", type: "string", description: "Reason for emergency request", required: true, defaultValue: "First-aid assistance" }
    ],
    requiredPermissions: ["living_cv_profile"],
    status: "needs_approval",
    executionCount: 1,
    auditLogs: []
  },
  {
    id: "harmonica_scan_nodes",
    productId: "les-harmonica",
    name: "Scan Proximity Nodes",
    description: "Scans bluetooth/P2P range for pairwise device nodes.",
    parameters: [],
    requiredPermissions: ["trusted_proximity"],
    status: "active",
    executionCount: 50,
    auditLogs: []
  },
  {
    id: "harmonica_pair_handshake",
    productId: "les-harmonica",
    name: "Perform Secure Pairing",
    description: "Establishes cryptographic key exchange with proximity device.",
    parameters: [
      { name: "deviceId", type: "select", options: ["dev-1", "dev-2", "dev-3"], description: "Node ID to pair", required: true, defaultValue: "dev-1" }
    ],
    requiredPermissions: ["encrypted_contact_handoff"],
    status: "active",
    executionCount: 11,
    auditLogs: []
  },
  {
    id: "oyun_analyze_deck",
    productId: "les-affiliate",
    name: "Get Deck Optimization",
    description: "Analyzes items and badges to suggest ideal card combos for affiliate rewards.",
    parameters: [],
    requiredPermissions: ["card_drop_preview"],
    status: "active",
    executionCount: 33,
    auditLogs: []
  },
  {
    id: "oyun_trigger_auto_duel",
    productId: "les-affiliate",
    name: "Run Automated Card Duel",
    description: "Simulates full game round against AI deck to harvest loyalty rewards.",
    parameters: [],
    requiredPermissions: ["quest_deck_preview"],
    status: "needs_approval",
    executionCount: 6,
    auditLogs: []
  },
  {
    id: "ai_compile_cv_segment",
    productId: "les-ai",
    name: "Compile Living CV Segment",
    description: "Summarizes check-in history, quest metrics, and certifications into structured draft.",
    parameters: [
      { name: "agentId", type: "select", options: ["a-1", "a-2"], description: "KADRO Agent ID", required: true, defaultValue: "a-1" }
    ],
    requiredPermissions: ["agent_tasks", "evidence_summary"],
    status: "active",
    executionCount: 15,
    auditLogs: []
  },
  {
    id: "cert_generate_zkp_proof",
    productId: "les-certification",
    name: "Generate ZKP Credential Token",
    description: "Generates selective disclosure QR code hiding age details but confirming eligibility.",
    parameters: [
      { name: "discloseStudent", type: "boolean", description: "Disclose active student status", required: true, defaultValue: true },
      { name: "discloseAgeGate", type: "boolean", description: "Disclose 18+ status (hides birth year)", required: true, defaultValue: false }
    ],
    requiredPermissions: ["selective_disclosure", "trust_credential_preview"],
    status: "active",
    executionCount: 28,
    auditLogs: []
  }
];

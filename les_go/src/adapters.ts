import { appConfig } from "./config";
import type { CommerceFacetSignal, FlowTempo, InteractionChannel, OpportunityCard, PlaceCheckIn } from "./types";

export interface OpportunityAdapter {
  getOpportunities(checkIn: PlaceCheckIn, activeChannels: InteractionChannel[]): OpportunityCard[];
}

const baseActions: OpportunityCard["actions"] = [
  { id: "open", label: "Open", kind: "primary" },
  { id: "dismiss", label: "Dismiss", kind: "secondary" },
  { id: "report", label: "Report", kind: "warning" }
];

const activateActions: OpportunityCard["actions"] = [
  { id: "activate", label: "Activate", kind: "primary" },
  { id: "dismiss", label: "Dismiss", kind: "secondary" },
  { id: "report", label: "Report", kind: "warning" }
];

type CardInput = Omit<OpportunityCard, "actions" | "tempo" | "timeLabel"> & {
  tempo?: FlowTempo;
  timeLabel?: string;
  actions?: OpportunityCard["actions"];
};

function card(input: CardInput): OpportunityCard {
  return {
    tempo: input.tempo ?? "today",
    timeLabel: input.timeLabel ?? "Today",
    ...input,
    actions: input.actions ?? baseActions
  };
}

function activationCard(input: CardInput): OpportunityCard {
  return {
    tempo: input.tempo ?? "ongoing",
    timeLabel: input.timeLabel ?? "Open",
    ...input,
    actions: input.actions ?? activateActions
  };
}

function facet(
  key: CommerceFacetSignal["key"],
  value: string,
  label = value,
  source: CommerceFacetSignal["source"] = "adapter",
  confidence: CommerceFacetSignal["confidence"] = "explicit"
): CommerceFacetSignal {
  return { key, value, label, source, confidence };
}

function placeFacet(checkIn: PlaceCheckIn): CommerceFacetSignal {
  return facet("place", checkIn.placeType, checkIn.placeName, "place", "explicit");
}

export const lesPlaceActionAdapter = {
  getPlaceActions(checkIn: PlaceCheckIn): OpportunityCard[] {
    const cards: OpportunityCard[] = [];

    if (hasMenu(checkIn)) {
      cards.push(
        card({
          id: `menu-${checkIn.placeId}`,
          type: "menu",
          tempo: "short",
          timeLabel: checkIn.mode === "eat" ? "Now" : "Menu",
          sourceApp: "lescommerce",
          title: menuTitle(checkIn),
          reason: menuReason(checkIn),
          requiredActivation: null,
          safetyLabels: ["menu preview", "prices may change", "paid placement labeled"],
          actions: [
            { id: "open", label: "View menu", kind: "primary" },
            { id: "dismiss", label: "Dismiss", kind: "secondary" },
            { id: "report", label: "Report", kind: "warning" }
          ]
        })
      );
    }

    if (hasTicketLink(checkIn)) {
      cards.push(
        card({
          id: `ticket-${checkIn.placeId}`,
          type: "ticket",
          tempo: "today",
          timeLabel: "Ticket",
          sourceApp: "third_party_ticket_link",
          title: ticketTitle(checkIn),
          reason: "Go sadece rezervasyon/bilet linkini acik etiketler. Koltuk, odeme, iptal ve iade kosullari ucuncu parti bilet uygulamasinda tamamlanir.",
          requiredActivation: null,
          safetyLabels: ["external checkout", "terms on ticket app", "no payment in Go"],
          actions: [
            { id: "open", label: "Reserve ticket", kind: "primary" },
            { id: "dismiss", label: "Dismiss", kind: "secondary" },
            { id: "report", label: "Report", kind: "warning" }
          ]
        })
      );
    }

    cards.push(
      card({
        id: `route-${checkIn.placeId}`,
        type: "route",
        tempo: "short",
        timeLabel: "Route",
        sourceApp: "maps_or_mobility_link",
        title: routeTitle(checkIn),
        reason: routeReason(checkIn),
        requiredActivation: null,
        safetyLabels: routeSafetyLabels(checkIn),
        actions: [
          { id: "open", label: "Open route", kind: "primary" },
          { id: "dismiss", label: "Dismiss", kind: "secondary" },
          { id: "report", label: "Report", kind: "warning" }
        ]
      })
    );

    if (checkIn.placeType !== "adult_venue") {
      cards.push(
        card({
          id: `next-stop-${checkIn.placeId}`,
          type: "next_stop",
          tempo: "short",
          timeLabel: "After",
          sourceApp: "les_go",
          title: nextStopTitle(checkIn),
          reason: nextStopReason(checkIn),
          requiredActivation: null,
          safetyLabels: ["aggregate trend", "people not exposed", "no private trail"],
          actions: [
            { id: "open", label: "See next stops", kind: "primary" },
            { id: "dismiss", label: "Dismiss", kind: "secondary" },
            { id: "report", label: "Report", kind: "warning" }
          ]
        })
      );
    }

    return cards;
  }
};

function hasMenu(checkIn: PlaceCheckIn): boolean {
  return ["canteen", "cafe", "club", "concert", "event", "beach", "village", "workplace", "gym", "football_club"].includes(checkIn.placeType);
}

function hasTicketLink(checkIn: PlaceCheckIn): boolean {
  return ["concert", "event", "club"].includes(checkIn.placeType);
}

function menuTitle(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "canteen") return "Kantin menusunu gor";
  if (checkIn.placeType === "cafe") return "Cafe menusunu gor";
  if (checkIn.placeType === "beach") return "Beach yiyecek/icecek menusu";
  if (checkIn.placeType === "village") return "Yerel yemek ve uretici listesi";
  if (checkIn.placeType === "gym") return "Gym cafe ve supplement menusu";
  if (checkIn.placeType === "football_club") return "Saha kantini ve takim teklifleri";
  if (checkIn.placeType === "workplace") return "Is cikisi yemek secenekleri";
  return "Mekan menusunu gor";
}

function menuReason(checkIn: PlaceCheckIn): string {
  if (checkIn.mode === "eat") {
    return "Yemek modu acik; menu, fiyat, yogunluk ve on siparis ihtimali ilk siraya gelir.";
  }

  return `${checkIn.placeName} icin menu, fiyat, uygunluk ve varsa on siparis/servis bilgisi tek kartta gorunur.`;
}

function ticketTitle(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "concert") return "Konser bileti rezerve et";
  if (checkIn.placeType === "club") return "Etkinlik veya masa linkini ac";
  return "Bilet / rezervasyon linkini ac";
}

function routeTitle(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "concert" || checkIn.placeType === "event" || checkIn.placeType === "club") {
    return "Oraya nasil giderim, nasil donerim?";
  }

  if (checkIn.placeType === "beach" || checkIn.placeType === "village") {
    return "Rota ve donus planini ac";
  }

  return "Yol tarifi ve donus secenekleri";
}

function routeReason(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "concert" || checkIn.placeType === "event" || checkIn.placeType === "club") {
    return "Gidis, donus, gec saat toplu tasima, taksi/rideshare ve arkadasla donus planini dis harita veya mobility uygulamasinda ac.";
  }

  if (checkIn.placeType === "adult_venue") {
    return "Bu mekan tipinde Go yalnizca guvenli gidis-donus ve legal/safety sinyali verir; matchmaking veya booking acmaz.";
  }

  return `${checkIn.placeName} icin yurume, toplu tasima, arac, bisiklet ve donus secenekleri route karti olarak acilir.`;
}

function routeSafetyLabels(checkIn: PlaceCheckIn): string[] {
  if (checkIn.placeType === "adult_venue") {
    return ["safety route only", "no matching", "no booking"];
  }

  if (checkIn.placeType === "concert" || checkIn.placeType === "event" || checkIn.placeType === "club") {
    return ["external maps", "return plan", "late-night safety"];
  }

  return ["external maps", "no private trail", "route preview"];
}

function nextStopTitle(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "canteen") return "Buradan sonra nereye akiyorlar?";
  if (checkIn.placeType === "library") return "Calisma sonrasi populer duraklar";
  if (checkIn.placeType === "concert" || checkIn.placeType === "event" || checkIn.placeType === "club") return "Etkinlik sonrasi guvenli akislari gor";
  if (checkIn.placeType === "gym" || checkIn.placeType === "football_club") return "Antrenman sonrasi duraklar";
  if (checkIn.placeType === "beach") return "Beach sonrasi planlar";
  if (checkIn.placeType === "workplace") return "Is cikisi akisi";
  return "Bu mekandan sonra nereye gidiliyor?";
}

function nextStopReason(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "canteen") {
    return "Ogrencilerin anonim/agregat akisi cafe, kutuphane, derslik veya kulup tarafina kayiyorsa bunu next-stop sinyali olarak gorursun.";
  }

  if (checkIn.placeType === "library") {
    return "Focus bloktan sonra kahve, yemek, grup calismasi veya eve donus rotalari one cikar; kisi profilleri acilmaz.";
  }

  if (checkIn.placeType === "concert" || checkIn.placeType === "event" || checkIn.placeType === "club") {
    return "Etkinlik sonrasi yemek, after-event, taksi, toplu tasima ve guvenli donus secenekleri anonim trend olarak gosterilir.";
  }

  if (checkIn.placeType === "gym" || checkIn.placeType === "football_club") {
    return "Spor sonrasi dus, smoothie, yemek, recovery, ekipman iadesi veya eve donus rotalari one cikar.";
  }

  if (checkIn.placeType === "beach") {
    return "Sahil sonrasi yemek, gun batimi noktasi, donus servisi, dus veya esya teslim akisi one cikar.";
  }

  if (checkIn.placeType === "workplace") {
    return "Is cikisi yemek, cafe, spor, eve donus veya servis/pickup rotalari dikkat dagitmadan gosterilir.";
  }

  return "Go kisi takibi yapmadan, sadece yeterli anonim sinyal varsa sonraki durak onerilerini gosterir.";
}

export const lesWaitAdapter = {
  getQueueActions(checkIn: PlaceCheckIn): OpportunityCard[] {
    if (checkIn.placeType === "canteen") {
      return [
        card({
          id: `wait-busy-${checkIn.placeId}`,
          type: "wait_action",
          tempo: "live",
          timeLabel: "12 min",
          sourceApp: "les_wait",
          title: "Sira yogun, 12 dk sonra gel",
          reason: `${checkIn.placeName} lunch rush icinde. Les Wait seni simdi bekletmek yerine daha sakin pencereye yonlendirir.`,
          requiredActivation: "les-wait",
          safetyLabels: ["queue estimate", "no hidden location trail"]
        }),
        card({
          id: `wait-preorder-${checkIn.placeId}`,
          type: "wait_action",
          tempo: "short",
          timeLabel: "Now",
          sourceApp: "les_wait",
          title: "On siparis ver",
          reason: "Kantin hazirlik penceresi acik; siparisini feed uzerinden baslatip bekleme suresini azaltabilirsin.",
          requiredActivation: "les-wait",
          safetyLabels: ["student canteen", "staff confirmation"]
        }),
        card({
          id: `wait-join-${checkIn.placeId}`,
          type: "wait_action",
          tempo: "live",
          timeLabel: "Live",
          sourceApp: "les_wait",
          title: "Siraya gir",
          reason: "Fiziksel olarak kalabaliga takilmadan siraya katil ve sirani feed'de takip et.",
          requiredActivation: "les-wait",
          safetyLabels: ["explicit action", "queue only"]
        })
      ];
    }

    if (checkIn.placeType === "cafe") {
      return [
        card({
          id: `wait-coffee-${checkIn.placeId}`,
          type: "wait_action",
          tempo: "short",
          timeLabel: "Break",
          sourceApp: "les_wait",
          title: "Kahve molasi icin hizli pencere",
          reason: "Ders arasi yogunlugunda siparis ve teslim penceresini feed'de takip et.",
          requiredActivation: "les-wait",
          safetyLabels: ["short window", "student break"]
        })
      ];
    }

    if (checkIn.placeType === "barber") {
      return [
        card({
          id: `wait-barber-${checkIn.placeId}`,
          type: "wait_action",
          tempo: "live",
          timeLabel: "Slot",
          sourceApp: "les_wait",
          title: "Berber sirasi yaklasiyor",
          reason: "Walk-in dalgasina takilmadan uygun koltuk penceresini bekleyebilirsin.",
          requiredActivation: "les-wait",
          safetyLabels: ["local service", "staff confirmation"]
        })
      ];
    }

    if (checkIn.placeType === "concert" || checkIn.placeType === "club" || checkIn.placeType === "football_club" || checkIn.placeType === "gym" || checkIn.placeType === "beach") {
      return [
        card({
          id: `wait-entry-${checkIn.placeId}`,
          type: "wait_action",
          tempo: "live",
          timeLabel: checkIn.placeType === "gym" ? "Locker" : "Entry",
          sourceApp: "les_wait",
          title: waitContextTitle(checkIn),
          reason: waitContextReason(checkIn),
          requiredActivation: "les-wait",
          safetyLabels: ["queue only", "venue controlled"]
        })
      ];
    }

    if (checkIn.placeType === "library") {
      return [
        card({
          id: `wait-study-room-${checkIn.placeId}`,
          type: "wait_action",
          tempo: "short",
          timeLabel: "Soon",
          sourceApp: "les_wait",
          title: "Sessiz calisma odasi bosaliyor",
          reason: `${checkIn.placeName} icinde bir masa/oda penceresi yaklasiyor; istersen bildirimle acilinca donersin.`,
          requiredActivation: "les-wait",
          safetyLabels: ["study space", "reservation preview"]
        })
      ];
    }

    if (checkIn.placeType === "clinic") {
      return [
        card({
          id: `wait-clinic-${checkIn.placeId}`,
          type: "wait_action",
          tempo: "live",
          timeLabel: "Queue",
          sourceApp: "les_wait",
          title: "Klinik sirani takip et",
          reason: "Klinik desk yogunlugunu zaman penceresiyle gosterir; hassas notlar v1'de yayinlanmaz.",
          requiredActivation: "les-wait",
          safetyLabels: ["private context", "no diagnosis in feed"]
        })
      ];
    }

    if (checkIn.placeType === "student_affairs") {
      return [
        card({
          id: `wait-student-affairs-${checkIn.placeId}`,
          type: "wait_action",
          tempo: "live",
          timeLabel: "Queue",
          sourceApp: "les_wait",
          title: "Ogrenci isleri sirana gir",
          reason: "Belge, onay ve danisma islemleri icin sirani gor; eksik evrak varsa agent kartina gec.",
          requiredActivation: "les-wait",
          safetyLabels: ["service queue", "document-safe"]
        })
      ];
    }

    if (checkIn.placeType === "adult_venue") {
      return [
        card({
          id: `wait-adult-safety-${checkIn.placeId}`,
          type: "wait_action",
          tempo: "stable",
          timeLabel: "18+",
          sourceApp: "les_wait",
          title: "Bekleme akisi guvenlik modunda",
          reason: "Bu mekan tipinde Les Wait yalnizca yasal durum, yas dogrulama ve guvenlik sinyali gosterir; servis/rezervasyon akisi acmaz.",
          requiredActivation: null,
          safetyLabels: ["18+ only", "legal venue only", "no service booking"]
        })
      ];
    }

    return [
      activationCard({
        id: `wait-request-${checkIn.placeId}`,
        type: "wait_action",
        tempo: "ongoing",
        timeLabel: "Request",
        sourceApp: "les_wait",
        title: "Bu mekanda bekleme sistemi aktif degil",
        reason: `${checkIn.placeName} icin Les Wait talep sinyali birak; yeterli ogrenci isterse mekan bekleme sistemine zorlanir.`,
        requiredActivation: "les-wait",
        safetyLabels: ["venue request", "community signal"]
      })
    ];
  }
};

function waitContextTitle(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "gym") return "Locker ve cihaz yogunlugu";
  if (checkIn.placeType === "football_club") return "Saha ve takim sirasi";
  if (checkIn.placeType === "beach") return "Beach servis penceresi";
  return "Giris akisi yogun";
}

function waitContextReason(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "gym") {
    return "Soyunma dolabi, grup dersi veya ekipman yogunlugu canli pencere olarak gorunur.";
  }

  if (checkIn.placeType === "football_club") {
    return "Saha, takim kurma veya ekipman teslim sirasi feed'de akar.";
  }

  if (checkIn.placeType === "beach") {
    return "Sahil hizmetleri, sezlong, dus, servis veya etkinlik penceresi yogunluga gore akar.";
  }

  return `${checkIn.placeName} icin giris, vestiyer veya bilet kontrol yogunlugu canli pencere olarak gorunur.`;
}

export const lesPokeAdapter = {
  getQuestOpportunities(checkIn: PlaceCheckIn): OpportunityCard[] {
    if (checkIn.placeType === "adult_venue") {
      return [];
    }

    const alwaysOn = card({
      id: `quest-discover-${checkIn.placeId}`,
      type: "quest",
      tempo: "ongoing",
      timeLabel: "This week",
      sourceApp: "les_poke",
      title: "3 farkli kampus noktasini kesfet",
      reason: "Okul hayati kucuk kesiflere bolunur; check-in'ler public trail olmadan quest ilerlemesi verebilir.",
      requiredActivation: "les-poke",
      safetyLabels: ["public-space only", "privacy controlled"]
    });

    if (checkIn.placeType === "campus") {
      return [
        card({
          id: `quest-club-${checkIn.placeId}`,
          type: "quest",
          tempo: "today",
          timeLabel: "Today",
          sourceApp: "les_poke",
          title: "Bugun kulup standina ugra",
          reason: `${checkIn.placeName} civarinda kulup/mentor akisi var; ilgi kanalina gore gorev acilir.`,
          requiredActivation: "les-poke",
          safetyLabels: ["student life", "no people exposure"]
        }),
        alwaysOn
      ];
    }

    if (checkIn.placeType === "football_club" || checkIn.placeType === "gym") {
      return [
        card({
          id: `quest-training-${checkIn.placeId}`,
          type: "quest",
          tempo: "short",
          timeLabel: checkIn.mode === "train" ? "Train" : "Today",
          sourceApp: "les_poke",
          title: checkIn.placeType === "football_club" ? "Takim antrenmani quest" : "Workout streak quest",
          reason: "Spor akisi egzersiz, takim, ekipman ve recovery sinyallerini quest'e cevirir.",
          requiredActivation: "les-poke",
          safetyLabels: ["sport mode", "proof optional"]
        }),
        alwaysOn
      ];
    }

    if (checkIn.placeType === "beach") {
      return [
        card({
          id: `quest-beach-${checkIn.placeId}`,
          type: "quest",
          tempo: checkIn.mode === "relax" ? "today" : "short",
          timeLabel: checkIn.mode === "date" ? "Opt-in" : "Beach",
          sourceApp: "les_poke",
          title: checkIn.mode === "date" ? "Beach sosyal planini opt-in tut" : "Beach gununu hafif quest'e cevir",
          reason: "Sahil akisi dinlenme, guvenlik, muzik, spor ve local teklifleri zorlamadan one alir.",
          requiredActivation: "les-poke",
          safetyLabels: ["public place", "consent-first", "no private trail"]
        })
      ];
    }

    if (checkIn.placeType === "village") {
      return [
        card({
          id: `quest-village-${checkIn.placeId}`,
          type: "quest",
          tempo: "ongoing",
          timeLabel: "Route",
          sourceApp: "les_poke",
          title: "Koy rotasi ve yerel hafiza",
          reason: "Uretici, yemek, dogal rota ve yerel hizmet sinyalleri sakin bir kesif akisi olarak akar.",
          requiredActivation: "les-poke",
          safetyLabels: ["local memory", "public place", "creator credit"]
        })
      ];
    }

    if (checkIn.placeType === "library") {
      return [
        card({
          id: `quest-focus-${checkIn.placeId}`,
          type: "quest",
          tempo: "short",
          timeLabel: "45 min",
          sourceApp: "les_poke",
          title: "Kutuphanede 45 dk focus quest",
          reason: "Odak suresi quest'e donusur; istersen sadece local progress olarak kalir.",
          requiredActivation: "les-poke",
          safetyLabels: ["focus mode", "proof optional"]
        }),
        alwaysOn
      ];
    }

    if (checkIn.placeType === "canteen") {
      return [
        card({
          id: `quest-menu-${checkIn.placeId}`,
          type: "quest",
          tempo: "today",
          timeLabel: "Lunch",
          sourceApp: "les_poke",
          title: "Kantin menusunu degerlendir",
          reason: "Ogrenci dostu fiyat, hijyen ve bekleme sinyali Les Certification'a kanit olur.",
          requiredActivation: "les-poke",
          safetyLabels: ["venue feedback", "human review"]
        })
      ];
    }

    if (checkIn.placeType === "cafe") {
      return [
        card({
          id: `quest-coffee-${checkIn.placeId}`,
          type: "quest",
          tempo: "short",
          timeLabel: "Break",
          sourceApp: "les_poke",
          title: "Kahve molasini mini quest'e cevir",
          reason: "Kisa arayi kulup, ders veya etkinlik akisi icin kucuk bir check-in sinyaline donustur.",
          requiredActivation: "les-poke",
          safetyLabels: ["public venue", "optional share"]
        }),
        card({
          id: `quest-creator-drop-${checkIn.placeId}`,
          type: "quest",
          tempo: "today",
          timeLabel: "Drop",
          sourceApp: "les_poke",
          title: "Creator coffee route drop",
          reason: "A local creator can publish a paid or member-only cafe route, Q&A, or city note. Paid access is labeled before unlock.",
          requiredActivation: "les-poke",
          safetyLabels: ["creator drop", "paid access labeled", "public place"]
        })
      ];
    }

    if (checkIn.placeType === "barber") {
      return [
        card({
          id: `quest-barber-${checkIn.placeId}`,
          type: "quest",
          tempo: "today",
          timeLabel: "Local",
          sourceApp: "les_poke",
          title: "Yerel hizmet deneyimini puanla",
          reason: "Bekleme, fiyat netligi ve hizmet kalitesi Les Certification icin kanit sinyali olur.",
          requiredActivation: "les-poke",
          safetyLabels: ["venue feedback", "no private trail"]
        })
      ];
    }

    if (checkIn.placeType === "club") {
      return [
        card({
          id: `quest-club-night-${checkIn.placeId}`,
          type: "quest",
          tempo: "today",
          timeLabel: "Today",
          sourceApp: "les_poke",
          title: "Club masasina veya topluluk standina ugra",
          reason: "Ilgi alanina gore kulup, ekip veya creator challenge akisi acilir.",
          requiredActivation: "les-poke",
          safetyLabels: ["opt-in social", "no people exposure"]
        }),
        card({
          id: `quest-club-creator-drop-${checkIn.placeId}`,
          type: "quest",
          tempo: "today",
          timeLabel: "Member",
          sourceApp: "les_poke",
          title: "Club creator drop",
          reason: "A creator or community can publish an exclusive event trail, recap, fan club post, or member challenge.",
          requiredActivation: "les-poke",
          safetyLabels: ["fan club", "paid access labeled", "18+ if needed"]
        })
      ];
    }

    if (checkIn.placeType === "event" || checkIn.placeType === "concert") {
      return [
        card({
          id: `quest-maker-${checkIn.placeId}`,
          type: "quest",
          tempo: "today",
          timeLabel: "Tonight",
          sourceApp: "les_poke",
          title: checkIn.placeType === "concert" ? "Konser ani icin check-in yap" : "Maker Night'a check-in yap",
          reason: "Etkinlik katilimi proje, sponsor, kulup ve kolektif hikaye firsatlarini feed'e tasir.",
          requiredActivation: "les-poke",
          safetyLabels: ["event check-in", "share controlled"]
        }),
        card({
          id: `quest-event-creator-drop-${checkIn.placeId}`,
          type: "quest",
          tempo: "today",
          timeLabel: "Drop",
          sourceApp: "les_poke",
          title: checkIn.placeType === "concert" ? "Konser creator/fan drop" : "Event creator/fan drop",
          reason: "Creators can unlock member-only recaps, backstage-style stories, city trails, or fan challenges without exposing private people by default.",
          requiredActivation: "les-poke",
          safetyLabels: ["creator membership", "paid access labeled", "consent-first"]
        }),
        alwaysOn
      ];
    }

    return [alwaysOn];
  }
};

export const lesMatchAdapter = {
  previewOpportunities(
    checkIn: PlaceCheckIn,
    activeChannels: InteractionChannel[]
  ): OpportunityCard[] {
    if (checkIn.placeType === "high_school") {
      return [
        card({
          id: `match-minor-safe-${checkIn.placeId}`,
          type: "match",
          tempo: "stable",
          timeLabel: "Safe mode",
          sourceApp: "les_match",
          title: "Lise modu: kisi eslesmesi kapali",
          reason: "Bu alanda sadece okul onayli kulup, grup calismasi ve rehberlik firsatlari onerilir.",
          requiredActivation: null,
          safetyLabels: ["minor-safe mode", "no person matching", "school context"]
        })
      ];
    }

    if (checkIn.placeType === "adult_venue") {
      return [
        card({
          id: `match-adult-disabled-${checkIn.placeId}`,
          type: "match",
          tempo: "stable",
          timeLabel: "Disabled",
          sourceApp: "les_match",
          title: "18+ mekan modu: matchmaking kapali",
          reason: "Bu mekan tipinde Les Match profil, dating, travel companion veya sponsor prompt'u acmaz; yalnizca yasal durum, yas dogrulama ve consent sinyali kalir.",
          requiredActivation: null,
          safetyLabels: ["18+ only", "no dating here", "no profile exposure"]
        })
      ];
    }

    const matchmakingActive = activeChannels.some(
      (channel) => channel.channelId === "matchmaking" && channel.status === "activated"
    );

    if (!matchmakingActive) {
      return [
        activationCard({
          id: `match-activate-${checkIn.placeId}`,
          type: "match",
          tempo: "ongoing",
          timeLabel: "Opt-in",
          sourceApp: "les_match",
          title: matchPromptTitle(checkIn),
          reason: inactiveMatchReason(checkIn),
          requiredActivation: "les-match",
          safetyLabels: ["explicit opt-in required", "people hidden for now"]
        })
      ];
    }

    return [
      card({
        id: `match-${checkIn.placeId}`,
        type: "match",
        tempo: "ongoing",
        timeLabel: "Opt-in",
        sourceApp: "les_match",
        title: activeMatchTitle(checkIn),
        reason: activeMatchReason(checkIn),
        requiredActivation: "les-match",
        safetyLabels: ["matchmaking opt-in", "explainable preview", "block anytime"]
      })
    ];
  }
};

function matchPromptTitle(checkIn: PlaceCheckIn): string {
  if (checkIn.mode === "date") {
    return "Opt-in sosyal/dating modu";
  }

  if (checkIn.placeType === "beach") {
    return "Beach sosyal firsatlari";
  }

  if (checkIn.placeType === "event" || checkIn.placeType === "concert") {
    return "Etkinlikte dating veya creator fan club";
  }

  if (checkIn.placeType === "club") {
    return "Yetiskin opt-in flort veya creator membership";
  }

  if (checkIn.placeType === "library" || checkIn.placeType === "course_center") {
    return "Ayni dersi calisan grup var";
  }

  if (checkIn.placeType === "campus" || checkIn.placeType === "workplace") {
    return "Mentor/sponsor eslesmesi";
  }

  return "Proje arkadasi firsati";
}

function inactiveMatchReason(checkIn: PlaceCheckIn): string {
  if (checkIn.mode === "date") {
    return "Date modu secili ama Les Match kapali. Kisi profilleri, flort ve sosyal planlar explicit opt-in olmadan acilmaz.";
  }

  if (checkIn.placeType === "club" || checkIn.placeType === "concert") {
    return "Les Match kapali. Yetiskin dating, travel companion ve birlikte deneyim firsatlari explicit opt-in olmadan feed'de acilmaz; beklenti ve riza netligi zorunludur.";
  }

  return "Les Match kapali. Kisi, sponsor ve mentor onerileri explicit opt-in olmadan feed'de acilmaz.";
}

function activeMatchTitle(checkIn: PlaceCheckIn): string {
  if (checkIn.mode === "date") {
    return "Opt-in sosyal plan adaylari";
  }

  if (checkIn.placeType === "event" || checkIn.placeType === "concert") {
    return "Opt-in etkinlik ve creator/fan firsatlari";
  }

  if (checkIn.placeType === "club") {
    return "Opt-in dating ve creator membership";
  }

  if (checkIn.placeType === "library" || checkIn.placeType === "course_center") {
    return "Ayni dersi calisan opt-in grup";
  }

  if (checkIn.placeType === "campus" || checkIn.placeType === "workplace") {
    return "Mentor ve sponsor adaylari";
  }

  return "Proje arkadasi adaylari";
}

function activeMatchReason(checkIn: PlaceCheckIn): string {
  if (checkIn.mode === "date") {
    return "Matchmaking kanali aktifse bile feed sadece consent-first sosyal plan preview eder; profil acma, mesaj ve gorunurluk kullanici kontrolundedir.";
  }

  if (checkIn.placeType === "club" || checkIn.placeType === "concert") {
    return "Matchmaking kanali aktif; Les Match sadece 18+, consent-first dating, deneyim arkadasligi veya etiketli creator/fan membership firsatlarini preview eder. Odeme karsiligi cinsel hizmet dili yasaktir.";
  }

  return "Matchmaking kanali aktif; Les Match yalnizca acik izinli ve aciklanabilir firsatlari preview eder.";
}

export const lesHarmonicaAdapter = {
  getSafeContactOpportunities(
    checkIn: PlaceCheckIn,
    activeChannels: InteractionChannel[]
  ): OpportunityCard[] {
    if (checkIn.placeType === "adult_venue") {
      return [];
    }

    if (checkIn.placeType === "high_school") {
      return [
        activationCard({
          id: `harmonica-minor-safe-${checkIn.placeId}`,
          type: "secure_contact",
          tempo: "stable",
          timeLabel: "Safe",
          sourceApp: "les_harmonica",
          title: "Guardian/school approved contact only",
          reason: "Lise modunda Harmonica sadece veli, okul, rehberlik, kulup veya onayli grup baglantilarini acar. Yabanci kisi kesfi ve dating handoff yoktur.",
          requiredActivation: "les-harmonica",
          safetyLabels: ["minor-safe", "guardian/school approved", "no stranger discovery"]
        })
      ];
    }

    const safeContactActive = activeChannels.some(
      (channel) => channel.channelId === "safe_contact" && channel.status === "activated"
    );

    const cardFactory = safeContactActive ? card : activationCard;

    return [
      cardFactory({
        id: `harmonica-safe-contact-${checkIn.placeId}`,
        type: "secure_contact",
        tempo: safeContactActive ? "today" : "ongoing",
        timeLabel: safeContactActive ? "Secure" : "Activate",
        sourceApp: "les_harmonica",
        title: harmonicaTitle(checkIn, safeContactActive),
        reason: harmonicaReason(checkIn, safeContactActive),
        requiredActivation: "les-harmonica",
        safetyLabels: harmonicaSafetyLabels(checkIn, safeContactActive),
        actions: safeContactActive
          ? [
              { id: "open", label: "Open safe contact", kind: "primary" },
              { id: "dismiss", label: "Dismiss", kind: "secondary" },
              { id: "report", label: "Report", kind: "warning" }
            ]
          : undefined
      })
    ];
  }
};

function harmonicaTitle(checkIn: PlaceCheckIn, active: boolean): string {
  if (!active) return "Anonim guvenli iletisim ac";
  if (checkIn.placeType === "student_affairs") return "Yetkili/ogrenci isleri guvenli temas";
  if (checkIn.placeType === "event" || checkIn.placeType === "concert" || checkIn.placeType === "club") return "Etkinlikte guvenli handoff";
  if (checkIn.placeType === "workplace") return "Is/staj icin kimliksiz guvenli temas";
  if (checkIn.placeType === "canteen" || checkIn.placeType === "cafe") return "Mekanda guvenli kisa iletisim";
  return "Kimliksiz guvenli baglanti";
}

function harmonicaReason(checkIn: PlaceCheckIn, active: boolean): string {
  if (!active) {
    return "Les Harmonica kapali. Acarsan uygulamalar ve mekanlar arasinda gercek kimligini gostermeden pairwise pseudonym ile guvenli iletisim/handoff baslatabilirsin.";
  }

  if (checkIn.placeType === "event" || checkIn.placeType === "concert" || checkIn.placeType === "club") {
    return "Etkinlik baglaminda staff, grup, bilet/yardim veya Les Match opt-in sonrasi sosyal handoff icin guvenli kanal acar. Kisi profili otomatik acilmaz.";
  }

  if (checkIn.placeType === "workplace") {
    return "Is, staj, mentor veya servis gorusmesi icin karsi tarafa sadece scoped trust ve pairwise ref gosterilir; gercek kimlik sen onaylamadan acilmaz.";
  }

  return `${checkIn.placeName} icinde guvenli temas, venue staff, peer service, Item Otel teslimat veya onayli grup iletisimi kimlik gizli baslatilabilir.`;
}

function harmonicaSafetyLabels(checkIn: PlaceCheckIn, active: boolean): string[] {
  const labels = ["pairwise pseudonym", "encrypted contact", "block/report"];
  if (!active) return ["activation required", ...labels];
  if (checkIn.placeType === "event" || checkIn.placeType === "concert" || checkIn.placeType === "club") {
    return [...labels, "Match required for people discovery"];
  }
  return [...labels, "no public people browsing"];
}

export const lesAffiliateOyunAdapter = {
  getGameOpportunities(checkIn: PlaceCheckIn): OpportunityCard[] {
    if (checkIn.placeType === "adult_venue" || !affiliateGameContext(checkIn)) {
      return [];
    }

    return [
      activationCard({
        id: `affiliate-game-${checkIn.placeId}`,
        type: "affiliate_game",
        tempo: affiliateGameTempo(checkIn),
        timeLabel: affiliateGameTimeLabel(checkIn),
        sourceApp: "les-affiliate",
        title: affiliateGameTitle(checkIn),
        reason: affiliateGameReason(checkIn),
        requiredActivation: "les-affiliate",
        safetyLabels: [
          "affiliate labeled",
          "checkout in Les Commerce",
          "quests via Les Poke",
          "Match opt-in for players",
          "no forced purchase"
        ]
      })
    ];
  }
};

function affiliateGameContext(checkIn: PlaceCheckIn): boolean {
  return [
    "campus",
    "canteen",
    "cafe",
    "library",
    "event",
    "concert",
    "club",
    "shop",
    "gym",
    "football_club",
    "beach",
    "village",
    "workplace"
  ].includes(checkIn.placeType);
}

function affiliateGameTempo(checkIn: PlaceCheckIn): FlowTempo {
  if (checkIn.placeType === "event" || checkIn.placeType === "concert" || checkIn.placeType === "club") return "today";
  if (checkIn.mode === "shop" || checkIn.mode === "social") return "short";
  return "ongoing";
}

function affiliateGameTimeLabel(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "event" || checkIn.placeType === "concert") return "Drop";
  if (checkIn.mode === "shop") return "Cards";
  return "Game";
}

function affiliateGameTitle(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "event" || checkIn.placeType === "concert") return "Etkinlik creator/card drop";
  if (checkIn.placeType === "canteen" || checkIn.placeType === "cafe") return "Mekan karti ve quest deck";
  if (checkIn.placeType === "gym" || checkIn.placeType === "football_club") return "Ekipman kartlariyla deck kur";
  if (checkIn.placeType === "workplace") return "Brand/campaign deck challenge";
  return "Affiliate oyun karti firsati";
}

function affiliateGameReason(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "event" || checkIn.placeType === "concert") {
    return "Les Poke etkinlik drop'unu quest karta cevirir, Les Commerce creator/urun karti ve affiliate linki tasir, Les Match sadece opt-in rakip/takim/fan eslesmesi acar.";
  }

  if (checkIn.placeType === "gym" || checkIn.placeType === "football_club") {
    return "Ekipman, forma, Item Otel kiralama veya yerel urunler product card olabilir. Satin alma ve komisyon Les Commerce'te kalir; oyun sadece deck/challenge akisini acar.";
  }

  return `${checkIn.placeName} baglamindan product card, quest card veya creator card uretilebilir. Paid placement etiketlenir; duello ve oyuncu eslesmesi Les Match opt-in olmadan acilmaz.`;
}

export const lesCareerAdapter = {
  getCareerOpportunities(checkIn: PlaceCheckIn): OpportunityCard[] {
    if (checkIn.placeType === "adult_venue") {
      return [];
    }

    if (checkIn.placeType === "high_school") {
      return [
        card({
          id: `education-safe-${checkIn.placeId}`,
          type: "education_opportunity",
          tempo: "ongoing",
          timeLabel: "Safe",
          sourceApp: "les-go/career",
          title: "Lise modu: egitim ve kulup firsatlari",
          reason: "CV burada okul onayli kulup, proje, ders calisma ve rehberlik sinyalleriyle buyur. Is/staj ve kisi eslesmesi yerine safe-mode egitim firsatlari gosterilir.",
          requiredActivation: null,
          safetyLabels: ["minor-safe", "school context", "no job matching"],
          actions: [
            { id: "open", label: "Open education path", kind: "primary" },
            { id: "dismiss", label: "Dismiss", kind: "secondary" },
            { id: "report", label: "Report", kind: "warning" }
          ]
        })
      ];
    }

    const cards: OpportunityCard[] = [
      card({
        id: `cv-growth-${checkIn.placeId}`,
        type: "cv_growth",
        tempo: "ongoing",
        timeLabel: "CV",
        sourceApp: "les-go/career",
        title: "CV burada buyusun",
        reason: `${checkIn.placeName} icindeki quest, check-in, servis isi, sertifika, proje ve KADRO taslaklari yasayan CV sinyaline donusebilir. Paylasim ogrenci onayi olmadan acilmaz.`,
        requiredActivation: "les-go",
        safetyLabels: ["user controlled CV", "share with consent", "AI drafts labeled"],
        actions: [
          { id: "open", label: "Open CV", kind: "primary" },
          { id: "dismiss", label: "Dismiss", kind: "secondary" },
          { id: "report", label: "Report", kind: "warning" }
        ]
      })
    ];

    if (careerContext(checkIn)) {
      cards.push(
        card({
          id: `career-apply-${checkIn.placeId}`,
          type: "application",
          tempo: "today",
          timeLabel: "Apply",
          sourceApp: "les-go/career",
          title: applicationTitle(checkIn),
          reason: applicationReason(checkIn),
          requiredActivation: "les-go",
          safetyLabels: ["no auto apply", "student review required", "CV visibility controlled"],
          actions: [
            { id: "open", label: "Prepare application", kind: "primary" },
            { id: "dismiss", label: "Dismiss", kind: "secondary" },
            { id: "report", label: "Report", kind: "warning" }
          ]
        })
      );
    }

    if (educationContext(checkIn)) {
      cards.push(
        card({
          id: `education-opportunity-${checkIn.placeId}`,
          type: "education_opportunity",
          tempo: "ongoing",
          timeLabel: "Learn",
          sourceApp: "les-go/career",
          title: educationTitle(checkIn),
          reason: educationReason(checkIn),
          requiredActivation: null,
          safetyLabels: ["education signal", "paid offers labeled", "certificate optional"],
          actions: [
            { id: "open", label: "See education path", kind: "primary" },
            { id: "dismiss", label: "Dismiss", kind: "secondary" },
            { id: "report", label: "Report", kind: "warning" }
          ]
        })
      );
    }

    return cards;
  }
};

export const lesNairobiStudentLaunchAdapter = {
  getLaunchOpportunities(checkIn: PlaceCheckIn): OpportunityCard[] {
    if (!isNairobiStudentLaunch(checkIn)) {
      return [];
    }

    return [
      card({
        id: `nairobi-launch-board-${checkIn.placeId}`,
        type: "cv_growth",
        tempo: "ongoing",
        timeLabel: "Launch",
        sourceApp: "les_go+les_ai+les_certification",
        title: "Nairobi student launch board",
        reason: "A University of Nairobi student or new graduate should see dignified routes first: living CV, fieldwork proof, internships, sponsor/mentor prep, campus gigs, creator work and safe travel planning. Adult dating stays separate, opt-in and never becomes a sexual-service marketplace.",
        requiredActivation: "les-go",
        safetyLabels: ["student controlled", "no exploitation", "adult contexts separate", "share with consent"],
        actions: [
          { id: "open", label: "Open launch board", kind: "primary" },
          { id: "dismiss", label: "Dismiss", kind: "secondary" },
          { id: "report", label: "Report", kind: "warning" }
        ]
      }),
      card({
        id: `nairobi-gis-career-${checkIn.placeId}`,
        type: "application",
        tempo: "today",
        timeLabel: "Apply",
        sourceApp: "les-go/career+les_ai/kadro",
        title: "GIS, NGO, research or tourism internship",
        reason: "Geography field notes, campus quests, route observations and creator work can become a reviewed CV draft. KADRO prepares the application; the student reviews before any sponsor, mentor or employer sees it.",
        requiredActivation: "les-go",
        safetyLabels: ["no auto apply", "student review required", "AI draft labeled"],
        commerceFacets: [
          placeFacet(checkIn),
          facet("category", "career", "Career", "tag"),
          facet("service_type", "internship", "Internship", "listing"),
          facet("service_type", "research_assistant", "Research assistant", "reason")
        ],
        actions: [
          { id: "open", label: "Prepare CV", kind: "primary" },
          { id: "dismiss", label: "Dismiss", kind: "secondary" },
          { id: "report", label: "Report", kind: "warning" }
        ]
      }),
      card({
        id: `nairobi-turkiye-readiness-${checkIn.placeId}`,
        type: "education_opportunity",
        tempo: "ongoing",
        timeLabel: "Travel",
        sourceApp: "les_travel+les_ai+les_harmonica",
        title: "Turkiye study visit readiness",
        reason: "For a Turkiye trip, Go should show official visa-source routing, document checklist, stay safety, first-night plan, trusted contact and return plan. It never pretends to be the visa authority.",
        requiredActivation: "les-travel",
        safetyLabels: ["official sources only", "fake visa warning", "safe stay check", "return plan"],
        commerceFacets: [
          placeFacet(checkIn),
          facet("category", "travel", "Travel", "tag"),
          facet("service_type", "visa_checklist", "Visa checklist", "reason"),
          facet("service_type", "safe_stay", "Safe stay", "listing")
        ],
        actions: [
          { id: "open", label: "Open travel plan", kind: "primary" },
          { id: "dismiss", label: "Dismiss", kind: "secondary" },
          { id: "report", label: "Report", kind: "warning" }
        ]
      }),
      card({
        id: `nairobi-safe-income-${checkIn.placeId}`,
        type: "service_gig",
        tempo: "today",
        timeLabel: "Earn",
        sourceApp: "lescommerce-marketplace+les_poke",
        title: "Safe campus income paths",
        reason: "Tutoring, field mapping help, hair/beauty service, peer courier, creator campus tour, DIY product demo, club work or event coverage can earn money with clear scope, price, proof and report controls. Academic cheating and sexual-service framing stay forbidden.",
        requiredActivation: "lescommerce-core",
        safetyLabels: ["clear scope", "no cheating", "no sexual service framing", "reportable"],
        commerceFacets: [
          placeFacet(checkIn),
          facet("category", "student_gig", "Student gig", "tag"),
          facet("service_type", "tutoring", "Tutoring", "listing"),
          facet("service_type", "peer_courier", "Peer courier", "listing"),
          facet("creator", "campus_creator", "Campus creator", "tag")
        ],
        actions: [
          { id: "open", label: "See gigs", kind: "primary" },
          { id: "dismiss", label: "Dismiss", kind: "secondary" },
          { id: "report", label: "Report", kind: "warning" }
        ]
      }),
      activationCard({
        id: `nairobi-sponsor-trust-${checkIn.placeId}`,
        type: "trust_credential",
        tempo: "stable",
        timeLabel: "Trust",
        sourceApp: "les_certification+les_block",
        title: "Show trust without exposing everything",
        reason: "A student can show domain trust for delivery, study consistency, creator work, event volunteering or verified school status without exposing full identity or private history. Hash/proof is optional and revocable.",
        requiredActivation: "les-certification",
        safetyLabels: ["identity hidden", "selective disclosure", "revocable", "wallet optional"],
        actions: [
          { id: "activate", label: "Preview trust", kind: "primary" },
          { id: "dismiss", label: "Dismiss", kind: "secondary" },
          { id: "report", label: "Report", kind: "warning" }
        ]
      })
    ];
  }
};

function isNairobiStudentLaunch(checkIn: PlaceCheckIn): boolean {
  return checkIn.placeId === "uon-geography-campus";
}

function careerContext(checkIn: PlaceCheckIn): boolean {
  return (
    checkIn.mode === "work" ||
    ["campus", "workplace", "event", "club", "library", "course_center", "student_affairs"].includes(checkIn.placeType)
  );
}

function educationContext(checkIn: PlaceCheckIn): boolean {
  return (
    checkIn.mode === "study" ||
    ["campus", "library", "course_center", "event", "student_affairs", "village"].includes(checkIn.placeType)
  );
}

function applicationTitle(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "workplace") return "Part-time is veya staj basvurusu hazirla";
  if (checkIn.placeType === "student_affairs") return "Basvuru evraklarini hazirla";
  if (checkIn.placeType === "event" || checkIn.placeType === "club") return "Etkinlikten proje/staj basvurusuna gec";
  return "Staj, is veya proje basvurusu";
}

function applicationReason(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "workplace") {
    return "Is yeri context'i acik; yasayan CV sinyallerinden part-time is, staj veya proje basvurusu taslagi uretilir. Gondermeden once ogrenci inceler.";
  }

  if (checkIn.placeType === "student_affairs") {
    return "Ogrenci isleri context'i belge, onay, burs, staj ve egitim basvurulari icin checklist ve taslak acabilir.";
  }

  if (checkIn.placeType === "event" || checkIn.placeType === "club") {
    return "Etkinlik katilimi, kulup gorevi ve proje ilgisi CV sinyaline donusur; ilgili staj/proje basvurusu feed'den baslatilir.";
  }

  return "Kampus sinyallerin staj, part-time is, proje ve mentor hazirligina donusur; otomatik basvuru yoktur.";
}

function educationTitle(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "course_center") return "Kurs, egitim veya sertifika firsati";
  if (checkIn.placeType === "library") return "Calisma hedefinden egitim yoluna";
  if (checkIn.placeType === "village") return "Yerel usta/uretim egitimi";
  return "Egitim, burs veya sertifika firsati";
}

function educationReason(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "course_center") {
    return "Kurs merkezi veya sinav lab sinyali, uygun egitim, deneme, kaynak, sertifika ya da burs firsatina baglanir.";
  }

  if (checkIn.placeType === "library") {
    return "Focus quest ve ders hedefleri, egitim yolu, kaynak listesi, mentor notu veya sertifika planina donusebilir.";
  }

  if (checkIn.placeType === "village") {
    return "Yerel uretici, zanaat veya usta bilgisi egitim/mentor firsati olarak acilir; ticari teklifler etiketlenir.";
  }

  return "Okul ve kampus context'i burs, egitim, kurs, sertifika ve mentor firsatlarini feed'e tasir.";
}

export const lesAiAdapter = {
  getAgentHelp(checkIn: PlaceCheckIn): OpportunityCard[] {
    if (checkIn.placeType === "adult_venue") {
      return [
        card({
          id: `agent-boundary-${checkIn.placeId}`,
          type: "agent_help",
          tempo: "stable",
          timeLabel: "Safety",
          sourceApp: "les_ai/kadro",
          title: kadroTitle(checkIn),
          reason: kadroReason(checkIn),
          requiredActivation: "les-ai",
          safetyLabels: ["AI agent labeled", "18+ only", "no booking or matching"]
        })
      ];
    }

    const cards: OpportunityCard[] = [
      card({
        id: `agent-${checkIn.placeId}`,
        type: "agent_help",
        tempo: "today",
        timeLabel: "Assist",
        sourceApp: "les_ai/kadro",
        title: kadroTitle(checkIn),
        reason: kadroReason(checkIn),
        requiredActivation: "les-ai",
        safetyLabels: ["AI agent labeled", "not a human match", "user controlled"]
      }),
      card({
        id: `agentandbot-task-${checkIn.placeId}`,
        type: "agent_help",
        tempo: "ongoing",
        timeLabel: "Task",
        sourceApp: "agentandbot.com",
        title: "AgentAndBot task workspace",
        reason: "Turn this school moment into a tracked agent task: draft, research, summarize, prepare or route to a tool.",
        requiredActivation: "agentandbot-governance-core",
        safetyLabels: ["external platform", "agent task", "explicit launch"]
      })
    ];

    if (["event", "concert", "club", "campus", "course_center", "library"].includes(checkIn.placeType)) {
      cards.push(
        card({
          id: `scenario-${checkIn.placeId}`,
          type: "agent_help",
          tempo: "ongoing",
          timeLabel: "Create",
          sourceApp: "les_ai/ai_senaryo",
          title: scenarioTitle(checkIn),
          reason: "Use collective scenario AI to turn this context into a scene, short film idea, campus story, service simulation or quest script.",
          requiredActivation: "ai-senaryo",
          safetyLabels: ["collective workspace", "AI-generated labeled", "consent for contributors"]
        })
      );
    }

    return cards;
  }
};

function kadroTitle(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "student_affairs") {
    return "KADRO evrak ve basvuru asistani";
  }

  if (checkIn.placeType === "adult_venue") {
    return "KADRO legal/safety boundary helper";
  }

  if (checkIn.placeType === "campus" || checkIn.placeType === "event" || checkIn.placeType === "concert" || checkIn.placeType === "club") {
    if (checkIn.placeType === "club" || checkIn.placeType === "concert") {
      return "KADRO consent/date planning helper";
    }

    return "KADRO mentor/worker agent onerisi";
  }

  if (checkIn.placeType === "course_center" || checkIn.placeType === "library") {
    return "KADRO study worker";
  }

  return "KADRO agent helper";
}

function kadroReason(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "student_affairs") {
    return "A labeled KADRO worker can prepare document checklists and application drafts without touching private records by default.";
  }

  if (checkIn.placeType === "adult_venue") {
    return "A labeled AI helper can explain age gate, consent, privacy and legal boundaries without opening matchmaking or service booking.";
  }

  if (checkIn.placeType === "campus" || checkIn.placeType === "event" || checkIn.placeType === "concert" || checkIn.placeType === "club") {
    if (checkIn.placeType === "club" || checkIn.placeType === "concert") {
      return "A labeled KADRO agent can help adults clarify expectations, travel/date boundaries, budget transparency and consent-safe messaging without arranging sexual services.";
    }

    return "A labeled KADRO agent can help with mentor prep, sponsor notes, event questions and follow-up tasks.";
  }

  if (checkIn.placeType === "course_center" || checkIn.placeType === "library") {
    return "A labeled KADRO study worker can split lessons into a plan, quiz or revision task.";
  }

  return "A labeled KADRO AI worker can turn this check-in into a clear task, plan or support note.";
}

function scenarioTitle(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "event" || checkIn.placeType === "concert") {
    return "Etkinligi kolektif senaryoya cevir";
  }

  if (checkIn.placeType === "club") {
    return "Club/topluluk hikayesini creator board'a tasir";
  }

  if (checkIn.placeType === "course_center" || checkIn.placeType === "library") {
    return "Ders hikayesi ve video fikri uret";
  }

  return "Kampus hikayesi veya servis simulasyonu yaz";
}

export const lesCommerceAdapter = {
  getOffers(checkIn: PlaceCheckIn): OpportunityCard[] {
    if (
      !["cafe", "shop", "event", "concert", "club", "canteen", "course_center", "barber", "gym", "football_club", "beach", "village"].includes(
        checkIn.placeType
      )
    ) {
      return [];
    }

    return [
      card({
        id: `commerce-${checkIn.placeId}`,
        type: "commerce_offer",
        tempo: "short",
        timeLabel: "Offer",
        sourceApp: "lescommerce",
        title: commerceTitle(checkIn),
        reason: commerceReason(checkIn),
        requiredActivation: "lescommerce-core",
        safetyLabels: ["paid placement labeled", "transparent reward"],
        commerceFacets: commerceFacets(checkIn)
      })
    ];
  }
};

function commerceFacets(checkIn: PlaceCheckIn): CommerceFacetSignal[] {
  const base = [placeFacet(checkIn), facet("listing_type", "offer", "Offer", "tag")];

  if (checkIn.placeType === "gym") {
    return [
      ...base,
      facet("category", "gym_gear", "Gym gear", "tag"),
      facet("item_type", "towel", "Towel", "reason", "derived"),
      facet("service_type", "recovery", "Recovery", "reason", "derived")
    ];
  }

  if (checkIn.placeType === "football_club") {
    return [
      ...base,
      facet("category", "football", "Football", "tag"),
      facet("item_type", "boots", "Boots", "reason", "derived"),
      facet("service_type", "field_booking", "Field booking", "reason", "derived")
    ];
  }

  if (checkIn.placeType === "beach") {
    return [
      ...base,
      facet("category", "beach", "Beach", "tag"),
      facet("item_type", "sunscreen", "Sunscreen", "reason", "derived"),
      facet("item_type", "rental", "Rental", "reason", "derived")
    ];
  }

  if (checkIn.placeType === "village") {
    return [
      ...base,
      facet("category", "local_food", "Local food", "reason", "derived"),
      facet("creator", "local_producer", "Local producer", "reason", "derived")
    ];
  }

  if (checkIn.mode === "eat") {
    return [...base, facet("category", "food", "Food", "tag"), facet("service_type", "student_menu", "Student menu", "reason", "derived")];
  }

  return [...base, facet("category", "student_offer", "Student offer", "tag")];
}

function commerceTitle(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "gym") return "Gym gear or care offer";
  if (checkIn.placeType === "football_club") return "Football gear and field offer";
  if (checkIn.placeType === "beach") return "Beach day offer";
  if (checkIn.placeType === "village") return "Local producer offer";
  if (checkIn.mode === "eat") return "Cikista ne yesem?";
  return "Student-friendly local offer";
}

function commerceReason(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "gym") {
    return "Training mode can surface towels, locker services, equipment rental, protein cafe or recovery offers with clear labels.";
  }

  if (checkIn.placeType === "football_club") {
    return "Field booking, jersey, boots, ball rental or team fee offers can appear with transparent price and terms.";
  }

  if (checkIn.placeType === "beach") {
    return "Beach mode can show sunscreen, towel, food, water sport, transport or item rental offers without hiding paid placement.";
  }

  if (checkIn.placeType === "village") {
    return "Village mode can show local food, producer, craft, room, ride or guide offers as certified local commerce.";
  }

  if (checkIn.mode === "eat") {
    return `${checkIn.placeName} cevresinde okul cikisi veya mola icin yemek teklifleri akar.`;
  }

  return `${checkIn.placeName} can show a clear reward or service credit without hidden boosts.`;
}

export const lesLocalListingAdapter = {
  getLocalListings(checkIn: PlaceCheckIn): OpportunityCard[] {
    if (checkIn.placeType === "adult_venue") {
      return [
        card({
          id: `listing-adult-boundary-${checkIn.placeId}`,
          type: "local_listing",
          tempo: "stable",
          timeLabel: "18+",
          sourceApp: "les_match",
          title: "18+ beklenti ve guvenlik siniri",
          reason: "Bu mekan tipinde yerel ilan, cinsel hizmet, booking veya profil pazari acilmaz. Sadece yas, riza, legal durum ve guvenlik sinyali gorunur.",
          requiredActivation: null,
          safetyLabels: ["18+ only", "no sexual services", "no booking"]
        })
      ];
    }

    const listings: OpportunityCard[] = [
      card({
        id: `listing-phone-${checkIn.placeId}`,
        type: "local_listing",
        tempo: "short",
        timeLabel: "Nearby",
        sourceApp: "lescommerce",
        title: "Burada biri iPhone satiyor",
        reason: `${checkIn.placeName} cevresindeki onayli kullanici ilani feed'e dusebilir. Odeme, teslim ve garanti kosullari acik etiketlenir.`,
        requiredActivation: "lescommerce-core",
        safetyLabels: ["peer listing", "paid access labeled", "reportable"],
        commerceFacets: [
          placeFacet(checkIn),
          facet("category", "electronics", "Electronics", "listing"),
          facet("brand", "Apple", "Apple", "title"),
          facet("model", "iPhone", "iPhone", "title"),
          facet("listing_type", "sale", "Sale", "listing")
        ]
      }),
      card({
        id: `listing-car-rental-${checkIn.placeId}`,
        type: "local_listing",
        tempo: "today",
        timeLabel: "Rent",
        sourceApp: "lescommerce",
        title: "Arabasini gunluk kiraya acan var",
        reason: "Arac kiralama, belge/sigorta/teslim kosullari netse yerel firsat olarak gorunur; riskli veya belgesiz ilan sertifikadan gecmez.",
        requiredActivation: "lescommerce-core",
        safetyLabels: ["contract needed", "insurance required", "identity check"],
        commerceFacets: [
          placeFacet(checkIn),
          facet("category", "car", "Car", "listing"),
          facet("listing_type", "rent", "Rent", "listing"),
          facet("rental_period", "daily", "Daily", "reason")
        ]
      })
    ];

    if (checkIn.placeType === "gym" || checkIn.placeType === "football_club" || checkIn.placeType === "beach") {
      listings.push(
        card({
          id: `listing-itemotel-${checkIn.placeId}`,
          type: "local_listing",
          tempo: "today",
          timeLabel: "Store",
          sourceApp: "les-itemotel",
          title: itemotelTitle(checkIn),
          reason: itemotelReason(checkIn),
          requiredActivation: "les-itemotel",
          safetyLabels: ["storage", "care log", "rent or sell opt-in"],
          commerceFacets: itemotelFacets(checkIn)
        })
      );
    }

    if (checkIn.mode === "eat") {
      listings.push(
        card({
          id: `listing-food-${checkIn.placeId}`,
          type: "local_listing",
          tempo: "short",
          timeLabel: "Food",
          sourceApp: "lescommerce",
          title: "Cikista ne yesem?",
          reason: "Yemek modu yakin mekan, ogrenci menusu, sira yogunlugu ve grup planlarini one alir.",
          requiredActivation: "lescommerce-core",
          safetyLabels: ["food offer", "queue aware", "paid placement labeled"],
          commerceFacets: [
            placeFacet(checkIn),
            facet("category", "food", "Food", "tag"),
            facet("service_type", "student_menu", "Student menu", "reason"),
            facet("delivery_method", "pickup", "Pickup", "reason", "derived")
          ]
        })
      );
    }

    if (["campus", "workplace", "cafe", "canteen", "library", "club", "concert", "event"].includes(checkIn.placeType)) {
      listings.push(
        card({
          id: `listing-outfit-${checkIn.placeId}`,
          type: "local_listing",
          tempo: "today",
          timeLabel: "Style",
          sourceApp: "lescommerce",
          title: "Mini etek / outfit ilani",
          reason: "Kiyafet, aksesuar veya event outfit satislari normal urun ilani olarak akar; beden, fiyat, teslim ve iade kosulu acik olmalidir.",
          requiredActivation: "lescommerce-core",
          safetyLabels: ["product listing", "clear price", "no body shaming"],
          commerceFacets: [
            placeFacet(checkIn),
            facet("category", "outfit", "Outfit", "listing"),
            facet("item_type", "skirt", "Skirt", "title"),
            facet("listing_type", "sale", "Sale", "listing")
          ]
        })
      );
    }

    if (["campus", "workplace", "cafe", "club", "concert", "event"].includes(checkIn.placeType)) {
      listings.push(
        activationCard({
          id: `listing-dinner-plan-${checkIn.placeId}`,
          type: "local_listing",
          tempo: "today",
          timeLabel: "Plan",
          sourceApp: "les_match",
          title: "Yemege cikmak isteyenler",
          reason: "Yetiskin veya uygun sosyal baglamda yemek/deneyim plani sadece Les Match opt-in ile acilir. Beklenti, butce, riza ve guvenlik netligi gerekir.",
          requiredActivation: "les-match",
          safetyLabels: ["opt-in required", "expectations clear", "not sexual payment"],
          commerceFacets: [
            placeFacet(checkIn),
            facet("category", "food", "Food", "tag"),
            facet("service_type", "meal_plan", "Meal plan", "reason"),
            facet("listing_type", "social_plan", "Social plan", "listing")
          ]
        })
      );
    }

    if (checkIn.placeType === "high_school") {
      return listings.filter((listing) => listing.id !== `listing-dinner-plan-${checkIn.placeId}`);
    }

    return listings;
  }
};

export const lesServiceGigAdapter = {
  getServiceGigs(checkIn: PlaceCheckIn): OpportunityCard[] {
    if (checkIn.placeType === "adult_venue") {
      return [];
    }

    const gigs: OpportunityCard[] = [];

    if (["campus", "library", "course_center", "high_school"].includes(checkIn.placeType)) {
      gigs.push(
        card({
          id: `gig-study-help-${checkIn.placeId}`,
          type: "service_gig",
          tempo: "today",
          timeLabel: "Study",
          sourceApp: "lescommerce-marketplace",
          title: "Ders anlatirim / odev kontrol ederim",
          reason: "Akademik yardim; baskasinin yerine odev yapmak degil. Ders anlatma, kaynak bulma, taslak kontrolu, formatlama ve calisma plani gibi etik destekler listelenir.",
          requiredActivation: "lescommerce-core",
          safetyLabels: ["academic integrity", "no cheating", "clear scope"],
          commerceFacets: [
            placeFacet(checkIn),
            facet("category", "study_help", "Study help", "tag"),
            facet("service_type", "tutoring", "Tutoring", "listing"),
            facet("service_type", "homework_review", "Homework review", "title")
          ]
        })
      );
    }

    if (["campus", "workplace", "cafe", "club", "concert", "event", "barber"].includes(checkIn.placeType)) {
      gigs.push(
        card({
          id: `gig-hair-${checkIn.placeId}`,
          type: "service_gig",
          tempo: "today",
          timeLabel: "Style",
          sourceApp: "lescommerce-marketplace",
          title: "Sacini yaparim / bakim hizmeti",
          reason: "Yakindaki kisi veya mekan sac, makyaj, tirnak, quick styling veya bakim randevusu acabilir. Fiyat, hijyen ve iptal kosulu acik olmalidir.",
          requiredActivation: "lescommerce-core",
          safetyLabels: ["service listing", "hygiene label", "reportable"],
          commerceFacets: [
            placeFacet(checkIn),
            facet("category", "beauty", "Beauty", "tag"),
            facet("service_type", "hair", "Hair", "title"),
            facet("certification", "hygiene_label", "Hygiene label", "tag")
          ]
        })
      );
    }

    if (["campus", "workplace", "student_affairs", "canteen", "cafe", "village"].includes(checkIn.placeType)) {
      gigs.push(
        card({
          id: `gig-carry-${checkIn.placeId}`,
          type: "service_gig",
          tempo: "short",
          timeLabel: "Carry",
          sourceApp: "les-itemotel",
          title: "Item Otel'e esya gotur/getir",
          reason: "Ayni yurt, kampus veya yakin rotadaki ogrenci ayakkabi, kucuk ekipman, paket ya da sezonluk esyayi Item Otel'e goturup getirebilir ve para kazanir. Teslim kaniti, rota, ucret ve paket siniri acik olur.",
          requiredActivation: "lescommerce-core",
          safetyLabels: ["peer courier", "delivery proof", "no illegal goods", "clear fee"],
          commerceFacets: [
            placeFacet(checkIn),
            facet("category", "peer_courier", "Peer courier", "tag"),
            facet("service_type", "delivery", "Delivery", "listing"),
            facet("delivery_method", "student_courier", "Student courier", "reason")
          ]
        })
      );
    }

    if (checkIn.placeType === "high_school") {
      return gigs.filter((gig) => gig.id === `gig-study-help-${checkIn.placeId}`);
    }

    return gigs;
  }
};

export const lesCreatorPromotionAdapter = {
  getCreatorPromotionOpportunities(checkIn: PlaceCheckIn): OpportunityCard[] {
    if (checkIn.placeType === "adult_venue" || checkIn.placeType === "high_school") {
      return [];
    }

    if (!creatorPromotionContext(checkIn)) {
      return [];
    }

    const cards: OpportunityCard[] = [
      card({
        id: `creator-promo-${checkIn.placeId}`,
        type: "creator_promotion",
        tempo: creatorPromotionTempo(checkIn),
        timeLabel: creatorPromotionTimeLabel(checkIn),
        sourceApp: "les_go+lescommerce",
        title: creatorPromotionTitle(checkIn),
        reason: creatorPromotionReason(checkIn),
        requiredActivation: "lescommerce-core",
        safetyLabels: [
          "sponsored content labeled",
          "merchant terms visible",
          "no hidden tracking",
          "creator controls accept/decline"
        ],
        commerceFacets: creatorPromotionFacets(checkIn),
        actions: [
          { id: "open", label: "Open creator brief", kind: "primary" },
          { id: "dismiss", label: "Dismiss", kind: "secondary" },
          { id: "report", label: "Report", kind: "warning" }
        ]
      })
    ];

    if (["campus", "cafe", "event", "concert", "club", "beach", "village"].includes(checkIn.placeType)) {
      cards.push(
        card({
          id: `creator-live-${checkIn.placeId}`,
          type: "creator_promotion",
          tempo: "live",
          timeLabel: "Live",
          sourceApp: "les_go+les_poke",
          title: creatorLiveTitle(checkIn),
          reason: "Bu akış Go'da yer/mod bağlamından doğar; Poke bunu görev/challenge yapabilir, Les Commerce ücret/affiliate/brief tarafını tutar, Certification sponsorlu içerik etiketini kontrol eder.",
          requiredActivation: "les-poke",
          safetyLabels: ["public-place only", "quest optional", "paid brief labeled", "reportable"],
          commerceFacets: [
            placeFacet(checkIn),
            facet("category", "creator_promotion", "Creator promotion", "tag"),
            facet("service_type", "live_stream", "Live stream", "listing"),
            facet("creator", "local_creator", "Local creator", "tag")
          ],
          actions: [
            { id: "open", label: "Open live task", kind: "primary" },
            { id: "dismiss", label: "Dismiss", kind: "secondary" },
            { id: "report", label: "Report", kind: "warning" }
          ]
        })
      );
    }

    return cards;
  }
};

function creatorPromotionContext(checkIn: PlaceCheckIn): boolean {
  return (
    checkIn.mode === "social" ||
    checkIn.mode === "shop" ||
    checkIn.mode === "travel" ||
    ["campus", "cafe", "canteen", "shop", "event", "concert", "club", "gym", "football_club", "beach", "village", "barber"].includes(
      checkIn.placeType
    )
  );
}

function creatorPromotionTempo(checkIn: PlaceCheckIn): FlowTempo {
  if (["event", "concert", "club", "beach"].includes(checkIn.placeType)) return "live";
  if (["cafe", "canteen", "shop", "barber"].includes(checkIn.placeType)) return "short";
  return "today";
}

function creatorPromotionTimeLabel(checkIn: PlaceCheckIn): string {
  if (["event", "concert", "club"].includes(checkIn.placeType)) return "Now";
  if (checkIn.placeType === "beach" || checkIn.placeType === "village") return "Route";
  return "Creator";
}

function creatorPromotionTitle(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "cafe") return "Cafe icin reels/story isi";
  if (checkIn.placeType === "canteen") return "Kantin menu tanitim videosu";
  if (checkIn.placeType === "shop") return "Magaza urun cekimi brief'i";
  if (checkIn.placeType === "gym") return "Gym walk video / equipment tanitimi";
  if (checkIn.placeType === "football_club") return "Saha, takim ve ekipman icerigi";
  if (checkIn.placeType === "beach") return "Beach walk, foto ve canli yayin isi";
  if (checkIn.placeType === "village") return "Yerel uretici rota videosu";
  if (checkIn.placeType === "concert" || checkIn.placeType === "event" || checkIn.placeType === "club") return "Etkinlik creator coverage";
  if (checkIn.placeType === "barber") return "Before/after icerik isi";
  return "Creator promotion isi";
}

function creatorPromotionReason(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "beach") {
    return "Creator sahilde yurur, foto/video/live icerik uretir ve mekan/urun/rota tanitim brief'inden para kazanir. Ticari teklif, odeme ve affiliate Les Commerce'te kalir.";
  }

  if (checkIn.placeType === "village") {
    return "Yerel uretici, yemek, rota veya el isi icin creator tanitim brief'i acilabilir; creator gezer, ceker, yayinlar ve kaynak/etiket acik kalir.";
  }

  if (["event", "concert", "club"].includes(checkIn.placeType)) {
    return "Etkinlik sahibi veya marka creator cagirabilir: live coverage, story, foto seti veya backstage tanitim. Go firsati gosterir; Les Commerce brief/odeme/komisyonu tutar.";
  }

  if (["cafe", "canteen", "shop", "barber"].includes(checkIn.placeType)) {
    return `${checkIn.placeName} merchant'i creator cagirip kisa video, fotograf, menu/urun tanitimi veya before-after icerigi yaptirabilir. Sponsorlu oldugu acik etiketlenir.`;
  }

  return "Marka, mekan veya satici creator cagirir; creator gezer, video/foto/live uretir ve ticari brief uzerinden para kazanir. Go baglami bulur, Les Commerce isi tutar.";
}

function creatorLiveTitle(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "campus") return "Kampus turu / kulup standi live gorevi";
  if (checkIn.placeType === "beach") return "Beach live walk challenge";
  if (checkIn.placeType === "village") return "Yerel rota live tanitim";
  if (checkIn.placeType === "cafe") return "Cafe story challenge";
  return "Canli creator gorevi";
}

function creatorPromotionFacets(checkIn: PlaceCheckIn): CommerceFacetSignal[] {
  const base = [
    placeFacet(checkIn),
    facet("category", "creator_promotion", "Creator promotion", "tag"),
    facet("service_type", "sponsored_content", "Sponsored content", "listing"),
    facet("creator", "local_creator", "Local creator", "tag")
  ];

  if (["event", "concert", "club"].includes(checkIn.placeType)) {
    return [
      ...base,
      facet("service_type", "event_coverage", "Event coverage", "reason"),
      facet("delivery_method", "live_stream", "Live stream", "reason")
    ];
  }

  if (checkIn.placeType === "beach" || checkIn.placeType === "village") {
    return [
      ...base,
      facet("service_type", "walk_video", "Walk video", "reason"),
      facet("delivery_method", "photo_video", "Photo/video", "reason")
    ];
  }

  if (["cafe", "canteen", "shop", "barber"].includes(checkIn.placeType)) {
    return [
      ...base,
      facet("service_type", "reels_story", "Reels/story", "reason"),
      facet("listing_type", "creator_gig", "Creator gig", "listing")
    ];
  }

  return base;
}

function itemotelTitle(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "gym") return "Ayakkabi/ekipman otelde kalsin";
  if (checkIn.placeType === "football_club") return "Krampon ve takim ekipmani oteli";
  if (checkIn.placeType === "beach") return "Beach esyani sakla, bak, kirala";
  return "Esya oteli: sakla, bakim yaptir, kirala/sat";
}

function itemotelReason(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "gym") {
    return "Spor ayakkabi, ekipman, havlu veya sezonluk item evde yer kaplamaz; otelde saklanir, bakimi yapilir, sahibi izin verirse kiralanir veya satilir. Yakin ogrenci peer courier olarak goturup getirebilir.";
  }

  if (checkIn.placeType === "football_club") {
    return "Krampon, forma, top veya takim ekipmani depoda durur; temizlenir/bakimi yapilir, musaitse kiralik veya satilik listing'e doner. Yakindaki ogrenci teslimat isinden kazanabilir.";
  }

  if (checkIn.placeType === "beach") {
    return "Sahil sandalyesi, havlu, canta, surf/kayak gibi sezonluk esyalar otelde saklanir; bakim ve temizlikten sonra kiralanabilir veya satilabilir.";
  }

  return "Kullanmadigin esya evinde yer kaplamaz. Otelde saklanir, bakimi yapilir, sahibi izin verirse kiralanir veya satilir; satilmadiysa geri cagrilir.";
}

function itemotelFacets(checkIn: PlaceCheckIn): CommerceFacetSignal[] {
  const base = [
    placeFacet(checkIn),
    facet("category", "item_hotel", "Item Otel", "tag"),
    facet("listing_type", "rent_or_sale", "Rent/sell", "listing"),
    facet("care_type", "care_log", "Care log", "tag")
  ];

  if (checkIn.placeType === "gym") {
    return [
      ...base,
      facet("item_type", "shoes", "Shoes", "reason"),
      facet("item_type", "gym_gear", "Gym gear", "reason")
    ];
  }

  if (checkIn.placeType === "football_club") {
    return [
      ...base,
      facet("item_type", "boots", "Boots", "reason"),
      facet("category", "football", "Football", "tag")
    ];
  }

  if (checkIn.placeType === "beach") {
    return [
      ...base,
      facet("item_type", "beach_gear", "Beach gear", "reason"),
      facet("rental_period", "seasonal", "Seasonal", "reason", "derived")
    ];
  }

  return base;
}

export const lesCertificationAdapter = {
  getPlaceSignal(checkIn: PlaceCheckIn): OpportunityCard[] {
    if (checkIn.placeType === "adult_venue") {
      return [
        card({
          id: `cert-adult-${checkIn.placeId}`,
          type: "certification_signal",
          tempo: "stable",
          timeLabel: "Safety",
          sourceApp: "les_certification",
          title: "18+ legal/safety signal only",
          reason: "This venue type can only expose legal status, age-gate, consent and safety review signals. No matchmaking, no service booking, no private trails.",
          requiredActivation: null,
          safetyLabels: ["human review required", "18+ only", "legal status"]
        })
      ];
    }

    const cards: OpportunityCard[] = [
      card({
        id: `cert-${checkIn.placeId}`,
        type: "certification_signal",
        tempo: "stable",
        timeLabel: "Place signal",
        sourceApp: "les_certification",
        title: "Make this a LesTupid place candidate",
        reason: "Repeated check-ins can signal honest pricing, fair waiting and clean local value.",
        requiredActivation: null,
        safetyLabels: ["human review required", "evidence-based"]
      })
    ];

    if (trustCredentialContext(checkIn)) {
      cards.push(
        card({
          id: `trust-credential-${checkIn.placeId}`,
          type: "trust_credential",
          tempo: "stable",
          timeLabel: "Trust",
          sourceApp: "les_certification",
          title: trustCredentialTitle(checkIn),
          reason: trustCredentialReason(checkIn),
          requiredActivation: "les-certification",
          safetyLabels: ["identity hidden", "pairwise pseudonym", "hash-only proof optional", "revocable"],
          actions: [
            { id: "open", label: "Preview trust badge", kind: "primary" },
            { id: "dismiss", label: "Dismiss", kind: "secondary" },
            { id: "report", label: "Report", kind: "warning" }
          ]
        })
      );
    }

    return cards;
  }
};

function trustCredentialContext(checkIn: PlaceCheckIn): boolean {
  return [
    "campus",
    "workplace",
    "canteen",
    "cafe",
    "library",
    "student_affairs",
    "shop",
    "gym",
    "football_club",
    "event",
    "village",
    "beach"
  ].includes(checkIn.placeType);
}

function trustCredentialTitle(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "canteen" || checkIn.placeType === "cafe") return "Kimliksiz guvenilir alici rozeti";
  if (checkIn.placeType === "gym" || checkIn.placeType === "football_club") return "Ekipman/kiralama icin trust goster";
  if (checkIn.placeType === "student_affairs") return "Basvuru ve belge icin guven sinyali";
  if (checkIn.placeType === "workplace") return "Is/staj icin kimliksiz trust preview";
  return "Kimligimi acmadan trust goster";
}

function trustCredentialReason(checkIn: PlaceCheckIn): string {
  if (checkIn.placeType === "gym" || checkIn.placeType === "football_club") {
    return "Teslimat, kiralama, Item Otel bakim kaydi veya ekipman iade gecmisi ozet trust credential'a donusebilir. Karsi taraf sadece alan ve seviye gorur; tum gecmis acilmaz.";
  }

  if (checkIn.placeType === "workplace") {
    return "CV, mikro-is, teslimat, egitim ve sertifika sinyallerinden is/staj icin kimliksiz guven rozeti uretilir. Gercek kimlik ve detaylar sadece sen onaylarsan acilir.";
  }

  return `${checkIn.placeName} icin alisveris, sira, teslimat, katki veya sertifika sinyallerinden domain bazli guven rozeti gosterilebilir. Blockchain sadece hash/proof tasir.`;
}

export const lesBlockAdapter = {
  getOptionalProofEvents(checkIn: PlaceCheckIn): OpportunityCard[] {
    if (checkIn.placeType === "adult_venue") {
      return [];
    }

    return [
      card({
        id: `proof-${checkIn.placeId}`,
        type: "proof_or_point",
        tempo: "stable",
        timeLabel: "Optional",
        sourceApp: "les_block",
        title: "Optional point proof",
        reason: "This check-in can later produce a point or certificate proof if you explicitly allow it.",
        requiredActivation: null,
        safetyLabels: ["wallet optional", "hash only", "no private location trail"]
      })
    ];
  }
};

export function getOpportunities(
  checkIn: PlaceCheckIn,
  activeChannels: InteractionChannel[]
): OpportunityCard[] {
  return [
    ...lesPlaceActionAdapter.getPlaceActions(checkIn),
    ...lesWaitAdapter.getQueueActions(checkIn),
    ...lesPokeAdapter.getQuestOpportunities(checkIn),
    ...lesMatchAdapter.previewOpportunities(checkIn, activeChannels),
    ...lesHarmonicaAdapter.getSafeContactOpportunities(checkIn, activeChannels),
    ...lesAffiliateOyunAdapter.getGameOpportunities(checkIn),
    ...lesNairobiStudentLaunchAdapter.getLaunchOpportunities(checkIn),
    ...lesAiAdapter.getAgentHelp(checkIn),
    ...lesCareerAdapter.getCareerOpportunities(checkIn),
    ...lesLocalListingAdapter.getLocalListings(checkIn),
    ...lesServiceGigAdapter.getServiceGigs(checkIn),
    ...lesCreatorPromotionAdapter.getCreatorPromotionOpportunities(checkIn),
    ...lesCommerceAdapter.getOffers(checkIn),
    ...lesCertificationAdapter.getPlaceSignal(checkIn),
    ...lesBlockAdapter.getOptionalProofEvents(checkIn)
  ];
}

export const mockOpportunityAdapter: OpportunityAdapter = {
  getOpportunities
};

export const httpOpportunityAdapter: OpportunityAdapter = {
  getOpportunities(checkIn, activeChannels) {
    void checkIn;
    void activeChannels;

    // v1 keeps the UI deterministic while the Phoenix APIs are being built.
    // The HTTP adapter boundary is intentionally explicit so replacing this
    // fallback does not change component code.
    return mockOpportunityAdapter.getOpportunities(checkIn, activeChannels);
  }
};

export function getOpportunityAdapter(): OpportunityAdapter {
  return appConfig.opportunityAdapter === "http" ? httpOpportunityAdapter : mockOpportunityAdapter;
}

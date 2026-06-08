import React, { useMemo, useState, useEffect } from "react";
import { createRoot } from "react-dom/client";
import "./styles.css";
import {
  appActivations,
  channels,
  identity,
  places,
  mockItemOtelRecords,
  studentCvProfile,
  mockQuests,
  mockMatchProfiles,
  mockCrmLogs,
  mockHarmonicaDevices,
  mockOyunCards,
  mockKadroAgents,
  mockZkpCredentials
} from "./data";
import { getOpportunityAdapter } from "./adapters";
import type {
  CommerceFacetSignal,
  OpportunityAction,
  OpportunityCard,
  OpportunityType,
  PlaceCheckIn,
  PlaceMode,
  PlaceOption,
  PlaceType,
  PrivacyLevel,
  ItemOtelRecord,
  StudentCvProfile,
  QueueTicket,
  QuestItem,
  MatchProfile,
  CrmLog,
  HarmonicaDevice,
  OyunCard,
  KadroAgent,
  ZkpCredential,
  FlowTempo
} from "./types";

const privacyOptions: Array<{ id: PrivacyLevel; label: string }> = [
  { id: "coarse_location", label: "Area" },
  { id: "public_place", label: "Place" },
  { id: "private_note", label: "Private" }
];

const placeFilters: Array<{ id: PlaceType | "all"; label: string }> = [
  { id: "all", label: "All" },
  { id: "campus", label: "Campus" },
  { id: "workplace", label: "Work" },
  { id: "canteen", label: "Canteen" },
  { id: "cafe", label: "Coffee" },
  { id: "football_club", label: "Football" },
  { id: "gym", label: "Gym" },
  { id: "beach", label: "Beach" },
  { id: "village", label: "Village" },
  { id: "barber", label: "Barber" },
  { id: "club", label: "Club" },
  { id: "concert", label: "Concert" },
  { id: "library", label: "Study" },
  { id: "course_center", label: "Course" },
  { id: "student_affairs", label: "Service" },
  { id: "high_school", label: "School" },
  { id: "event", label: "Event" },
  { id: "adult_venue", label: "18+" }
];

const modeLabels: Record<PlaceMode, string> = {
  study: "Study",
  eat: "Eat",
  work: "Work",
  train: "Train",
  social: "Social",
  date: "Date",
  relax: "Relax",
  shop: "Shop",
  care: "Care",
  travel: "Travel",
  service: "Service",
  safe: "Safe"
};

const modeHeadlines: Record<PlaceMode, string> = {
  study: "Flow around your study block.",
  eat: "Flow around what you eat next.",
  work: "Flow around your workday.",
  train: "Flow around your training window.",
  social: "Flow around who and what is live here.",
  date: "Flow around opt-in social plans.",
  relax: "Flow around your break.",
  shop: "Flow around local things to buy, rent or sell.",
  care: "Flow around care, safety and support.",
  travel: "Flow around where you are going.",
  service: "Flow around the service you need.",
  safe: "Flow around safe-mode only."
};

const feedFilters: Array<{ id: OpportunityType | "all"; label: string }> = [
  { id: "all", label: "For you" },
  { id: "menu", label: "Menu" },
  { id: "ticket", label: "Tickets" },
  { id: "route", label: "Route" },
  { id: "next_stop", label: "Next" },
  { id: "service_gig", label: "Gigs" },
  { id: "cv_growth", label: "CV" },
  { id: "application", label: "Apply" },
  { id: "education_opportunity", label: "Learn" },
  { id: "trust_credential", label: "Trust" },
  { id: "secure_contact", label: "Contact" },
  { id: "affiliate_game", label: "Game" },
  { id: "creator_promotion", label: "Creator" },
  { id: "care_info", label: "Care" },
  { id: "quest", label: "Quests" },
  { id: "wait_action", label: "Wait" },
  { id: "match", label: "Match" },
  { id: "local_listing", label: "Listings" },
  { id: "agent_help", label: "Agents" },
  { id: "commerce_offer", label: "Offers" }
];

const opportunityLabels: Record<OpportunityType, string> = {
  menu: "Menu",
  ticket: "Ticket",
  route: "Route",
  next_stop: "Next",
  service_gig: "Gig",
  cv_growth: "CV",
  application: "Apply",
  education_opportunity: "Learn",
  trust_credential: "Trust",
  secure_contact: "Contact",
  affiliate_game: "Game",
  creator_promotion: "Creator",
  care_info: "Care",
  quest: "Quest",
  wait_action: "Wait",
  match: "Match",
  local_listing: "Listing",
  agent_help: "Agent",
  commerce_offer: "Offer",
  certification_signal: "Signal",
  proof_or_point: "Proof"
};

// Minimalist premium SVG icons for each opportunity type
const opportunityIcons: Record<OpportunityType, React.ReactNode> = {
  menu: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><path d="M4 3h12a2 2 0 0 1 2 2v16H6a2 2 0 0 1-2-2V3z"/><path d="M8 7h6M8 11h6M8 15h4"/></svg>
  ),
  ticket: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><path d="M3 9a3 3 0 1 0 0 6v3a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-3a3 3 0 1 0 0-6V6a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v3z"/><path d="M13 5v14"/></svg>
  ),
  route: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><path d="M4 19V5l5-2 6 2 5-2v14l-5 2-6-2-5 2z"/><path d="M9 3v14M15 5v14"/></svg>
  ),
  next_stop: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><path d="M5 12h12"/><path d="M13 6l6 6-6 6"/><circle cx="5" cy="12" r="2"/><circle cx="19" cy="12" r="2"/></svg>
  ),
  service_gig: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><path d="M12 12a4 4 0 1 0-4-4 4 4 0 0 0 4 4z"/><path d="M4 21a8 8 0 0 1 16 0"/><path d="M18 8h3M19.5 6.5v3"/></svg>
  ),
  cv_growth: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><path d="M4 4h16v16H4z"/><path d="M8 8h8M8 12h5M8 16h8"/><path d="M17 3v4M7 3v4"/></svg>
  ),
  application: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><path d="M14 2v6h6"/><path d="M9 15l2 2 4-5"/></svg>
  ),
  education_opportunity: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><path d="M22 10L12 5 2 10l10 5 10-5z"/><path d="M6 12v5c3 2 9 2 12 0v-5"/><path d="M22 10v6"/></svg>
  ),
  trust_credential: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><path d="M12 2l7 4v6c0 5-3 8-7 10-4-2-7-5-7-10V6l7-4z"/><path d="M9 12l2 2 4-5"/><path d="M4 21h16"/></svg>
  ),
  secure_contact: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><path d="M21 15a4 4 0 0 1-4 4H8l-5 3V7a4 4 0 0 1 4-4h10a4 4 0 0 1 4 4z"/><path d="M8 10h8M8 14h5"/></svg>
  ),
  affiliate_game: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><rect x="4" y="3" width="12" height="16" rx="2"/><path d="M8 7h4M8 11h5M8 15h3"/><path d="M18 7l2 10a2 2 0 0 1-2 2h-2"/></svg>
  ),
  creator_promotion: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><path d="M15 10l4.55-2.28A1 1 0 0 1 21 8.62v6.76a1 1 0 0 1-1.45.9L15 14"/><rect x="3" y="6" width="12" height="12" rx="2"/><circle cx="9" cy="12" r="2"/><path d="M7 2h4M9 2v4"/></svg>
  ),
  care_info: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><path d="M22 12h-4l-3 8L9 4l-3 8H2"/><path d="M12 20c-3-2-6-5-6-9a6 6 0 0 1 12 0c0 4-3 7-6 9z"/></svg>
  ),
  quest: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/></svg>
  ),
  wait_action: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
  ),
  match: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
  ),
  local_listing: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
  ),
  agent_help: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg>
  ),
  commerce_offer: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
  ),
  certification_signal: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
  ),
  proof_or_point: (
    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="icon-svg"><polygon points="12 2 22 8.5 22 15.5 12 22 2 15.5 2 8.5 12 2"/></svg>
  )
};

const settingsIcon = (
  <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" className="settings-icon-svg"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
);

const checkMarkIcon = (
  <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" strokeWidth="3" fill="none" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
);

const opportunityAdapter = getOpportunityAdapter();

function sameCommerceFacet(left: CommerceFacetSignal, right: CommerceFacetSignal) {
  return left.key === right.key && left.value === right.value;
}

function normalizeCommerceFacet(value: string) {
  return value
    .toLocaleLowerCase("tr-TR")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[^\p{L}\p{N}]+/gu, " ")
    .trim();
}

function opportunityMatchesCommerceFacets(opportunity: OpportunityCard, activeFacets: CommerceFacetSignal[]) {
  if (activeFacets.length === 0) return true;

  const cardFacets = opportunity.commerceFacets ?? [];
  const searchableText = normalizeCommerceFacet(
    `${opportunity.title} ${opportunity.reason} ${opportunity.sourceApp} ${opportunity.safetyLabels.join(" ")}`
  );

  return activeFacets.every((facet) => {
    const structuredMatch = cardFacets.some((candidate) => sameCommerceFacet(candidate, facet));
    const textMatch =
      searchableText.includes(normalizeCommerceFacet(facet.label)) ||
      searchableText.includes(normalizeCommerceFacet(facet.value));

    return structuredMatch || textMatch;
  });
}

const aiCrew = [
  {
    source: "les_ai/kadro",
    title: "KADRO worker",
    text: "Labeled AI workers for study, sponsor prep, venue support and consent-safe planning."
  },
  {
    source: "agentandbot.com",
    title: "Task workspace",
    text: "External agent runtime for tracked tasks, tools, drafts and workflow help."
  },
  {
    source: "les_ai/ai_senaryo",
    title: "Creator board",
    text: "Collective scenario, quest, recap and short-film idea workspace."
  }
];

type NearbyTopic = {
  id: string;
  label: string;
  detail: string;
  heat: "live" | "warm" | "calm";
  safety: string;
};

type VisualDemoFlow = {
  id: string;
  title: string;
  mood: string;
  tempo: FlowTempo;
  sourceApps: string[];
  scene: string;
  steps: string[];
  visualCue: string;
  trustRule: string;
};

const nearbyPlacePreviewLimit = 6;
const nearbyTopicPreviewLimit = 4;
const feedPreviewLimit = 5;

type ViewType =
  | "hub"
  | "visual"
  | "wait"
  | "poke"
  | "match"
  | "itemotel"
  | "contacts"
  | "care"
  | "harmonica"
  | "oyun"
  | "ai"
  | "certification";

const visualDemoFlows: VisualDemoFlow[] = [
  {
    id: "campus-day",
    title: "School day flow",
    mood: "busy but controlled",
    tempo: "live",
    sourceApps: ["les_go", "les_wait", "les_poke", "les_match", "les_ai", "les_contacts"],
    scene: "A student enters campus, sees only the few things that matter now.",
    steps: ["Check in", "Canteen queue", "Focus quest", "Study group prompt", "Private CRM memory"],
    visualCue: "Dense nearby rail, live queue strip, compact opportunity cards.",
    trustRule: "People discovery stays opt-in; school/minor contexts stay safe-mode."
  },
  {
    id: "commerce-memory",
    title: "Buy, use, remember",
    mood: "useful and terms-visible",
    tempo: "today",
    sourceApps: ["lescommerce", "les_contacts", "les_certification", "les_go"],
    scene: "A user buys, rents or saves a product and the relationship becomes private memory.",
    steps: ["Product card", "Checkout or listing", "Receipt reference", "Warranty/follow-up", "CRM memory"],
    visualCue: "Product cards show price, terms, source app and follow-up state.",
    trustRule: "Commerce owns checkout; Contacts stores only private relationship memory."
  },
  {
    id: "itemotel-loop",
    title: "Item Otel loop",
    mood: "custody, care and recall clarity",
    tempo: "ongoing",
    sourceApps: ["les_itemotel", "lescommerce", "les_wait", "les_certification", "les_contacts"],
    scene: "An item leaves home, gets stored, cared for, rented/sold or recalled.",
    steps: ["Send item", "Condition log", "Care window", "Rent/sell option", "Recall delivery"],
    visualCue: "Stable item cards, condition badges, care log, recall button.",
    trustRule: "Ownership and custody details stay private unless explicitly listed."
  },
  {
    id: "safe-contact",
    title: "Anonymous trust contact",
    mood: "protected and restrained",
    tempo: "short",
    sourceApps: ["les_harmonica", "les_certification", "les_match", "les_go"],
    scene: "Two people or a venue/user pair can communicate without exposing raw identity.",
    steps: ["Proximity signal", "Pairwise alias", "Consent handoff", "Encrypted contact", "Revoke/report"],
    visualCue: "Secure purple card, low-motion trust rail, visible revoke/report controls.",
    trustRule: "No public people browsing; contact exists only after scoped consent."
  },
  {
    id: "creator-ai-game",
    title: "Creator, AI and game drop",
    mood: "playful but labeled",
    tempo: "today",
    sourceApps: ["les_poke", "les_affiliate_oyun", "les_ai", "agentandbot", "lescommerce"],
    scene: "A quest or creator drop becomes a product card, AI task or game opportunity.",
    steps: ["Quest/drop", "Creator card", "AI helper", "Commerce link", "Reward/proof"],
    visualCue: "Playful card stack, AI label, rarity/odds and affiliate disclosure.",
    trustRule: "AI is always labeled; paid/affiliate mechanics are always disclosed."
  },
  {
    id: "care-safety",
    title: "Care and safety info",
    mood: "calm, serious, source-led",
    tempo: "stable",
    sourceApps: ["les_care", "les_wait", "les_certification", "les_contacts"],
    scene: "A health or safety question becomes safe info, routing and private follow-up.",
    steps: ["Question", "Safety boundary", "Clinic/pharmacy route", "Queue/visit", "Private note"],
    visualCue: "Sober cards, no playful effects, clear emergency/source labels.",
    trustRule: "No diagnosis or prescription behavior; private health events stay private."
  },
  {
    id: "kenya-turkiye-student",
    title: "Kenya student to Turkiye",
    mood: "official, hopeful and careful",
    tempo: "ongoing",
    sourceApps: ["les_travel", "les_ai", "les_certification", "lescommerce", "les_harmonica", "les_contacts"],
    scene: "A University of Nairobi geography student plans a Turkiye trip without fake visa links, unsafe stays or missing return plans.",
    steps: ["Trip intent", "Official visa source", "Document checklist", "Safe stay", "Arrival mode"],
    visualCue: "Sober readiness checklist, official-source badge, stay risk labels and emergency contact pack.",
    trustRule: "Visa rules are verified from official sources at runtime; LesTupid does not become the visa authority."
  },
  {
    id: "nairobi-student-launch",
    title: "Nairobi student launch",
    mood: "ambitious, protected and useful",
    tempo: "ongoing",
    sourceApps: ["les_go", "les_poke", "les_match", "lescommerce", "les_travel", "les_ai", "les_certification"],
    scene: "A University of Nairobi student or new graduate opens one campus feed and sees safe income, CV, sponsor, travel and creator paths.",
    steps: ["Campus check-in", "Living CV", "Safe gigs", "Mentor/sponsor opt-in", "Travel readiness"],
    visualCue: "Launch board at the top, then moving opportunity cards for work, study, creator, travel and trust.",
    trustRule: "Adult dating is separate and opt-in; money, gifts or trips are never framed as sexual-service exchange."
  },
  {
    id: "holiday-risk-guard",
    title: "Holiday risk guard",
    mood: "calm, skeptical and protective",
    tempo: "short",
    sourceApps: ["les_travel", "lescommerce", "les_care", "les_harmonica", "les_match", "les_contacts"],
    scene: "A holiday plan becomes a budget, stay, route, health and trust check before the user walks into a tourist trap.",
    steps: ["Budget guard", "Stay check", "Risk briefing", "Safe contact", "Return plan"],
    visualCue: "Risk cards look like risk cards: not cute, not hidden, not manipulative.",
    trustRule: "Travel companion and social discovery stay opt-in; money, gifts or travel are never framed as adult-service exchange."
  }
];

// Helper to trigger simulated audio alert
function triggerAudioBeep() {
  try {
    const ctx = new (window.AudioContext || (window as any).webkitAudioContext)();
    const osc = ctx.createOscillator();
    const gain = ctx.createGain();
    osc.connect(gain);
    gain.connect(ctx.destination);
    osc.type = "sine";
    osc.frequency.setValueAtTime(880, ctx.currentTime);
    gain.gain.setValueAtTime(0.2, ctx.currentTime);
    osc.start();
    osc.stop(ctx.currentTime + 0.15);
  } catch (e) {
    console.warn("Audio Context not supported", e);
  }
}

function App() {
  const [activeView, setActiveView] = useState<ViewType>("hub");
  const [sidebarCollapsed, setSidebarCollapsed] = useState(false);

  // Core PWA Shell states
  const [placeId, setPlaceId] = useState(places[0]?.id ?? "");
  const [selectedMode, setSelectedMode] = useState<PlaceMode>(places[0]?.defaultMode ?? "study");
  const [placeFilter, setPlaceFilter] = useState<PlaceType | "all">("all");
  const [feedFilter, setFeedFilter] = useState<OpportunityType | "all">("all");
  const [activeCommerceFacets, setActiveCommerceFacets] = useState<CommerceFacetSignal[]>([]);
  const [privacyLevel, setPrivacyLevel] = useState<PrivacyLevel>("coarse_location");
  const [dismissedIds, setDismissedIds] = useState<string[]>([]);
  const [reportedIds, setReportedIds] = useState<string[]>([]);
  const [showSettings, setShowSettings] = useState(false);
  const [browsePlaces, setBrowsePlaces] = useState(false);
  const [browseTopics, setBrowseTopics] = useState(false);
  const [browseFeed, setBrowseFeed] = useState(false);

  // CV signals tracking
  const [cvProfile, setCvProfile] = useState<StudentCvProfile>(studentCvProfile);

  // 1. Les Wait Simulator State
  const [waitTicket, setWaitTicket] = useState<QueueTicket | null>(null);

  // 2. Les Poke Simulator State
  const [quests, setQuests] = useState<QuestItem[]>(mockQuests);
  const [selectedQuest, setSelectedQuest] = useState<QuestItem | null>(mockQuests[0] ?? null);
  const [questXp, setQuestXp] = useState(120);
  const [simulatingGps, setSimulatingGps] = useState(false);

  // 3. Les Match Simulator State
  const [matchProfiles, setMatchProfiles] = useState<MatchProfile[]>(mockMatchProfiles);
  const [matchIndex, setMatchIndex] = useState(0);
  const [activeChatMatch, setActiveChatMatch] = useState<MatchProfile | null>(null);
  const [matchChatMsg, setMatchChatMsg] = useState("");
  const [matchChatHistory, setMatchChatHistory] = useState<string[]>([]);
  const [showMatchPopup, setShowMatchPopup] = useState(false);

  // 4. Les Commerce & Item Otel state
  const [items, setItems] = useState<ItemOtelRecord[]>(mockItemOtelRecords);
  const [loadingItems, setLoadingItems] = useState(false);
  const [expandedItemId, setExpandedItemId] = useState<number | null>(null);
  const [careTypeInput, setCareTypeInput] = useState<Record<number, string>>({});
  const [careNotesInput, setCareNotesInput] = useState<Record<number, string>>({});
  const [listTypeInput, setListTypeInput] = useState<Record<number, "rent" | "sale" | "both">>({});
  const [priceSaleInput, setPriceSaleInput] = useState<Record<number, string>>({});
  const [priceRentInput, setPriceRentInput] = useState<Record<number, string>>({});
  const [newItemName, setNewItemName] = useState("");
  const [newItemCategory, setNewItemCategory] = useState<"apparel" | "sports" | "automotive" | "wedding" | "other">("sports");
  const [showNewItemForm, setShowNewItemForm] = useState(false);

  // 5. Les Contacts CRM State
  const [crmLogs, setCrmLogs] = useState<CrmLog[]>(mockCrmLogs);
  const [crmFilter, setCrmFilter] = useState<"all" | "work" | "personal" | "social" | "travel">("all");
  const [newCrmNotes, setNewCrmNotes] = useState("");
  const [newCrmContext, setNewCrmContext] = useState<"work" | "personal" | "social" | "travel">("personal");
  const [newCrmPlace, setNewCrmPlace] = useState("");

  // 6. Les Care State
  const [careSearch, setCareSearch] = useState("");
  const [emergencyActive, setEmergencyActive] = useState(false);

  // 7. Les Harmonica State
  const [harmonicaDevices, setHarmonicaDevices] = useState<HarmonicaDevice[]>(mockHarmonicaDevices);
  const [scanning, setScanning] = useState(false);
  const [pairedDevice, setPairedDevice] = useState<HarmonicaDevice | null>(null);
  const [secChatMsg, setSecChatMsg] = useState("");
  const [secChatHistory, setSecChatHistory] = useState<string[]>([]);

  // 8. Les Affiliate Oyun State
  const [oyunHand, setOyunHand] = useState<OyunCard[]>(mockOyunCards.slice(0, 3));
  const [gameLogs, setGameLogs] = useState<string[]>([]);
  const [playerHp, setPlayerHp] = useState(100);
  const [aiHp, setAiHp] = useState(100);
  const [duelActive, setDuelActive] = useState(false);
  const [winnerMessage, setWinnerMessage] = useState<string | null>(null);

  // 9. Les AI / KADRO State
  const [selectedAgent, setSelectedAgent] = useState<KadroAgent>(mockKadroAgents[0]!);
  const [aiPrompt, setAiPrompt] = useState("");
  const [aiConsoleContent, setAiConsoleContent] = useState("");
  const [isAiTyping, setIsAiTyping] = useState(false);
  const [aiOutputReady, setAiOutputReady] = useState(false);

  // 10. Les Certification ZKP State
  const [zkpCredentials, setZkpCredentials] = useState<ZkpCredential[]>(mockZkpCredentials);
  const [qrSeed, setQrSeed] = useState(0.85);

  // Simulate queue tick down for Les Wait
  useEffect(() => {
    if (!waitTicket || waitTicket.status !== "waiting") return;
    const interval = setInterval(() => {
      setWaitTicket((prev) => {
        if (!prev) return null;
        if (prev.userPosition <= 1) {
          clearInterval(interval);
          triggerAudioBeep();
          return { ...prev, userPosition: 0, estimatedMinutes: 0, status: "called" };
        }
        return {
          ...prev,
          userPosition: prev.userPosition - 1,
          estimatedMinutes: Math.max(1, Math.round((prev.userPosition - 1) * 2.2))
        };
      });
    }, 6000);
    return () => clearInterval(interval);
  }, [waitTicket]);

  // Handle joining queue in Les Wait
  const handleJoinQueue = (venueId: string, name: string) => {
    const ticket: QueueTicket = {
      id: `ticket-${Date.now()}`,
      venueId,
      venueName: name,
      ticketNumber: `A-${Math.floor(Math.random() * 90) + 10}`,
      userPosition: Math.floor(Math.random() * 8) + 4,
      estimatedMinutes: 15,
      status: "waiting"
    };
    setWaitTicket(ticket);
    setActiveView("wait");
  };

  // Skip queue number manually (Fast forward)
  const handleFastForwardQueue = () => {
    if (!waitTicket || waitTicket.status !== "waiting") return;
    setWaitTicket((prev) => {
      if (!prev) return null;
      if (prev.userPosition <= 1) {
        triggerAudioBeep();
        return { ...prev, userPosition: 0, estimatedMinutes: 0, status: "called" };
      }
      return {
        ...prev,
        userPosition: prev.userPosition - 1,
        estimatedMinutes: Math.max(1, Math.round((prev.userPosition - 1) * 2.2))
      };
    });
  };

  // Mock GPS Quest completion
  const handleSimulateGps = () => {
    if (!selectedQuest || selectedQuest.status === "completed") return;
    setSimulatingGps(true);
    setTimeout(() => {
      setQuests((prev) =>
        prev.map((q) => (q.id === selectedQuest.id ? { ...q, status: "completed" } : q))
      );
      setSelectedQuest((prev) => (prev ? { ...prev, status: "completed" } : null));
      setQuestXp((xp) => xp + selectedQuest.xp);
      setSimulatingGps(false);

      // Append new signal to Living CV
      const newSignal = {
        id: `cv-poke-${Date.now()}`,
        sourceApp: "les_poke",
        title: `${selectedQuest.name} tamamlandı`,
        detail: `Konumsal görev başarıyla tamamlandı. +${selectedQuest.xp} XP kazanıldı.`,
        status: "verified" as const
      };
      setCvProfile((prev) => ({
        ...prev,
        completionPercent: Math.min(100, prev.completionPercent + 4),
        signals: [newSignal, ...prev.signals]
      }));
    }, 1500);
  };

  // Swiping match cards
  const handleMatchChoice = (interested: boolean) => {
    if (interested) {
      // 50% match chance
      if (Math.random() > 0.4) {
        setShowMatchPopup(true);
        setMatchProfiles((prev) =>
          prev.map((p, idx) => (idx === matchIndex ? { ...p, mutualInterest: true } : p))
        );
      } else {
        setMatchIndex((prev) => (prev + 1) % matchProfiles.length);
      }
    } else {
      setMatchIndex((prev) => (prev + 1) % matchProfiles.length);
    }
  };

  // Send message inside mutual match chat
  const handleSendMatchMsg = (e: React.FormEvent) => {
    e.preventDefault();
    if (!matchChatMsg || !activeChatMatch) return;
    setMatchChatHistory((prev) => [...prev, `Sen: ${matchChatMsg}`]);
    const userMsg = matchChatMsg;
    setMatchChatMsg("");

    setTimeout(() => {
      setMatchChatHistory((prev) => [
        ...prev,
        `${activeChatMatch.pseudonym}: Harika! Proximity handoff yapıp Les Harmonica üzerinden şifreli sohbete geçelim mi?`
      ]);
    }, 1200);
  };

  // Add CRM memory log
  const handleAddCrmLog = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newCrmNotes) return;
    const log: CrmLog = {
      id: `crm-${Date.now()}`,
      date: new Date().toISOString().split("T")[0]!,
      placeName: newCrmPlace || "Bilinmeyen Konum",
      notes: newCrmNotes,
      context: newCrmContext
    };
    setCrmLogs((prev) => [log, ...prev]);
    setNewCrmNotes("");
    setNewCrmPlace("");
  };

  // Simulate radar scanning for Harmonica
  const handleRadarScan = () => {
    setScanning(true);
    setPairedDevice(null);
    setSecChatHistory([]);
    setTimeout(() => {
      setScanning(false);
    }, 2500);
  };

  // Ephemeral messaging session
  const handleSendSecureMsg = (e: React.FormEvent) => {
    e.preventDefault();
    if (!secChatMsg || !pairedDevice) return;
    setSecChatHistory((prev) => [...prev, `Sinyal (Sen): ${secChatMsg}`]);
    const userMsg = secChatMsg;
    setSecChatMsg("");

    setTimeout(() => {
      setSecChatHistory((prev) => [
        ...prev,
        `${pairedDevice.name}: Mesaj el sıkışma anahtarı ile şifrelendi [AES-GCM]. Dinleyen taraflar için sadece gürültü.`
      ]);
    }, 1000);
  };

  // Duel Arena actions
  const handleOyunCardPlay = (card: OyunCard) => {
    if (!duelActive || winnerMessage) return;
    const damage = card.power;
    const shield = card.defense;

    // AI chooses random block/attack
    const aiAction = Math.random() > 0.5 ? "attack" : "block";
    const aiPower = Math.floor(Math.random() * 5) + 3;

    let playerDamageDealt = Math.max(0, damage - (aiAction === "block" ? aiPower : 0));
    let aiDamageDealt = aiAction === "attack" ? Math.max(0, aiPower - shield) : 0;

    const newAiHp = Math.max(0, aiHp - playerDamageDealt);
    const newPlayerHp = Math.max(0, playerHp - aiDamageDealt);

    setAiHp(newAiHp);
    setPlayerHp(newPlayerHp);

    const log = `Tur Sonucu: Kartın [${card.name}] ${damage} güçle saldırdı. AI [${
      aiAction === "attack" ? "Saldırı" : "Savunma"
    }] seçti. AI'ya ${playerDamageDealt} hasar verdin. Sana ${aiDamageDealt} hasar geldi.`;
    setGameLogs((prev) => [log, ...prev]);

    if (newAiHp <= 0) {
      setWinnerMessage("Tebrikler! Oyunu Kazandın. +50 XP");
      // Add XP to quest log
      setQuestXp((x) => x + 50);

      // Add Oyun winner credential
      const newSignal = {
        id: `cv-oyun-${Date.now()}`,
        sourceApp: "les-affiliate-oyun",
        title: "Sertifikalı kart düellosu galibiyeti",
        detail: "Eşya ve referans kart ekonomisinde doğrulanan düello kazancı.",
        status: "verified" as const
      };
      setCvProfile((prev) => ({
        ...prev,
        completionPercent: Math.min(100, prev.completionPercent + 5),
        signals: [newSignal, ...prev.signals]
      }));
    } else if (newPlayerHp <= 0) {
      setWinnerMessage("AI Kazandı. Kart desteni güçlendirip tekrar dene!");
    }
  };

  // KADRO AI interaction
  const handleSendAiPrompt = (e: React.FormEvent) => {
    e.preventDefault();
    if (!aiPrompt) return;
    setIsAiTyping(true);
    setAiOutputReady(false);
    setAiConsoleContent("Analiz başlatılıyor...");

    setTimeout(() => {
      setAiConsoleContent("KADRO ajanları kimlik ve onay sertifikalarını tarıyor...\n");
    }, 600);

    setTimeout(() => {
      setAiConsoleContent((prev) => prev + "Giriş analiz edildi. Taslak yanıt derleniyor...\n");
    }, 1200);

    setTimeout(() => {
      setAiConsoleContent(selectedAgent.responseTemplate);
      setIsAiTyping(false);
      setAiOutputReady(true);
    }, 2000);
  };

  const handleExportAiDraftToCv = () => {
    if (!aiOutputReady) return;
    const newSignal = {
      id: `cv-ai-${Date.now()}`,
      sourceApp: "les_ai/kadro",
      title: `${selectedAgent.name} Taslağı`,
      detail: selectedAgent.responseTemplate.slice(0, 75) + "...",
      status: "draft" as const
    };
    setCvProfile((prev) => ({
      ...prev,
      completionPercent: Math.min(100, prev.completionPercent + 6),
      signals: [newSignal, ...prev.signals]
    }));
    setAiPrompt("");
    setAiConsoleContent("Taslak Living CV paneline başarıyla gönderildi!");
    setAiOutputReady(false);
  };

  // Circular commerce actions (mock handlers)
  const handleRecall = (id: number) => {
    setItems((prev) =>
      prev.map((item) =>
        item.id === id
          ? { ...item, status: "shipped_back", storage_location: undefined, listing: undefined }
          : item
      )
    );
  };

  const handleCare = (id: number) => {
    const careType = careTypeInput[id] || "general_maintenance";
    const notes = careNotesInput[id] || "";
    setItems((prev) =>
      prev.map((item) => {
        if (item.id === id) {
          const newLog = {
            id: Date.now(),
            care_type: careType as any,
            notes,
            performed_at: new Date().toISOString(),
            provider_id: "Otel Bakım Merkezi (Simüle)"
          };
          return {
            ...item,
            status: "in_maintenance",
            care_logs: [newLog, ...item.care_logs]
          };
        }
        return item;
      })
    );
    setCareNotesInput((prev) => ({ ...prev, [id]: "" }));
  };

  const handleList = (id: number) => {
    const listingType = listTypeInput[id] || "rent";
    const priceSale = priceSaleInput[id] || "";
    const priceRentDaily = priceRentInput[id] || "";
    setItems((prev) =>
      prev.map((item) => {
        if (item.id === id) {
          return {
            ...item,
            status: listingType === "sale" ? "listed_for_sale" : "listed_for_rent",
            listing: {
              id: Date.now(),
              listing_type: listingType,
              price_sale: priceSale,
              price_rent_daily: priceRentDaily,
              is_active: true
            }
          };
        }
        return item;
      })
    );
  };

  const handleUnlist = (id: number) => {
    setItems((prev) =>
      prev.map((item) =>
        item.id === id ? { ...item, status: "in_storage", listing: undefined } : item
      )
    );
  };

  const handleCreateItem = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newItemName) return;
    const newItem: ItemOtelRecord = {
      id: Date.now(),
      owner_identity_id: "student-demo-001",
      name: newItemName,
      category: newItemCategory,
      status: "in_storage",
      storage_location: "Kabul Masası",
      condition_rating: 10,
      images: ["/images/itemotel-generic.png"],
      care_logs: [],
      inserted_at: new Date().toISOString()
    };
    setItems((prev) => [newItem, ...prev]);
    setNewItemName("");
    setShowNewItemForm(false);
  };

  const selectedPlace = places.find((place) => place.id === placeId) ?? places[0]!;
  const activeMode = selectedPlace.modes.includes(selectedMode) ? selectedMode : selectedPlace.defaultMode;
  const activeApps = appActivations.filter((app) => app.status === "activated");
  const activeChannels = channels.filter((channel) => channel.status === "activated");
  const visiblePlaces =
    placeFilter === "all" ? places : places.filter((place) => place.type === placeFilter);
  const nearbyPlaces = browsePlaces ? visiblePlaces : visiblePlaces.slice(0, nearbyPlacePreviewLimit);

  const checkIn: PlaceCheckIn = {
    placeId: selectedPlace.id,
    placeName: selectedPlace.name,
    placeType: selectedPlace.type,
    mode: activeMode,
    privacyLevel,
    source: "manual"
  };

  const opportunities = useMemo(() => {
    return opportunityAdapter
      .getOpportunities(checkIn, channels)
      .filter((opportunity) => !dismissedIds.includes(opportunity.id))
      .filter((opportunity) => feedFilter === "all" || opportunity.type === feedFilter)
      .filter((opportunity) => opportunityMatchesCommerceFacets(opportunity, activeCommerceFacets));
  }, [checkIn.placeId, checkIn.placeType, checkIn.mode, checkIn.privacyLevel, dismissedIds, feedFilter, activeCommerceFacets]);

  const nearbyTopics = useMemo(() => {
    // Generate topics list helper
    const base: NearbyTopic[] = [
      {
        id: `${selectedPlace.id}-menu`,
        label: "Menu",
        detail: "food and prices",
        heat: activeMode === "eat" ? "live" : "warm",
        safety: "prices visible"
      },
      {
        id: `${selectedPlace.id}-queue`,
        label: "Queue window",
        detail: "wait and timing",
        heat: "live",
        safety: "no private trail"
      },
      {
        id: `${selectedPlace.id}-safe-contact`,
        label: "Safe contact",
        detail: "anonymous handoff",
        heat: activeMode === "social" || activeMode === "work" ? "live" : "warm",
        safety: "encrypted"
      }
    ];
    return base;
  }, [selectedPlace.id, activeMode]);

  const visibleTopics = browseTopics ? nearbyTopics : nearbyTopics.slice(0, nearbyTopicPreviewLimit);
  const visibleOpportunities = browseFeed ? opportunities : opportunities.slice(0, feedPreviewLimit);

  function toggleCommerceFacet(facet: CommerceFacetSignal) {
    setActiveCommerceFacets((current) => {
      if (current.some((item) => sameCommerceFacet(item, facet))) {
        return current.filter((item) => !sameCommerceFacet(item, facet));
      }

      return [...current, facet];
    });
    setBrowseFeed(false);
  }

  function handleAction(opportunity: OpportunityCard, action: OpportunityAction) {
    if (action.id === "dismiss") {
      setDismissedIds((ids) => [...ids, opportunity.id]);
    }
    if (action.id === "report") {
      setReportedIds((ids) => [...ids, opportunity.id]);
    }
    if (action.id === "activate" && opportunity.requiredActivation) {
      if (opportunity.requiredActivation === "lestupid-waiting-app") {
        handleJoinQueue(selectedPlace.id, selectedPlace.name);
      } else if (opportunity.requiredActivation === "les-poke") {
        setActiveView("poke");
      } else if (opportunity.requiredActivation === "les-match") {
        setActiveView("match");
      } else if (opportunity.requiredActivation === "les-itemotel") {
        setActiveView("itemotel");
      } else if (opportunity.requiredActivation === "les-harmonica") {
        setActiveView("harmonica");
      }
    }
  }

  function handlePlaceOpen(place: PlaceOption) {
    setPlaceId(place.id);
    setSelectedMode(place.defaultMode);
    setDismissedIds([]);
    setFeedFilter("all");
    setActiveCommerceFacets([]);
    setBrowseTopics(false);
    setBrowseFeed(false);
    setShowSettings(false);
  }

  return (
    <div className={`app-container ${sidebarCollapsed ? "sidebar-collapsed" : ""}`}>
      {/* Sidebar Navigation */}
      <aside className={`sidebar-nav ${sidebarCollapsed ? "collapsed" : ""}`} aria-label="Main Navigation">
        <div className="sidebar-brand" style={{ justifyContent: sidebarCollapsed ? "center" : "space-between", width: "100%", padding: sidebarCollapsed ? "0" : "0 12px" }}>
          {!sidebarCollapsed && <div className="brand-logo">LesTupid</div>}
          {!sidebarCollapsed && <span className="brand-dot" />}
          <button
            className="sidebar-collapse-btn"
            onClick={() => setSidebarCollapsed(!sidebarCollapsed)}
            aria-label={sidebarCollapsed ? "Expand Sidebar" : "Collapse Sidebar"}
            title={sidebarCollapsed ? "Genişlet" : "Daralt"}
            style={{
              background: "none",
              border: "none",
              color: "var(--muted)",
              cursor: "pointer",
              padding: "6px",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              borderRadius: "8px",
              transition: "all 0.2s"
            }}
          >
            {sidebarCollapsed ? (
              <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round"><polyline points="9 18 15 12 9 6"/></svg>
            ) : (
              <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
            )}
          </button>
        </div>

        <nav className="nav-menu">
          <button
            className={`nav-item ${activeView === "hub" ? "active" : ""}`}
            onClick={() => setActiveView("hub")}
            data-label="Ecosystem Hub"
          >
            <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
            <span>Ecosystem Hub</span>
          </button>
          <button
            className={`nav-item ${activeView === "visual" ? "active" : ""}`}
            onClick={() => setActiveView("visual")}
            data-label="Visual Flows"
          >
            <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><rect x="3" y="4" width="18" height="14" rx="2"/><path d="M7 20h10M9 8h6M7 12h10"/></svg>
            <span>Visual Flows</span>
          </button>
          <button
            className={`nav-item ${activeView === "wait" ? "active" : ""}`}
            onClick={() => setActiveView("wait")}
            data-label="Les Wait (Queue)"
          >
            <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
            <span>Les Wait (Queue)</span>
          </button>
          <button
            className={`nav-item ${activeView === "poke" ? "active" : ""}`}
            onClick={() => setActiveView("poke")}
            data-label="Les Poke (Quests)"
          >
            <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
            <span>Les Poke (Quests)</span>
          </button>
          <button
            className={`nav-item ${activeView === "match" ? "active" : ""}`}
            onClick={() => setActiveView("match")}
            data-label="Les Match (Match)"
          >
            <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
            <span>Les Match (Match)</span>
          </button>
          <button
            className={`nav-item ${activeView === "itemotel" ? "active" : ""}`}
            onClick={() => setActiveView("itemotel")}
            data-label="Eşya Otelim"
          >
            <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
            <span>Eşya Otelim</span>
          </button>
          <button
            className={`nav-item ${activeView === "contacts" ? "active" : ""}`}
            onClick={() => setActiveView("contacts")}
            data-label="Les Contacts (CRM)"
          >
            <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><path d="M14 2v6h6"/><path d="M16 13H8M16 17H8M10 9H8"/></svg>
            <span>Les Contacts (CRM)</span>
          </button>
          <button
            className={`nav-item ${activeView === "care" ? "active" : ""}`}
            onClick={() => setActiveView("care")}
            data-label="Les Care (Health)"
          >
            <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
            <span>Les Care (Health)</span>
          </button>
          <button
            className={`nav-item ${activeView === "harmonica" ? "active" : ""}`}
            onClick={() => setActiveView("harmonica")}
            data-label="Proximity (Link)"
          >
            <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><path d="M12 2a10 10 0 1 0 10 10A10 10 0 0 0 12 2zm0 18a8 8 0 1 1 8-8 8 8 0 0 1-8 8z"/><path d="M12 6v6l4 2"/></svg>
            <span>Proximity (Link)</span>
          </button>
          <button
            className={`nav-item ${activeView === "oyun" ? "active" : ""}`}
            onClick={() => setActiveView("oyun")}
            data-label="Kart Oyunu"
          >
            <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><rect x="4" y="3" width="12" height="16" rx="2"/><path d="M8 7h4M8 11h5M8 15h3"/><path d="M18 7l2 10a2 2 0 0 1-2 2h-2"/></svg>
            <span>Kart Oyunu</span>
          </button>
          <button
            className={`nav-item ${activeView === "ai" ? "active" : ""}`}
            onClick={() => setActiveView("ai")}
            data-label="KADRO AI"
          >
            <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><rect x="3" y="11" width="18" height="10" rx="2"/><path d="M12 2v9M8 5h8"/></svg>
            <span>KADRO AI</span>
          </button>
          <button
            className={`nav-item ${activeView === "certification" ? "active" : ""}`}
            onClick={() => setActiveView("certification")}
            data-label="Selective Trust"
          >
            <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
            <span>Selective Trust</span>
          </button>
        </nav>
      </aside>

      {/* Main Content Area */}
      <main className="main-content">
        {activeView === "visual" && <VisualFlowGallery flows={visualDemoFlows} onOpenView={setActiveView} />}

        {activeView === "hub" && (
          <div className="app-shell">
            <section className="top-bar" aria-label="LesTupid Go status">
              <div>
                <p className="eyebrow">LesTupid Go</p>
                <h1>{modeHeadlines[activeMode]}</h1>
              </div>
              <div className="identity-card">
                <span className="status-dot" />
                <div>
                  <strong>{identity.label}</strong>
                  <span>{identity.status}</span>
                </div>
              </div>
            </section>

            <section className="place-home" aria-labelledby="place-title">
              <div className="place-hero">
                <span className="place-type">{selectedPlace.type.replace("_", " ")}</span>
                <h2 id="place-title">{selectedPlace.name}</h2>
                <p>{selectedPlace.headline}</p>
                <div className="mode-row" aria-label="Current mode">
                  {selectedPlace.modes.map((mode) => (
                    <button
                      className={mode === activeMode ? "mode-chip active" : "mode-chip"}
                      key={mode}
                      type="button"
                      onClick={() => {
                        setSelectedMode(mode);
                        setDismissedIds([]);
                        setFeedFilter("all");
                        setActiveCommerceFacets([]);
                      }}
                    >
                      {modeLabels[mode]}
                    </button>
                  ))}
                </div>
                <div className="place-meta">
                  <span>{selectedPlace.area}</span>
                  <span>{selectedPlace.distance}</span>
                  <span>{selectedPlace.signal}</span>
                  <span>{modeLabels[activeMode]} mode</span>
                </div>
              </div>

              <div className="place-actions-container">
                <div className="place-actions-row">
                  <button
                    className="primary-button check-in-btn"
                    type="button"
                    onClick={() => handleJoinQueue(selectedPlace.id, selectedPlace.name)}
                  >
                    {checkMarkIcon}
                    <span>Sıraya Gir</span>
                  </button>
                  <button
                    className={`settings-toggle-button ${showSettings ? "active" : ""}`}
                    type="button"
                    onClick={() => setShowSettings(!showSettings)}
                    aria-label="Gizlilik Ayarları"
                    title="Gizlilik Seçenekleri"
                  >
                    {settingsIcon}
                  </button>
                </div>

                <div className={`expanded-settings-panel ${showSettings ? "visible" : ""}`}>
                  <p className="settings-title">Privacy Level</p>
                  <div className="segmented-control" aria-label="Privacy level">
                    {privacyOptions.map((option) => (
                      <button
                        className={option.id === privacyLevel ? "segment active" : "segment"}
                        key={option.id}
                        type="button"
                        onClick={() => setPrivacyLevel(option.id)}
                      >
                        {option.label}
                      </button>
                    ))}
                  </div>
                </div>
              </div>
            </section>

            <section className="ai-crew-strip" aria-label="AI Crew">
              {aiCrew.map((member) => (
                <article className="ai-crew-card" key={member.source}>
                  <span>{member.source}</span>
                  <h3>{member.title}</h3>
                  <p>{member.text}</p>
                </article>
              ))}
            </section>

            <CvSnapshot profile={cvProfile} place={selectedPlace} mode={activeMode} />

            <section className="content-grid">
              <aside className="static-rail" aria-labelledby="places-title">
                <div className="rail-heading">
                  <div>
                    <p className="eyebrow">Nearby</p>
                    <h2 id="places-title">Places near me</h2>
                  </div>
                </div>

                <FilterRow
                  items={placeFilters}
                  activeId={placeFilter}
                  onPick={(id) => setPlaceFilter(id)}
                />

                <div className="place-list">
                  {nearbyPlaces.map((place) => (
                    <PlaceDoor
                      key={place.id}
                      place={place}
                      active={place.id === selectedPlace.id}
                      onOpen={handlePlaceOpen}
                    />
                  ))}
                </div>
                {visiblePlaces.length > nearbyPlacePreviewLimit ? (
                  <button
                    className="browse-button"
                    type="button"
                    onClick={() => setBrowsePlaces((value) => !value)}
                  >
                    {browsePlaces
                      ? "Show less places"
                      : `Browse ${visiblePlaces.length - nearbyPlacePreviewLimit} more places`}
                  </button>
                ) : null}

                <StatusGroup title="Apps" items={activeApps.map((app) => app.productId)} />
                <StatusGroup title="Channels" items={activeChannels.map((channel) => channel.channelId)} />
              </aside>

              <section className="feed-section" aria-labelledby="feed-title">
                <div className="feed-heading">
                  <div>
                    <p className="eyebrow">Flow & Opportunities</p>
                    <h2 id="feed-title">Focus on what matters now</h2>
                  </div>
                  {reportedIds.length > 0 ? (
                    <span className="report-pill">{reportedIds.length} report queued</span>
                  ) : null}
                </div>

                <section className="nearby-topics" aria-label="Nearby topics">
                  <div className="topic-heading">
                    <div>
                      <span>Nearby topics</span>
                      <strong>{visibleTopics.length} of {nearbyTopics.length}</strong>
                    </div>
                  </div>
                  <div className="topic-grid">
                    {visibleTopics.map((topic) => (
                      <button className={`topic-chip heat-${topic.heat}`} key={topic.id} type="button">
                        <span>{topic.label}</span>
                        <small>{topic.detail}</small>
                        <em>{topic.safety}</em>
                      </button>
                    ))}
                  </div>
                </section>

                <FilterRow
                  items={feedFilters}
                  activeId={feedFilter}
                  onPick={(id) => {
                    setFeedFilter(id);
                    setBrowseFeed(false);
                  }}
                />

                <CommerceFacetBar
                  activeFacets={activeCommerceFacets}
                  total={opportunities.length}
                  onToggle={toggleCommerceFacet}
                  onClear={() => setActiveCommerceFacets([])}
                />

                <div className="feed-stack">
                  <FlowIntro place={selectedPlace} mode={activeMode} />
                  {visibleOpportunities.map((opportunity) => (
                    <Opportunity
                      key={opportunity.id}
                      opportunity={opportunity}
                      onAction={handleAction}
                      activeCommerceFacets={activeCommerceFacets}
                      onCommerceFacetSelect={toggleCommerceFacet}
                    />
                  ))}
                  {opportunities.length === 0 ? (
                    <div className="empty-feed-card">
                      <strong>No cards match these commerce filters.</strong>
                      <span>Clear a facet or change the nearby context.</span>
                    </div>
                  ) : null}
                  {opportunities.length > feedPreviewLimit ? (
                    <button
                      className="browse-feed-button"
                      type="button"
                      onClick={() => setBrowseFeed((value) => !value)}
                    >
                      {browseFeed
                        ? "Show fewer cards"
                        : `Browse ${opportunities.length - feedPreviewLimit} more cards`}
                    </button>
                  ) : null}
                </div>
              </section>
            </section>
          </div>
        )}

        {/* 1. Les Wait Queue Simulator View */}
        {activeView === "wait" && (
          <div className="sim-container">
            <div className="sim-header">
              <h2>Les Wait Dashboard</h2>
              <p>Breathable wait states, active queue tracking, and smart arrival windows.</p>
            </div>

            <div className="wait-dashboard">
              <div>
                {waitTicket ? (
                  <div className="ticket-stub">
                    <div className="ticket-header">
                      <span>Sıra Bileti</span>
                      <span>{waitTicket.venueName}</span>
                    </div>
                    <div className="ticket-num">{waitTicket.ticketNumber}</div>
                    <div style={{ textAlign: "center", marginBottom: "16px" }}>
                      {waitTicket.status === "waiting" ? (
                        <p style={{ margin: 0, fontWeight: 700, color: "#fffaf1" }}>
                          Sıranız: <strong>{waitTicket.userPosition}.</strong> kişi
                        </p>
                      ) : waitTicket.status === "called" ? (
                        <p style={{ margin: 0, fontWeight: 900, color: "#ffe4a3" }}>
                          Sıranız Geldi! Kabul Masasına Geçin.
                        </p>
                      ) : (
                        <p style={{ margin: 0, color: "#ff8888" }}>Süreç tamamlandı.</p>
                      )}
                    </div>
                    {waitTicket.status === "waiting" && (
                      <div className="progress-circle-box" style={{ background: "rgba(255,255,255,0.08)" }}>
                        <span style={{ color: "#ffe4a3", fontSize: "11px", fontWeight: 800 }}>TAHMİNİ BEKLEME</span>
                        <div className="countdown-timer" style={{ color: "#ffffff" }}>
                          {waitTicket.estimatedMinutes} <small style={{ fontSize: "20px" }}>dk</small>
                        </div>
                        <button
                          className="action-button primary"
                          style={{ width: "100%", marginTop: "12px", background: "#ffffff", color: "#000000" }}
                          onClick={handleFastForwardQueue}
                        >
                          Sırayı İlerlet (-1 Kişi)
                        </button>
                      </div>
                    )}
                    <button
                      className="action-button secondary"
                      style={{ width: "100%", marginTop: "12px", background: "rgba(255,255,255,0.15)", color: "#ffffff", border: "0" }}
                      onClick={() => setWaitTicket(null)}
                    >
                      Bileti İptal Et
                    </button>
                  </div>
                ) : (
                  <div className="ticket-stub" style={{ background: "#f8f8f8", border: "1px dashed var(--line)", color: "var(--ink)", textAlign: "center" }}>
                    <p style={{ color: "var(--muted)", margin: "40px 0" }}>Aktif bir sıranız bulunmuyor.</p>
                  </div>
                )}
              </div>

              <div>
                <h3>Mekan Sırasına Katıl</h3>
                <p style={{ color: "var(--muted)", fontSize: "14px", marginBottom: "16px" }}>
                  Mevcut check-in noktalarından birini seçerek anında sanal kuyruğa katılabilirsiniz.
                </p>
                <div style={{ display: "grid", gap: "10px" }}>
                  {places
                    .filter((p) => p.modes.includes("service") || p.type === "canteen")
                    .map((p) => (
                      <div
                        key={p.id}
                        style={{
                          display: "flex",
                          justifyContent: spaceBetweenHelper(p),
                          alignItems: "center",
                          border: "1px solid var(--line)",
                          padding: "16px",
                          borderRadius: "12px"
                        }}
                      >
                        <div>
                          <strong>{p.name}</strong>
                          <div style={{ fontSize: "12px", color: "var(--muted)" }}>
                            Ortalama Yoğunluk: %{Math.floor(Math.random() * 40) + 50}
                          </div>
                        </div>
                        <button
                          className="action-button secondary"
                          onClick={() => handleJoinQueue(p.id, p.name)}
                        >
                          Sıraya Gir
                        </button>
                      </div>
                    ))}
                </div>
              </div>
            </div>
          </div>
        )}

        {/* 2. Les Poke Quest Simulator View */}
        {activeView === "poke" && (
          <div className="sim-container">
            <div className="sim-header">
              <h2>Les Poke (City Quests)</h2>
              <p>Safe real-world challenges, public coordinates check-ins, and local drop policies.</p>
            </div>

            <div className="poke-dashboard">
              <div>
                <div className="map-container">
                  <div className="map-grid-overlay" />
                  {quests.map((q) => (
                    <div
                      key={q.id}
                      className="map-marker"
                      style={{ left: `${q.coordinates.x}%`, top: `${q.coordinates.y}%` }}
                      onClick={() => setSelectedQuest(q)}
                    >
                      <div className={`marker-beacon ${q.status}`} />
                      <div className="marker-tooltip">{q.name}</div>
                    </div>
                  ))}
                </div>
                <div style={{ marginTop: "12px", display: "flex", justifyContent: "space-between", fontSize: "13px" }}>
                  <span>Seviye XP: <strong>{questXp}</strong></span>
                  <span style={{ color: "var(--green)" }}>Haritada 4 Quest Aktif</span>
                </div>
              </div>

              <div>
                {selectedQuest ? (
                  <div style={{ border: "1px solid var(--line)", padding: "20px", borderRadius: "16px" }}>
                    <span className="place-type" style={{ background: "var(--green)", color: "#fff" }}>
                      +{selectedQuest.xp} XP
                    </span>
                    <h3 style={{ marginTop: "10px" }}>{selectedQuest.name}</h3>
                    <p style={{ fontSize: "14px", color: "var(--ink)", lineHeight: 1.4 }}>
                      {selectedQuest.detail}
                    </p>
                    <div style={{ margin: "16px 0", fontSize: "12px", color: "var(--muted)" }}>
                      Konum ID: <code>{selectedQuest.placeId}</code>
                    </div>

                    {selectedQuest.status === "completed" ? (
                      <div style={{ background: "rgba(101, 201, 143, 0.1)", color: "var(--green)", padding: "12px", borderRadius: "8px", fontWeight: 700, textAlign: "center" }}>
                        ✓ Görev Başarıyla Tamamlandı
                      </div>
                    ) : (
                      <button
                        className="action-button primary"
                        style={{ width: "100%" }}
                        onClick={handleSimulateGps}
                        disabled={simulatingGps}
                      >
                        {simulatingGps ? "GPS Doğrulanıyor..." : "Konumda Check-in Yap (GPS Simüle)"}
                      </button>
                    )}
                  </div>
                ) : (
                  <div style={{ textAlign: "center", color: "var(--muted)", padding: "40px 0" }}>
                    Quest detayları için haritadaki noktalara tıklayın.
                  </div>
                )}
              </div>
            </div>
          </div>
        )}

        {/* 3. Les Match Simulator View */}
        {activeView === "match" && (
          <div className="sim-container">
            <div className="sim-header">
              <h2>Les Match (Matchmaking)</h2>
              <p>Consent-first discovery, pseudonym listings, and certified interest matching.</p>
            </div>

            {activeChatMatch ? (
              <div style={{ border: "1px solid var(--line)", borderRadius: "16px", overflow: "hidden", display: "flex", flexDirection: "column", height: "460px" }}>
                <div style={{ background: "var(--ink)", color: "#fff", padding: "16px", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                  <div>
                    <strong>{activeChatMatch.pseudonym}</strong>
                    <div style={{ fontSize: "11px", opacity: 0.8 }}>Secure Channel [Açık Bağlantı]</div>
                  </div>
                  <button
                    className="action-button secondary"
                    style={{ padding: "6px 12px", minHeight: "auto", background: "rgba(255,255,255,0.15)", color: "#fff", border: "0" }}
                    onClick={() => {
                      setActiveChatMatch(null);
                      setMatchChatHistory([]);
                    }}
                  >
                    Kapat
                  </button>
                </div>
                <div style={{ flex: 1, padding: "16px", overflowY: "auto", display: "flex", flexDirection: "column", gap: "10px", background: "#f9f9f9" }}>
                  <div style={{ fontSize: "11px", color: "var(--muted)", textAlign: "center", fontStyle: "italic" }}>
                    Eşleşme sağlandı. Bu kanal geçici bir önizlemedir.
                  </div>
                  {matchChatHistory.map((m, idx) => (
                    <div
                      key={idx}
                      style={{
                        alignSelf: m.startsWith("Sen:") ? "flex-end" : "flex-start",
                        background: m.startsWith("Sen:") ? "var(--ink)" : "#ffffff",
                        color: m.startsWith("Sen:") ? "#ffffff" : "var(--ink)",
                        padding: "10px 14px",
                        borderRadius: "12px",
                        boxShadow: "0 2px 4px rgba(0,0,0,0.04)",
                        maxWidth: "80%"
                      }}
                    >
                      {m.replace(/^(Sen:|[^:]+:)/, "")}
                    </div>
                  ))}
                </div>
                <form onSubmit={handleSendMatchMsg} style={{ display: "flex", borderTop: "1px solid var(--line)" }}>
                  <input
                    type="text"
                    placeholder="Güvenli mesaj yaz..."
                    value={matchChatMsg}
                    onChange={(e) => setMatchChatMsg(e.target.value)}
                    style={{ flex: 1, border: "0", padding: "16px", outline: "none" }}
                  />
                  <button className="action-button primary" style={{ borderRadius: "0", minHeight: "auto" }}>
                    Gönder
                  </button>
                </form>
              </div>
            ) : (
              <div className="matchmaker-suite">
                <div className="swipe-deck">
                  {matchProfiles.map((p, idx) => {
                    if (idx !== matchIndex) return null;
                    return (
                      <div className="swipe-card" key={p.id}>
                        <div>
                          <div className="match-avatar-circle">👤</div>
                          <h2>{p.pseudonym}</h2>
                          <div style={{ color: "var(--muted)", fontSize: "13px", marginBottom: "12px" }}>
                            Uzaklık: {p.distance}
                          </div>
                          <div className="pill-row" style={{ justifyContent: "center", marginBottom: "14px" }}>
                            {p.tags.map((t) => (
                              <span key={t} className="pill" style={{ background: "rgba(18,22,25,0.04)" }}>
                                {t}
                              </span>
                            ))}
                          </div>
                          <p style={{ fontSize: "14px", color: "var(--muted)", lineHeight: 1.4 }}>
                            {p.description}
                          </p>
                        </div>

                        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "12px" }}>
                          <button
                            className="action-button secondary"
                            onClick={() => handleMatchChoice(false)}
                          >
                            Geç (Skip)
                          </button>
                          <button
                            className="action-button primary"
                            style={{ background: "var(--red)" }}
                            onClick={() => handleMatchChoice(true)}
                          >
                            İlgi Göster (Like)
                          </button>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            )}

            {showMatchPopup && (
              <div className="match-popup">
                <div className="match-popup-content">
                  <div className="match-pulse-ring">💖</div>
                  <h2>Karşılıklı İlgi!</h2>
                  <p style={{ color: "var(--muted)", fontSize: "14px", marginBottom: "24px" }}>
                    <strong>{matchProfiles[matchIndex]?.pseudonym}</strong> da seninle eşleşmek istiyor. Güvenli sohbete geçebilirsiniz.
                  </p>
                  <div style={{ display: "grid", gap: "10px" }}>
                    <button
                      className="action-button primary"
                      onClick={() => {
                        setActiveChatMatch(matchProfiles[matchIndex]!);
                        setShowMatchPopup(false);
                      }}
                    >
                      Mesaj Gönder
                    </button>
                    <button
                      className="action-button secondary"
                      onClick={() => {
                        setShowMatchPopup(false);
                        setMatchIndex((prev) => (prev + 1) % matchProfiles.length);
                      }}
                    >
                      Sonra (Kapat)
                    </button>
                  </div>
                </div>
              </div>
            )}
          </div>
        )}

        {/* 4. Les Commerce & Item Otel View */}
        {activeView === "itemotel" && (
          <div className="sim-container">
            <div className="sim-header">
              <h2>Les Item Otel</h2>
              <p>Circular commerce workspace: personal items storage, care, and active listings.</p>
            </div>

            <div className="itemotel-dashboard">
              <div className="itemotel-stats-grid">
                <div className="stat-card">
                  <span className="stat-num">{items.length}</span>
                  <span className="stat-label">Toplam Eşya</span>
                </div>
                <div className="stat-card">
                  <span className="stat-num">{items.filter((i) => i.status.startsWith("listed")).length}</span>
                  <span className="stat-label">Aktif İlan</span>
                </div>
                <div className="stat-card">
                  <span className="stat-num">450 TL</span>
                  <span className="stat-label">Pasif Gelir</span>
                </div>
              </div>

              <div className="itemotel-actions-header">
                <h3>Kişisel Eşya Depom</h3>
                <button
                  className="action-button primary"
                  onClick={() => setShowNewItemForm(!showNewItemForm)}
                  type="button"
                >
                  {showNewItemForm ? "Formu Kapat" : "Yeni Eşya Gönder"}
                </button>
              </div>

              {showNewItemForm && (
                <form onSubmit={handleCreateItem} className="itemotel-new-item-form">
                  <h4>Yeni Eşya Kabul Talebi</h4>
                  <div className="form-group">
                    <label htmlFor="item-name">Eşya Adı</label>
                    <input
                      type="text"
                      id="item-name"
                      placeholder="Örn: Pro-Ride Kayak Takımı"
                      value={newItemName}
                      onChange={(e) => setNewItemName(e.target.value)}
                      required
                    />
                  </div>
                  <div className="form-group">
                    <label htmlFor="item-category">Kategori</label>
                    <select
                      id="item-category"
                      value={newItemCategory}
                      onChange={(e: any) => setNewItemCategory(e.target.value)}
                    >
                      <option value="sports">Spor Ekipmanı</option>
                      <option value="automotive">Otomotiv / Lastik</option>
                      <option value="wedding">Gelinlik & Özel Gün</option>
                      <option value="apparel">Giyim / Sezonluk Dolap</option>
                      <option value="other">Diğer</option>
                    </select>
                  </div>
                  <button type="submit" className="action-button primary">Depolama İçin Gönder</button>
                </form>
              )}

              {loadingItems && <p className="loading-text">Eşya listesi güncelleniyor...</p>}

              <div className="itemotel-grid">
                {items.map((item) => {
                  const isExpanded = expandedItemId === item.id;
                  const activeListing = item.listing;

                  return (
                    <article key={item.id} className={`itemotel-card ${item.status} ${isExpanded ? "expanded" : ""}`}>
                      <button
                        className="card-expand-toggle"
                        onClick={() => setExpandedItemId(isExpanded ? null : item.id)}
                        aria-label="Toggle details"
                        type="button"
                      >
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" strokeWidth="3" fill="none" strokeLinecap="round" strokeLinejoin="round" className="plus-icon"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                      </button>

                      <div className="itemotel-card-header">
                        <span className={`status-badge status-${item.status}`}>
                          {item.status.replace(/_/g, " ")}
                        </span>
                        <h3>{item.name}</h3>
                        <p className="item-cat-label">{item.category.toUpperCase()}</p>
                      </div>

                      {isExpanded && (
                        <div className="itemotel-card-details">
                          <hr className="details-divider" />

                          <div className="details-meta-grid">
                            <div className="meta-item">
                              <span className="meta-label">Depo Konumu</span>
                              <span className="meta-val">{item.storage_location || "Yolda / Sevk Ediliyor"}</span>
                            </div>
                            <div className="meta-item">
                              <span className="meta-label">Kondisyon Skoru</span>
                              <span className="meta-val">{item.condition_rating ? `${item.condition_rating}/10` : "Belirlenmedi"}</span>
                            </div>
                          </div>

                          {/* Care logs section */}
                          <div className="details-section">
                            <h4 className="section-title">Bakım & Koruma Geçmişi</h4>
                            {item.care_logs && item.care_logs.length > 0 ? (
                              <div className="care-logs-list">
                                {item.care_logs.map((log) => (
                                  <div key={log.id} className="care-log-item">
                                    <div className="care-log-header">
                                      <strong>{log.care_type.replace(/_/g, " ").toUpperCase()}</strong>
                                      <span>{new Date(log.performed_at).toLocaleDateString()}</span>
                                    </div>
                                    {log.notes && <p className="care-log-notes">{log.notes}</p>}
                                    <div className="care-log-meta">
                                      <span>Yapan: {log.provider_id || "Sistem"}</span>
                                      {log.certificate_id && (
                                        <span className="cert-pill">✓ Sertifikalı: {log.certificate_id}</span>
                                      )}
                                    </div>
                                  </div>
                                ))}
                              </div>
                            ) : (
                              <p className="no-data-text">Henüz yapılmış bir bakım kaydı bulunmuyor.</p>
                            )}
                          </div>

                          {/* Request care form */}
                          {item.status !== "shipped_back" && item.status !== "sold" && (
                            <div className="details-section care-request-section">
                              <h4 className="section-title">Profesyonel Bakım Siparişi</h4>
                              <div className="care-request-form">
                                <select
                                  value={careTypeInput[item.id] || "general_maintenance"}
                                  onChange={(e) => setCareTypeInput((prev) => ({ ...prev, [item.id]: e.target.value }))}
                                >
                                  <option value="general_maintenance">Genel Kontrol & Bakım</option>
                                  <option value="cleaning">Kuru Temizleme / Yıkama</option>
                                  <option value="repair">Profesyonel Onarım</option>
                                  {item.category === "sports" && <option value="waxing">Waxing & Cila</option>}
                                  {item.category === "automotive" && <option value="tire_rotation">Lastik Rotasyonu & Balans</option>}
                                </select>
                                <input
                                  type="text"
                                  placeholder="Özel istekleriniz veya notlar..."
                                  value={careNotesInput[item.id] || ""}
                                  onChange={(e) => setCareNotesInput((prev) => ({ ...prev, [item.id]: e.target.value }))}
                                />
                                <button
                                  className="action-button secondary"
                                  onClick={() => handleCare(item.id)}
                                  type="button"
                                >
                                  Bakım Siparişi Ver
                                </button>
                              </div>
                            </div>
                          )}

                          {/* Circular commerce management */}
                          <div className="details-section monetization-section">
                            <h4 className="section-title">Döngüsel Ticaret ve Monetizasyon</h4>

                            {activeListing ? (
                              <div className="active-listing-info">
                                <p>
                                  İlan Aktif: <strong>{activeListing.listing_type.toUpperCase()}</strong>
                                  {activeListing.price_rent_daily && <span> - Günlük Kira: {activeListing.price_rent_daily} TL</span>}
                                  {activeListing.price_sale && <span> - Satış Bedeli: {activeListing.price_sale} TL</span>}
                                </p>
                                <button
                                  className="action-button warning"
                                  onClick={() => handleUnlist(item.id)}
                                  type="button"
                                >
                                  İlandan Kaldır
                                </button>
                              </div>
                            ) : (
                              item.status !== "shipped_back" && item.status !== "sold" && (
                                <div className="listing-setup-form">
                                  <div className="form-row">
                                    <label>Listeleme Türü</label>
                                    <select
                                      value={listTypeInput[item.id] || "rent"}
                                      onChange={(e: any) => setListTypeInput((prev) => ({ ...prev, [item.id]: e.target.value }))}
                                    >
                                      <option value="rent">Kirala (Pasif Gelir)</option>
                                      <option value="sale">Doğrudan Sat</option>
                                      <option value="both">İkisi De (Hem Sat hem Kirala)</option>
                                    </select>
                                  </div>

                                  {(listTypeInput[item.id] === "sale" || listTypeInput[item.id] === "both") && (
                                    <div className="form-row">
                                      <label>Satış Fiyatı (TL)</label>
                                      <input
                                        type="number"
                                        placeholder="Satış Bedeli Girin"
                                        value={priceSaleInput[item.id] || ""}
                                        onChange={(e) => setPriceSaleInput((prev) => ({ ...prev, [item.id]: e.target.value }))}
                                      />
                                    </div>
                                  )}

                                  {(listTypeInput[item.id] === "rent" || listTypeInput[item.id] === "both" || !listTypeInput[item.id]) && (
                                    <div className="form-row">
                                      <label>Günlük Kira Bedeli (TL)</label>
                                      <input
                                        type="number"
                                        placeholder="Kira Bedeli Girin"
                                        value={priceRentInput[item.id] || ""}
                                        onChange={(e) => setPriceRentInput((prev) => ({ ...prev, [item.id]: e.target.value }))}
                                      />
                                    </div>
                                  )}

                                  <button
                                    className="action-button primary"
                                    onClick={() => handleList(item.id)}
                                    type="button"
                                  >
                                    Pazaryerinde Yayına Al
                                  </button>
                                </div>
                              )
                            )}
                          </div>

                          {/* Retrieval / Recall action */}
                          {item.status !== "shipped_back" && item.status !== "sold" && (
                            <div className="details-section recall-section">
                              <h4 className="section-title">Eşyayı Geri Çağır (İade)</h4>
                              <p className="info-text">Eşyanız depodan alınarak kurye ile kayıtlı adresinize teslim edilecektir.</p>
                              <button
                                className="action-button secondary"
                                onClick={() => handleRecall(item.id)}
                                type="button"
                              >
                                Adresime Gönderilmesini İstiyorum
                              </button>
                            </div>
                          )}
                        </div>
                      )}
                    </article>
                  );
                })}
              </div>
            </div>
          </div>
        )}

        {/* 5. Les Contacts Private CRM View */}
        {activeView === "contacts" && (
          <div className="sim-container">
            <div className="sim-header">
              <h2>Les Contacts (Private CRM)</h2>
              <p>Context-separated private timeline logs, interactions, and safe place memories.</p>
            </div>

            <div style={{ display: "grid", gridTemplateColumns: "360px 1fr", gap: "28px" }}>
              <div>
                <h3>Yeni Hafıza Ekle</h3>
                <form onSubmit={handleAddCrmLog} style={{ display: "flex", flexDirection: "column", gap: "12px", marginTop: "12px" }}>
                  <div className="form-group">
                    <label>Mekan/Yer</label>
                    <input
                      type="text"
                      placeholder="Örn: Canteen, Kütüphane"
                      value={newCrmPlace}
                      onChange={(e) => setNewCrmPlace(e.target.value)}
                    />
                  </div>
                  <div className="form-group">
                    <label>Bağlam (Context)</label>
                    <select
                      value={newCrmContext}
                      onChange={(e: any) => setNewCrmContext(e.target.value)}
                    >
                      <option value="personal">Kişisel (Personal)</option>
                      <option value="work">İş (Work)</option>
                      <option value="social">Sosyal (Social)</option>
                      <option value="travel">Seyahat (Travel)</option>
                    </select>
                  </div>
                  <div className="form-group">
                    <label>Özel Notlar</label>
                    <textarea
                      placeholder="Gizli notların..."
                      value={newCrmNotes}
                      onChange={(e) => setNewCrmNotes(e.target.value)}
                      style={{ padding: "10px", borderRadius: "8px", border: "1px solid var(--line)", minHeight: "80px", resize: "none" }}
                      required
                    />
                  </div>
                  <button className="action-button primary"> CRM Belleğine Kaydet </button>
                </form>
              </div>

              <div>
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "16px" }}>
                  <h3>Timeline Akışı</h3>
                  <select
                    value={crmFilter}
                    onChange={(e: any) => setCrmFilter(e.target.value)}
                    style={{ padding: "6px 12px", borderRadius: "6px", border: "1px solid var(--line)" }}
                  >
                    <option value="all">Filtrele: Tümü</option>
                    <option value="personal">Kişisel</option>
                    <option value="work">İş</option>
                    <option value="social">Sosyal</option>
                    <option value="travel">Seyahat</option>
                  </select>
                </div>

                <div className="crm-timeline">
                  {crmLogs
                    .filter((log) => crmFilter === "all" || log.context === crmFilter)
                    .map((log) => (
                      <div className="crm-timeline-item" key={log.id}>
                        <div className="crm-timeline-dot" />
                        <div className="crm-timeline-content">
                          <div className="crm-timeline-header">
                            <span>{log.placeName}</span>
                            <span>{log.date}</span>
                          </div>
                          <p style={{ margin: "6px 0", fontSize: "14px", color: "var(--ink)", lineHeight: 1.4 }}>
                            {log.notes}
                          </p>
                          <div style={{ display: "flex", justifyContent: "space-between", fontSize: "11px", color: "var(--muted)", fontWeight: 700 }}>
                            <span style={{ textTransform: "uppercase" }}>{log.context}</span>
                            {log.people && <span>Kişi: {log.people}</span>}
                          </div>
                        </div>
                      </div>
                    ))}
                </div>
              </div>
            </div>
          </div>
        )}

        {/* 6. Les Care Health View */}
        {activeView === "care" && (
          <div className="sim-container">
            <div className="sim-header">
              <h2>Les Care (Safe Health Support)</h2>
              <p>Pseudonymous health routing, emergency certified alarms, and verified first-aid guidance.</p>
            </div>

            <div style={{ display: "grid", gridTemplateColumns: "1fr 340px", gap: "28px" }}>
              <div>
                <div className="form-group" style={{ marginBottom: "20px" }}>
                  <input
                    type="text"
                    placeholder="İlk yardım konularını ara (Örn: bayılma, kesik, yanık)..."
                    value={careSearch}
                    onChange={(e) => setCareSearch(e.target.value)}
                    style={{ width: "100%", padding: "12px", borderRadius: "10px", border: "1px solid var(--line)" }}
                  />
                </div>

                <h3>Doğrulanmış İlk Yardım Kılavuzu</h3>
                <div style={{ display: "grid", gap: "12px", marginTop: "12px" }}>
                  {firstAidGuides
                    .filter((g) => g.title.toLowerCase().includes(careSearch.toLowerCase()) || g.steps.toLowerCase().includes(careSearch.toLowerCase()))
                    .map((g, idx) => (
                      <div key={idx} style={{ border: "1px solid var(--line)", padding: "16px", borderRadius: "12px" }}>
                        <span className="place-type" style={{ background: "rgba(217, 79, 69, 0.1)", color: "var(--red)" }}>
                          Önemli Rehber
                        </span>
                        <h4 style={{ marginTop: "10px", fontSize: "16px" }}>{g.title}</h4>
                        <p style={{ fontSize: "13px", color: "var(--muted)", lineHeight: 1.4, margin: "8px 0 0" }}>
                          {g.steps}
                        </p>
                      </div>
                    ))}
                </div>
              </div>

              <div>
                <div className={`care-emergency-panel ${emergencyActive ? "active" : ""}`}>
                  <h3 style={{ margin: 0, color: emergencyActive ? "var(--red)" : "var(--ink)", textAlign: "center" }}>
                    {emergencyActive ? "🚨 ACİL ALARM AKTİF" : "Acil Durum Paneli"}
                  </h3>
                  <p style={{ fontSize: "13px", color: "var(--muted)", textAlign: "center", lineHeight: 1.4 }}>
                    {emergencyActive
                      ? "Çevredeki en yakın sertifikalı ilk yardım ekibine konumsuz acil durum çağrısı ve kimliksiz tıbbi kartınız yayınlanıyor."
                      : "Gerektiğinde yakın mesafedeki sertifikalı öğrencilere veya görevlilere anonim tıbbi çağrı yapın."}
                  </p>

                  {emergencyActive ? (
                    <>
                      <div className="zkp-qr-container">
                        <div className="zkp-qr-mock">
                          {Array.from({ length: 144 }).map((_, idx) => (
                            <div
                              key={idx}
                              className={`qr-dot ${Math.sin(idx * 0.9) > 0.1 ? "off" : ""}`}
                              style={{ background: "var(--red)" }}
                            />
                          ))}
                        </div>
                      </div>
                      <div style={{ textAlign: "center", fontSize: "11px", fontWeight: 700, color: "var(--red)" }}>
                        TIBBİ BARKOD (ZKP)
                      </div>
                      <button
                        className="action-button secondary"
                        style={{ width: "100%" }}
                        onClick={() => setEmergencyActive(false)}
                      >
                        Çağrıyı Sonlandır
                      </button>
                    </>
                  ) : (
                    <button
                      className="action-button primary"
                      style={{ background: "var(--red)", width: "100%" }}
                      onClick={() => setEmergencyActive(true)}
                    >
                      Acil Durum Çağrısı Yap
                    </button>
                  )}
                </div>
              </div>
            </div>
          </div>
        )}

        {/* 7. Les Harmonica Proximity scanner View */}
        {activeView === "harmonica" && (
          <div className="sim-container">
            <div className="sim-header">
              <h2>Les Harmonica (Secure Handoff)</h2>
              <p>Domain-scoped pairwise credential exchanges, peer pairing, and ephemeral messaging.</p>
            </div>

            <div style={{ display: "grid", gridTemplateColumns: "360px 1fr", gap: "28px" }}>
              <div>
                <div className="harmonica-radar">
                  <div className="radar-beam" style={{ display: scanning ? "block" : "none" }} />
                  <div className="radar-circle circle-1" />
                  <div className="radar-circle circle-2" />
                  <div className="radar-circle circle-3" />

                  {/* Device dots */}
                  {!scanning &&
                    harmonicaDevices.map((d, idx) => {
                      const offsets = [
                        { left: "30%", top: "40%" },
                        { left: "70%", top: "30%" },
                        { left: "55%", top: "75%" }
                      ];
                      return (
                        <div
                          key={d.id}
                          className="radar-ping"
                          style={{ ...offsets[idx], background: d.paired ? "var(--green)" : "var(--yellow)" }}
                          onClick={() => setPairedDevice(d)}
                        />
                      );
                    })}
                </div>

                <button
                  className="action-button primary"
                  style={{ width: "100%", background: "var(--teal)" }}
                  onClick={handleRadarScan}
                  disabled={scanning}
                >
                  {scanning ? "Güvenli Yakınlık Taranıyor..." : "Yakındaki Cihazları Tara"}
                </button>
              </div>

              <div>
                {pairedDevice ? (
                  <div style={{ border: "1px solid var(--line)", padding: "20px", borderRadius: "16px" }}>
                    <h3>{pairedDevice.name}</h3>
                    <div style={{ fontSize: "11px", color: "var(--muted)" }}>
                      Sinyal Gücü: %{pairedDevice.signalStrength} | Kamu Anahtarı: <code>{pairedDevice.publicKey}</code>
                    </div>

                    {pairedDevice.paired ? (
                      <div style={{ marginTop: "16px" }}>
                        <div style={{ background: "#f5f5f5", padding: "12px", borderRadius: "8px", minHeight: "100px", marginBottom: "12px", maxHeight: "160px", overflowY: "auto" }}>
                          <p style={{ fontSize: "11px", color: "var(--muted)", margin: "0 0 8px", textAlign: "center" }}>
                            Geçici pairwise oturumu açıldı. Mesajlar yerel olarak yok edilir.
                          </p>
                          {secChatHistory.map((m, idx) => (
                            <div key={idx} style={{ fontSize: "13px", margin: "4px 0" }}>
                              {m}
                            </div>
                          ))}
                        </div>
                        <form onSubmit={handleSendSecureMsg} style={{ display: "flex", gap: "10px" }}>
                          <input
                            type="text"
                            placeholder="Pairwise kanalıyla şifreli ilet..."
                            value={secChatMsg}
                            onChange={(e) => setSecChatMsg(e.target.value)}
                            style={{ flex: 1, padding: "8px 12px", border: "1px solid var(--line)", borderRadius: "8px" }}
                          />
                          <button className="action-button primary" style={{ minHeight: "auto" }}>
                            Gönder
                          </button>
                        </form>
                      </div>
                    ) : (
                      <div style={{ marginTop: "16px" }}>
                        <p style={{ fontSize: "13px", color: "var(--muted)", lineHeight: 1.4 }}>
                          Bu cihazla el sıkışma (handoff) başlatarak pseudonymous pairwise anahtar alışverişi yapabilirsiniz.
                        </p>
                        <button
                          className="action-button primary"
                          style={{ width: "100%", marginTop: "12px" }}
                          onClick={() => {
                            setHarmonicaDevices((prev) =>
                              prev.map((d) => (d.id === pairedDevice.id ? { ...d, paired: true } : d))
                            );
                            setPairedDevice({ ...pairedDevice, paired: true });
                          }}
                        >
                          Pairwise Bağlantıyı Onayla
                        </button>
                      </div>
                    )}
                  </div>
                ) : (
                  <div style={{ textAlign: "center", color: "var(--muted)", padding: "60px 0" }}>
                    Bağlantı kurmak için soldaki radarda bulunan bir sinyal noktasına tıklayın.
                  </div>
                )}
              </div>
            </div>
          </div>
        )}

        {/* 8. Les Affiliate Oyun Card Game View */}
        {activeView === "oyun" && (
          <div className="sim-container">
            <div className="sim-header">
              <h2>Les Affiliate Oyun (Card Game)</h2>
              <p>Social commerce card battles, quest item modifiers, and certified gaming economy.</p>
            </div>

            <div className="duel-arena">
              <div className="arena-grid">
                <div className="arena-player">
                  <strong>Sen (Player)</strong>
                  <div className="health-bar">
                    <div className="health-bar-fill" style={{ width: `${playerHp}%` }} />
                  </div>
                  <div style={{ fontSize: "12px", marginTop: "4px" }}>HP: {playerHp}/100</div>
                </div>

                <div style={{ fontSize: "20px", fontWeight: 900 }}>VS</div>

                <div className="arena-player">
                  <strong>AI Rakipler</strong>
                  <div className="health-bar">
                    <div
                      className={`health-bar-fill ${aiHp < 30 ? "warning" : ""}`}
                      style={{ width: `${aiHp}%` }}
                    />
                  </div>
                  <div style={{ fontSize: "12px", marginTop: "4px" }}>HP: {aiHp}/100</div>
                </div>
              </div>

              {winnerMessage ? (
                <div style={{ background: "rgba(255, 255, 255, 0.1)", padding: "24px", borderRadius: "12px", textAlign: "center", marginBottom: "16px" }}>
                  <h3 style={{ margin: 0 }}>{winnerMessage}</h3>
                  <button
                    className="action-button primary"
                    style={{ marginTop: "12px" }}
                    onClick={() => {
                      setPlayerHp(100);
                      setAiHp(100);
                      setGameLogs([]);
                      setWinnerMessage(null);
                      setDuelActive(true);
                    }}
                  >
                    Yeni Oyun Başlat
                  </button>
                </div>
              ) : duelActive ? (
                <div>
                  <div style={{ background: "rgba(0,0,0,0.3)", padding: "12px", borderRadius: "8px", height: "100px", overflowY: "auto", fontSize: "12px", color: "#aaa", marginBottom: "20px", display: "flex", flexDirection: "column-reverse" }}>
                    {gameLogs.map((log, idx) => (
                      <div key={idx} style={{ margin: "2px 0" }}>
                        {log}
                      </div>
                    ))}
                  </div>

                  <h4 style={{ textAlign: "center", margin: "0 0 10px", fontSize: "13px" }}>Oynamak İçin Bir Kart Seç</h4>
                  <div className="game-card-fan">
                    {oyunHand.map((card) => (
                      <button
                        className={`game-card ${card.rarity}`}
                        key={card.id}
                        onClick={() => handleOyunCardPlay(card)}
                      >
                        <div style={{ fontSize: "24px", textAlign: "center" }}>{card.image}</div>
                        <div style={{ fontSize: "10px", fontWeight: 800, textAlign: "center" }}>{card.name}</div>
                        <div className="game-card-stats">
                          <span style={{ color: "var(--red)" }}>ATK:{card.power}</span>
                          <span style={{ color: "var(--green)" }}>DEF:{card.defense}</span>
                        </div>
                      </button>
                    ))}
                  </div>
                </div>
              ) : (
                <div style={{ textAlign: "center", padding: "40px 0" }}>
                  <p style={{ color: "#aaa" }}>Desten hazır: 3 adet affiliate ve quest kartı aktif.</p>
                  <button
                    className="action-button primary"
                    onClick={() => setDuelActive(true)}
                  >
                    Düello Arenasını Başlat
                  </button>
                </div>
              )}
            </div>
          </div>
        )}

        {/* 9. Les AI / KADRO View */}
        {activeView === "ai" && (
          <div className="sim-container">
            <div className="sim-header">
              <h2>KADRO AI Agents</h2>
              <p>Interact with certified AI workers, review tasks drafts, and compile CV signals.</p>
            </div>

            <div style={{ display: "grid", gridTemplateColumns: "320px 1fr", gap: "28px" }}>
              <div>
                <h3>Ajan Kadrosu</h3>
                <div style={{ display: "grid", gap: "10px", marginTop: "12px" }}>
                  {mockKadroAgents.map((agent) => (
                    <div
                      key={agent.id}
                      onClick={() => {
                        setSelectedAgent(agent);
                        setAiConsoleContent("");
                        setAiOutputReady(false);
                      }}
                      style={{
                        padding: "14px",
                        border: "1px solid var(--line)",
                        borderRadius: "12px",
                        cursor: "pointer",
                        background: selectedAgent.id === agent.id ? "rgba(32,117,111,0.05)" : "var(--surface)",
                        borderColor: selectedAgent.id === agent.id ? "var(--teal)" : "var(--line)"
                      }}
                    >
                      <div style={{ display: "flex", gap: "10px", alignItems: "center" }}>
                        <span style={{ fontSize: "24px" }}>{agent.avatar}</span>
                        <div>
                          <strong>{agent.name}</strong>
                          <div style={{ fontSize: "11px", color: "var(--muted)" }}>{agent.role}</div>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              <div>
                <div style={{ border: "1px solid var(--line)", padding: "20px", borderRadius: "16px" }}>
                  <h3>{selectedAgent.name} ile Oturum</h3>
                  <p style={{ fontSize: "13px", color: "var(--muted)", margin: "4px 0 16px" }}>
                    {selectedAgent.bio}
                  </p>

                  <form onSubmit={handleSendAiPrompt} style={{ display: "flex", gap: "10px", marginBottom: "16px" }}>
                    <input
                      type="text"
                      placeholder={`${selectedAgent.name} için bir talimat yaz...`}
                      value={aiPrompt}
                      onChange={(e) => setAiPrompt(e.target.value)}
                      style={{ flex: 1, padding: "10px 14px", border: "1px solid var(--line)", borderRadius: "8px" }}
                      disabled={isAiTyping}
                    />
                    <button className="action-button primary" disabled={isAiTyping}>
                      Çalıştır
                    </button>
                  </form>

                  <strong>Ajan Konsol Çıktısı [Simüle]:</strong>
                  <div className="ai-terminal">
                    <pre style={{ margin: 0, whiteSpace: "pre-wrap" }}>
                      {aiConsoleContent || "Talebinizi bekliyor..."}
                    </pre>
                  </div>

                  {aiOutputReady && (
                    <button
                      className="action-button primary"
                      style={{ width: "100%", marginTop: "16px", background: "var(--teal)" }}
                      onClick={handleExportAiDraftToCv}
                    >
                      Bu Taslağı Living CV'ye Ekle (Export)
                    </button>
                  )}
                </div>
              </div>
            </div>
          </div>
        )}

        {/* 10. Les Certification ZKP View */}
        {activeView === "certification" && (
          <div className="sim-container">
            <div className="sim-header">
              <h2>Selective Disclosure & ZKP</h2>
              <p>Select credentials to compile dynamic ZKP tokens with complete identity privacy.</p>
            </div>

            <div style={{ display: "grid", gridTemplateColumns: "1fr 340px", gap: "28px" }}>
              <div>
                <h3>Güvenilir Kimlik Bilgilerim</h3>
                <p style={{ fontSize: "14px", color: "var(--muted)", marginBottom: "16px" }}>
                  İstediğiniz bilginin yanındaki onay kutusunu işaretleyerek veya kaldırarak sadece ilgili verilerin ZKP QR koduna eklenmesini sağlayabilirsiniz.
                </p>

                <div style={{ display: "flex", flexDirection: "column", gap: "12px" }}>
                  {zkpCredentials.map((cred) => (
                    <div
                      key={cred.id}
                      style={{
                        display: "flex",
                        alignItems: "center",
                        gap: "14px",
                        border: "1px solid var(--line)",
                        padding: "16px",
                        borderRadius: "12px",
                        background: cred.hidden ? "rgba(18,22,25,0.02)" : "var(--surface)",
                        opacity: cred.hidden ? 0.6 : 1
                      }}
                    >
                      <input
                        type="checkbox"
                        checked={!cred.hidden}
                        onChange={() => {
                          setZkpCredentials((prev) =>
                            prev.map((c) => (c.id === cred.id ? { ...c, hidden: !c.hidden } : c))
                          );
                          setQrSeed(Math.random());
                        }}
                        style={{ width: "18px", height: "18px", cursor: "pointer" }}
                      />
                      <div style={{ flex: 1 }}>
                        <span style={{ fontSize: "10px", textTransform: "uppercase", color: "var(--teal)", fontWeight: 800 }}>
                          {cred.type}
                        </span>
                        <h4 style={{ margin: "2px 0 4px", fontSize: "16px" }}>{cred.title}</h4>
                        <div style={{ fontSize: "12px", color: "var(--muted)", fontFamily: "monospace" }}>
                          {cred.hidden ? "••••••••••••• (GİZLİ)" : cred.value}
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              <div>
                <div style={{ border: "1px solid var(--line)", padding: "24px", borderRadius: "16px", background: "#fafafa" }}>
                  <h3 style={{ textAlign: "center", marginBottom: "16px" }}>ZKP Kanıt Barkodu</h3>
                  <div className="zkp-qr-container">
                    <div className="zkp-qr-mock">
                      {Array.from({ length: 144 }).map((_, idx) => {
                        const stateVal = Math.sin(idx * qrSeed) > 0;
                        return (
                          <div
                            key={idx}
                            className={`qr-dot ${stateVal ? "" : "off"}`}
                          />
                        );
                      })}
                    </div>
                  </div>
                  <p style={{ fontSize: "11px", color: "var(--muted)", textAlign: "center", marginTop: "14px", lineHeight: 1.4 }}>
                    Yukarıdaki QR kod ZKP (Sıfır Bilgi Kanıtı) ile kriptografik olarak imzalanmıştır. Sadece seçtiğiniz bilgileri açığa çıkarır.
                  </p>
                </div>
              </div>
            </div>
          </div>
        )}
      </main>

      {/* Floating Bottom Nav Drawer for Mobile */}
      <div className="mobile-bottom-nav">
        <div className="mobile-nav-container">
          <button
            className={`mobile-nav-item ${activeView === "hub" ? "active" : ""}`}
            onClick={() => setActiveView("hub")}
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
            <span>Hub</span>
          </button>
          <button
            className={`mobile-nav-item ${activeView === "visual" ? "active" : ""}`}
            onClick={() => setActiveView("visual")}
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5"><rect x="3" y="4" width="18" height="14" rx="2"/><path d="M7 20h10M8 9h8M8 13h5"/></svg>
            <span>Flows</span>
          </button>
          <button
            className={`mobile-nav-item ${activeView === "wait" ? "active" : ""}`}
            onClick={() => setActiveView("wait")}
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
            <span>Wait</span>
          </button>
          <button
            className={`mobile-nav-item ${activeView === "poke" ? "active" : ""}`}
            onClick={() => setActiveView("poke")}
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/></svg>
            <span>Quests</span>
          </button>
          <button
            className={`mobile-nav-item ${activeView === "itemotel" ? "active" : ""}`}
            onClick={() => setActiveView("itemotel")}
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"/></svg>
            <span>Storage</span>
          </button>
          <button
            className={`mobile-nav-item ${activeView === "match" ? "active" : ""}`}
            onClick={() => setActiveView("match")}
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
            <span>Match</span>
          </button>
        </div>
      </div>
    </div>
  );
}

function VisualFlowGallery({
  flows,
  onOpenView
}: {
  flows: VisualDemoFlow[];
  onOpenView: (view: ViewType) => void;
}) {
  const openableViews: Record<string, ViewType> = {
    les_wait: "wait",
    les_poke: "poke",
    les_match: "match",
    les_itemotel: "itemotel",
    les_harmonica: "harmonica",
    les_travel: "hub",
    les_ai: "ai",
    agentandbot: "ai",
    les_contacts: "contacts",
    les_care: "care",
    les_certification: "certification",
    lescommerce: "itemotel",
    les_affiliate_oyun: "oyun"
  };

  return (
    <div className="visual-demo-shell">
      <header className="visual-demo-hero">
        <p className="eyebrow">Visual Demo System</p>
        <h1>See the ecosystem as flows.</h1>
        <p>
          Each card shows how a real moment becomes app UI: places stay grounded,
          feeds move, risk is visible, and every product keeps its own mood.
        </p>
      </header>

      <section className="visual-map" aria-label="LesTupid flow map">
        <div className="visual-node root">LesTupid Go</div>
        <div className="visual-line" />
        <div className="visual-node-grid">
          {["Wait", "Poke", "Match", "Commerce", "Contacts", "AI", "Care", "Trust"].map((label) => (
            <span className="visual-node small" key={label}>{label}</span>
          ))}
        </div>
      </section>

      <section className="visual-flow-grid">
        {flows.map((flow) => (
          <article className={`visual-flow-card tempo-${flow.tempo}`} key={flow.id}>
            <div className="visual-flow-top">
              <span className="visual-flow-mood">{flow.mood}</span>
              <span className="card-time">{flow.tempo}</span>
            </div>
            <h2>{flow.title}</h2>
            <p>{flow.scene}</p>

            <div className="visual-step-rail">
              {flow.steps.map((step, index) => (
                <div className="visual-step" key={step}>
                  <span>{index + 1}</span>
                  <strong>{step}</strong>
                </div>
              ))}
            </div>

            <div className="visual-app-row">
              {flow.sourceApps.map((app) => {
                const target = openableViews[app];
                return target ? (
                  <button className="visual-app-pill" key={app} type="button" onClick={() => onOpenView(target)}>
                    {app}
                  </button>
                ) : (
                  <span className="visual-app-pill passive" key={app}>{app}</span>
                );
              })}
            </div>

            <div className="visual-rule-grid">
              <div>
                <span>Visual cue</span>
                <p>{flow.visualCue}</p>
              </div>
              <div>
                <span>Trust rule</span>
                <p>{flow.trustRule}</p>
              </div>
            </div>
          </article>
        ))}
      </section>
    </div>
  );
}

// Helpers
function spaceBetweenHelper(p: PlaceOption) {
  return "space-between";
}

const firstAidGuides = [
  {
    title: "Bayılma / Senkop",
    steps: "Kişiyi sırtüstü yatırın, ayaklarını 30 cm kaldırın (Şok pozisyonu). Solunumunu kontrol edin. Sıkan giysileri gevşetin. Kendine gelene kadar ağızdan yiyecek/içecek vermeyin."
  },
  {
    title: "Ciddi Kanama",
    steps: "Yara üzerine temiz bir bezle doğrudan basınç uygulayın. Kanayan bölgeyi kalp seviyesinin üzerine kaldırın. Basınçlı sargı yapın ve tıbbi yardım çağırın."
  },
  {
    title: "Isı Yanıkları",
    steps: "Yanan bölgeyi en az 10-15 dakika akan soğuk (ancak buzlu olmayan) su altında tutun. Su toplayan yerleri patlatmayın. Üzerine diş macunu veya yağ sürmeyin."
  }
];

function CvSnapshot({
  profile,
  place,
  mode
}: {
  profile: StudentCvProfile;
  place: PlaceOption;
  mode: PlaceMode;
}) {
  const topSignals = profile.signals.slice(0, 3);

  return (
    <section className="cv-snapshot" aria-label="Living CV">
      <div className="cv-main">
        <div>
          <p className="eyebrow">Living CV</p>
          <h2>CV burada büyüsün</h2>
          <p>
            {profile.headline}. {place.name} ve {modeLabels[mode]} modu; quest, başvuru,
            servis işi, sertifika ve AI taslaklarını paylaşmadan önce kontrol edilen CV sinyaline çevirir.
          </p>
        </div>
        <div className="cv-meter" aria-label={`CV completion ${profile.completionPercent}%`}>
          <strong>{profile.completionPercent}%</strong>
          <span>ready</span>
          <i style={{ width: `${profile.completionPercent}%` }} />
        </div>
      </div>

      <div className="cv-track-row">
        {profile.targetTracks.map((track) => (
          <span key={track}>{track.replace("_", " ")}</span>
        ))}
      </div>

      <div className="cv-signal-grid">
        {topSignals.map((signal) => (
          <article className="cv-signal" key={signal.id}>
            <span>{signal.sourceApp}</span>
            <strong>{signal.title}</strong>
            <small>{signal.detail}</small>
            <em>{signal.status.replace("_", " ")}</em>
          </article>
        ))}
      </div>
    </section>
  );
}

function FilterRow<T extends string>({
  items,
  activeId,
  onPick
}: {
  items: Array<{ id: T; label: string }>;
  activeId: T;
  onPick: (id: T) => void;
}) {
  return (
    <div className="filter-row">
      {items.map((item) => (
        <button
          className={item.id === activeId ? "filter-chip active" : "filter-chip"}
          key={item.id}
          type="button"
          onClick={() => onPick(item.id)}
        >
          {item.label}
        </button>
      ))}
    </div>
  );
}

function PlaceDoor({
  place,
  active,
  onOpen
}: {
  place: PlaceOption;
  active: boolean;
  onOpen: (place: PlaceOption) => void;
}) {
  return (
    <button className={active ? "place-door active" : "place-door"} type="button" onClick={() => onOpen(place)}>
      <span>{place.type.replace("_", " ")}</span>
      <strong>{place.name}</strong>
      <small>{place.area}</small>
    </button>
  );
}

function FlowIntro({ place, mode }: { place: PlaceOption; mode: PlaceMode }) {
  return (
    <article className="flow-card flow-intro">
      <div className="flow-image" />
      <div className="flow-body">
        <div className="card-topline">
          <span>Check-in context</span>
          <span>{place.distance}</span>
        </div>
        <h3>{place.headline}</h3>
        <p>{contextLine(place, mode)}</p>
        <div className="safety-row">
          <span>{modeLabels[mode]} mode</span>
          {place.tags.map((tag) => (
            <span key={tag}>{tag}</span>
          ))}
        </div>
      </div>
    </article>
  );
}

function contextLine(place: PlaceOption, mode: PlaceMode): string {
  const modeCopy: Record<PlaceMode, string> = {
    study: "Study mode prefers focus quests, group study, quiet rooms and AI help.",
    eat: "Eat mode brings menu, queue, lunch plan and nearby food offers forward.",
    work: "Work mode lifts tasks, listings, lunch windows, mentors and service needs.",
    train: "Train mode follows workout, team, gear, locker, care and recovery signals.",
    social: "Social mode shows public, opt-in group, club and event opportunities.",
    date: "Date mode stays opt-in and consent-first; people stay hidden until Match is active.",
    relax: "Relax mode slows the feed toward beach, break, safety, music and low-pressure offers.",
    shop: "Shop mode surfaces things to buy, rent, sell, store or compare nearby.",
    care: "Care mode prioritizes clinic, safety, first-aid, pharmacy and private context.",
    travel: "Travel mode follows routes, local places, trip needs, rentals and memories.",
    service: "Service mode focuses on queue, appointment, documents, pickup and staff actions.",
    safe: "Safe mode restricts people matching and prioritizes age, school or legal boundaries."
  };

  return `${place.signal}. ${modeCopy[mode]}`;
}

function StatusGroup({ title, items }: { title: string; items: string[] }) {
  return (
    <div className="status-group">
      <h3>{title}</h3>
      <div className="pill-row">
        {items.map((item) => (
          <span className="pill" key={item}>
            {item}
          </span>
        ))}
      </div>
    </div>
  );
}

function CommerceFacetBar({
  activeFacets,
  total,
  onToggle,
  onClear
}: {
  activeFacets: CommerceFacetSignal[];
  total: number;
  onToggle: (facet: CommerceFacetSignal) => void;
  onClear: () => void;
}) {
  return (
    <section className="commerce-facet-bar" aria-label="Commerce facet filters">
      <div>
        <span>Tap-to-filter</span>
        <strong>{activeFacets.length > 0 ? `${total} matching cards` : "Tap commerce values on cards"}</strong>
      </div>
      <div className="commerce-facet-active-list">
        {activeFacets.length === 0 ? (
          <em>Brand, model, size, place, item or service chips will appear on commerce cards.</em>
        ) : (
          activeFacets.map((facet) => (
            <button
              key={`${facet.key}-${facet.value}`}
              type="button"
              className="commerce-facet-chip active"
              onClick={() => onToggle(facet)}
              title={`${facet.label} filtresini kaldir`}
            >
              <small>{facet.key}</small>
              {facet.label}
            </button>
          ))
        )}
        {activeFacets.length > 0 ? (
          <button type="button" className="commerce-facet-clear" onClick={onClear}>
            Clear
          </button>
        ) : null}
      </div>
    </section>
  );
}

function CommerceFacetChips({
  facets,
  activeFacets,
  onSelect
}: {
  facets?: CommerceFacetSignal[];
  activeFacets: CommerceFacetSignal[];
  onSelect: (facet: CommerceFacetSignal) => void;
}) {
  if (!facets || facets.length === 0) return null;

  return (
    <div className="commerce-facet-row" aria-label="Commerce filter values">
      {facets.map((facet) => {
        const active = activeFacets.some((candidate) => sameCommerceFacet(candidate, facet));

        return (
          <button
            key={`${facet.key}-${facet.value}`}
            type="button"
            className={active ? "commerce-facet-chip active" : "commerce-facet-chip"}
            onClick={() => onSelect(facet)}
            title={`Filter by ${facet.label}`}
          >
            <small>{facet.key}</small>
            {facet.label}
          </button>
        );
      })}
    </div>
  );
}

function Opportunity({
  opportunity,
  onAction,
  activeCommerceFacets,
  onCommerceFacetSelect
}: {
  opportunity: OpportunityCard;
  onAction: (opportunity: OpportunityCard, action: OpportunityAction) => void;
  activeCommerceFacets: CommerceFacetSignal[];
  onCommerceFacetSelect: (facet: CommerceFacetSignal) => void;
}) {
  const [expanded, setExpanded] = useState(false);

  const primaryAction = opportunity.actions.find((action) => action.kind === "primary") || opportunity.actions[0];

  return (
    <article className={`flow-card opportunity-card ${opportunity.type} tempo-${opportunity.tempo} ${expanded ? "expanded" : ""}`}>
      <button
        className="card-expand-toggle"
        onClick={() => setExpanded(!expanded)}
        aria-label="Toggle details"
        title={expanded ? "Detayları Kapat" : "Detayları Göster"}
      >
        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" strokeWidth="3" fill="none" strokeLinecap="round" strokeLinejoin="round" className="plus-icon"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
      </button>

      <div className="card-topline">
        <span className="card-badge">
          {opportunityIcons[opportunity.type]}
          <span>{opportunityLabels[opportunity.type]}</span>
        </span>
        <span className="card-time">{opportunity.timeLabel}</span>
      </div>

      <h3 className="card-title">{opportunity.title}</h3>
      <p className="card-reason">{opportunity.reason}</p>
      <CommerceFacetChips
        facets={opportunity.commerceFacets}
        activeFacets={activeCommerceFacets}
        onSelect={onCommerceFacetSelect}
      />

      {!expanded && primaryAction && (
        <div className="action-row simple-action">
          <button
            className={`action-button ${primaryAction.kind}`}
            type="button"
            onClick={() => onAction(opportunity, primaryAction)}
          >
            {primaryAction.label}
          </button>
        </div>
      )}

      <div className={`card-details-panel ${expanded ? "visible" : ""}`}>
        <hr className="details-divider" />

        <div className="details-meta-grid">
          <div className="meta-item">
            <span className="meta-label">Source App</span>
            <span className="meta-val">{opportunity.sourceApp}</span>
          </div>
          <div className="meta-item">
            <span className="meta-label">Activation</span>
            {opportunity.requiredActivation ? (
              <span className="meta-val warn">Requires {opportunity.requiredActivation}</span>
            ) : (
              <span className="meta-val success">None needed</span>
            )}
          </div>
        </div>

        {opportunity.safetyLabels.length > 0 && (
          <div className="details-section">
            <h4 className="section-title">Safety & Consent</h4>
            <div className="safety-row">
              {opportunity.safetyLabels.map((label) => (
                <span key={label} className="safety-pill">{label}</span>
              ))}
            </div>
          </div>
        )}

        <div className="action-row expanded-actions">
          {opportunity.actions.map((action) => (
            <button
              className={`action-button ${action.kind}`}
              key={action.id}
              type="button"
              onClick={() => onAction(opportunity, action)}
            >
              {action.label}
            </button>
          ))}
        </div>
      </div>
    </article>
  );
}

createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);

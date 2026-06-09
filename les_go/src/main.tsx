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
  kadroMarketplaceAgents,
  mockZkpCredentials,
  mockAiSkills
} from "./data";
import { getOpportunityAdapter } from "./adapters";
import { previewContactsDraft } from "./contactsAdapter";
import { getCoreAdapter } from "./coreAdapter";
import { CareView } from "./features/care/CareView";
import { AiConsoleView } from "./features/ai/AiConsoleView";
import { AffiliateOyunView } from "./features/affiliate/AffiliateOyunView";
import { CertificationView } from "./features/certification/CertificationView";
import { CommerceFamilyView } from "./features/commerce/CommerceFamilyView";
import { ContactsView } from "./features/contacts/ContactsView";
import { HarmonicaView } from "./features/harmonica/HarmonicaView";
import { HubView } from "./features/hub/HubView";
import { ItemOtelView } from "./features/itemotel/ItemOtelView";
import { MatchView } from "./features/match/MatchView";
import { PokeView } from "./features/poke/PokeView";
import { VisualFlowGallery } from "./features/visual/VisualFlowGallery";
import { WaitView } from "./features/wait/WaitView";
import type { VisualDemoFlow } from "./features/visual/VisualFlowGallery";
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
  FlowTempo,
  AiSkill,
  AiSkillAuditLog,
  EcosystemIdentity,
  ContactsDraftPreview
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
const coreAdapter = getCoreAdapter();

function sameCommerceFacet(left: CommerceFacetSignal, right: CommerceFacetSignal) {
  return left.key === right.key && left.value === right.value;
}

function normalizeActivationProductId(productId: string) {
  if (productId === "lescommerce") return "lescommerce-core";
  return productId;
}

function upsertActivation(activations: typeof appActivations, nextActivation: (typeof appActivations)[number]) {
  const existingIndex = activations.findIndex((activation) => activation.productId === nextActivation.productId);

  if (existingIndex === -1) {
    return [...activations, nextActivation];
  }

  return activations.map((activation, index) => (index === existingIndex ? nextActivation : activation));
}

function upsertChannel(channelsList: typeof channels, nextChannel: (typeof channels)[number]) {
  const existingIndex = channelsList.findIndex((channel) => channel.channelId === nextChannel.channelId);

  if (existingIndex === -1) {
    return [...channelsList, nextChannel];
  }

  return channelsList.map((channel, index) => (index === existingIndex ? nextChannel : channel));
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

const nearbyPlacePreviewLimit = 6;
const nearbyTopicPreviewLimit = 4;
const feedPreviewLimit = 5;

const firstAidGuides = [
  {
    title: "Bayilma / Senkop",
    steps: "Kisiyi sirtustu yatirin, ayaklarini 30 cm kaldirin. Solunumunu kontrol edin. Sikan giysileri gevsedin. Kendine gelene kadar agizdan yiyecek/icecek vermeyin."
  },
  {
    title: "Ciddi Kanama",
    steps: "Yara uzerine temiz bir bezle dogrudan basin uygulayin. Kanayan bolgeyi kalp seviyesinin uzerine kaldirin. Basincli sargi yapin ve tibbi yardim cagirin."
  },
  {
    title: "Isi Yaniklari",
    steps: "Yanan bolgeyi en az 10-15 dakika soguk ancak buzlu olmayan su altinda tutun. Su toplayan yerleri patlatmayin. Uzerine dis macunu veya yag surmeyin."
  }
];

type ViewType =
  | "hub"
  | "visual"
  | "wait"
  | "poke"
  | "match"
  | "commerce"
  | "itemotel"
  | "contacts"
  | "care"
  | "harmonica"
  | "oyun"
  | "ai"
  | "certification";

type AppModeInfo = {
  productName: string;
  goRole: string;
  standaloneRole: string;
  standaloneUrl?: string;
  standaloneLabel?: string;
  standaloneStatus?: "ready" | "planned";
};

const appModeInfo: Partial<Record<ViewType, AppModeInfo>> = {
  wait: {
    productName: "Les Wait",
    goRole: "Queue opportunity preview, activation prompt, and light ticket simulator inside Les Go.",
    standaloneRole: "Owns camera QR, owner QR creation, phone/photo fallback, staff actions, and normalized queue events.",
    standaloneUrl: "http://127.0.0.1:4010/waiting.html",
    standaloneLabel: "Open standalone Les Wait",
    standaloneStatus: "ready"
  },
  poke: {
    productName: "Les Poke",
    goRole: "Quest cards and nearby action prompts appear in the Go feed.",
    standaloneRole: "Owns quest creation, map/check-in verification, drops, creator quests, and XP rules.",
    standaloneUrl: "http://127.0.0.1:8082/",
    standaloneLabel: "Open standalone Les Poke",
    standaloneStatus: "ready"
  },
  match: {
    productName: "Les Match",
    goRole: "Opt-in discovery previews and activation-safe prompts inside context feeds.",
    standaloneRole: "Owns consent, profiles, candidates, matches, safety reports, and secure conversation state.",
    standaloneLabel: "Standalone Les Match planned",
    standaloneStatus: "planned"
  },
  commerce: {
    productName: "Les Commerce",
    goRole: "Shows the commerce family as one place: DIY, marketplace/listings, quick commerce, storefronts, and Item Otel.",
    standaloneRole: "Owns commerce engines that can each run alone: DIY video marketplace, general listings, quick store builder, storefront theme pool, and item custody commerce.",
    standaloneLabel: "Commerce family has multiple standalone apps",
    standaloneStatus: "planned"
  },
  itemotel: {
    productName: "Les Item Otel",
    goRole: "Shows item storage, care, rent/sell opportunities, and courier prompts in context.",
    standaloneRole: "Owns item custody, care logs, listing state, pickup/return workflows, and commerce operations.",
    standaloneLabel: "Standalone Item Otel planned",
    standaloneStatus: "planned"
  },
  contacts: {
    productName: "Les Contacts",
    goRole: "Turns people, places, products, and memories into private contextual cards.",
    standaloneRole: "Owns personal CRM import, relationship memory, lead state, and consented integrations.",
    standaloneLabel: "Standalone Contacts planned",
    standaloneStatus: "planned"
  },
  care: {
    productName: "Les Care",
    goRole: "Shows verified care info, safe-mode prompts, and emergency cards without exposing private trails.",
    standaloneRole: "Owns health guidance review, emergency handoff, source labeling, and care-specific policy.",
    standaloneLabel: "Standalone Care planned",
    standaloneStatus: "planned"
  },
  harmonica: {
    productName: "Les Harmonica",
    goRole: "Shows secure nearby handoff and trust opportunities inside Les Go.",
    standaloneRole: "Owns pairwise identity, anonymous trust exchange, secure messaging, and device proximity flows.",
    standaloneLabel: "Standalone Harmonica planned",
    standaloneStatus: "planned"
  },
  oyun: {
    productName: "Les Affiliate Oyun",
    goRole: "Shows affiliate game opportunities, quest modifiers, and commerce rewards.",
    standaloneRole: "Owns game rules, deck economy, affiliate rewards, and certified play sessions.",
    standaloneLabel: "Standalone Oyun planned",
    standaloneStatus: "planned"
  },
  ai: {
    productName: "AgentAndBot / KADRO",
    goRole: "Shows hireable AI workers and task adapters that can help inside LesTupid flows.",
    standaloneRole: "Owns agent cards, protocol catalog, auth.md strategy, skills, tasks, and governance APIs.",
    standaloneUrl: "http://127.0.0.1:4001/protocols",
    standaloneLabel: "Open AgentAndBot",
    standaloneStatus: "ready"
  },
  certification: {
    productName: "Les Certification",
    goRole: "Shows trust, proof, selective disclosure, and safety/certification prompts.",
    standaloneRole: "Owns certificates, ZKP strategy, policy validation, app registry, and proof adapters.",
    standaloneLabel: "Standalone Certification planned",
    standaloneStatus: "planned"
  }
};

const commerceProducts = [
  {
    id: "lescommerce-diydiy",
    name: "DIY Marketplace",
    status: "Standalone storefront exists",
    stack: "Phoenix backend / Next.js storefront",
    role: "A video starts the product page: materials, masters, finished goods, workshops, and creator promotion.",
    path: "Les_Commerce/diy-marketplace-elixir",
    standaloneUrl: "http://127.0.0.1:3006/",
    actionLabel: "Open DIY storefront"
  },
  {
    id: "lescommerce-marketplace",
    name: "Marketplace & Listings",
    status: "Engine area",
    stack: "Elixir/Phoenix planned",
    role: "General listing engine for products, homes, cars, services, local offers, peer gigs, and place-based listings.",
    path: "Les_Commerce/marketplace-elixir",
    actionLabel: "Planned standalone"
  },
  {
    id: "lescommerce-books",
    name: "Books & Sahaf Marketplace",
    status: "Vertical marketplace",
    stack: "Shared marketplace engine / Quick Commerce catalog",
    role: "NadirKitap-style bookseller, sahaf, used book, academic book and collectible book marketplace.",
    path: "Les_Commerce/books-marketplace",
    actionLabel: "Books vertical planned"
  },
  {
    id: "lescommerce-quick-commerce",
    name: "Quick Commerce",
    status: "Standalone storefront exists",
    stack: "Phoenix backend / Astro storefront",
    role: "Shopify-style fast merchant store creation, catalog, checkout, custom storefront and optional marketplace publishing.",
    path: "Les_Commerce/quick-commerce-elixir",
    standaloneUrl: "http://127.0.0.1:4321/",
    actionLabel: "Open quick storefront"
  },
  {
    id: "lescommerce-storefronts",
    name: "Storefronts",
    status: "Theme pool",
    stack: "Astro / Next.js templates",
    role: "Reusable storefront themes for Quick Commerce and related commerce apps.",
    path: "Les_Commerce/storefronts",
    actionLabel: "Theme pool planned"
  },
  {
    id: "les-itemotel",
    name: "Les Item Otel",
    status: "Visible Go module",
    stack: "Manifest/spec plus Go prototype",
    role: "Item custody, storage, care, rent, sale, courier pickup/return and recall.",
    path: "Les_Commerce/les_itemotel",
    goView: "itemotel" as ViewType,
    actionLabel: "Open Item Otel"
  }
];

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
    sourceApps: ["les_poke", "les-affiliate", "les_ai", "agentandbot", "lescommerce"],
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

function AppModeNote({ view }: { view: ViewType }) {
  const info = appModeInfo[view];
  if (!info) return null;

  return (
    <div className="mode-note">
      <div className="mode-note-copy">
        <span>
          <strong>Les Go mode:</strong> {info.goRole}
        </span>
        <span>
          <strong>Standalone:</strong> {info.standaloneRole}
        </span>
      </div>
      {info.standaloneUrl ? (
        <a href={info.standaloneUrl} target="_blank" rel="noreferrer">
          {info.standaloneLabel || `Open standalone ${info.productName}`}
        </a>
      ) : (
        <span className="mode-note-status">{info.standaloneLabel || "Standalone app planned"}</span>
      )}
    </div>
  );
}

function compactCode(value: string) {
  return String(value || "")
    .trim()
    .toUpperCase()
    .replace(/[^A-Z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 18);
}

function shortHash(value: string) {
  let hash = 2166136261;
  const text = String(value || "lestupid-wait");
  for (let index = 0; index < text.length; index += 1) {
    hash ^= text.charCodeAt(index);
    hash = Math.imul(hash, 16777619);
  }
  return (hash >>> 0).toString(36).toUpperCase().padStart(7, "0").slice(0, 7);
}

function buildWaitSurface(placeName: string, flowType: string, service: string) {
  const code = `WAIT-${compactCode(placeName).slice(0, 3) || "LES"}-${shortHash(
    `${placeName}:${flowType}:${service}`
  )}`;
  const link = `http://127.0.0.1:4010/waiting.html?surface=${encodeURIComponent(code)}&flow=${encodeURIComponent(
    flowType
  )}&place=${encodeURIComponent(placeName)}&service=${encodeURIComponent(service)}`;
  const qrUrl = `https://quickchart.io/qr?size=180&margin=1&text=${encodeURIComponent(link)}`;
  return { code, link, qrUrl };
}

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
  const [navSearch, setNavSearch] = useState("");

  const navItems = useMemo(() => [
    { id: "hub", label: "Ecosystem Hub", icon: <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg> },
    { id: "visual", label: "Visual Flows", icon: <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><rect x="3" y="4" width="18" height="14" rx="2"/><path d="M7 20h10M9 8h6M7 12h10"/></svg> },
    { id: "wait", label: "Les Wait (Queue)", icon: <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg> },
    { id: "poke", label: "Les Poke (Quests)", icon: <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg> },
    { id: "match", label: "Les Match (Match)", icon: <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg> },
    { id: "commerce", label: "Les Commerce", icon: <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.7 13.4a2 2 0 0 0 2 1.6h8.7a2 2 0 0 0 2-1.6L22 6H6"/></svg> },
    { id: "itemotel", label: "Eşya Otelim", icon: <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg> },
    { id: "contacts", label: "Les Contacts (CRM)", icon: <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><path d="M14 2v6h6"/><path d="M16 13H8M16 17H8M10 9H8"/></svg> },
    { id: "care", label: "Les Care (Health)", icon: <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg> },
    { id: "harmonica", label: "Proximity (Link)", icon: <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><path d="M12 2a10 10 0 1 0 10 10A10 10 0 0 0 12 2zm0 18a8 8 0 1 1 8-8 8 8 0 0 1-8 8z"/><path d="M12 6v6l4 2"/></svg> },
    { id: "oyun", label: "Kart Oyunu", icon: <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><rect x="4" y="3" width="12" height="16" rx="2"/><path d="M8 7h4M8 11h5M8 15h3"/><path d="M18 7l2 10a2 2 0 0 1-2 2h-2"/></svg> },
    { id: "ai", label: "KADRO AI", icon: <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><rect x="3" y="11" width="18" height="10" rx="2"/><path d="M12 2v9M8 5h8"/></svg> },
    { id: "certification", label: "Selective Trust", icon: <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" strokeWidth="2.5" fill="none"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg> }
  ], []);

  const filteredNavItems = useMemo(() => {
    return navItems.filter((item) =>
      item.label.toLowerCase().includes(navSearch.toLowerCase())
    );
  }, [navItems, navSearch]);

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
  const [identityState, setIdentityState] = useState<EcosystemIdentity>(identity);
  const [appActivationsState, setAppActivationsState] = useState(appActivations);
  const [channelsState, setChannelsState] = useState(channels);
  const [coreSnapshotSource, setCoreSnapshotSource] = useState<"mock" | "http">("mock");
  const [coreActionNotice, setCoreActionNotice] = useState<string | null>(null);

  // CV signals tracking
  const [cvProfile, setCvProfile] = useState<StudentCvProfile>(studentCvProfile);

  // 1. Les Wait Simulator State
  const [waitTicket, setWaitTicket] = useState<QueueTicket | null>(null);
  const [waitChannel, setWaitChannel] = useState<QueueTicket["channel"]>("camera_qr");
  const [waitSurfaceCode, setWaitSurfaceCode] = useState("WAIT-CAM-READY");
  const [waitProofRef, setWaitProofRef] = useState("go-preview");
  const [waitNotice, setWaitNotice] = useState("Ready. Go shows the same Les Wait surface; camera opens in standalone.");
  const [waitOwnerService, setWaitOwnerService] = useState("student queue / pickup");
  const [waitOwnerFlow, setWaitOwnerFlow] = useState("campus_service");

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
  const [contactsDraftPreview, setContactsDraftPreview] = useState<ContactsDraftPreview | null>(null);
  const [contactsPreviewSource, setContactsPreviewSource] = useState<"mock" | "http">("mock");
  const [contactsPreviewLoading, setContactsPreviewLoading] = useState(false);

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
  const [selectedAgent, setSelectedAgent] = useState<KadroAgent>(kadroMarketplaceAgents[0] || mockKadroAgents[0]!);
  const [aiPrompt, setAiPrompt] = useState("");
  const [aiConsoleContent, setAiConsoleContent] = useState("");
  const [isAiTyping, setIsAiTyping] = useState(false);
  const [aiOutputReady, setAiOutputReady] = useState(false);
  const [aiSubTab, setAiSubTab] = useState<"agents" | "skills">("agents");


  // 10. Les Certification ZKP State
  const [zkpCredentials, setZkpCredentials] = useState<ZkpCredential[]>(mockZkpCredentials);
  const [qrSeed, setQrSeed] = useState(0.85);

  // 11. AI Skills Integration State
  const [aiSkills, setAiSkills] = useState<AiSkill[]>(mockAiSkills);
  const [globalAuditLogs, setGlobalAuditLogs] = useState<AiSkillAuditLog[]>(mockAiSkills.flatMap(s => s.auditLogs));

  useEffect(() => {
    let active = true;

    void coreAdapter.loadSnapshot().then((snapshot) => {
      if (!active) return;

      setIdentityState(snapshot.identity);
      setAppActivationsState(snapshot.appActivations);
      setChannelsState(snapshot.channels);
      setCoreSnapshotSource(snapshot.source);
    });

    return () => {
      active = false;
    };
  }, []);

  const handleExecuteAiSkill = (skillId: string, params: Record<string, any>): string => {
    const skill = aiSkills.find(s => s.id === skillId);
    if (!skill) {
      return JSON.stringify({ status: "failed", error: "Skill not found" }, null, 2);
    }

    const timestamp = new Date().toISOString();

    if (skill.status === "disabled") {
      const output = JSON.stringify({ status: "failed", error: "Security Policy Block: This AI Skill is disabled globally by the user." }, null, 2);
      const logEntry: AiSkillAuditLog = { timestamp, input: params, output, status: "failed" };
      setAiSkills(prev => prev.map(s => s.id === skillId ? { ...s, executionCount: s.executionCount + 1, lastExecutedAt: timestamp, auditLogs: [logEntry, ...s.auditLogs] } : s));
      setGlobalAuditLogs(prev => [logEntry, ...prev]);
      return output;
    }

    if (skill.status === "needs_approval") {
      const output = JSON.stringify({ status: "failed", error: "Consent Block: Execution requires explicit student signature. Please authorize execution request." }, null, 2);
      const logEntry: AiSkillAuditLog = { timestamp, input: params, output, status: "failed" };
      setAiSkills(prev => prev.map(s => s.id === skillId ? { ...s, executionCount: s.executionCount + 1, lastExecutedAt: timestamp, auditLogs: [logEntry, ...s.auditLogs] } : s));
      setGlobalAuditLogs(prev => [logEntry, ...prev]);
      return output;
    }

    let payload: any = { status: "success", timestamp };

    switch (skillId) {
      case "get_contextual_opportunities": {
        const activePlace = places.find(p => p.id === placeId) || places[0]!;
        payload.contextPlace = activePlace.name;
        payload.contextMode = selectedMode;
        payload.opportunities = [
          { title: `${activePlace.name} - Study Session`, type: "education_opportunity" },
          { title: `${activePlace.name} - Reward Quest`, type: "quest" }
        ].slice(0, Number(params.limit || 3));
        break;
      }
      case "wait_join_queue": {
        const targetVenueId = params.venueId || "main-canteen";
        const venue = places.find(p => p.id === targetVenueId) || { name: targetVenueId };
        const ticket: QueueTicket = {
          id: `ticket-${Date.now()}`,
          venueId: targetVenueId,
      venueName: venue.name,
      ticketNumber: `A-${Math.floor(Math.random() * 90) + 10}`,
      userPosition: Math.floor(Math.random() * 8) + 4,
      estimatedMinutes: 15,
      status: "waiting",
      channel: waitChannel,
      surfaceId: waitSurfaceCode,
      proofRef: waitProofRef,
      sourceQuestId: selectedQuest?.id
    };
        setWaitTicket(ticket);
        payload.ticket = ticket;
        payload.message = `Successfully joined wait queue for ${venue.name}`;
        break;
      }
      case "wait_leave_queue": {
        if (!waitTicket) {
          payload = { status: "failed", error: "No active ticket found" };
        } else {
          setWaitTicket(null);
          payload.message = "Successfully left the wait queue.";
        }
        break;
      }
      case "poke_list_quests": {
        payload.questsCount = quests.length;
        payload.quests = quests.map(q => ({ id: q.id, name: q.name, status: q.status, xp: q.xp }));
        break;
      }
      case "poke_verify_gps": {
        const qId = params.questId || "q-1";
        const quest = quests.find(q => q.id === qId);
        if (!quest) {
          payload = { status: "failed", error: "Quest not found" };
        } else if (quest.status === "completed") {
          payload = { status: "success", message: "Quest is already completed", quest };
        } else {
          setQuests((prev) =>
            prev.map((q) => (q.id === qId ? { ...q, status: "completed" } : q))
          );
          if (selectedQuest && selectedQuest.id === qId) {
            setSelectedQuest(prev => (prev ? { ...prev, status: "completed" } : null));
          }
          setQuestXp((xp) => xp + quest.xp);
          const newSignal = {
            id: `cv-poke-${Date.now()}`,
            sourceApp: "les_poke",
            title: `${quest.name} tamamlandı`,
            detail: `AI verify_gps arayüzü ile tamamlandı. +${quest.xp} XP.`,
            status: "verified" as const
          };
          setCvProfile((prev) => ({
            ...prev,
            completionPercent: Math.min(100, prev.completionPercent + 4),
            signals: [newSignal, ...prev.signals]
          }));
          payload.message = `Quest ${quest.name} completed successfully. +${quest.xp} XP.`;
          payload.quest = { ...quest, status: "completed" };
        }
        break;
      }
      case "match_search_tags": {
        const searchTag = (params.tag || "").toLowerCase();
        const matches = matchProfiles.filter(p => p.tags.some(t => t.toLowerCase().includes(searchTag)));
        payload.matchesFound = matches.length;
        payload.profiles = matches.map(p => ({ pseudonym: p.pseudonym, distance: p.distance, tags: p.tags }));
        break;
      }
      case "match_submit_consent": {
        const profId = params.profileId || "m-1";
        const isInterest = params.consent === undefined ? true : params.consent;
        const targetProfile = matchProfiles.find(p => p.id === profId);
        if (!targetProfile) {
          payload = { status: "failed", error: "Profile not found" };
        } else {
          if (isInterest) {
            setShowMatchPopup(true);
            setMatchProfiles((prev) =>
              prev.map((p) => (p.id === profId ? { ...p, mutualInterest: true } : p))
            );
            payload.message = `Submitted interest swipe on ${targetProfile.pseudonym}. It's a mutual match!`;
            payload.mutualMatch = true;
          } else {
            payload.message = `Passed on profile ${targetProfile.pseudonym}.`;
            payload.mutualMatch = false;
          }
        }
        break;
      }
      case "otel_list_inventory": {
        payload.itemCount = items.length;
        payload.inventory = items.map(item => ({ id: item.id, name: item.name, category: item.category, status: item.status, location: item.storage_location }));
        break;
      }
      case "otel_order_maintenance": {
        const itemId = Number(params.itemId || 1);
        const careType = params.careType || "waxing";
        const notes = params.notes || "AI maintenance request";
        const item = items.find(i => i.id === itemId);
        if (!item) {
          payload = { status: "failed", error: "Item not found in Otel registry" };
        } else {
          const newLog = {
            id: Date.now(),
            care_type: careType,
            notes,
            performed_at: new Date().toISOString()
          };
          setItems(prev => prev.map(i => i.id === itemId ? { ...i, status: "in_maintenance", care_logs: [newLog, ...i.care_logs] } : i));
          payload.message = `Maintenance ticket generated for item: ${item.name}. Status set to 'in_maintenance'.`;
          payload.ticket = newLog;
        }
        break;
      }
      case "otel_publish_listing": {
        const itemId = Number(params.itemId || 1);
        const listType = params.listingType || "rent";
        const price = Number(params.price || 10);
        const item = items.find(i => i.id === itemId);
        if (!item) {
          payload = { status: "failed", error: "Item not found" };
        } else {
          const updatedListing = {
            id: Date.now(),
            listing_type: listType,
            price_sale: listType === "sale" || listType === "both" ? price : undefined,
            price_rent_daily: listType === "rent" || listType === "both" ? price : undefined,
            is_active: true
          };
          setItems(prev => prev.map(i => i.id === itemId ? { ...i, status: listType === "rent" ? "listed_for_rent" : "listed_for_sale", listing: updatedListing } : i));
          payload.message = `Item ${item.name} successfully listed on marketplace board.`;
          payload.listing = updatedListing;
        }
        break;
      }
      case "crm_search_timeline": {
        const logContext = params.context || "all";
        const filtered = logContext === "all" ? crmLogs : crmLogs.filter(log => log.context === logContext);
        payload.count = filtered.length;
        payload.logs = filtered;
        break;
      }
      case "crm_record_interaction": {
        const pName = params.placeName || "Campus Library";
        const pNotes = params.notes || "Interaction logged by AI skill";
        const pContext = params.context || "social";
        const log: CrmLog = {
          id: `crm-${Date.now()}`,
          date: new Date().toISOString().split("T")[0]!,
          placeName: pName,
          notes: pNotes,
          context: pContext
        };
        setCrmLogs((prev) => [log, ...prev]);
        payload.message = `Logged interaction under ${pContext} context linked to ${pName}.`;
        payload.crmRecord = log;
        break;
      }
      case "care_fetch_clinic_slots": {
        payload.slots = [
          { time: "14:00", doctor: "Dr. Ayşe Yılmaz", status: "open" },
          { time: "14:30", doctor: "Dr. Ayşe Yılmaz", status: "open" },
          { time: "15:00", doctor: "Dr. Mehmet Kaya", status: "booked" }
        ];
        break;
      }
      case "care_generate_emergency_qr": {
        const reason = params.reason || "First-aid";
        payload.message = "Responder authorization token generated.";
        payload.signedToken = `lestupid:emergency:${Date.now()}:sha256:d8f28fa8e932b144`;
        payload.reason = reason;
        setEmergencyActive(true);
        break;
      }
      case "harmonica_scan_nodes": {
        payload.nodes = harmonicaDevices.map(d => ({ id: d.id, name: d.name, signal: `${d.signalStrength}%` }));
        break;
      }
      case "harmonica_pair_handshake": {
        const devId = params.deviceId || "dev-1";
        const dev = harmonicaDevices.find(d => d.id === devId);
        if (!dev) {
          payload = { status: "failed", error: "Device not found in range" };
        } else {
          setHarmonicaDevices(prev => prev.map(d => d.id === devId ? { ...d, paired: true } : d));
          setPairedDevice({ ...dev, paired: true });
          payload.message = `Handshake established with ${dev.name}. Public keys rotated.`;
          payload.sharedPublicKey = dev.publicKey;
        }
        break;
      }
      case "oyun_analyze_deck": {
        payload.cards = oyunHand.map(c => ({ id: c.id, name: c.name, score: c.power + c.defense }));
        payload.totalPower = oyunHand.reduce((sum, c) => sum + c.power, 0);
        payload.deckOptimal = true;
        break;
      }
      case "oyun_trigger_auto_duel": {
        const log = "Tur Sonucu [AI Skill Auto Run]: Kart Salındı. AI savunması delindi. AI Hasar Aldı (-15 HP).";
        setAiHp(prev => Math.max(0, prev - 25));
        setGameLogs((prev) => [log, ...prev]);
        payload.message = "Initiated battle simulation round.";
        payload.combatOutcome = { playerHpDamageDealt: 25, aiHpDamageDealt: 0 };
        break;
      }
      case "ai_compile_cv_segment": {
        const targetAgentId = params.agentId || "a-1";
        const agent = [...kadroMarketplaceAgents, ...mockKadroAgents].find(a => a.id === targetAgentId);
        if (!agent) {
          payload = { status: "failed", error: "Agent not found" };
        } else {
          const newSignal = {
            id: `cv-ai-${Date.now()}`,
            sourceApp: "les_ai",
            title: `Compiled by ${agent.name}`,
            detail: agent.responseTemplate.slice(0, 80) + "...",
            status: "draft" as const
          };
          setCvProfile((prev) => ({
            ...prev,
            completionPercent: Math.min(100, prev.completionPercent + 5),
            signals: [newSignal, ...prev.signals]
          }));
          payload.message = "Living CV segment draft exported successfully.";
          payload.cvSegment = newSignal;
        }
        break;
      }
      case "cert_generate_zkp_proof": {
        const discloseStudent = params.discloseStudent === undefined ? true : params.discloseStudent;
        const discloseAgeGate = params.discloseAgeGate === undefined ? false : params.discloseAgeGate;
        const compiledProof = `zkp-token:${discloseStudent ? "STUDENT=TRUE" : "STUDENT=HIDDEN"}:${discloseAgeGate ? "18+=TRUE" : "18+=HIDDEN"}:sha256:${Math.random().toString(16).slice(2, 18)}`;
        setQrSeed(Math.random());
        setZkpCredentials(prev => prev.map(c => {
          if (c.type === "Identity") return { ...c, hidden: !discloseStudent };
          if (c.type === "Age Gate") return { ...c, hidden: !discloseAgeGate };
          return c;
        }));
        payload.message = "ZKP credential compiled and QR updated.";
        payload.zkpProofToken = compiledProof;
        break;
      }
      default:
        payload = { status: "failed", error: "Execution method not defined in simulator context." };
    }

    const finalOutput = JSON.stringify(payload, null, 2);
    const logEntry: AiSkillAuditLog = { timestamp, input: params, output: finalOutput, status: payload.status === "success" ? "success" : "failed" };

    setAiSkills(prev => prev.map(s => s.id === skillId ? { ...s, executionCount: s.executionCount + 1, lastExecutedAt: timestamp, auditLogs: [logEntry, ...s.auditLogs] } : s));
    setGlobalAuditLogs(prev => [logEntry, ...prev]);

    return finalOutput;
  };

  const handleUpdateSkillStatus = (skillId: string, newStatus: AiSkill["status"]) => {
    setAiSkills(prev => prev.map(s => s.id === skillId ? { ...s, status: newStatus } : s));
  };



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
  const handleJoinQueue = async (venueId: string, name: string) => {
    const queuePlace = places.find((place) => place.id === venueId) ?? selectedPlace;
    const submission = await coreAdapter.submitCheckIn({
      placeId: venueId,
      placeName: name,
      placeType: queuePlace.type,
      mode: queuePlace.modes.includes(selectedMode) ? selectedMode : queuePlace.defaultMode,
      privacyLevel,
      source: "manual"
    });

    const ticket: QueueTicket = {
      id: `ticket-${Date.now()}`,
      venueId,
      venueName: name,
      ticketNumber: `A-${Math.floor(Math.random() * 90) + 10}`,
      userPosition: Math.floor(Math.random() * 8) + 4,
      estimatedMinutes: 15,
      status: "waiting",
      channel: waitChannel,
      surfaceId: waitSurfaceCode,
      proofRef: waitProofRef,
      sourceQuestId: selectedQuest?.id
    };
    setWaitTicket(ticket);
    setWaitNotice(
      submission.accepted
        ? `${name} queue joined through ${waitChannel}. Check-in recorded via ${submission.source}.`
        : `${name} queue joined through ${waitChannel}. Check-in sync needs retry.`
    );
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
        sourceApp: "les-affiliate",
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
  const currentWaitSurface = buildWaitSurface(selectedPlace.name, waitOwnerFlow, waitOwnerService);
  const activeMode = selectedPlace.modes.includes(selectedMode) ? selectedMode : selectedPlace.defaultMode;
  const activeApps = appActivationsState.filter((app) => app.status === "activated");
  const activeChannels = channelsState.filter((channel) => channel.status === "activated");
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
      .getOpportunities(checkIn, activeChannels)
      .filter((opportunity) => !dismissedIds.includes(opportunity.id))
      .filter((opportunity) => feedFilter === "all" || opportunity.type === feedFilter)
      .filter((opportunity) => opportunityMatchesCommerceFacets(opportunity, activeCommerceFacets));
  }, [checkIn.placeId, checkIn.placeType, checkIn.mode, checkIn.privacyLevel, dismissedIds, feedFilter, activeCommerceFacets, activeChannels]);

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

  async function handlePreviewContactsDraft() {
    setContactsPreviewLoading(true);

    const result = await previewContactsDraft(checkIn);

    setContactsDraftPreview(result.draft);
    setContactsPreviewSource(result.source);
    setContactsPreviewLoading(false);
  }

  function toggleCommerceFacet(facet: CommerceFacetSignal) {
    setActiveCommerceFacets((current) => {
      if (current.some((item) => sameCommerceFacet(item, facet))) {
        return current.filter((item) => !sameCommerceFacet(item, facet));
      }

      return [...current, facet];
    });
    setBrowseFeed(false);
  }

  async function handleAction(opportunity: OpportunityCard, action: OpportunityAction) {
    if (action.id === "dismiss") {
      setDismissedIds((ids) => [...ids, opportunity.id]);
    }
    if (action.id === "report") {
      setReportedIds((ids) => [...ids, opportunity.id]);
    }
    if (action.id === "activate" && opportunity.requiredActivation) {
      const activationProductId = normalizeActivationProductId(opportunity.requiredActivation);
      const activationResult = await coreAdapter.activateApp(activationProductId);

      setAppActivationsState((current) => upsertActivation(current, activationResult.activation));
      let notice = `Activated ${activationResult.activation.productId} via ${activationResult.source}.`;

      if (activationProductId === "les-match") {
        const channelResult = await coreAdapter.activateChannel("matchmaking");
        setChannelsState((current) => upsertChannel(current, channelResult.channel));
        notice = `${notice} Channel ${channelResult.channel.channelId} activated via ${channelResult.source}.`;
      } else if (activationProductId === "les-harmonica") {
        const channelResult = await coreAdapter.activateChannel("safe_contact");
        setChannelsState((current) => upsertChannel(current, channelResult.channel));
        notice = `${notice} Channel ${channelResult.channel.channelId} activated via ${channelResult.source}.`;
      }

      setCoreActionNotice(notice);

      if (opportunity.requiredActivation === "les-wait") {
        handleJoinQueue(selectedPlace.id, selectedPlace.name);
      } else if (opportunity.requiredActivation === "les-poke") {
        setActiveView("poke");
      } else if (opportunity.requiredActivation === "les-match") {
        setActiveView("match");
      } else if (
        opportunity.requiredActivation === "les-ai" ||
        opportunity.requiredActivation === "agentandbot-governance-core" ||
        opportunity.requiredActivation === "ai-senaryo"
      ) {
        setActiveView("ai");
      } else if (opportunity.requiredActivation === "les-certification") {
        setActiveView("certification");
      } else if (opportunity.requiredActivation === "les-affiliate") {
        setActiveView("oyun");
      } else if (opportunity.requiredActivation === "les-itemotel") {
        setActiveView("itemotel");
      } else if (
        opportunity.requiredActivation === "lescommerce" ||
        opportunity.requiredActivation === "lescommerce-core" ||
        opportunity.requiredActivation.startsWith("lescommerce-")
      ) {
        setActiveView("commerce");
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

        {!sidebarCollapsed && (
          <div className="sidebar-search" style={{ padding: "0 12px 12px" }}>
            <input
              type="text"
              placeholder="Search apps..."
              value={navSearch}
              onChange={(e) => setNavSearch(e.target.value)}
              style={{
                width: "100%",
                padding: "8px 12px",
                fontSize: "13px",
                border: "1px solid var(--line)",
                borderRadius: "8px",
                background: "rgba(18, 22, 25, 0.03)",
                color: "var(--ink)",
                outline: "none",
                transition: "all 0.2s ease"
              }}
              onFocus={(e) => {
                e.target.style.borderColor = "var(--ink)";
                e.target.style.background = "#fff";
                e.target.style.boxShadow = "0 0 0 3px hsla(210, 24%, 12%, 0.08)";
              }}
              onBlur={(e) => {
                e.target.style.borderColor = "var(--line)";
                e.target.style.background = "rgba(18, 22, 25, 0.03)";
                e.target.style.boxShadow = "none";
              }}
            />
          </div>
        )}

        <nav className="nav-menu">
          {filteredNavItems.map((item) => (
            <button
              key={item.id}
              className={`nav-item ${activeView === item.id ? "active" : ""}`}
              onClick={() => setActiveView(item.id as ViewType)}
              data-label={item.label}
            >
              {item.icon}
              <span>{item.label}</span>
            </button>
          ))}
          {filteredNavItems.length === 0 && (
            <div style={{ padding: "20px 12px", color: "var(--muted)", fontSize: "13px", textAlign: "center" }}>
              No apps found
            </div>
          )}
        </nav>
      </aside>

      {/* Main Content Area */}
      <main className="main-content">
        {activeView === "visual" && <VisualFlowGallery flows={visualDemoFlows} onOpenView={setActiveView} />}

        {activeView === "hub" && (
          <HubView
            activeMode={activeMode}
            activeApps={activeApps}
            activeChannels={activeChannels}
            activeCommerceFacets={activeCommerceFacets}
            aiCrew={aiCrew}
            browseFeed={browseFeed}
            browsePlaces={browsePlaces}
            checkMarkIcon={checkMarkIcon}
            coreActionNotice={coreActionNotice}
            coreSnapshotSource={coreSnapshotSource}
            cvProfile={cvProfile}
            feedFilter={feedFilter}
            feedFilters={feedFilters}
            feedPreviewLimit={feedPreviewLimit}
            identityState={identityState}
            inlineSkills={(
              <InlineSkillAdapters
                productId="les-go"
                skills={aiSkills}
                onExecute={handleExecuteAiSkill}
                onUpdateStatus={handleUpdateSkillStatus}
              />
            )}
            modeHeadlines={modeHeadlines}
            modeLabels={modeLabels}
            nearbyPlacePreviewLimit={nearbyPlacePreviewLimit}
            nearbyPlaces={nearbyPlaces}
            nearbyTopics={nearbyTopics}
            opportunities={opportunities}
            opportunityIcons={opportunityIcons}
            opportunityLabels={opportunityLabels}
            placeFilter={placeFilter}
            placeFilters={placeFilters}
            privacyLevel={privacyLevel}
            privacyOptions={privacyOptions}
            reportedIds={reportedIds}
            selectedPlace={selectedPlace}
            settingsIcon={settingsIcon}
            showSettings={showSettings}
            visibleOpportunities={visibleOpportunities}
            visiblePlaces={visiblePlaces}
            visibleTopics={visibleTopics}
            onAction={handleAction}
            onJoinQueue={handleJoinQueue}
            onOpenPlace={handlePlaceOpen}
            onSetActiveCommerceFacets={setActiveCommerceFacets}
            onSetBrowseFeed={setBrowseFeed}
            onSetBrowsePlaces={setBrowsePlaces}
            onSetDismissedIds={setDismissedIds}
            onSetFeedFilter={setFeedFilter}
            onSetPlaceFilter={setPlaceFilter}
            onSetPrivacyLevel={setPrivacyLevel}
            onSetSelectedMode={setSelectedMode}
            onSetShowSettings={setShowSettings}
            onToggleCommerceFacet={toggleCommerceFacet}
          />
        )}

        {/* 1. Les Wait Queue Simulator View */}
        {activeView === "wait" && (
          <WaitView
            modeNote={<AppModeNote view="wait" />}
            inlineSkills={(
              <InlineSkillAdapters
                productId="les-wait"
                skills={aiSkills}
                onExecute={handleExecuteAiSkill}
                onUpdateStatus={handleUpdateSkillStatus}
              />
            )}
            waitChannel={waitChannel}
            waitSurfaceCode={waitSurfaceCode}
            phoneSurfaceCode={`PHONE-${shortHash(selectedPlace.name)}`}
            waitProofRef={waitProofRef}
            waitNotice={waitNotice}
            waitOwnerService={waitOwnerService}
            waitOwnerFlow={waitOwnerFlow}
            waitTicket={waitTicket}
            selectedPlace={selectedPlace}
            selectedQuest={selectedQuest}
            currentWaitSurface={currentWaitSurface}
            waitPlaces={places
              .filter((place) => place.id === selectedPlace.id || place.modes.includes("service") || place.type === "canteen")
              .slice(0, 6)}
            onWaitChannelChange={setWaitChannel}
            onWaitSurfaceCodeChange={setWaitSurfaceCode}
            onWaitProofRefChange={setWaitProofRef}
            onWaitNoticeChange={setWaitNotice}
            onWaitOwnerServiceChange={setWaitOwnerService}
            onWaitOwnerFlowChange={setWaitOwnerFlow}
            onPhotoProofSelect={(file) => {
              setWaitChannel("photo_proof");
              setWaitSurfaceCode(`PHOTO-${shortHash(file?.name || selectedPlace.name)}`);
              setWaitProofRef(`photo:${shortHash(`${file?.name || "local-photo"}:${file?.size || 0}`)}`);
              setWaitNotice("Photo proof token created locally. The image itself is not stored.");
            }}
            onUseOwnerQr={() => {
              setWaitSurfaceCode(currentWaitSurface.code);
              setWaitProofRef("owner-generated");
              setWaitNotice("Owner entrance created. It matches the standalone join link.");
            }}
            onOpenPoke={() => setActiveView("poke")}
            onJoinQueue={handleJoinQueue}
            onFastForwardQueue={handleFastForwardQueue}
            onCancelTicket={() => setWaitTicket(null)}
          />
        )}
        {/* 2. Les Poke Quest Simulator View */}
        {activeView === "poke" && (
          <PokeView
            modeNote={<AppModeNote view="poke" />}
            inlineSkills={(
              <InlineSkillAdapters
                productId="les-poke"
                skills={aiSkills}
                onExecute={handleExecuteAiSkill}
                onUpdateStatus={handleUpdateSkillStatus}
              />
            )}
            quests={quests}
            selectedQuest={selectedQuest}
            questXp={questXp}
            simulatingGps={simulatingGps}
            onSelectQuest={setSelectedQuest}
            onSimulateGps={handleSimulateGps}
          />
        )}
        {/* 3. Les Match Simulator View */}
        {activeView === "match" && (
          <MatchView
            modeNote={<AppModeNote view="match" />}
            inlineSkills={(
              <InlineSkillAdapters
                productId="les-match"
                skills={aiSkills}
                onExecute={handleExecuteAiSkill}
                onUpdateStatus={handleUpdateSkillStatus}
              />
            )}
            activeChatMatch={activeChatMatch}
            matchChatHistory={matchChatHistory}
            matchChatMsg={matchChatMsg}
            matchProfiles={matchProfiles}
            matchIndex={matchIndex}
            showMatchPopup={showMatchPopup}
            onCloseChat={() => {
              setActiveChatMatch(null);
              setMatchChatHistory([]);
            }}
            onMatchChatMsgChange={setMatchChatMsg}
            onSendMatchMsg={handleSendMatchMsg}
            onMatchChoice={handleMatchChoice}
            onOpenChatFromPopup={() => {
              setActiveChatMatch(matchProfiles[matchIndex]!);
              setShowMatchPopup(false);
            }}
            onDismissPopup={() => {
              setShowMatchPopup(false);
              setMatchIndex((prev) => (prev + 1) % matchProfiles.length);
            }}
          />
        )}

        {/* 4. Les Commerce Family View */}
        {activeView === "commerce" && (
          <CommerceFamilyView
            modeNote={<AppModeNote view="commerce" />}
            inlineSkills={(
              <InlineSkillAdapters
                productId="lescommerce-core"
                skills={aiSkills}
                onExecute={handleExecuteAiSkill}
                onUpdateStatus={handleUpdateSkillStatus}
              />
            )}
            products={commerceProducts}
            onOpenGoView={(viewId) => setActiveView(viewId as ViewType)}
          />
        )}

        {/* 5. Les Commerce & Item Otel View */}
        {activeView === "itemotel" && (
          <ItemOtelView
            modeNote={<AppModeNote view="itemotel" />}
            inlineSkills={(
              <InlineSkillAdapters
                productId="les-itemotel"
                skills={aiSkills}
                onExecute={handleExecuteAiSkill}
                onUpdateStatus={handleUpdateSkillStatus}
              />
            )}
            items={items}
            loadingItems={loadingItems}
            expandedItemId={expandedItemId}
            showNewItemForm={showNewItemForm}
            newItemName={newItemName}
            newItemCategory={newItemCategory}
            careTypeInput={careTypeInput}
            careNotesInput={careNotesInput}
            listTypeInput={listTypeInput}
            priceSaleInput={priceSaleInput}
            priceRentInput={priceRentInput}
            onExpandedItemChange={setExpandedItemId}
            onShowNewItemFormChange={setShowNewItemForm}
            onNewItemNameChange={setNewItemName}
            onNewItemCategoryChange={setNewItemCategory}
            onCareTypeInputChange={setCareTypeInput}
            onCareNotesInputChange={setCareNotesInput}
            onListTypeInputChange={setListTypeInput}
            onPriceSaleInputChange={setPriceSaleInput}
            onPriceRentInputChange={setPriceRentInput}
            onCreateItem={handleCreateItem}
            onCare={handleCare}
            onList={handleList}
            onUnlist={handleUnlist}
            onRecall={handleRecall}
          />
        )}

        {/* 5. Les Contacts Private CRM View */}
        {activeView === "contacts" && (
          <ContactsView
            modeNote={<AppModeNote view="contacts" />}
            inlineSkills={(
              <InlineSkillAdapters
                productId="les-contacts"
                skills={aiSkills}
                onExecute={handleExecuteAiSkill}
                onUpdateStatus={handleUpdateSkillStatus}
              />
            )}
            newCrmPlace={newCrmPlace}
            newCrmContext={newCrmContext}
            newCrmNotes={newCrmNotes}
            crmFilter={crmFilter}
            crmLogs={crmLogs}
            contactsDraftPreview={contactsDraftPreview}
            contactsPreviewSource={contactsPreviewSource}
            contactsPreviewLoading={contactsPreviewLoading}
            onNewCrmPlaceChange={setNewCrmPlace}
            onNewCrmContextChange={setNewCrmContext}
            onNewCrmNotesChange={setNewCrmNotes}
            onCrmFilterChange={setCrmFilter}
            onAddCrmLog={handleAddCrmLog}
            onPreviewContactsDraft={() => void handlePreviewContactsDraft()}
          />
        )}

        {/* 6. Les Care Health View */}
        {activeView === "care" && (
          <CareView
            modeNote={<AppModeNote view="care" />}
            inlineSkills={(
              <InlineSkillAdapters
                productId="les-care"
                skills={aiSkills}
                onExecute={handleExecuteAiSkill}
                onUpdateStatus={handleUpdateSkillStatus}
              />
            )}
            careSearch={careSearch}
            firstAidGuides={firstAidGuides}
            emergencyActive={emergencyActive}
            onCareSearchChange={setCareSearch}
            onEmergencyActiveChange={setEmergencyActive}
          />
        )}

        {/* 7. Les Harmonica Proximity scanner View */}
        {activeView === "harmonica" && (
          <HarmonicaView
            modeNote={<AppModeNote view="harmonica" />}
            inlineSkills={(
              <InlineSkillAdapters
                productId="les-harmonica"
                skills={aiSkills}
                onExecute={handleExecuteAiSkill}
                onUpdateStatus={handleUpdateSkillStatus}
              />
            )}
            scanning={scanning}
            harmonicaDevices={harmonicaDevices}
            pairedDevice={pairedDevice}
            secChatHistory={secChatHistory}
            secChatMsg={secChatMsg}
            onRadarScan={handleRadarScan}
            onPairedDeviceChange={setPairedDevice}
            onSecChatMsgChange={setSecChatMsg}
            onSendSecureMsg={handleSendSecureMsg}
            onConfirmPairwiseConnection={(device) => {
              setHarmonicaDevices((prev) =>
                prev.map((entry) => (entry.id === device.id ? { ...entry, paired: true } : entry))
              );
              setPairedDevice({ ...device, paired: true });
            }}
          />
        )}
        {/* 8. Les Affiliate Oyun Card Game View */}
        {activeView === "oyun" && (
          <AffiliateOyunView
            modeNote={<AppModeNote view="oyun" />}
            inlineSkills={(
              <InlineSkillAdapters
                productId="les-affiliate"
                skills={aiSkills}
                onExecute={handleExecuteAiSkill}
                onUpdateStatus={handleUpdateSkillStatus}
              />
            )}
            playerHp={playerHp}
            aiHp={aiHp}
            winnerMessage={winnerMessage}
            duelActive={duelActive}
            gameLogs={gameLogs}
            oyunHand={oyunHand}
            onResetGame={() => {
              setPlayerHp(100);
              setAiHp(100);
              setGameLogs([]);
              setWinnerMessage(null);
              setDuelActive(true);
            }}
            onStartDuel={() => setDuelActive(true)}
            onPlayCard={handleOyunCardPlay}
          />
        )}

        {/* 9. Les AI / KADRO View */}
        {activeView === "ai" && (
          <AiConsoleView
            modeNote={<AppModeNote view="ai" />}
            aiSubTab={aiSubTab}
            selectedAgent={selectedAgent}
            aiPrompt={aiPrompt}
            aiConsoleContent={aiConsoleContent}
            aiOutputReady={aiOutputReady}
            isAiTyping={isAiTyping}
            marketplaceAgents={kadroMarketplaceAgents}
            aiSkills={aiSkills}
            globalAuditLogs={globalAuditLogs}
            onAiSubTabChange={setAiSubTab}
            onSelectedAgentChange={setSelectedAgent}
            onAiPromptChange={setAiPrompt}
            onSendAiPrompt={handleSendAiPrompt}
            onExportAiDraftToCv={handleExportAiDraftToCv}
            onUpdateSkillStatus={handleUpdateSkillStatus}
            onResetAiConsole={() => {
              setAiConsoleContent("");
              setAiOutputReady(false);
            }}
            onHireAgent={(agent) => {
              setAiConsoleContent(`${agent.name} hire request drafted.\nTask: ${agent.hireMode || "Task workspace"}\nConsent: user approval required before execution.`);
              setAiOutputReady(true);
            }}
            onOpenAgentCard={(agent) => {
              setAiConsoleContent(`${agent.name} AgentAndBot card opened in demo mode.\nSource: ${agent.sourceApp || "agentandbot.com"}\nIdentity: ${agent.identityClass || "ai_worker"}`);
            }}
            onOpenCvPreview={(agent) => {
              setAiConsoleContent(`${agent.name} CV preview is available at ${agent.cvUrl}.\nIn production this opens AgentAndBot governance profile.`);
            }}
          />
        )}
        {/* 10. Les Certification ZKP View */}
        {activeView === "certification" && (
          <CertificationView
            modeNote={<AppModeNote view="certification" />}
            inlineSkills={(
              <InlineSkillAdapters
                productId="les-certification"
                skills={aiSkills}
                onExecute={handleExecuteAiSkill}
                onUpdateStatus={handleUpdateSkillStatus}
              />
            )}
            zkpCredentials={zkpCredentials}
            qrSeed={qrSeed}
            onToggleCredential={(credentialId) => {
              setZkpCredentials((prev) =>
                prev.map((credential) =>
                  credential.id === credentialId ? { ...credential, hidden: !credential.hidden } : credential
                )
              );
              setQrSeed(Math.random());
            }}
          />
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
            className={`mobile-nav-item ${activeView === "commerce" || activeView === "itemotel" ? "active" : ""}`}
            onClick={() => setActiveView("commerce")}
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.7 13.4a2 2 0 0 0 2 1.6h8.7a2 2 0 0 0 2-1.6L22 6H6"/></svg>
            <span>Commerce</span>
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

interface InlineSkillAdaptersProps {
  productId: string;
  skills: AiSkill[];
  onExecute: (skillId: string, params: Record<string, any>) => string;
  onUpdateStatus: (skillId: string, status: AiSkill["status"]) => void;
}

function InlineSkillAdapters({ productId, skills, onExecute, onUpdateStatus }: InlineSkillAdaptersProps) {
  const [isOpen, setIsOpen] = useState(false);
  const appSkills = skills.filter(s => s.productId === productId);
  
  const [paramsState, setParamsState] = useState<Record<string, Record<string, any>>>(() => {
    const initial: Record<string, Record<string, any>> = {};
    appSkills.forEach(s => {
      initial[s.id] = {};
      s.parameters.forEach(p => {
        initial[s.id][p.name] = p.defaultValue !== undefined ? p.defaultValue : (p.type === "boolean" ? false : "");
      });
    });
    return initial;
  });

  const [outputsState, setOutputsState] = useState<Record<string, string>>({});

  if (appSkills.length === 0) return null;

  const handleRun = (skillId: string) => {
    const params = paramsState[skillId] || {};
    const result = onExecute(skillId, params);
    setOutputsState(prev => ({ ...prev, [skillId]: result }));
  };

  const handleParamChange = (skillId: string, name: string, value: any) => {
    setParamsState(prev => ({
      ...prev,
      [skillId]: {
        ...(prev[skillId] || {}),
        [name]: value
      }
    }));
  };

  return (
    <div className="skill-adapters-container" style={{ marginTop: "24px", border: "1px solid var(--line)", borderRadius: "16px", background: "rgba(255, 255, 255, 0.03)", overflow: "hidden" }}>
      <div className="skill-adapters-header" onClick={() => setIsOpen(!isOpen)} style={{ display: "flex", justifyContent: "space-between", alignItems: "center", padding: "16px 20px", cursor: "pointer", borderBottom: isOpen ? "1px solid var(--line)" : "none", background: "var(--surface)" }}>
        <div style={{ display: "flex", alignItems: "center", gap: "10px" }}>
          <span style={{ fontSize: "18px" }}>🔌</span>
          <strong style={{ fontSize: "14px", color: "var(--ink)" }}>AI Skill Adapters ({appSkills.length} Available)</strong>
        </div>
        <span style={{ fontSize: "12px", color: "var(--muted)", transition: "transform 0.2s", transform: isOpen ? "rotate(180deg)" : "rotate(0)" }}>▼</span>
      </div>

      {isOpen && (
        <div className="skill-adapters-content" style={{ padding: "20px" }}>
          <p className="skills-subtitle" style={{ margin: "0 0 16px 0", fontSize: "13px", color: "var(--muted)" }}>
            Configure boundaries and run simulated tool calls for this application's AI capabilities.
          </p>
          <div style={{ display: "grid", gap: "20px" }}>
            {appSkills.map(skill => {
              const currentParams = paramsState[skill.id] || {};
              const currentOutput = outputsState[skill.id];

              return (
                <div key={skill.id} className="skill-card-inner" style={{ padding: "16px", border: "1px solid var(--line)", borderRadius: "12px", background: "var(--surface)" }}>
                  <div className="skill-card-header" style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: "8px" }}>
                    <div>
                      <span className="skill-code" style={{ fontFamily: "monospace", fontSize: "12px", background: "rgba(32,117,111,0.08)", color: "var(--teal)", padding: "2px 6px", borderRadius: "4px" }}>
                        {skill.id}()
                      </span>
                      <h4 style={{ margin: "6px 0 2px 0", fontSize: "14px", fontWeight: "bold" }}>{skill.name}</h4>
                    </div>
                    <div style={{ display: "flex", gap: "8px", alignItems: "center" }}>
                      <select 
                        value={skill.status} 
                        onChange={(e) => onUpdateStatus(skill.id, e.target.value as any)}
                        className={`skill-status-select ${skill.status}`}
                        style={{ fontSize: "12px", padding: "4px 8px", borderRadius: "6px", border: "1px solid var(--line)", background: "var(--surface)" }}
                      >
                        <option value="active">Active</option>
                        <option value="needs_approval">Needs Approval</option>
                        <option value="disabled">Disabled</option>
                      </select>
                    </div>
                  </div>

                  <p className="skill-description" style={{ fontSize: "13px", color: "var(--muted)", margin: "0 0 12px 0", lineHeight: 1.4 }}>
                    {skill.description}
                  </p>

                  {skill.parameters.length > 0 && (
                    <div className="skill-params-form" style={{ marginTop: "12px", padding: "12px", border: "1px solid var(--line)", borderRadius: "8px", background: "rgba(0,0,0,0.02)" }}>
                      <div className="params-title" style={{ fontSize: "11px", textTransform: "uppercase", fontWeight: "bold", color: "var(--muted)", marginBottom: "8px" }}>Parameters:</div>
                      <div className="params-grid" style={{ display: "grid", gap: "12px" }}>
                        {skill.parameters.map(p => (
                          <div key={p.name} className="param-field" style={{ display: "flex", flexDirection: "column", gap: "4px" }}>
                            <label className="param-label" style={{ fontSize: "12px", fontWeight: 600, color: "var(--ink)", display: "flex", justifyContent: "space-between" }}>
                              <span>
                                {p.name} {p.required && <span className="req" style={{ color: "var(--rose)" }}>*</span>}
                              </span>
                              <span className="param-desc" style={{ fontWeight: "normal", fontSize: "11px", color: "var(--muted)" }}>{p.description}</span>
                            </label>
                            
                            {p.type === "select" ? (
                              <select
                                value={currentParams[p.name] || ""}
                                onChange={(e) => handleParamChange(skill.id, p.name, e.target.value)}
                                className="param-input"
                                style={{ width: "100%", padding: "8px", borderRadius: "6px", border: "1px solid var(--line)", background: "var(--surface)", fontSize: "13px" }}
                              >
                                {(p.options || []).map(opt => (
                                  <option key={opt} value={opt}>{opt}</option>
                                ))}
                              </select>
                            ) : p.type === "boolean" ? (
                              <div style={{ display: "flex", alignItems: "center", gap: "8px", marginTop: "4px" }}>
                                <input
                                  type="checkbox"
                                  checked={!!currentParams[p.name]}
                                  onChange={(e) => handleParamChange(skill.id, p.name, e.target.checked)}
                                  className="param-checkbox"
                                />
                                <span style={{ fontSize: "12px", color: "var(--muted)" }}>Enable / True</span>
                              </div>
                            ) : (
                              <input
                                type={p.type === "number" ? "number" : "text"}
                                value={currentParams[p.name] ?? ""}
                                onChange={(e) => handleParamChange(skill.id, p.name, p.type === "number" ? Number(e.target.value) : e.target.value)}
                                className="param-input"
                                placeholder={String(p.defaultValue || "")}
                                style={{ width: "100%", padding: "8px", borderRadius: "6px", border: "1px solid var(--line)", background: "var(--surface)", fontSize: "13px" }}
                              />
                            )}
                          </div>
                        ))}
                      </div>
                    </div>
                  )}

                  <div style={{ marginTop: "14px", display: "flex", gap: "10px" }}>
                    <button 
                      type="button" 
                      className="action-button primary" 
                      style={{ padding: "8px 16px", fontSize: "12px", flex: 1 }}
                      onClick={() => handleRun(skill.id)}
                    >
                      Run Simulation
                    </button>
                    {currentOutput && (
                      <button 
                        type="button" 
                        className="action-button secondary" 
                        style={{ padding: "8px 16px", fontSize: "12px" }}
                        onClick={() => setOutputsState(prev => {
                          const copy = { ...prev };
                          delete copy[skill.id];
                          return copy;
                        })}
                      >
                        Clear
                      </button>
                    )}
                  </div>

                  {currentOutput && (
                    <div className="skill-terminal-output" style={{ marginTop: "14px", border: "1px solid var(--line)", borderRadius: "8px", overflow: "hidden", background: "#0c0f12" }}>
                      <div className="terminal-header" style={{ background: "#161b22", padding: "6px 12px", borderBottom: "1px solid var(--line)", fontSize: "11px", color: "#8b949e", display: "flex", justifyContent: "space-between" }}>
                        <span>Output Payload (JSON-LD)</span>
                      </div>
                      <pre className="terminal-pre" style={{ margin: 0, padding: "12px", fontSize: "12px", color: "#58a6ff", fontFamily: "monospace", overflowX: "auto", whiteSpace: "pre-wrap" }}>{currentOutput}</pre>
                    </div>
                  )}

                  {skill.auditLogs.length > 0 && (
                    <div className="skill-audit-mini" style={{ marginTop: "10px", fontSize: "11px", borderTop: "1px solid var(--line)", paddingTop: "8px" }}>
                      <span style={{ fontWeight: "bold", color: "var(--muted)", marginRight: "6px" }}>Recent Run Log:</span>
                      {skill.auditLogs.slice(0, 1).map((log, lIdx) => (
                        <span key={lIdx} style={{ color: log.status === "success" ? "var(--teal)" : "var(--rose)", fontFamily: "monospace" }}>
                          [{new Date(log.timestamp).toLocaleTimeString()}] Input: {JSON.stringify(log.input)} → {log.status.toUpperCase()}
                        </span>
                      ))}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </div>
      )}
    </div>
  );
}

createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);








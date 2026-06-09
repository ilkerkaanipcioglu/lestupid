export type ActivationStatus = "available" | "activated" | "paused" | "revoked";

export type OpportunityType =
  | "menu"
  | "ticket"
  | "route"
  | "next_stop"
  | "service_gig"
  | "cv_growth"
  | "application"
  | "education_opportunity"
  | "trust_credential"
  | "secure_contact"
  | "affiliate_game"
  | "creator_promotion"
  | "care_info"
  | "quest"
  | "wait_action"
  | "match"
  | "local_listing"
  | "agent_help"
  | "commerce_offer"
  | "certification_signal"
  | "proof_or_point";

export type FlowTempo = "live" | "short" | "today" | "ongoing" | "stable";

export type PrivacyLevel = "public_place" | "coarse_location" | "private_note";

export type PlaceMode =
  | "study"
  | "eat"
  | "work"
  | "train"
  | "social"
  | "date"
  | "relax"
  | "shop"
  | "care"
  | "travel"
  | "service"
  | "safe";

export type PlaceType =
  | "campus"
  | "workplace"
  | "canteen"
  | "cafe"
  | "football_club"
  | "gym"
  | "village"
  | "beach"
  | "course_center"
  | "event"
  | "club"
  | "concert"
  | "high_school"
  | "library"
  | "clinic"
  | "student_affairs"
  | "barber"
  | "shop"
  | "adult_venue";

export interface AppActivation {
  productId: string;
  status: ActivationStatus;
  permissions: string[];
}

export interface EcosystemIdentity {
  id: string;
  label: string;
  status: string;
}

export interface InteractionChannel {
  channelId: string;
  status: ActivationStatus;
  allowedApps: string[];
}

export interface PlaceCheckIn {
  placeId: string;
  placeName: string;
  placeType: PlaceType;
  mode: PlaceMode;
  privacyLevel: PrivacyLevel;
  source: "manual" | "qr";
}

export interface EcosystemSnapshot {
  identity: EcosystemIdentity;
  appActivations: AppActivation[];
  channels: InteractionChannel[];
  source: "mock" | "http";
}

export interface CheckInSubmission {
  accepted: boolean;
  source: "mock" | "http";
  privacyLevel: PrivacyLevel;
  eventId?: string;
}

export interface ContactsDraftPreview {
  eventId: string;
  draftStatus: string;
  visibility: string;
  crossAppShareDefault: string;
  userReviewRequired: boolean;
  sourceApp: string;
  identityId: string;
  contextSpace: string;
  sensitivity: string;
  tags: string[];
  place: {
    placeId?: string;
    placeName: string;
    placeType: string;
  };
  createdFrom: string;
}

export interface OpportunityAction {
  id: "activate" | "dismiss" | "open" | "report";
  label: string;
  kind: "primary" | "secondary" | "warning";
}

export type CommerceFacetKey =
  | "brand"
  | "model"
  | "category"
  | "size"
  | "color"
  | "material"
  | "condition"
  | "place"
  | "seller"
  | "service_type"
  | "listing_type"
  | "delivery_method"
  | "care_type"
  | "rental_period"
  | "certification"
  | "creator"
  | "item_type";

export interface CommerceFacetSignal {
  key: CommerceFacetKey;
  value: string;
  label: string;
  source: "title" | "reason" | "tag" | "place" | "listing" | "adapter";
  confidence: "explicit" | "derived";
}

export interface OpportunityCard {
  id: string;
  type: OpportunityType;
  tempo: FlowTempo;
  timeLabel: string;
  sourceApp: string;
  title: string;
  reason: string;
  requiredActivation: string | null;
  safetyLabels: string[];
  commerceFacets?: CommerceFacetSignal[];
  actions: OpportunityAction[];
}

export interface StudentCvSignal {
  id: string;
  sourceApp: string;
  title: string;
  detail: string;
  status: "draft" | "verified" | "self_declared" | "optional_proof";
}

export interface StudentCvProfile {
  identityId: string;
  headline: string;
  visibility: "private" | "opportunity_preview" | "shared_with_consent";
  completionPercent: number;
  targetTracks: Array<"internship" | "part_time_job" | "education" | "scholarship" | "mentor" | "project">;
  signals: StudentCvSignal[];
}

export interface PlaceOption {
  id: string;
  name: string;
  type: PlaceType;
  area: string;
  headline: string;
  signal: string;
  distance: string;
  tags: string[];
  defaultMode: PlaceMode;
  modes: PlaceMode[];
}

export interface ItemCareLog {
  id: number;
  care_type: "cleaning" | "repair" | "tire_rotation" | "waxing" | "general_maintenance";
  notes?: string;
  performed_at: string;
  provider_id?: string;
  certificate_id?: string;
  inserted_at?: string;
}

export interface ItemListing {
  id: number;
  listing_type: "rent" | "sale" | "both";
  price_sale?: number | string;
  price_rent_daily?: number | string;
  is_active: boolean;
  inserted_at?: string;
}

export interface ItemOtelRecord {
  id: number;
  owner_identity_id: string;
  name: string;
  category: "apparel" | "sports" | "automotive" | "wedding" | "other";
  status: "in_storage" | "in_maintenance" | "listed_for_rent" | "listed_for_sale" | "shipped_back" | "sold";
  storage_location?: string;
  condition_rating?: number;
  images: string[];
  care_logs: ItemCareLog[];
  listing?: ItemListing;
  inserted_at?: string;
}

export interface QueueTicket {
  id: string;
  venueId: string;
  venueName: string;
  ticketNumber: string;
  userPosition: number;
  estimatedMinutes: number;
  status: "waiting" | "called" | "missed" | "completed";
  channel?: "web" | "camera_qr" | "short_code" | "phone_lookup" | "photo_proof" | "staff_entry";
  surfaceId?: string;
  proofRef?: string;
  sourceQuestId?: string;
}

export interface QuestItem {
  id: string;
  name: string;
  detail: string;
  placeId: string;
  status: "locked" | "active" | "completed";
  xp: number;
  coordinates: { x: number; y: number };
}

export interface MatchProfile {
  id: string;
  pseudonym: string;
  avatarSeed: string;
  distance: string;
  mutualInterest: boolean;
  tags: string[];
  description: string;
}

export interface CrmLog {
  id: string;
  date: string;
  placeName: string;
  notes: string;
  context: "work" | "personal" | "social" | "travel";
  people?: string;
}

export interface HarmonicaDevice {
  id: string;
  name: string;
  signalStrength: number;
  paired: boolean;
  publicKey: string;
}

export interface OyunCard {
  id: string;
  name: string;
  power: number;
  defense: number;
  rarity: "common" | "rare" | "legendary";
  type: "product" | "quest" | "merchant";
  image: string;
}

export interface KadroAgent {
  id: string;
  name: string;
  role: string;
  bio: string;
  avatar: string;
  responseTemplate: string;
  category?: string;
  identityClass?: "ai_worker" | "ai_persona" | "external_owned_agent";
  sourceApp?: "les_ai/kadro" | "agentandbot.com";
  imageUrl?: string;
  fullBodyUrl?: string;
  cvUrl?: string;
  country?: string;
  city?: string;
  social?: string[];
  skills?: string[];
  hireMode?: string;
  hourlyRate?: string;
  availability?: string;
}

export interface ZkpCredential {
  id: string;
  type: string;
  title: string;
  issuer: string;
  value: string;
  hidden: boolean;
}

export interface AiSkillParameter {
  name: string;
  type: "string" | "number" | "boolean" | "select";
  options?: string[];
  description: string;
  required: boolean;
  defaultValue?: string | number | boolean;
}

export interface AiSkillAuditLog {
  timestamp: string;
  input: Record<string, any>;
  output: string;
  status: "success" | "failed";
}

export interface AiSkill {
  id: string;
  productId: string;
  name: string;
  description: string;
  parameters: AiSkillParameter[];
  requiredPermissions: string[];
  status: "active" | "disabled" | "needs_approval";
  executionCount: number;
  lastExecutedAt?: string;
  auditLogs: AiSkillAuditLog[];
}

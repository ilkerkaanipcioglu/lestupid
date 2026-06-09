import { appConfig } from "./config";
import type { ContactsDraftPreview, PlaceCheckIn } from "./types";

type ContactsPreviewResult = {
  draft: ContactsDraftPreview;
  source: "mock" | "http";
};

function inferContextSpace(placeType: PlaceCheckIn["placeType"]) {
  if (["campus", "library", "course_center", "high_school", "student_affairs"].includes(placeType)) return "school";
  if (placeType === "workplace") return "work";
  if (["village", "beach"].includes(placeType)) return "travel";
  if (placeType === "shop") return "commerce";
  return "personal";
}

function mapPrivacyLevel(privacyLevel: PlaceCheckIn["privacyLevel"]): "private" | "coarse_location" | "public" {
  if (privacyLevel === "private_note") return "private";
  if (privacyLevel === "public_place") return "public";
  return "coarse_location";
}

function mockDraft(checkIn: PlaceCheckIn): ContactsDraftPreview {
  const privacyLevel = mapPrivacyLevel(checkIn.privacyLevel);

  return {
    eventId: `draft-${checkIn.placeId}`,
    draftStatus: "private_draft",
    visibility: "private",
    crossAppShareDefault: "blocked",
    userReviewRequired: true,
    sourceApp: "les-go",
    identityId: "student-demo-001",
    contextSpace: inferContextSpace(checkIn.placeType),
    sensitivity:
      privacyLevel === "private" || checkIn.placeType === "clinic" || checkIn.placeType === "adult_venue"
        ? "sensitive"
        : "standard",
    tags: [inferContextSpace(checkIn.placeType), checkIn.placeType, "private_draft", "check_in"],
    place: {
      placeId: checkIn.placeId,
      placeName: checkIn.placeName,
      placeType: checkIn.placeType
    },
    createdFrom: "check_in"
  };
}

export async function previewContactsDraft(checkIn: PlaceCheckIn): Promise<ContactsPreviewResult> {
  try {
    const response = await fetch(`${appConfig.lesContactsApiBaseUrl}/api/drafts/check-ins/preview`, {
      method: "POST",
      headers: {
        "content-type": "application/json"
      },
      body: JSON.stringify({
        identity_id: "student-demo-001",
        source_app: "les-go",
        place_id: checkIn.placeId,
        place_name: checkIn.placeName,
        place_type: checkIn.placeType,
        privacy_level: mapPrivacyLevel(checkIn.privacyLevel)
      })
    });

    if (!response.ok) {
      throw new Error("Contacts preview unavailable");
    }

    const payload = await response.json();

    return {
      draft: {
        eventId: payload?.data?.event_id ?? mockDraft(checkIn).eventId,
        draftStatus: payload?.data?.draft_status ?? "private_draft",
        visibility: payload?.data?.visibility ?? "private",
        crossAppShareDefault: payload?.data?.cross_app_share_default ?? "blocked",
        userReviewRequired: payload?.data?.user_review_required ?? true,
        sourceApp: payload?.data?.source_app ?? "les-go",
        identityId: payload?.data?.identity_id ?? "student-demo-001",
        contextSpace: payload?.data?.context_space ?? inferContextSpace(checkIn.placeType),
        sensitivity: payload?.data?.sensitivity ?? "standard",
        tags: payload?.data?.tags ?? [],
        place: {
          placeId: payload?.data?.place?.place_id,
          placeName: payload?.data?.place?.place_name ?? checkIn.placeName,
          placeType: payload?.data?.place?.place_type ?? checkIn.placeType
        },
        createdFrom: payload?.data?.created_from ?? "check_in"
      },
      source: "http"
    };
  } catch (_error) {
    return {
      draft: mockDraft(checkIn),
      source: "mock"
    };
  }
}

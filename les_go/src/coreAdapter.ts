import { appConfig } from "./config";
import { appActivations, channels, identity } from "./data";
import type {
  AppActivation,
  CheckInSubmission,
  EcosystemSnapshot,
  InteractionChannel,
  PlaceCheckIn
} from "./types";

type CoreAdapter = {
  loadSnapshot(): Promise<EcosystemSnapshot>;
  submitCheckIn(checkIn: PlaceCheckIn): Promise<CheckInSubmission>;
  activateApp(productId: string): Promise<{ activation: AppActivation; source: "mock" | "http" }>;
  activateChannel(
    channelId: string
  ): Promise<{ channel: InteractionChannel; source: "mock" | "http" }>;
};

function mockSnapshot(): EcosystemSnapshot {
  return {
    identity,
    appActivations,
    channels,
    source: "mock"
  };
}

function normalizeAppActivations(input: unknown): AppActivation[] {
  if (!Array.isArray(input)) {
    return appActivations;
  }

  return input.filter(
    (item): item is AppActivation =>
      Boolean(item) &&
      typeof item === "object" &&
      typeof (item as AppActivation).productId === "string" &&
      typeof (item as AppActivation).status === "string" &&
      Array.isArray((item as AppActivation).permissions)
  );
}

function normalizeChannels(input: unknown): InteractionChannel[] {
  if (!Array.isArray(input)) {
    return channels;
  }

  return input.filter(
    (item): item is InteractionChannel =>
      Boolean(item) &&
      typeof item === "object" &&
      typeof (item as InteractionChannel).channelId === "string" &&
      typeof (item as InteractionChannel).status === "string" &&
      Array.isArray((item as InteractionChannel).allowedApps)
  );
}

function normalizeActivation(input: unknown): AppActivation | null {
  if (
    input &&
    typeof input === "object" &&
    typeof (input as AppActivation).productId === "string" &&
    typeof (input as AppActivation).status === "string" &&
    Array.isArray((input as AppActivation).permissions)
  ) {
    return input as AppActivation;
  }

  return null;
}

function normalizeChannel(input: unknown): InteractionChannel | null {
  if (
    input &&
    typeof input === "object" &&
    typeof (input as InteractionChannel).channelId === "string" &&
    typeof (input as InteractionChannel).status === "string" &&
    Array.isArray((input as InteractionChannel).allowedApps)
  ) {
    return input as InteractionChannel;
  }

  return null;
}

function mapPrivacyLevel(privacyLevel: PlaceCheckIn["privacyLevel"]): "public" | "coarse_location" | "private" {
  if (privacyLevel === "public_place") return "public";
  if (privacyLevel === "private_note") return "private";
  return "coarse_location";
}

const mockCoreAdapter: CoreAdapter = {
  async loadSnapshot() {
    return mockSnapshot();
  },
  async submitCheckIn(checkIn) {
    return {
      accepted: true,
      source: "mock",
      privacyLevel: checkIn.privacyLevel
    };
  },
  async activateApp(productId) {
    const existing = appActivations.find((activation) => activation.productId === productId);

    return {
      activation:
        existing ?? {
          productId,
          status: "activated",
          permissions: []
      },
      source: "mock"
    };
  },
  async activateChannel(channelId) {
    const existing = channels.find((channel) => channel.channelId === channelId);

    return {
      channel:
        existing ?? {
          channelId,
          status: "activated",
          allowedApps: []
        },
      source: "mock"
    };
  }
};

const httpCoreAdapter: CoreAdapter = {
  async loadSnapshot() {
    try {
      const [identityResponse, activationsResponse] = await Promise.all([
        fetch(`${appConfig.apiBaseUrl}/api/identity/status`),
        fetch(`${appConfig.apiBaseUrl}/api/activations`)
      ]);

      if (!identityResponse.ok || !activationsResponse.ok) {
        return mockSnapshot();
      }

      const identityPayload = await identityResponse.json();
      const activationsPayload = await activationsResponse.json();

      return {
        identity: {
          id: identityPayload?.identity?.id ?? identity.id,
          label: identityPayload?.identity?.label ?? identity.label,
          status: identityPayload?.identity?.status ?? identity.status
        },
        appActivations: normalizeAppActivations(
          activationsPayload?.activations ?? activationsPayload?.app_activations ?? activationsPayload
        ),
        channels: normalizeChannels(activationsPayload?.channels),
        source: "http"
      };
    } catch (_error) {
      return mockSnapshot();
    }
  },
  async submitCheckIn(checkIn) {
    try {
      const response = await fetch(`${appConfig.lesPokeApiBaseUrl}/api/check-ins`, {
        method: "POST",
        headers: {
          "content-type": "application/json"
        },
        body: JSON.stringify({
          check_in: {
            place_id: checkIn.placeId,
            place_name: checkIn.placeName,
            place_type: checkIn.placeType,
            mode: checkIn.mode,
            privacy_level: mapPrivacyLevel(checkIn.privacyLevel),
            source: checkIn.source
          }
        })
      });

      if (!response.ok) {
        return {
          accepted: false,
          source: "mock",
          privacyLevel: checkIn.privacyLevel
        };
      }

      const payload = await response.json();

      return {
        accepted: true,
        source: "http",
        privacyLevel: checkIn.privacyLevel,
        eventId: payload?.data?.event?.id
      };
    } catch (_error) {
      return {
        accepted: true,
        source: "mock",
        privacyLevel: checkIn.privacyLevel
      };
    }
  },
  async activateApp(productId) {
    try {
      const response = await fetch(`${appConfig.apiBaseUrl}/api/activations/apps/${productId}`, {
        method: "POST",
        headers: {
          "content-type": "application/json"
        },
        body: JSON.stringify({})
      });

      if (!response.ok) {
        throw new Error(`Activation failed for ${productId}`);
      }

      const payload = await response.json();
      const activation = normalizeActivation(payload?.activation);

      if (!activation) {
        throw new Error(`Activation payload missing for ${productId}`);
      }

      return {
        activation,
        source: "http"
      };
    } catch (_error) {
      return mockCoreAdapter.activateApp(productId);
    }
  },
  async activateChannel(channelId) {
    try {
      const response = await fetch(`${appConfig.apiBaseUrl}/api/activations/channels/${channelId}`, {
        method: "POST",
        headers: {
          "content-type": "application/json"
        },
        body: JSON.stringify({})
      });

      if (!response.ok) {
        throw new Error(`Channel activation failed for ${channelId}`);
      }

      const payload = await response.json();
      const channel = normalizeChannel(payload?.channel);

      if (!channel) {
        throw new Error(`Channel payload missing for ${channelId}`);
      }

      return {
        channel,
        source: "http"
      };
    } catch (_error) {
      return mockCoreAdapter.activateChannel(channelId);
    }
  }
};

export function getCoreAdapter(): CoreAdapter {
  return appConfig.coreAdapter === "http" ? httpCoreAdapter : mockCoreAdapter;
}

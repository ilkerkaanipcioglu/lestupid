import { StatusBar } from "expo-status-bar";
import { useMemo, useState } from "react";
import {
  FlatList,
  Linking,
  Pressable,
  SafeAreaView,
  ScrollView,
  StyleSheet,
  Text,
  View
} from "react-native";
import { Ionicons } from "@expo/vector-icons";

import {
  CITIES,
  LIVE_EVENTS,
  QUESTS,
  type CityId,
  type LiveEvent,
  type Quest
} from "./src/data/quests";

type Screen = "map" | "profile";

const userStats = {
  points: 120,
  badges: ["First Walk", "Memory Keeper"],
  completedQuestIds: ["kadikoy-moda-pier"]
};

export default function App() {
  const [cityId, setCityId] = useState<CityId>("kadikoy");
  const [screen, setScreen] = useState<Screen>("map");
  const [selectedQuest, setSelectedQuest] = useState<Quest | null>(null);
  const [selectedLiveEvent, setSelectedLiveEvent] = useState<LiveEvent | null>(null);

  const city = CITIES.find((item) => item.id === cityId) ?? CITIES[0]!;
  const quests = useMemo(
    () => QUESTS.filter((quest) => quest.cityId === cityId),
    [cityId]
  );
  const liveEvents = useMemo(
    () => LIVE_EVENTS.filter((event) => event.cityId === cityId),
    [cityId]
  );

  return (
    <SafeAreaView style={styles.safeArea}>
      <StatusBar style="light" />
      <View style={styles.shell}>
        <View style={styles.header}>
          <View style={styles.headerGlow} />
          <View>
            <Text style={styles.eyebrow}>Live city quests</Text>
            <Text style={styles.title}>{city.name}</Text>
            <Text style={styles.subtitle}>
              Walk, unlock memories, follow live moments.
            </Text>
          </View>
          <View style={styles.pointsPill}>
            <Ionicons name="sparkles" size={16} color="#f59e0b" />
            <Text style={styles.pointsText}>{userStats.points}</Text>
          </View>
        </View>

        <View style={styles.segmented}>
          {CITIES.map((item) => (
            <Pressable
              accessibilityRole="button"
              key={item.id}
              onPress={() => {
                setCityId(item.id);
                setSelectedQuest(null);
                setSelectedLiveEvent(null);
              }}
              style={[
                styles.segmentButton,
                item.id === cityId && styles.segmentButtonActive
              ]}
            >
              <Text
                style={[
                  styles.segmentText,
                  item.id === cityId && styles.segmentTextActive
                ]}
              >
                {item.name}
              </Text>
            </Pressable>
          ))}
        </View>

        {screen === "map" ? (
          <ScrollView contentContainerStyle={styles.content}>
            <View style={styles.mapPlaceholder}>
              <View style={styles.mapGrid} />
              <View style={styles.mapPathOne} />
              <View style={styles.mapPathTwo} />
              <View style={styles.mapWater} />
              <View style={styles.mapDistrict}>
                <Text style={styles.mapDistrictText}>{city.name}</Text>
                <Text style={styles.mapDistrictMeta}>Quest zone</Text>
              </View>
              {quests.map((quest, index) => (
                <Pressable
                  accessibilityRole="button"
                  key={quest.id}
                  onPress={() => setSelectedQuest(quest)}
                  style={[
                    styles.questPin,
                    {
                      left: `${24 + index * 25}%`,
                      top: `${28 + (index % 2) * 30}%`
                    }
                  ]}
                >
                  <Ionicons name="location" size={24} color="#f97316" />
                </Pressable>
              ))}
              {liveEvents.map((event, index) => (
                <Pressable
                  accessibilityRole="button"
                  key={event.id}
                  onPress={() => setSelectedLiveEvent(event)}
                  style={[
                    styles.livePin,
                    {
                      left: `${58 + index * 18}%`,
                      top: `${20 + (index % 2) * 34}%`
                    }
                  ]}
                >
                  <View style={styles.livePinPulse} />
                  <Ionicons name="radio" size={20} color="#fef2f2" />
                </Pressable>
              ))}
            </View>

            <LiveStrip events={liveEvents} onSelect={setSelectedLiveEvent} />

            {selectedLiveEvent ? (
              <LiveFollowPanel event={selectedLiveEvent} />
            ) : null}

            <View style={styles.sectionHeader}>
              <Text style={styles.sectionTitle}>Nearby quests</Text>
              <Text style={styles.sectionMeta}>{quests.length} active</Text>
            </View>

            <FlatList
              data={quests}
              keyExtractor={(item) => item.id}
              scrollEnabled={false}
              renderItem={({ item }) => (
                <QuestCard
                  quest={item}
                  selected={selectedQuest?.id === item.id}
                  completed={userStats.completedQuestIds.includes(item.id)}
                  onPress={() => setSelectedQuest(item)}
                />
              )}
            />

            {selectedQuest ? (
              <QuestDetail
                quest={selectedQuest}
                completed={userStats.completedQuestIds.includes(selectedQuest.id)}
                liveEvent={liveEvents.find((event) => event.questId === selectedQuest.id)}
              />
            ) : null}
          </ScrollView>
        ) : (
          <ProfileScreen />
        )}

        <View style={styles.tabs}>
          <TabButton
            icon="map"
            label="Map"
            active={screen === "map"}
            onPress={() => setScreen("map")}
          />
          <TabButton
            icon="person-circle"
            label="Profile"
            active={screen === "profile"}
            onPress={() => setScreen("profile")}
          />
        </View>
      </View>
    </SafeAreaView>
  );
}

function LiveStrip({
  events,
  onSelect
}: {
  events: LiveEvent[];
  onSelect: (event: LiveEvent) => void;
}) {
  if (events.length === 0) {
    return null;
  }

  return (
    <View style={styles.livePanel}>
      <View style={styles.liveHeader}>
        <View style={styles.liveDot} />
        <Text style={styles.liveLabel}>Live now</Text>
      </View>
      {events.map((event) => (
        <View key={event.id} style={styles.liveRow}>
          <Pressable
            accessibilityRole="button"
            onPress={() => onSelect(event)}
            style={styles.liveCopy}
          >
            <Text style={styles.liveTitle}>{event.title}</Text>
            <Text style={styles.liveDescription}>
              {event.host} - {event.platform} - {event.distanceLabel}
            </Text>
            {event.campaignLabel ? (
              <Text style={styles.liveCampaignLabel}>{event.campaignLabel}</Text>
            ) : null}
          </Pressable>
          <Pressable
            accessibilityRole="link"
            onPress={() => Linking.openURL(event.externalUrl)}
            style={styles.liveButton}
          >
            <Ionicons name="open" size={15} color="#fef2f2" />
            <Text style={styles.liveButtonText}>Open</Text>
          </Pressable>
        </View>
      ))}
    </View>
  );
}

function LiveFollowPanel({ event }: { event: LiveEvent }) {
  return (
    <View style={styles.followPanel}>
      <View style={styles.followIcon}>
        <Ionicons name="navigate" size={21} color="#083344" />
      </View>
      <View style={styles.followBody}>
        <Text style={styles.followTitle}>Track {event.host}</Text>
        <Text style={styles.followCopy}>
          {event.title} is live {event.distanceLabel}. Follow the map pin and meet nearby.
        </Text>
        {event.commerceHandoff ? (
          <Text style={styles.followMeta}>{event.commerceHandoff}</Text>
        ) : null}
      </View>
      <Pressable accessibilityRole="button" style={styles.followButton}>
        <Text style={styles.followButtonText}>Go near</Text>
      </Pressable>
    </View>
  );
}

function QuestCard({
  quest,
  selected,
  completed,
  onPress
}: {
  quest: Quest;
  selected: boolean;
  completed: boolean;
  onPress: () => void;
}) {
  const isCreatorPromotion = quest.type === "creator_promotion";

  return (
    <Pressable
      accessibilityRole="button"
      onPress={onPress}
      style={[styles.questCard, selected && styles.questCardSelected]}
    >
      <View style={[styles.questIcon, isCreatorPromotion && styles.questIconCreator]}>
        <Ionicons
          name={getQuestIcon(quest, completed)}
          size={18}
          color={isCreatorPromotion ? "#fdf2f8" : "#111827"}
        />
      </View>
      <View style={styles.questBody}>
        <Text style={styles.questTitle}>{quest.title}</Text>
        <Text style={styles.questDescription}>{quest.description}</Text>
        <View style={styles.questMetaRow}>
          <Text style={[styles.questMeta, isCreatorPromotion && styles.questMetaCreator]}>
            {quest.sponsorLabel ?? quest.type}
          </Text>
          <Text style={styles.questMeta}>{quest.points} pts</Text>
          {quest.sourceApp ? (
            <Text style={styles.questMeta}>{quest.sourceApp}</Text>
          ) : null}
        </View>
      </View>
    </Pressable>
  );
}

function QuestDetail({
  quest,
  completed,
  liveEvent
}: {
  quest: Quest;
  completed: boolean;
  liveEvent?: LiveEvent;
}) {
  return (
    <View style={styles.detailPanel}>
      <Text style={styles.detailLabel}>Quest detail</Text>
      <Text style={styles.detailTitle}>{quest.title}</Text>
      <Text style={styles.detailCopy}>{quest.memory}</Text>
      {quest.commerceHandoff ? (
        <View style={styles.handoffPanel}>
          <Ionicons name="bag-handle" size={18} color="#78350f" />
          <Text style={styles.handoffText}>{quest.commerceHandoff}</Text>
        </View>
      ) : null}
      {quest.safetyLabels?.length ? (
        <View style={styles.safetyRow}>
          {quest.safetyLabels.map((label) => (
            <Text key={label} style={styles.safetyPill}>
              {label.replace(/_/g, " ")}
            </Text>
          ))}
        </View>
      ) : null}
      <Pressable
        accessibilityRole="button"
        style={[styles.primaryButton, completed && styles.primaryButtonDisabled]}
      >
        <Ionicons name={completed ? "checkmark-circle" : "flag"} size={18} color="#111827" />
        <Text style={styles.primaryButtonText}>
          {completed ? "Completed" : quest.actionLabel ?? "Complete quest"}
        </Text>
      </Pressable>
      <View style={styles.broadcastPanel}>
        <View style={styles.broadcastIcon}>
          <Ionicons name="radio" size={18} color="#fef2f2" />
        </View>
        <View style={styles.broadcastBody}>
          <Text style={styles.broadcastTitle}>
            {liveEvent ? liveEvent.title : "Open a live field note"}
          </Text>
          <Text style={styles.broadcastCopy}>
            {liveEvent
              ? liveEvent.description
              : "Start a short live moment from this spot for nearby explorers."}
          </Text>
        </View>
        <Pressable accessibilityRole="button" style={styles.broadcastButton}>
          <Text style={styles.broadcastButtonText}>
            {liveEvent ? "Join" : "Go live"}
          </Text>
        </Pressable>
      </View>
      <View style={styles.platformRow}>
        <PlatformButton
          label="TikTok"
          url={liveEvent?.platform === "tiktok" ? liveEvent.externalUrl : "https://www.tiktok.com/live"}
        />
        <PlatformButton
          label="Instagram"
          url={liveEvent?.platform === "instagram" ? liveEvent.externalUrl : "https://www.instagram.com/"}
        />
      </View>
    </View>
  );
}

function getQuestIcon(
  quest: Quest,
  completed: boolean
): keyof typeof Ionicons.glyphMap {
  if (completed) {
    return "checkmark";
  }

  if (quest.type === "creator_promotion") {
    return "videocam";
  }

  if (quest.type === "photo_prompt") {
    return "camera";
  }

  if (quest.type === "question") {
    return "help";
  }

  return "walk";
}

function PlatformButton({ label, url }: { label: string; url: string }) {
  return (
    <Pressable
      accessibilityRole="link"
      onPress={() => Linking.openURL(url)}
      style={styles.platformButton}
    >
      <Ionicons name="open-outline" size={16} color="#fee2e2" />
      <Text style={styles.platformButtonText}>{label}</Text>
    </Pressable>
  );
}

function ProfileScreen() {
  return (
    <ScrollView contentContainerStyle={styles.content}>
      <View style={styles.profilePanel}>
        <Text style={styles.sectionTitle}>Explorer profile</Text>
        <Text style={styles.profilePoints}>{userStats.points} points</Text>
        <Text style={styles.questDescription}>
          Keep walking the city to unlock more memory layers and local badges.
        </Text>
      </View>
      <View style={styles.sectionHeader}>
        <Text style={styles.sectionTitle}>Badges</Text>
      </View>
      {userStats.badges.map((badge) => (
        <View key={badge} style={styles.badgeRow}>
          <Ionicons name="ribbon" size={20} color="#22c55e" />
          <Text style={styles.badgeText}>{badge}</Text>
        </View>
      ))}
    </ScrollView>
  );
}

function TabButton({
  icon,
  label,
  active,
  onPress
}: {
  icon: keyof typeof Ionicons.glyphMap;
  label: string;
  active: boolean;
  onPress: () => void;
}) {
  return (
    <Pressable
      accessibilityRole="button"
      onPress={onPress}
      style={[styles.tabButton, active && styles.tabButtonActive]}
    >
      <Ionicons name={icon} size={20} color={active ? "#111827" : "#d1d5db"} />
      <Text style={[styles.tabText, active && styles.tabTextActive]}>{label}</Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: "#08111f"
  },
  shell: {
    flex: 1,
    backgroundColor: "#0d1424"
  },
  header: {
    alignItems: "center",
    backgroundColor: "#111827",
    borderBottomColor: "#243244",
    borderBottomWidth: 1,
    flexDirection: "row",
    justifyContent: "space-between",
    paddingHorizontal: 20,
    paddingTop: 20,
    paddingBottom: 18,
    position: "relative",
    overflow: "hidden"
  },
  headerGlow: {
    backgroundColor: "#0f766e",
    borderRadius: 999,
    height: 140,
    opacity: 0.28,
    position: "absolute",
    right: -42,
    top: -64,
    width: 140
  },
  eyebrow: {
    color: "#67e8f9",
    fontSize: 13,
    fontWeight: "700",
    letterSpacing: 0,
    textTransform: "uppercase"
  },
  title: {
    color: "#f9fafb",
    fontSize: 34,
    fontWeight: "800",
    letterSpacing: 0,
    marginTop: 2
  },
  subtitle: {
    color: "#b6c6d8",
    fontSize: 13,
    fontWeight: "600",
    marginTop: 4
  },
  pointsPill: {
    alignItems: "center",
    backgroundColor: "#fff7ed",
    borderColor: "#fed7aa",
    borderRadius: 8,
    borderWidth: 1,
    flexDirection: "row",
    gap: 6,
    paddingHorizontal: 12,
    paddingVertical: 8
  },
  pointsText: {
    color: "#92400e",
    fontWeight: "800"
  },
  segmented: {
    backgroundColor: "#172033",
    borderColor: "#263549",
    borderRadius: 8,
    borderWidth: 1,
    flexDirection: "row",
    gap: 6,
    margin: 20,
    padding: 4
  },
  segmentButton: {
    alignItems: "center",
    borderRadius: 6,
    flex: 1,
    minHeight: 42,
    justifyContent: "center"
  },
  segmentButtonActive: {
    backgroundColor: "#d9f99d"
  },
  segmentText: {
    color: "#d1d5db",
    fontWeight: "700"
  },
  segmentTextActive: {
    color: "#365314"
  },
  content: {
    paddingBottom: 108,
    paddingHorizontal: 20
  },
  mapPlaceholder: {
    aspectRatio: 1.16,
    backgroundColor: "#0f3f46",
    borderColor: "#2dd4bf",
    borderRadius: 8,
    borderWidth: 1,
    marginBottom: 22,
    overflow: "hidden",
    position: "relative"
  },
  mapGrid: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: "#10525a",
    opacity: 0.92
  },
  mapPathOne: {
    backgroundColor: "rgba(254,243,199,0.88)",
    borderRadius: 999,
    height: 14,
    left: "-8%",
    position: "absolute",
    top: "52%",
    transform: [{ rotate: "-18deg" }],
    width: "118%"
  },
  mapPathTwo: {
    backgroundColor: "rgba(219,234,254,0.86)",
    borderRadius: 999,
    height: 12,
    left: "28%",
    position: "absolute",
    top: "-10%",
    transform: [{ rotate: "28deg" }],
    width: "25%"
  },
  mapWater: {
    backgroundColor: "rgba(14,165,233,0.32)",
    borderRadius: 999,
    bottom: "-14%",
    height: "38%",
    position: "absolute",
    right: "-12%",
    width: "62%"
  },
  mapDistrict: {
    backgroundColor: "rgba(8,17,31,0.78)",
    borderColor: "rgba(255,255,255,0.2)",
    borderRadius: 8,
    borderWidth: 1,
    left: 14,
    paddingHorizontal: 12,
    paddingVertical: 10,
    position: "absolute",
    top: 14
  },
  mapDistrictText: {
    color: "#f8fafc",
    fontSize: 16,
    fontWeight: "900"
  },
  mapDistrictMeta: {
    color: "#a7f3d0",
    fontSize: 12,
    fontWeight: "800",
    marginTop: 2
  },
  questPin: {
    alignItems: "center",
    backgroundColor: "#fff7ed",
    borderColor: "#fed7aa",
    borderRadius: 999,
    borderWidth: 2,
    height: 44,
    justifyContent: "center",
    position: "absolute",
    width: 44
  },
  livePin: {
    alignItems: "center",
    backgroundColor: "#dc2626",
    borderColor: "#fee2e2",
    borderRadius: 999,
    borderWidth: 2,
    height: 46,
    justifyContent: "center",
    position: "absolute",
    width: 46
  },
  livePinPulse: {
    backgroundColor: "rgba(248,113,113,0.32)",
    borderRadius: 999,
    height: 62,
    position: "absolute",
    width: 62
  },
  livePanel: {
    backgroundColor: "#311116",
    borderColor: "#f87171",
    borderRadius: 8,
    borderWidth: 1,
    marginBottom: 22,
    padding: 14
  },
  liveHeader: {
    alignItems: "center",
    flexDirection: "row",
    gap: 8,
    marginBottom: 10
  },
  liveDot: {
    backgroundColor: "#ef4444",
    borderRadius: 999,
    height: 9,
    width: 9
  },
  liveLabel: {
    color: "#fecaca",
    fontSize: 12,
    fontWeight: "900",
    letterSpacing: 0,
    textTransform: "uppercase"
  },
  liveRow: {
    alignItems: "center",
    backgroundColor: "rgba(254,226,226,0.08)",
    borderRadius: 8,
    flexDirection: "row",
    gap: 12,
    justifyContent: "space-between",
    padding: 10
  },
  liveCopy: {
    flex: 1
  },
  liveTitle: {
    color: "#fff7ed",
    fontSize: 16,
    fontWeight: "900"
  },
  liveDescription: {
    color: "#fecaca",
    fontSize: 13,
    marginTop: 3,
    textTransform: "capitalize"
  },
  liveCampaignLabel: {
    alignSelf: "flex-start",
    backgroundColor: "#fdf2f8",
    borderRadius: 999,
    color: "#9d174d",
    fontSize: 11,
    fontWeight: "900",
    marginTop: 7,
    overflow: "hidden",
    paddingHorizontal: 8,
    paddingVertical: 3
  },
  followPanel: {
    alignItems: "center",
    backgroundColor: "#d1fae5",
    borderColor: "#6ee7b7",
    borderWidth: 1,
    borderRadius: 8,
    flexDirection: "row",
    gap: 12,
    marginBottom: 22,
    padding: 14
  },
  followIcon: {
    alignItems: "center",
    backgroundColor: "#67e8f9",
    borderRadius: 8,
    height: 42,
    justifyContent: "center",
    width: 42
  },
  followBody: {
    flex: 1
  },
  followTitle: {
    color: "#083344",
    fontSize: 16,
    fontWeight: "900"
  },
  followCopy: {
    color: "#115e59",
    fontSize: 13,
    lineHeight: 18,
    marginTop: 2
  },
  followMeta: {
    color: "#134e4a",
    fontSize: 12,
    fontWeight: "800",
    lineHeight: 17,
    marginTop: 6
  },
  followButton: {
    alignItems: "center",
    backgroundColor: "#0f766e",
    borderRadius: 8,
    justifyContent: "center",
    minHeight: 38,
    paddingHorizontal: 12
  },
  followButtonText: {
    color: "#ecfeff",
    fontWeight: "900"
  },
  liveButton: {
    alignItems: "center",
    backgroundColor: "#ef4444",
    borderRadius: 8,
    flexDirection: "row",
    gap: 6,
    minHeight: 38,
    paddingHorizontal: 12
  },
  liveButtonText: {
    color: "#fef2f2",
    fontWeight: "900"
  },
  sectionHeader: {
    alignItems: "center",
    flexDirection: "row",
    justifyContent: "space-between",
    marginBottom: 10
  },
  sectionTitle: {
    color: "#f9fafb",
    fontSize: 20,
    fontWeight: "800"
  },
  sectionMeta: {
    color: "#a7f3d0",
    fontWeight: "700"
  },
  questCard: {
    backgroundColor: "#151f31",
    borderColor: "#2a3a50",
    borderRadius: 8,
    borderWidth: 1,
    flexDirection: "row",
    gap: 12,
    marginBottom: 10,
    padding: 14
  },
  questCardSelected: {
    backgroundColor: "#182846",
    borderColor: "#93c5fd"
  },
  questIcon: {
    alignItems: "center",
    backgroundColor: "#d9f99d",
    borderRadius: 8,
    height: 38,
    justifyContent: "center",
    width: 38
  },
  questIconCreator: {
    backgroundColor: "#be185d"
  },
  questBody: {
    flex: 1
  },
  questTitle: {
    color: "#f9fafb",
    fontSize: 16,
    fontWeight: "800"
  },
  questDescription: {
    color: "#cbd5e1",
    fontSize: 14,
    lineHeight: 20,
    marginTop: 4
  },
  questMetaRow: {
    flexDirection: "row",
    gap: 8,
    marginTop: 10
  },
  questMeta: {
    backgroundColor: "#ecfeff",
    borderRadius: 999,
    color: "#155e75",
    fontSize: 12,
    fontWeight: "700",
    overflow: "hidden",
    paddingHorizontal: 9,
    paddingVertical: 4
  },
  questMetaCreator: {
    backgroundColor: "#fdf2f8",
    color: "#9d174d"
  },
  detailPanel: {
    backgroundColor: "#13233f",
    borderColor: "#35527c",
    borderWidth: 1,
    borderRadius: 8,
    marginTop: 10,
    padding: 16
  },
  detailLabel: {
    color: "#bfdbfe",
    fontSize: 12,
    fontWeight: "800",
    letterSpacing: 0,
    textTransform: "uppercase"
  },
  detailTitle: {
    color: "#f9fafb",
    fontSize: 20,
    fontWeight: "800",
    marginTop: 6
  },
  detailCopy: {
    color: "#dbeafe",
    lineHeight: 22,
    marginTop: 8
  },
  handoffPanel: {
    alignItems: "center",
    backgroundColor: "#fef3c7",
    borderColor: "#fbbf24",
    borderRadius: 8,
    borderWidth: 1,
    flexDirection: "row",
    gap: 10,
    marginTop: 12,
    padding: 12
  },
  handoffText: {
    color: "#78350f",
    flex: 1,
    fontSize: 13,
    fontWeight: "800",
    lineHeight: 18
  },
  safetyRow: {
    flexDirection: "row",
    flexWrap: "wrap",
    gap: 8,
    marginTop: 12
  },
  safetyPill: {
    backgroundColor: "#eef2ff",
    borderRadius: 999,
    color: "#3730a3",
    fontSize: 11,
    fontWeight: "800",
    overflow: "hidden",
    paddingHorizontal: 9,
    paddingVertical: 5,
    textTransform: "capitalize"
  },
  primaryButton: {
    alignItems: "center",
    alignSelf: "flex-start",
    backgroundColor: "#fcd34d",
    borderRadius: 8,
    flexDirection: "row",
    gap: 8,
    marginTop: 16,
    minHeight: 44,
    paddingHorizontal: 14
  },
  primaryButtonDisabled: {
    backgroundColor: "#86efac"
  },
  primaryButtonText: {
    color: "#111827",
    fontWeight: "800"
  },
  broadcastPanel: {
    alignItems: "center",
    backgroundColor: "#7f1d1d",
    borderRadius: 8,
    flexDirection: "row",
    gap: 10,
    marginTop: 14,
    padding: 12
  },
  broadcastIcon: {
    alignItems: "center",
    backgroundColor: "#dc2626",
    borderRadius: 8,
    height: 38,
    justifyContent: "center",
    width: 38
  },
  broadcastBody: {
    flex: 1
  },
  broadcastTitle: {
    color: "#fff7ed",
    fontWeight: "900"
  },
  broadcastCopy: {
    color: "#fecaca",
    fontSize: 12,
    lineHeight: 17,
    marginTop: 2
  },
  broadcastButton: {
    alignItems: "center",
    backgroundColor: "#fee2e2",
    borderRadius: 8,
    minHeight: 36,
    justifyContent: "center",
    paddingHorizontal: 12
  },
  broadcastButtonText: {
    color: "#991b1b",
    fontWeight: "900"
  },
  platformRow: {
    flexDirection: "row",
    gap: 10,
    marginTop: 12
  },
  platformButton: {
    alignItems: "center",
    backgroundColor: "#991b1b",
    borderRadius: 8,
    flex: 1,
    flexDirection: "row",
    gap: 8,
    justifyContent: "center",
    minHeight: 42
  },
  platformButtonText: {
    color: "#fee2e2",
    fontWeight: "900"
  },
  profilePanel: {
    backgroundColor: "#151f31",
    borderColor: "#2a3a50",
    borderWidth: 1,
    borderRadius: 8,
    marginBottom: 22,
    padding: 18
  },
  profilePoints: {
    color: "#facc15",
    fontSize: 34,
    fontWeight: "900",
    marginTop: 10
  },
  badgeRow: {
    alignItems: "center",
    backgroundColor: "#151f31",
    borderColor: "#2a3a50",
    borderWidth: 1,
    borderRadius: 8,
    flexDirection: "row",
    gap: 10,
    marginBottom: 10,
    minHeight: 52,
    paddingHorizontal: 14
  },
  badgeText: {
    color: "#f9fafb",
    fontWeight: "800"
  },
  tabs: {
    backgroundColor: "#08111f",
    borderTopColor: "#334155",
    borderTopWidth: 1,
    bottom: 0,
    flexDirection: "row",
    gap: 10,
    left: 0,
    padding: 14,
    position: "absolute",
    right: 0
  },
  tabButton: {
    alignItems: "center",
    borderRadius: 8,
    flex: 1,
    flexDirection: "row",
    gap: 8,
    justifyContent: "center",
    minHeight: 48
  },
  tabButtonActive: {
    backgroundColor: "#d9f99d"
  },
  tabText: {
    color: "#d1d5db",
    fontWeight: "800"
  },
  tabTextActive: {
    color: "#365314"
  }
});

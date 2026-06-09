import type { ReactNode } from "react";
import { CommerceFacetBar, CvSnapshot, FilterRow, FlowIntro, Opportunity, PlaceDoor, StatusGroup } from "./HubPrimitives";
import type {
  CommerceFacetSignal,
  EcosystemIdentity,
  OpportunityAction,
  OpportunityCard,
  OpportunityType,
  PlaceMode,
  PlaceOption,
  PlaceType,
  PrivacyLevel,
  StudentCvProfile
} from "../../types";

interface TopicItem {
  id: string;
  label: string;
  detail: string;
  safety: string;
  heat: string;
}

interface HubViewProps {
  activeMode: PlaceMode;
  activeApps: Array<{ productId: string }>;
  activeChannels: Array<{ channelId: string }>;
  activeCommerceFacets: CommerceFacetSignal[];
  aiCrew: Array<{ source: string; title: string; text: string }>;
  browseFeed: boolean;
  browsePlaces: boolean;
  coreActionNotice: string | null;
  coreSnapshotSource: string;
  cvProfile: StudentCvProfile;
  feedFilter: OpportunityType | "all";
  feedFilters: Array<{ id: OpportunityType | "all"; label: string }>;
  feedPreviewLimit: number;
  identityState: EcosystemIdentity;
  inlineSkills: ReactNode;
  modeHeadlines: Record<PlaceMode, string>;
  modeLabels: Record<PlaceMode, string>;
  nearbyPlacePreviewLimit: number;
  nearbyPlaces: PlaceOption[];
  nearbyTopics: TopicItem[];
  opportunities: OpportunityCard[];
  opportunityIcons: Record<OpportunityType, ReactNode>;
  opportunityLabels: Record<OpportunityType, string>;
  placeFilter: PlaceType | "all";
  placeFilters: Array<{ id: PlaceType | "all"; label: string }>;
  privacyLevel: PrivacyLevel;
  privacyOptions: Array<{ id: PrivacyLevel; label: string }>;
  reportedIds: string[];
  selectedPlace: PlaceOption;
  showSettings: boolean;
  visibleOpportunities: OpportunityCard[];
  visiblePlaces: PlaceOption[];
  visibleTopics: TopicItem[];
  onAction: (opportunity: OpportunityCard, action: OpportunityAction) => void;
  onJoinQueue: (placeId: string, placeName: string) => void;
  onOpenPlace: (place: PlaceOption) => void;
  onSetActiveCommerceFacets: (facets: CommerceFacetSignal[]) => void;
  onSetBrowseFeed: (value: boolean | ((current: boolean) => boolean)) => void;
  onSetBrowsePlaces: (value: boolean | ((current: boolean) => boolean)) => void;
  onSetDismissedIds: (ids: string[]) => void;
  onSetFeedFilter: (id: OpportunityType | "all") => void;
  onSetPlaceFilter: (id: PlaceType | "all") => void;
  onSetPrivacyLevel: (level: PrivacyLevel) => void;
  onSetSelectedMode: (mode: PlaceMode) => void;
  onSetShowSettings: (value: boolean | ((current: boolean) => boolean)) => void;
  onToggleCommerceFacet: (facet: CommerceFacetSignal) => void;
  checkMarkIcon: ReactNode;
  settingsIcon: ReactNode;
}

export function HubView({
  activeMode,
  activeApps,
  activeChannels,
  activeCommerceFacets,
  aiCrew,
  browseFeed,
  browsePlaces,
  checkMarkIcon,
  coreActionNotice,
  coreSnapshotSource,
  cvProfile,
  feedFilter,
  feedFilters,
  feedPreviewLimit,
  identityState,
  inlineSkills,
  modeHeadlines,
  modeLabels,
  nearbyPlacePreviewLimit,
  nearbyPlaces,
  nearbyTopics,
  opportunities,
  opportunityIcons,
  opportunityLabels,
  placeFilter,
  placeFilters,
  privacyLevel,
  privacyOptions,
  reportedIds,
  selectedPlace,
  settingsIcon,
  showSettings,
  visibleOpportunities,
  visiblePlaces,
  visibleTopics,
  onAction,
  onJoinQueue,
  onOpenPlace,
  onSetActiveCommerceFacets,
  onSetBrowseFeed,
  onSetBrowsePlaces,
  onSetDismissedIds,
  onSetFeedFilter,
  onSetPlaceFilter,
  onSetPrivacyLevel,
  onSetSelectedMode,
  onSetShowSettings,
  onToggleCommerceFacet
}: HubViewProps) {
  return (
    <div className="app-shell">
      <section className="top-bar" aria-label="LesTupid Go status">
        <div>
          <p className="eyebrow">LesTupid Go</p>
          <h1>{modeHeadlines[activeMode]}</h1>
        </div>
        <div className="identity-card">
          <span className="status-dot" />
          <div>
            <strong>{identityState.label}</strong>
            <span>{identityState.status} via {coreSnapshotSource}</span>
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
                  onSetSelectedMode(mode);
                  onSetDismissedIds([]);
                  onSetFeedFilter("all");
                  onSetActiveCommerceFacets([]);
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
              onClick={() => onJoinQueue(selectedPlace.id, selectedPlace.name)}
            >
              {checkMarkIcon}
              <span>Sıraya Gir</span>
            </button>
            <button
              className={`settings-toggle-button ${showSettings ? "active" : ""}`}
              type="button"
              onClick={() => onSetShowSettings(!showSettings)}
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
                  onClick={() => onSetPrivacyLevel(option.id)}
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

      <CvSnapshot profile={cvProfile} place={selectedPlace} mode={activeMode} modeLabels={modeLabels} />

      <section className="content-grid">
        <aside className="static-rail" aria-labelledby="places-title">
          <div className="rail-heading">
            <div>
              <p className="eyebrow">Nearby</p>
              <h2 id="places-title">Places near me</h2>
            </div>
          </div>

          <FilterRow items={placeFilters} activeId={placeFilter} onPick={(id) => onSetPlaceFilter(id)} />

          <div className="place-list">
            {nearbyPlaces.map((place) => (
              <PlaceDoor key={place.id} place={place} active={place.id === selectedPlace.id} onOpen={onOpenPlace} />
            ))}
          </div>
          {visiblePlaces.length > nearbyPlacePreviewLimit ? (
            <button className="browse-button" type="button" onClick={() => onSetBrowsePlaces((value) => !value)}>
              {browsePlaces ? "Show less places" : `Browse ${visiblePlaces.length - nearbyPlacePreviewLimit} more places`}
            </button>
          ) : null}

          <StatusGroup title="Apps" items={activeApps.map((app) => app.productId)} />
          <StatusGroup title="Channels" items={activeChannels.map((channel) => channel.channelId)} />
          {coreActionNotice ? <p className="small-note">{coreActionNotice}</p> : null}
        </aside>

        <section className="feed-section" aria-labelledby="feed-title">
          <div className="feed-heading">
            <div>
              <p className="eyebrow">Flow & Opportunities</p>
              <h2 id="feed-title">Focus on what matters now</h2>
            </div>
            {reportedIds.length > 0 ? <span className="report-pill">{reportedIds.length} report queued</span> : null}
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
              onSetFeedFilter(id);
              onSetBrowseFeed(false);
            }}
          />

          <CommerceFacetBar
            activeFacets={activeCommerceFacets}
            total={opportunities.length}
            onToggle={onToggleCommerceFacet}
            onClear={() => onSetActiveCommerceFacets([])}
          />

          <div className="feed-stack">
            <FlowIntro place={selectedPlace} mode={activeMode} modeLabels={modeLabels} />
            {visibleOpportunities.map((opportunity) => (
              <Opportunity
                key={opportunity.id}
                opportunity={opportunity}
                onAction={onAction}
                activeCommerceFacets={activeCommerceFacets}
                onCommerceFacetSelect={onToggleCommerceFacet}
                opportunityIcons={opportunityIcons}
                opportunityLabels={opportunityLabels}
              />
            ))}
            {opportunities.length === 0 ? (
              <div className="empty-feed-card">
                <strong>No cards match these commerce filters.</strong>
                <span>Clear a facet or change the nearby context.</span>
              </div>
            ) : null}
            {opportunities.length > feedPreviewLimit ? (
              <button className="browse-feed-button" type="button" onClick={() => onSetBrowseFeed((value) => !value)}>
                {browseFeed ? "Show fewer cards" : `Browse ${opportunities.length - feedPreviewLimit} more cards`}
              </button>
            ) : null}
          </div>
        </section>
      </section>

      {inlineSkills}
    </div>
  );
}

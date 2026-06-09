import { useState } from "react";
import type {
  CommerceFacetSignal,
  OpportunityAction,
  OpportunityCard,
  OpportunityType,
  PlaceMode,
  PlaceOption,
  StudentCvProfile
} from "../../types";

function sameCommerceFacet(left: CommerceFacetSignal, right: CommerceFacetSignal) {
  return left.key === right.key && left.value === right.value;
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

export function CvSnapshot({
  profile,
  place,
  mode,
  modeLabels
}: {
  profile: StudentCvProfile;
  place: PlaceOption;
  mode: PlaceMode;
  modeLabels: Record<PlaceMode, string>;
}) {
  const topSignals = profile.signals.slice(0, 3);

  return (
    <section className="cv-snapshot" aria-label="Living CV">
      <div className="cv-main">
        <div>
          <p className="eyebrow">Living CV</p>
          <h2>CV burada buyusun</h2>
          <p>
            {profile.headline}. {place.name} ve {modeLabels[mode]} modu; quest, basvuru,
            servis isi, sertifika ve AI taslaklarini paylasmadan once kontrol edilen CV sinyaline cevirir.
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

export function FilterRow<T extends string>({
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

export function PlaceDoor({
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

export function FlowIntro({
  place,
  mode,
  modeLabels
}: {
  place: PlaceOption;
  mode: PlaceMode;
  modeLabels: Record<PlaceMode, string>;
}) {
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

export function StatusGroup({ title, items }: { title: string; items: string[] }) {
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

export function CommerceFacetBar({
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

export function Opportunity({
  opportunity,
  onAction,
  activeCommerceFacets,
  onCommerceFacetSelect,
  opportunityIcons,
  opportunityLabels
}: {
  opportunity: OpportunityCard;
  onAction: (opportunity: OpportunityCard, action: OpportunityAction) => void;
  activeCommerceFacets: CommerceFacetSignal[];
  onCommerceFacetSelect: (facet: CommerceFacetSignal) => void;
  opportunityIcons: Record<OpportunityType, React.ReactNode>;
  opportunityLabels: Record<OpportunityType, string>;
}) {
  const [expanded, setExpanded] = useState(false);
  const primaryAction = opportunity.actions.find((action) => action.kind === "primary") || opportunity.actions[0];

  return (
    <article className={`flow-card opportunity-card ${opportunity.type} tempo-${opportunity.tempo} ${expanded ? "expanded" : ""}`}>
      <button
        className="card-expand-toggle"
        onClick={() => setExpanded(!expanded)}
        aria-label="Toggle details"
        title={expanded ? "Detaylari Kapat" : "Detaylari Goster"}
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
      <CommerceFacetChips facets={opportunity.commerceFacets} activeFacets={activeCommerceFacets} onSelect={onCommerceFacetSelect} />

      {!expanded && primaryAction && (
        <div className="action-row simple-action">
          <button className={`action-button ${primaryAction.kind}`} type="button" onClick={() => onAction(opportunity, primaryAction)}>
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
                <span key={label} className="safety-pill">
                  {label}
                </span>
              ))}
            </div>
          </div>
        )}

        <div className="action-row expanded-actions">
          {opportunity.actions.map((action) => (
            <button className={`action-button ${action.kind}`} key={action.id} type="button" onClick={() => onAction(opportunity, action)}>
              {action.label}
            </button>
          ))}
        </div>
      </div>
    </article>
  );
}

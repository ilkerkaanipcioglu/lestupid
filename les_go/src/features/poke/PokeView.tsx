import type { ReactNode } from "react";
import type { QuestItem } from "../../types";

interface PokeViewProps {
  modeNote: ReactNode;
  inlineSkills: ReactNode;
  quests: QuestItem[];
  selectedQuest: QuestItem | null;
  questXp: number;
  simulatingGps: boolean;
  onSelectQuest: (quest: QuestItem) => void;
  onSimulateGps: () => void;
}

export function PokeView({
  modeNote,
  inlineSkills,
  quests,
  selectedQuest,
  questXp,
  simulatingGps,
  onSelectQuest,
  onSimulateGps
}: PokeViewProps) {
  return (
    <div className="sim-container">
      <div className="sim-header">
        <h2>Les Poke (City Quests)</h2>
        <p>Safe real-world challenges, public coordinates check-ins, and local drop policies.</p>
        {modeNote}
      </div>

      <div className="poke-dashboard">
        <div>
          <div className="map-container">
            <div className="map-grid-overlay" />
            {quests.map((quest) => (
              <div
                key={quest.id}
                className="map-marker"
                style={{ left: `${quest.coordinates.x}%`, top: `${quest.coordinates.y}%` }}
                onClick={() => onSelectQuest(quest)}
              >
                <div className={`marker-beacon ${quest.status}`} />
                <div className="marker-tooltip">{quest.name}</div>
              </div>
            ))}
          </div>
          <div className="poke-status-row">
            <span>
              Seviye XP: <strong>{questXp}</strong>
            </span>
            <span className="poke-status-live">Haritada {quests.length} Quest Aktif</span>
          </div>
        </div>

        <div>
          {selectedQuest ? (
            <div className="poke-quest-card">
              <span className="poke-xp-badge">+{selectedQuest.xp} XP</span>
              <h3>{selectedQuest.name}</h3>
              <p>{selectedQuest.detail}</p>
              <div className="poke-quest-meta">
                Konum ID: <code>{selectedQuest.placeId}</code>
              </div>

              {selectedQuest.status === "completed" ? (
                <div className="poke-quest-success">Gorev basariyla tamamlandi</div>
              ) : (
                <button className="action-button primary poke-quest-action" onClick={onSimulateGps} disabled={simulatingGps}>
                  {simulatingGps ? "GPS Dogrulaniyor..." : "Konumda Check-in Yap (GPS Simule)"}
                </button>
              )}
            </div>
          ) : (
            <div className="poke-empty-state">Quest detaylari icin haritadaki noktalara tiklayin.</div>
          )}
        </div>
      </div>

      {inlineSkills}
    </div>
  );
}

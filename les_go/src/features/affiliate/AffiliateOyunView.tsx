import type { ReactNode } from "react";
import type { OyunCard } from "../../types";

interface AffiliateOyunViewProps {
  modeNote: ReactNode;
  inlineSkills: ReactNode;
  playerHp: number;
  aiHp: number;
  winnerMessage: string | null;
  duelActive: boolean;
  gameLogs: string[];
  oyunHand: OyunCard[];
  onResetGame: () => void;
  onStartDuel: () => void;
  onPlayCard: (card: OyunCard) => void;
}

export function AffiliateOyunView({
  modeNote,
  inlineSkills,
  playerHp,
  aiHp,
  winnerMessage,
  duelActive,
  gameLogs,
  oyunHand,
  onResetGame,
  onStartDuel,
  onPlayCard
}: AffiliateOyunViewProps) {
  return (
    <div className="sim-container">
      <div className="sim-header">
        <h2>Les Affiliate Oyun (Card Game)</h2>
        <p>Social commerce card battles, quest item modifiers, and certified gaming economy.</p>
        {modeNote}
      </div>

      <div className="duel-arena">
        <div className="arena-grid">
          <div className="arena-player">
            <strong>Sen (Player)</strong>
            <div className="health-bar">
              <div className="health-bar-fill" style={{ width: `${playerHp}%` }} />
            </div>
            <div className="arena-hp-label">HP: {playerHp}/100</div>
          </div>

          <div className="arena-versus">VS</div>

          <div className="arena-player">
            <strong>AI Rakipler</strong>
            <div className="health-bar">
              <div className={`health-bar-fill ${aiHp < 30 ? "warning" : ""}`} style={{ width: `${aiHp}%` }} />
            </div>
            <div className="arena-hp-label">HP: {aiHp}/100</div>
          </div>
        </div>

        {winnerMessage ? (
          <div className="arena-result-card">
            <h3>{winnerMessage}</h3>
            <button className="action-button primary arena-result-action" onClick={onResetGame}>
              Yeni Oyun Baslat
            </button>
          </div>
        ) : duelActive ? (
          <div>
            <div className="arena-log-panel">
              {gameLogs.map((log, idx) => (
                <div key={idx} className="arena-log-line">
                  {log}
                </div>
              ))}
            </div>

            <h4 className="arena-prompt">Oynamak Icin Bir Kart Sec</h4>
            <div className="game-card-fan">
              {oyunHand.map((card) => (
                <button className={`game-card ${card.rarity}`} key={card.id} onClick={() => onPlayCard(card)}>
                  <div className="game-card-image">{card.image}</div>
                  <div className="game-card-name">{card.name}</div>
                  <div className="game-card-stats">
                    <span className="game-card-atk">ATK:{card.power}</span>
                    <span className="game-card-def">DEF:{card.defense}</span>
                  </div>
                </button>
              ))}
            </div>
          </div>
        ) : (
          <div className="arena-idle-state">
            <p>Desten hazir: 3 adet affiliate ve quest karti aktif.</p>
            <button className="action-button primary" onClick={onStartDuel}>
              Duello Arenasini Baslat
            </button>
          </div>
        )}
      </div>

      {inlineSkills}
    </div>
  );
}

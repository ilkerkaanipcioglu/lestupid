import type { FormEvent, ReactNode } from "react";
import type { MatchProfile } from "../../types";

interface MatchViewProps {
  modeNote: ReactNode;
  inlineSkills: ReactNode;
  activeChatMatch: MatchProfile | null;
  matchChatHistory: string[];
  matchChatMsg: string;
  matchProfiles: MatchProfile[];
  matchIndex: number;
  showMatchPopup: boolean;
  onCloseChat: () => void;
  onMatchChatMsgChange: (value: string) => void;
  onSendMatchMsg: (event: FormEvent<HTMLFormElement>) => void;
  onMatchChoice: (interested: boolean) => void;
  onOpenChatFromPopup: () => void;
  onDismissPopup: () => void;
}

export function MatchView({
  modeNote,
  inlineSkills,
  activeChatMatch,
  matchChatHistory,
  matchChatMsg,
  matchProfiles,
  matchIndex,
  showMatchPopup,
  onCloseChat,
  onMatchChatMsgChange,
  onSendMatchMsg,
  onMatchChoice,
  onOpenChatFromPopup,
  onDismissPopup
}: MatchViewProps) {
  return (
    <div className="sim-container">
      <div className="sim-header">
        <h2>Les Match (Matchmaking)</h2>
        <p>Consent-first discovery, pseudonym listings, and certified interest matching.</p>
        {modeNote}
      </div>

      {activeChatMatch ? (
        <div className="match-chat-shell">
          <div className="match-chat-header">
            <div>
              <strong>{activeChatMatch.pseudonym}</strong>
              <div className="match-chat-subtitle">Secure Channel [Acik Baglanti]</div>
            </div>
            <button className="action-button secondary match-chat-close" onClick={onCloseChat}>
              Kapat
            </button>
          </div>
          <div className="match-chat-body">
            <div className="match-chat-note">Eslesme saglandi. Bu kanal gecici bir onizlemedir.</div>
            {matchChatHistory.map((message, idx) => {
              const mine = message.startsWith("Sen:");
              return (
                <div className={mine ? "match-chat-bubble mine" : "match-chat-bubble"} key={idx}>
                  {message.replace(/^(Sen:|[^:]+:)/, "")}
                </div>
              );
            })}
          </div>
          <form onSubmit={onSendMatchMsg} className="match-chat-form">
            <input
              type="text"
              placeholder="Guvenli mesaj yaz..."
              value={matchChatMsg}
              onChange={(event) => onMatchChatMsgChange(event.target.value)}
              className="match-chat-input"
            />
            <button className="action-button primary match-chat-send">Gonder</button>
          </form>
        </div>
      ) : (
        <div className="matchmaker-suite">
          <div className="swipe-deck">
            {matchProfiles.map((profile, idx) => {
              if (idx !== matchIndex) return null;

              return (
                <div className="swipe-card" key={profile.id}>
                  <div>
                    <div className="match-avatar-circle">M</div>
                    <h2>{profile.pseudonym}</h2>
                    <div className="match-distance">Uzaklik: {profile.distance}</div>
                    <div className="pill-row match-tag-row">
                      {profile.tags.map((tag) => (
                        <span key={tag} className="pill match-tag-pill">
                          {tag}
                        </span>
                      ))}
                    </div>
                    <p className="match-description">{profile.description}</p>
                  </div>

                  <div className="match-action-grid">
                    <button className="action-button secondary" onClick={() => onMatchChoice(false)}>
                      Gec (Skip)
                    </button>
                    <button className="action-button primary match-like-button" onClick={() => onMatchChoice(true)}>
                      Ilgi Goster (Like)
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
            <div className="match-pulse-ring">LOVE</div>
            <h2>Karsilikli Ilgi!</h2>
            <p className="match-popup-copy">
              <strong>{matchProfiles[matchIndex]?.pseudonym}</strong> da seninle eslesmek istiyor. Guvenli sohbete
              gecebilirsiniz.
            </p>
            <div className="match-popup-actions">
              <button className="action-button primary" onClick={onOpenChatFromPopup}>
                Mesaj Gonder
              </button>
              <button className="action-button secondary" onClick={onDismissPopup}>
                Sonra (Kapat)
              </button>
            </div>
          </div>
        </div>
      )}

      {inlineSkills}
    </div>
  );
}

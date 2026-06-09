import type { ChangeEvent, ReactNode } from "react";
import type { PlaceOption, QueueTicket, QuestItem } from "../../types";

interface WaitSurface {
  code: string;
  link: string;
  qrUrl: string;
}

interface WaitViewProps {
  modeNote: ReactNode;
  inlineSkills: ReactNode;
  waitChannel: QueueTicket["channel"];
  waitSurfaceCode: string;
  phoneSurfaceCode: string;
  waitProofRef: string;
  waitNotice: string;
  waitOwnerService: string;
  waitOwnerFlow: string;
  waitTicket: QueueTicket | null;
  selectedPlace: PlaceOption;
  selectedQuest: QuestItem | null;
  currentWaitSurface: WaitSurface;
  waitPlaces: PlaceOption[];
  onWaitChannelChange: (channel: QueueTicket["channel"]) => void;
  onWaitSurfaceCodeChange: (value: string) => void;
  onWaitProofRefChange: (value: string) => void;
  onWaitNoticeChange: (value: string) => void;
  onWaitOwnerServiceChange: (value: string) => void;
  onWaitOwnerFlowChange: (value: string) => void;
  onPhotoProofSelect: (file?: File) => void;
  onUseOwnerQr: () => void;
  onOpenPoke: () => void;
  onJoinQueue: (venueId: string, venueName: string) => void;
  onFastForwardQueue: () => void;
  onCancelTicket: () => void;
}

export function WaitView({
  modeNote,
  inlineSkills,
  waitChannel,
  waitSurfaceCode,
  phoneSurfaceCode,
  waitProofRef,
  waitNotice,
  waitOwnerService,
  waitOwnerFlow,
  waitTicket,
  selectedPlace,
  selectedQuest,
  currentWaitSurface,
  waitPlaces,
  onWaitChannelChange,
  onWaitSurfaceCodeChange,
  onWaitProofRefChange,
  onWaitNoticeChange,
  onWaitOwnerServiceChange,
  onWaitOwnerFlowChange,
  onPhotoProofSelect,
  onUseOwnerQr,
  onOpenPoke,
  onJoinQueue,
  onFastForwardQueue,
  onCancelTicket
}: WaitViewProps) {
  return (
    <div className="sim-container">
      <div className="sim-header">
        <h2>Waiting without trapping people.</h2>
        <p>A fair waiting flow for places, services, pickups, rooms, gates, and Poke-driven visits.</p>
        {modeNote}
      </div>

      <div className="wait-unified-shell">
        <section className="wait-entry-grid" aria-label="Les Wait entry surfaces">
          <article className="wait-entry-card">
            <h3>Join with camera, code, phone, or photo</h3>
            <p>
              Same as standalone Les Wait: every entry method becomes one queue event. In Go,
              camera opens in standalone, while code, phone and photo proof are simulated here.
            </p>
            <div className="wait-chip-row">
              <button
                className={waitChannel === "camera_qr" ? "wait-chip active" : "wait-chip"}
                type="button"
                onClick={() => {
                  onWaitChannelChange("camera_qr");
                  onWaitSurfaceCodeChange(currentWaitSurface.code);
                  onWaitProofRefChange("go-camera-preview");
                  onWaitNoticeChange("Camera QR selected. Open standalone for real camera permission.");
                }}
              >
                QR
              </button>
              <button
                className={waitChannel === "short_code" ? "wait-chip active" : "wait-chip"}
                type="button"
                onClick={() => {
                  onWaitChannelChange("short_code");
                  onWaitSurfaceCodeChange(currentWaitSurface.code);
                  onWaitProofRefChange("short-code");
                  onWaitNoticeChange("Short code selected. This can be printed on a table, door, or counter.");
                }}
              >
                Code
              </button>
              <button
                className={waitChannel === "phone_lookup" ? "wait-chip active" : "wait-chip"}
                type="button"
                onClick={() => {
                  onWaitChannelChange("phone_lookup");
                  onWaitSurfaceCodeChange(phoneSurfaceCode);
                  onWaitProofRefChange("phone-hash");
                  onWaitNoticeChange("Phone fallback selected. Backend should store scoped hashes, not raw numbers.");
                }}
              >
                Phone
              </button>
              <label className={waitChannel === "photo_proof" ? "wait-chip active file-chip" : "wait-chip file-chip"}>
                Photo
                <input
                  type="file"
                  accept="image/*"
                  onChange={(event: ChangeEvent<HTMLInputElement>) => onPhotoProofSelect(event.currentTarget.files?.[0])}
                />
              </label>
            </div>
            <div className="wait-field-grid">
              <label>
                Surface
                <input value={waitSurfaceCode} onChange={(event) => onWaitSurfaceCodeChange(event.target.value)} />
              </label>
              <label>
                Proof
                <input value={waitProofRef} onChange={(event) => onWaitProofRefChange(event.target.value)} />
              </label>
            </div>
          </article>

          <article className="wait-entry-card">
            <h3>Place owner creates the entrance</h3>
            <p>
              The owner/staff side creates QR, short code and join link. Go shows the same
              surface; standalone owns print, camera, and future staff persistence.
            </p>
            <div className="wait-field-grid">
              <label>
                Flow
                <input value={waitOwnerFlow} onChange={(event) => onWaitOwnerFlowChange(event.target.value)} />
              </label>
              <label>
                Service
                <input value={waitOwnerService} onChange={(event) => onWaitOwnerServiceChange(event.target.value)} />
              </label>
            </div>
            <div className="wait-owner-surface">
              <div>
                <strong>{currentWaitSurface.code}</strong>
                <span>{currentWaitSurface.link}</span>
              </div>
              <img src={currentWaitSurface.qrUrl} alt="Les Wait QR" />
            </div>
            <div className="wait-chip-row">
              <button className="wait-chip active" type="button" onClick={onUseOwnerQr}>
                Create QR
              </button>
              <a className="wait-chip link-chip" href={currentWaitSurface.link} target="_blank" rel="noreferrer">
                Open link
              </a>
            </div>
          </article>
        </section>

        <section className="wait-live-layout">
          <div className="ticket-stub wait-ticket-stub">
            <div className="ticket-header">
              <span>Queue ticket</span>
              <span>{waitTicket?.venueName || selectedPlace.name}</span>
            </div>
            {waitTicket ? (
              <>
                <div className="ticket-num">{waitTicket.ticketNumber}</div>
                <div className="wait-ticket-meta">
                  <span>{waitTicket.surfaceId}</span>
                  <span>{waitTicket.channel}</span>
                  <span>{waitTicket.proofRef}</span>
                </div>
                {waitTicket.status === "waiting" ? (
                  <div className="progress-circle-box wait-progress-box">
                    <span>Estimated wait</span>
                    <div className="countdown-timer">
                      {waitTicket.estimatedMinutes} <small>min</small>
                    </div>
                    <p>
                      Your position: <strong>{waitTicket.userPosition}</strong>. You can leave the
                      line area and come back when called.
                    </p>
                    <button className="action-button primary" onClick={onFastForwardQueue}>
                      Move queue forward
                    </button>
                  </div>
                ) : (
                  <div className="wait-called-state">
                    <strong>Your turn is ready.</strong>
                    <span>Go to the desk, pickup point, room, table, or gate.</span>
                  </div>
                )}
                <button className="action-button secondary" onClick={onCancelTicket}>
                  Cancel ticket
                </button>
              </>
            ) : (
              <div className="wait-empty-ticket">
                <strong>No active ticket</strong>
                <span>Choose an entry method and join a place queue.</span>
              </div>
            )}
          </div>

          <div className="wait-place-panel">
            <div className="wait-panel-head">
              <div>
                <h3>Place queues and Poke context</h3>
                <p>
                  Les Wait starts from where you are going. Les Poke can create the quest before,
                  during, or after the wait.
                </p>
              </div>
              <button className="action-button secondary" type="button" onClick={onOpenPoke}>
                Open Poke
              </button>
            </div>
            <div className="wait-notice">{waitNotice}</div>
            <div className="wait-place-list">
              {waitPlaces.map((place, index) => (
                <article className="wait-place-row" key={place.id}>
                  <div>
                    <strong>{place.name}</strong>
                    <span>
                      {place.type.replace(/_/g, " ")} / {place.defaultMode} / density %{58 + index * 7}
                    </span>
                    <small>Poke link: {selectedQuest?.name || "nearby quest"} can become a wait-aware task.</small>
                  </div>
                  <button className="action-button secondary" onClick={() => onJoinQueue(place.id, place.name)}>
                    Join
                  </button>
                </article>
              ))}
            </div>
          </div>
        </section>
      </div>

      {inlineSkills}
    </div>
  );
}

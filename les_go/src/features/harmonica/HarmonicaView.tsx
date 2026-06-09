import type { FormEvent, ReactNode } from "react";
import type { HarmonicaDevice } from "../../types";

interface HarmonicaViewProps {
  modeNote: ReactNode;
  inlineSkills: ReactNode;
  scanning: boolean;
  harmonicaDevices: HarmonicaDevice[];
  pairedDevice: HarmonicaDevice | null;
  secChatHistory: string[];
  secChatMsg: string;
  onRadarScan: () => void;
  onPairedDeviceChange: (device: HarmonicaDevice | null) => void;
  onSecChatMsgChange: (value: string) => void;
  onSendSecureMsg: (event: FormEvent<HTMLFormElement>) => void;
  onConfirmPairwiseConnection: (device: HarmonicaDevice) => void;
}

export function HarmonicaView({
  modeNote,
  inlineSkills,
  scanning,
  harmonicaDevices,
  pairedDevice,
  secChatHistory,
  secChatMsg,
  onRadarScan,
  onPairedDeviceChange,
  onSecChatMsgChange,
  onSendSecureMsg,
  onConfirmPairwiseConnection
}: HarmonicaViewProps) {
  const radarOffsets = [
    { left: "30%", top: "40%" },
    { left: "70%", top: "30%" },
    { left: "55%", top: "75%" }
  ];

  return (
    <div className="sim-container">
      <div className="sim-header">
        <h2>Les Harmonica (Secure Handoff)</h2>
        <p>Domain-scoped pairwise credential exchanges, peer pairing, and ephemeral messaging.</p>
        {modeNote}
      </div>

      <div style={{ display: "grid", gridTemplateColumns: "360px 1fr", gap: "28px" }}>
        <div>
          <div className="harmonica-radar">
            <div className="radar-beam" style={{ display: scanning ? "block" : "none" }} />
            <div className="radar-circle circle-1" />
            <div className="radar-circle circle-2" />
            <div className="radar-circle circle-3" />

            {!scanning &&
              harmonicaDevices.map((device, index) => (
                <div
                  key={device.id}
                  className="radar-ping"
                  style={{ ...radarOffsets[index], background: device.paired ? "var(--green)" : "var(--yellow)" }}
                  onClick={() => onPairedDeviceChange(device)}
                />
              ))}
          </div>

          <button
            className="action-button primary"
            style={{ width: "100%", background: "var(--teal)" }}
            onClick={onRadarScan}
            disabled={scanning}
          >
            {scanning ? "Güvenli Yakınlık Taranıyor..." : "Yakındaki Cihazları Tara"}
          </button>
        </div>

        <div>
          {pairedDevice ? (
            <div style={{ border: "1px solid var(--line)", padding: "20px", borderRadius: "16px" }}>
              <h3>{pairedDevice.name}</h3>
              <div style={{ fontSize: "11px", color: "var(--muted)" }}>
                Sinyal Gücü: %{pairedDevice.signalStrength} | Kamu Anahtarı: <code>{pairedDevice.publicKey}</code>
              </div>

              {pairedDevice.paired ? (
                <div style={{ marginTop: "16px" }}>
                  <div style={{ background: "#f5f5f5", padding: "12px", borderRadius: "8px", minHeight: "100px", marginBottom: "12px", maxHeight: "160px", overflowY: "auto" }}>
                    <p style={{ fontSize: "11px", color: "var(--muted)", margin: "0 0 8px", textAlign: "center" }}>
                      Geçici pairwise oturumu açıldı. Mesajlar yerel olarak yok edilir.
                    </p>
                    {secChatHistory.map((message, index) => (
                      <div key={index} style={{ fontSize: "13px", margin: "4px 0" }}>
                        {message}
                      </div>
                    ))}
                  </div>
                  <form onSubmit={onSendSecureMsg} style={{ display: "flex", gap: "10px" }}>
                    <input
                      type="text"
                      placeholder="Pairwise kanalıyla şifreli ilet..."
                      value={secChatMsg}
                      onChange={(event) => onSecChatMsgChange(event.target.value)}
                      style={{ flex: 1, padding: "8px 12px", border: "1px solid var(--line)", borderRadius: "8px" }}
                    />
                    <button className="action-button primary" style={{ minHeight: "auto" }}>
                      Gönder
                    </button>
                  </form>
                </div>
              ) : (
                <div style={{ marginTop: "16px" }}>
                  <p style={{ fontSize: "13px", color: "var(--muted)", lineHeight: 1.4 }}>
                    Bu cihazla el sıkışma (handoff) başlatarak pseudonymous pairwise anahtar alışverişi yapabilirsiniz.
                  </p>
                  <button
                    className="action-button primary"
                    style={{ width: "100%", marginTop: "12px" }}
                    onClick={() => onConfirmPairwiseConnection(pairedDevice)}
                  >
                    Pairwise Bağlantıyı Onayla
                  </button>
                </div>
              )}
            </div>
          ) : (
            <div style={{ textAlign: "center", color: "var(--muted)", padding: "60px 0" }}>
              Bağlantı kurmak için soldaki radarda bulunan bir sinyal noktasına tıklayın.
            </div>
          )}
        </div>
      </div>

      {inlineSkills}
    </div>
  );
}

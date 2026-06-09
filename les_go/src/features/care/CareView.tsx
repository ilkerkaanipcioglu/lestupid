import type { ReactNode } from "react";

interface FirstAidGuide {
  title: string;
  steps: string;
}

interface CareViewProps {
  modeNote: ReactNode;
  inlineSkills: ReactNode;
  careSearch: string;
  firstAidGuides: FirstAidGuide[];
  emergencyActive: boolean;
  onCareSearchChange: (value: string) => void;
  onEmergencyActiveChange: (value: boolean) => void;
}

export function CareView({
  modeNote,
  inlineSkills,
  careSearch,
  firstAidGuides,
  emergencyActive,
  onCareSearchChange,
  onEmergencyActiveChange
}: CareViewProps) {
  const normalizedQuery = careSearch.toLowerCase();

  return (
    <div className="sim-container">
      <div className="sim-header">
        <h2>Les Care (Safe Health Support)</h2>
        <p>Pseudonymous health routing, emergency certified alarms, and verified first-aid guidance.</p>
        {modeNote}
      </div>

      <div style={{ display: "grid", gridTemplateColumns: "1fr 340px", gap: "28px" }}>
        <div>
          <div className="form-group" style={{ marginBottom: "20px" }}>
            <input
              type="text"
              placeholder="İlk yardım konularını ara (Örn: bayılma, kesik, yanık)..."
              value={careSearch}
              onChange={(event) => onCareSearchChange(event.target.value)}
              style={{ width: "100%", padding: "12px", borderRadius: "10px", border: "1px solid var(--line)" }}
            />
          </div>

          <h3>Doğrulanmış İlk Yardım Kılavuzu</h3>
          <div style={{ display: "grid", gap: "12px", marginTop: "12px" }}>
            {firstAidGuides
              .filter((guide) => guide.title.toLowerCase().includes(normalizedQuery) || guide.steps.toLowerCase().includes(normalizedQuery))
              .map((guide, index) => (
                <div key={index} style={{ border: "1px solid var(--line)", padding: "16px", borderRadius: "12px" }}>
                  <span className="place-type" style={{ background: "rgba(217, 79, 69, 0.1)", color: "var(--red)" }}>
                    Önemli Rehber
                  </span>
                  <h4 style={{ marginTop: "10px", fontSize: "16px" }}>{guide.title}</h4>
                  <p style={{ fontSize: "13px", color: "var(--muted)", lineHeight: 1.4, margin: "8px 0 0" }}>
                    {guide.steps}
                  </p>
                </div>
              ))}
          </div>
        </div>

        <div>
          <div className={`care-emergency-panel ${emergencyActive ? "active" : ""}`}>
            <h3 style={{ margin: 0, color: emergencyActive ? "var(--red)" : "var(--ink)", textAlign: "center" }}>
              {emergencyActive ? "ACİL ALARM AKTİF" : "Acil Durum Paneli"}
            </h3>
            <p style={{ fontSize: "13px", color: "var(--muted)", textAlign: "center", lineHeight: 1.4 }}>
              {emergencyActive
                ? "Çevredeki en yakın sertifikalı ilk yardım ekibine konumsuz acil durum çağrısı ve kimliksiz tıbbi kartınız yayınlanıyor."
                : "Gerektiğinde yakın mesafedeki sertifikalı öğrencilere veya görevlilere anonim tıbbi çağrı yapın."}
            </p>

            {emergencyActive ? (
              <>
                <div className="zkp-qr-container">
                  <div className="zkp-qr-mock">
                    {Array.from({ length: 144 }).map((_, index) => (
                      <div
                        key={index}
                        className={`qr-dot ${Math.sin(index * 0.9) > 0.1 ? "off" : ""}`}
                        style={{ background: "var(--red)" }}
                      />
                    ))}
                  </div>
                </div>
                <div style={{ textAlign: "center", fontSize: "11px", fontWeight: 700, color: "var(--red)" }}>
                  TIBBİ BARKOD (ZKP)
                </div>
                <button
                  className="action-button secondary"
                  style={{ width: "100%" }}
                  onClick={() => onEmergencyActiveChange(false)}
                >
                  Çağrıyı Sonlandır
                </button>
              </>
            ) : (
              <button
                className="action-button primary"
                style={{ background: "var(--red)", width: "100%" }}
                onClick={() => onEmergencyActiveChange(true)}
              >
                Acil Durum Çağrısı Yap
              </button>
            )}
          </div>
        </div>
      </div>

      {inlineSkills}
    </div>
  );
}

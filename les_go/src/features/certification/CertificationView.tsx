import type { ReactNode } from "react";
import type { ZkpCredential } from "../../types";

interface CertificationViewProps {
  modeNote: ReactNode;
  inlineSkills: ReactNode;
  zkpCredentials: ZkpCredential[];
  qrSeed: number;
  onToggleCredential: (credentialId: string) => void;
}

export function CertificationView({
  modeNote,
  inlineSkills,
  zkpCredentials,
  qrSeed,
  onToggleCredential
}: CertificationViewProps) {
  return (
    <div className="sim-container">
      <div className="sim-header">
        <h2>Selective Disclosure & ZKP</h2>
        <p>Select credentials to compile dynamic ZKP tokens with complete identity privacy.</p>
        {modeNote}
      </div>

      <div className="zkp-layout">
        <div>
          <h3>Guvenilir Kimlik Bilgilerim</h3>
          <p className="zkp-copy">
            Istediginiz bilginin yanindaki onay kutusunu isaretleyerek veya kaldirarak sadece ilgili verilerin
            ZKP QR koduna eklenmesini saglayabilirsiniz.
          </p>

          <div className="zkp-credential-list">
            {zkpCredentials.map((cred) => (
              <div className={`zkp-credential-card ${cred.hidden ? "hidden" : ""}`} key={cred.id}>
                <input
                  type="checkbox"
                  checked={!cred.hidden}
                  onChange={() => onToggleCredential(cred.id)}
                  className="zkp-credential-toggle"
                />
                <div className="zkp-credential-copy">
                  <span className="zkp-credential-type">{cred.type}</span>
                  <h4>{cred.title}</h4>
                  <div className="zkp-credential-value">
                    {cred.hidden ? "•••••••••••••• (GIZLI)" : cred.value}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        <div>
          <div className="zkp-proof-card">
            <h3>ZKP Kanit Barkodu</h3>
            <div className="zkp-qr-container">
              <div className="zkp-qr-mock">
                {Array.from({ length: 144 }).map((_, idx) => {
                  const stateVal = Math.sin(idx * qrSeed) > 0;
                  return <div key={idx} className={`qr-dot ${stateVal ? "" : "off"}`} />;
                })}
              </div>
            </div>
            <p className="zkp-proof-copy">
              Yukaridaki QR kod ZKP (Sifir Bilgi Kaniti) ile kriptografik olarak imzalanmistir. Sadece sectiginiz
              bilgileri aciga cikarir.
            </p>
          </div>
        </div>
      </div>

      {inlineSkills}
    </div>
  );
}

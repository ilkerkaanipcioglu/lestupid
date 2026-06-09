import type { FormEvent, ReactNode } from "react";
import type { ContactsDraftPreview, CrmLog } from "../../types";

type CrmContextFilter = CrmLog["context"] | "all";

interface ContactsViewProps {
  modeNote: ReactNode;
  inlineSkills: ReactNode;
  newCrmPlace: string;
  newCrmContext: CrmLog["context"];
  newCrmNotes: string;
  crmFilter: CrmContextFilter;
  crmLogs: CrmLog[];
  contactsDraftPreview: ContactsDraftPreview | null;
  contactsPreviewSource: "mock" | "http";
  contactsPreviewLoading: boolean;
  onNewCrmPlaceChange: (value: string) => void;
  onNewCrmContextChange: (value: CrmLog["context"]) => void;
  onNewCrmNotesChange: (value: string) => void;
  onCrmFilterChange: (value: CrmContextFilter) => void;
  onAddCrmLog: (event: FormEvent<HTMLFormElement>) => void;
  onPreviewContactsDraft: () => void;
}

export function ContactsView({
  modeNote,
  inlineSkills,
  newCrmPlace,
  newCrmContext,
  newCrmNotes,
  crmFilter,
  crmLogs,
  contactsDraftPreview,
  contactsPreviewSource,
  contactsPreviewLoading,
  onNewCrmPlaceChange,
  onNewCrmContextChange,
  onNewCrmNotesChange,
  onCrmFilterChange,
  onAddCrmLog,
  onPreviewContactsDraft
}: ContactsViewProps) {
  return (
    <div className="sim-container">
      <div className="sim-header">
        <h2>Les Contacts (Private CRM)</h2>
        <p>Context-separated private timeline logs, interactions, and safe place memories.</p>
        {modeNote}
      </div>

      <div style={{ display: "grid", gridTemplateColumns: "360px 1fr", gap: "28px" }}>
        <div>
          <h3>Yeni Hafıza Ekle</h3>
          <form onSubmit={onAddCrmLog} style={{ display: "flex", flexDirection: "column", gap: "12px", marginTop: "12px" }}>
            <div className="form-group">
              <label>Mekan/Yer</label>
              <input
                type="text"
                placeholder="Örn: Canteen, Kütüphane"
                value={newCrmPlace}
                onChange={(event) => onNewCrmPlaceChange(event.target.value)}
              />
            </div>
            <div className="form-group">
              <label>Bağlam (Context)</label>
              <select value={newCrmContext} onChange={(event) => onNewCrmContextChange(event.target.value as CrmLog["context"])}>
                <option value="personal">Kişisel (Personal)</option>
                <option value="work">İş (Work)</option>
                <option value="social">Sosyal (Social)</option>
                <option value="travel">Seyahat (Travel)</option>
              </select>
            </div>
            <div className="form-group">
              <label>Özel Notlar</label>
              <textarea
                placeholder="Gizli notların..."
                value={newCrmNotes}
                onChange={(event) => onNewCrmNotesChange(event.target.value)}
                style={{ padding: "10px", borderRadius: "8px", border: "1px solid var(--line)", minHeight: "80px", resize: "none" }}
                required
              />
            </div>
            <button className="action-button primary"> CRM Belleğine Kaydet </button>
          </form>

          <div className="contacts-preview-panel">
            <div className="contacts-preview-header">
              <h3>Current Place Draft Preview</h3>
              <button
                className="action-button secondary"
                type="button"
                onClick={onPreviewContactsDraft}
                disabled={contactsPreviewLoading}
              >
                {contactsPreviewLoading ? "Loading..." : "Preview draft"}
              </button>
            </div>
            <p className="contacts-preview-copy">
              Preview only. This stays private and review-required before any CRM promotion.
            </p>
            {contactsDraftPreview ? (
              <div className="contacts-preview-card">
                <div className="contacts-preview-meta">
                  <span>{contactsDraftPreview.place.placeName}</span>
                  <span>{contactsDraftPreview.contextSpace}</span>
                </div>
                <p>
                  {contactsDraftPreview.draftStatus} via {contactsPreviewSource} with {contactsDraftPreview.sensitivity} sensitivity.
                </p>
                <div className="safety-row">
                  <span>{contactsDraftPreview.visibility}</span>
                  <span>{contactsDraftPreview.crossAppShareDefault}</span>
                  <span>{contactsDraftPreview.createdFrom}</span>
                </div>
              </div>
            ) : null}
          </div>
        </div>

        <div>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "16px" }}>
            <h3>Timeline Akışı</h3>
            <select
              value={crmFilter}
              onChange={(event) => onCrmFilterChange(event.target.value as CrmContextFilter)}
              style={{ padding: "6px 12px", borderRadius: "6px", border: "1px solid var(--line)" }}
            >
              <option value="all">Filtrele: Tümü</option>
              <option value="personal">Kişisel</option>
              <option value="work">İş</option>
              <option value="social">Sosyal</option>
              <option value="travel">Seyahat</option>
            </select>
          </div>

          <div className="crm-timeline">
            {crmLogs
              .filter((log) => crmFilter === "all" || log.context === crmFilter)
              .map((log) => (
                <div className="crm-timeline-item" key={log.id}>
                  <div className="crm-timeline-dot" />
                  <div className="crm-timeline-content">
                    <div className="crm-timeline-header">
                      <span>{log.placeName}</span>
                      <span>{log.date}</span>
                    </div>
                    <p style={{ margin: "6px 0", fontSize: "14px", color: "var(--ink)", lineHeight: 1.4 }}>
                      {log.notes}
                    </p>
                    <div style={{ display: "flex", justifyContent: "space-between", fontSize: "11px", color: "var(--muted)", fontWeight: 700 }}>
                      <span style={{ textTransform: "uppercase" }}>{log.context}</span>
                      {log.people ? <span>Kişi: {log.people}</span> : null}
                    </div>
                  </div>
                </div>
              ))}
          </div>
        </div>
      </div>

      {inlineSkills}
    </div>
  );
}

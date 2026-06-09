import type { FormEvent, ReactNode } from "react";
import type { AiSkill, AiSkillAuditLog, KadroAgent } from "../../types";

interface AiConsoleViewProps {
  modeNote: ReactNode;
  aiSubTab: "agents" | "skills";
  selectedAgent: KadroAgent;
  aiPrompt: string;
  aiConsoleContent: string;
  aiOutputReady: boolean;
  isAiTyping: boolean;
  marketplaceAgents: KadroAgent[];
  aiSkills: AiSkill[];
  globalAuditLogs: AiSkillAuditLog[];
  onAiSubTabChange: (tab: "agents" | "skills") => void;
  onSelectedAgentChange: (agent: KadroAgent) => void;
  onAiPromptChange: (value: string) => void;
  onSendAiPrompt: (event: FormEvent<HTMLFormElement>) => void;
  onExportAiDraftToCv: () => void;
  onUpdateSkillStatus: (skillId: string, status: AiSkill["status"]) => void;
  onResetAiConsole: () => void;
  onHireAgent: (agent: KadroAgent) => void;
  onOpenAgentCard: (agent: KadroAgent) => void;
  onOpenCvPreview: (agent: KadroAgent) => void;
}

export function AiConsoleView({
  modeNote,
  aiSubTab,
  selectedAgent,
  aiPrompt,
  aiConsoleContent,
  aiOutputReady,
  isAiTyping,
  marketplaceAgents,
  aiSkills,
  globalAuditLogs,
  onAiSubTabChange,
  onSelectedAgentChange,
  onAiPromptChange,
  onSendAiPrompt,
  onExportAiDraftToCv,
  onUpdateSkillStatus,
  onResetAiConsole,
  onHireAgent,
  onOpenAgentCard,
  onOpenCvPreview
}: AiConsoleViewProps) {
  return (
    <div className="sim-container">
      <div className="sim-header">
        <h2>KADRO AI Console</h2>
        <p>Interact with certified AI workers, manage tool adapters, and inspect audit logs.</p>
        {modeNote}

        <div className="sub-tab-bar" style={{ display: "flex", gap: "20px", marginTop: "16px", borderBottom: "1px solid var(--line)", paddingBottom: "10px" }}>
          <button
            className={`sub-tab-btn ${aiSubTab === "agents" ? "active" : ""}`}
            onClick={() => onAiSubTabChange("agents")}
            style={{ background: "none", border: "none", color: aiSubTab === "agents" ? "var(--teal)" : "var(--muted)", fontWeight: "bold", fontSize: "14px", cursor: "pointer", paddingBottom: "4px", borderBottom: aiSubTab === "agents" ? "2px solid var(--teal)" : "none" }}
          >
            KADRO Workers
          </button>
          <button
            className={`sub-tab-btn ${aiSubTab === "skills" ? "active" : ""}`}
            onClick={() => onAiSubTabChange("skills")}
            style={{ background: "none", border: "none", color: aiSubTab === "skills" ? "var(--teal)" : "var(--muted)", fontWeight: "bold", fontSize: "14px", cursor: "pointer", paddingBottom: "4px", borderBottom: aiSubTab === "skills" ? "2px solid var(--teal)" : "none" }}
          >
            Ecosystem AI Skills & Security
          </button>
        </div>
      </div>

      {aiSubTab === "agents" ? (
        <div className="kadro-market-layout">
          <div className="kadro-roster-panel">
            <div className="kadro-panel-title">
              <h3>Ajan Kadrosu</h3>
              <span>{marketplaceAgents.length} worker</span>
            </div>
            <div className="kadro-agent-grid">
              {marketplaceAgents.map((agent) => (
                <button
                  type="button"
                  className={`kadro-agent-card ${selectedAgent.id === agent.id ? "selected" : ""}`}
                  key={agent.id}
                  onClick={() => {
                    onSelectedAgentChange(agent);
                    onResetAiConsole();
                  }}
                >
                  <div className="kadro-avatar-wrap">
                    {agent.imageUrl ? (
                      <img
                        src={agent.imageUrl}
                        alt={agent.name}
                        onError={(event) => {
                          event.currentTarget.style.display = "none";
                        }}
                      />
                    ) : null}
                    <span>{agent.avatar}</span>
                  </div>
                  <div className="kadro-card-copy">
                    <strong>{agent.name}</strong>
                    <small>{agent.role}</small>
                    <div className="kadro-mini-meta">
                      <span>{agent.category || "Worker"}</span>
                      <span>{agent.availability || "Ready"}</span>
                    </div>
                  </div>
                </button>
              ))}
            </div>
          </div>

          <div>
            <div className="kadro-detail-card">
              <div className="kadro-detail-hero">
                <div className="kadro-detail-photo">
                  {selectedAgent.imageUrl ? (
                    <img
                      src={selectedAgent.imageUrl}
                      alt={selectedAgent.name}
                      onError={(event) => {
                        event.currentTarget.style.display = "none";
                      }}
                    />
                  ) : null}
                  <span>{selectedAgent.avatar}</span>
                </div>
                <div className="kadro-detail-copy">
                  <div className="kadro-status-row">
                    <span>{selectedAgent.identityClass || "ai_worker"}</span>
                    <span>{selectedAgent.sourceApp || "les_ai/kadro"}</span>
                    <span>{selectedAgent.country || "Global"}</span>
                  </div>
                  <h3>{selectedAgent.name}</h3>
                  <p>{selectedAgent.role}</p>
                </div>
              </div>

              <p className="kadro-agent-bio">{selectedAgent.bio}</p>

              <div className="kadro-skill-row">
                {(selectedAgent.skills || []).map((skill) => (
                  <span key={skill}>{skill}</span>
                ))}
              </div>

              <div className="kadro-hire-strip">
                <div>
                  <small>Hire mode</small>
                  <strong>{selectedAgent.hireMode || "Task workspace"}</strong>
                </div>
                <div>
                  <small>Price</small>
                  <strong>{selectedAgent.hourlyRate || "Demo credits"}</strong>
                </div>
                <div>
                  <small>Status</small>
                  <strong>{selectedAgent.availability || "Ready"}</strong>
                </div>
              </div>

              <div className="kadro-action-row">
                <button className="action-button primary" onClick={() => onHireAgent(selectedAgent)}>
                  Hire / Task
                </button>
                <button className="action-button" onClick={() => onOpenAgentCard(selectedAgent)}>
                  Agent Card
                </button>
                {selectedAgent.cvUrl ? (
                  <button className="action-button" onClick={() => onOpenCvPreview(selectedAgent)}>
                    CV Preview
                  </button>
                ) : null}
              </div>

              <form onSubmit={onSendAiPrompt} style={{ display: "flex", gap: "10px", marginBottom: "16px" }}>
                <input
                  type="text"
                  placeholder={`${selectedAgent.name} için bir talimat yaz...`}
                  value={aiPrompt}
                  onChange={(event) => onAiPromptChange(event.target.value)}
                  style={{ flex: 1, padding: "10px 14px", border: "1px solid var(--line)", borderRadius: "8px" }}
                  disabled={isAiTyping}
                />
                <button className="action-button primary" disabled={isAiTyping}>
                  Çalıştır
                </button>
              </form>

              <strong>Ajan Konsol Çıktısı [Simüle]:</strong>
              <div className="ai-terminal">
                <pre style={{ margin: 0, whiteSpace: "pre-wrap" }}>
                  {aiConsoleContent || "Talebinizi bekliyor..."}
                </pre>
              </div>

              {aiOutputReady ? (
                <button
                  className="action-button primary"
                  style={{ width: "100%", marginTop: "16px", background: "var(--teal)" }}
                  onClick={onExportAiDraftToCv}
                >
                  Bu Taslağı Living CV'ye Ekle (Export)
                </button>
              ) : null}
            </div>
          </div>
        </div>
      ) : (
        <div style={{ display: "grid", gridTemplateColumns: "1fr 350px", gap: "28px" }}>
          <div>
            <h3 style={{ marginBottom: "12px" }}>Ecosystem Tool Adapters</h3>
            <div style={{ display: "grid", gap: "14px" }}>
              {aiSkills.map((skill) => (
                <div key={skill.id} style={{ padding: "16px", border: "1px solid var(--line)", borderRadius: "12px", background: "var(--surface)" }}>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "8px" }}>
                    <div>
                      <span style={{ fontSize: "11px", textTransform: "uppercase", background: "rgba(32,117,111,0.1)", color: "var(--teal)", padding: "2px 6px", borderRadius: "4px", marginRight: "8px" }}>
                        {skill.productId}
                      </span>
                      <span style={{ fontWeight: "bold", fontFamily: "monospace" }}>{skill.id}()</span>
                    </div>
                    <select
                      value={skill.status}
                      onChange={(event) => onUpdateSkillStatus(skill.id, event.target.value as AiSkill["status"])}
                      className={`skill-status-select ${skill.status}`}
                    >
                      <option value="active">Active</option>
                      <option value="needs_approval">Needs Approval</option>
                      <option value="disabled">Disabled</option>
                    </select>
                  </div>
                  <h4 style={{ margin: "4px 0" }}>{skill.name}</h4>
                  <p style={{ fontSize: "13px", color: "var(--muted)", margin: "4px 0" }}>{skill.description}</p>

                  <div style={{ marginTop: "10px", fontSize: "11px", color: "var(--muted)", display: "flex", gap: "16px" }}>
                    <span>Calls: <strong>{skill.executionCount}</strong></span>
                    {skill.lastExecutedAt ? (
                      <span>Last run: <strong>{new Date(skill.lastExecutedAt).toLocaleTimeString()}</strong></span>
                    ) : null}
                    <span>Permissions: <strong>{skill.requiredPermissions.join(", ")}</strong></span>
                  </div>
                </div>
              ))}
            </div>
          </div>

          <div>
            <h3 style={{ marginBottom: "12px" }}>Live Security Audit Trail</h3>
            <div style={{ padding: "16px", border: "1px solid var(--line)", borderRadius: "12px", background: "var(--surface)", maxHeight: "500px", overflowY: "auto" }}>
              {globalAuditLogs.length === 0 ? (
                <div style={{ textAlign: "center", color: "var(--muted)", padding: "24px 0" }}>No executions logged.</div>
              ) : (
                <div style={{ display: "grid", gap: "12px" }}>
                  {globalAuditLogs.map((log, index) => (
                    <div key={index} style={{ padding: "10px", borderBottom: "1px solid var(--line)", fontSize: "12px" }}>
                      <div style={{ display: "flex", justifyContent: "space-between", marginBottom: "4px" }}>
                        <strong style={{ color: log.status === "success" ? "var(--teal)" : "var(--rose)" }}>
                          {log.status === "success" ? "SUCCESS" : "BLOCKED"}
                        </strong>
                        <span style={{ fontSize: "10px", color: "var(--muted)" }}>
                          {new Date(log.timestamp).toLocaleTimeString()}
                        </span>
                      </div>
                      <div style={{ fontSize: "11px", color: "var(--muted)", fontFamily: "monospace" }}>
                        Params: {JSON.stringify(log.input)}
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

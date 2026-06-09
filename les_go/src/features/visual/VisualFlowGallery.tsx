import type { FlowTempo } from "../../types";

export type VisualGalleryView =
  | "hub"
  | "wait"
  | "poke"
  | "match"
  | "commerce"
  | "itemotel"
  | "contacts"
  | "care"
  | "harmonica"
  | "oyun"
  | "ai"
  | "certification";

export interface VisualDemoFlow {
  id: string;
  title: string;
  mood: string;
  tempo: FlowTempo;
  sourceApps: string[];
  scene: string;
  steps: string[];
  visualCue: string;
  trustRule: string;
}

interface VisualFlowGalleryProps {
  flows: VisualDemoFlow[];
  onOpenView: (view: VisualGalleryView) => void;
}

export function VisualFlowGallery({ flows, onOpenView }: VisualFlowGalleryProps) {
  const openableViews: Record<string, VisualGalleryView> = {
    les_wait: "wait",
    les_poke: "poke",
    les_match: "match",
    les_itemotel: "itemotel",
    les_harmonica: "harmonica",
    les_travel: "hub",
    les_ai: "ai",
    agentandbot: "ai",
    les_contacts: "contacts",
    les_care: "care",
    les_certification: "certification",
    lescommerce: "commerce",
    "lescommerce-marketplace": "commerce",
    "lescommerce-diydiy": "commerce",
    "lescommerce-quick-commerce": "commerce",
    "lescommerce-storefronts": "commerce",
    "les-affiliate": "oyun"
  };

  return (
    <div className="visual-demo-shell">
      <header className="visual-demo-hero">
        <p className="eyebrow">Visual Demo System</p>
        <h1>See the ecosystem as flows.</h1>
        <p>
          Each card shows how a real moment becomes app UI: places stay grounded,
          feeds move, risk is visible, and every product keeps its own mood.
        </p>
      </header>

      <section className="visual-map" aria-label="LesTupid flow map">
        <div className="visual-node root">LesTupid Go</div>
        <div className="visual-line" />
        <div className="visual-node-grid">
          {["Wait", "Poke", "Match", "Commerce", "Contacts", "AI", "Care", "Trust"].map((label) => (
            <span className="visual-node small" key={label}>
              {label}
            </span>
          ))}
        </div>
      </section>

      <section className="visual-flow-grid">
        {flows.map((flow) => (
          <article className={`visual-flow-card tempo-${flow.tempo}`} key={flow.id}>
            <div className="visual-flow-top">
              <span className="visual-flow-mood">{flow.mood}</span>
              <span className="card-time">{flow.tempo}</span>
            </div>
            <h2>{flow.title}</h2>
            <p>{flow.scene}</p>

            <div className="visual-step-rail">
              {flow.steps.map((step, index) => (
                <div className="visual-step" key={step}>
                  <span>{index + 1}</span>
                  <strong>{step}</strong>
                </div>
              ))}
            </div>

            <div className="visual-app-row">
              {flow.sourceApps.map((app) => {
                const target = openableViews[app];
                return target ? (
                  <button className="visual-app-pill" key={app} type="button" onClick={() => onOpenView(target)}>
                    {app}
                  </button>
                ) : (
                  <span className="visual-app-pill passive" key={app}>
                    {app}
                  </span>
                );
              })}
            </div>

            <div className="visual-rule-grid">
              <div>
                <span>Visual cue</span>
                <p>{flow.visualCue}</p>
              </div>
              <div>
                <span>Trust rule</span>
                <p>{flow.trustRule}</p>
              </div>
            </div>
          </article>
        ))}
      </section>
    </div>
  );
}

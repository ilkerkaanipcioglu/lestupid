import type { ReactNode } from "react";

interface CommerceProduct {
  id: string;
  name: string;
  role: string;
  stack: string;
  path: string;
  status: string;
  actionLabel: string;
  goView?: string;
  standaloneUrl?: string;
}

interface CommerceFamilyViewProps {
  modeNote: ReactNode;
  inlineSkills: ReactNode;
  products: CommerceProduct[];
  onOpenGoView: (viewId: string) => void;
}

export function CommerceFamilyView({
  modeNote,
  inlineSkills,
  products,
  onOpenGoView
}: CommerceFamilyViewProps) {
  return (
    <div className="sim-container">
      <div className="sim-header">
        <h2>Les Commerce</h2>
        <p>DIY, marketplace/listings, quick commerce, storefronts, and Item Otel in one visible family.</p>
        {modeNote}
      </div>

      <div className="commerce-family-hero">
        <div>
          <span className="place-type">commerce family</span>
          <h3>One commerce language, many apps.</h3>
          <p>
            Go shows commerce as a contextual surface. Each engine can still become its own
            standalone product: a DIY video page, a general listing marketplace, a quick merchant
            storefront, reusable themes, or Item Otel custody commerce.
          </p>
        </div>
        <div className="commerce-family-metrics">
          <div><strong>{products.length}</strong><span>sub-apps</span></div>
          <div><strong>1</strong><span>tap-to-filter contract</span></div>
          <div><strong>opt-in</strong><span>listing / custody</span></div>
        </div>
      </div>

      <div className="commerce-family-grid">
        {products.map((product) => (
          <article className="commerce-family-card" key={product.id}>
            <div className="commerce-family-card-head">
              <span>{product.status}</span>
              <strong>{product.id}</strong>
            </div>
            <h3>{product.name}</h3>
            <p>{product.role}</p>
            <div className="commerce-family-meta">
              <span>{product.stack}</span>
              <span>{product.path}</span>
            </div>
            <div className="commerce-family-actions">
              {product.goView ? (
                <button className="action-button secondary" type="button" onClick={() => onOpenGoView(product.goView!)}>
                  {product.actionLabel}
                </button>
              ) : product.standaloneUrl ? (
                <a className="action-button secondary link-action" href={product.standaloneUrl} target="_blank" rel="noreferrer">
                  {product.actionLabel}
                </a>
              ) : (
                <span className="mode-note-status">{product.actionLabel}</span>
              )}
            </div>
          </article>
        ))}
      </div>

      <section className="commerce-family-contract">
        <h3>Shared behavior</h3>
        <div>
          <span>Tap visible commerce values to filter: brand, model, size, place, item, service.</span>
          <span>Quick Commerce shops can publish a product to one or more marketplaces without duplicating the catalog record.</span>
          <span>Books/Sahaf marketplace filters by title, author, publisher, ISBN, edition, condition, city and delivery.</span>
          <span>DIY video pages connect materials, masters, finished products, and creator promotion.</span>
          <span>Item Otel can publish rent/sale listings only with explicit owner consent.</span>
          <span>Quick Commerce can publish store products into Marketplace through adapters.</span>
        </div>
      </section>

      {inlineSkills}
    </div>
  );
}

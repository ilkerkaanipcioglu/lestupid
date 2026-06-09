import type { FormEvent, ReactNode } from "react";
import type { ItemOtelRecord } from "../../types";

type ItemCategory = ItemOtelRecord["category"];
type ItemListType = "rent" | "sale" | "both";

interface ItemOtelViewProps {
  modeNote: ReactNode;
  inlineSkills: ReactNode;
  items: ItemOtelRecord[];
  loadingItems: boolean;
  expandedItemId: number | null;
  showNewItemForm: boolean;
  newItemName: string;
  newItemCategory: ItemCategory;
  careTypeInput: Record<number, string>;
  careNotesInput: Record<number, string>;
  listTypeInput: Record<number, ItemListType>;
  priceSaleInput: Record<number, string>;
  priceRentInput: Record<number, string>;
  onExpandedItemChange: (id: number | null) => void;
  onShowNewItemFormChange: (value: boolean) => void;
  onNewItemNameChange: (value: string) => void;
  onNewItemCategoryChange: (value: ItemCategory) => void;
  onCareTypeInputChange: (updater: (prev: Record<number, string>) => Record<number, string>) => void;
  onCareNotesInputChange: (updater: (prev: Record<number, string>) => Record<number, string>) => void;
  onListTypeInputChange: (updater: (prev: Record<number, ItemListType>) => Record<number, ItemListType>) => void;
  onPriceSaleInputChange: (updater: (prev: Record<number, string>) => Record<number, string>) => void;
  onPriceRentInputChange: (updater: (prev: Record<number, string>) => Record<number, string>) => void;
  onCreateItem: (event: FormEvent<HTMLFormElement>) => void;
  onCare: (id: number) => void;
  onList: (id: number) => void;
  onUnlist: (id: number) => void;
  onRecall: (id: number) => void;
}

export function ItemOtelView({
  modeNote,
  inlineSkills,
  items,
  loadingItems,
  expandedItemId,
  showNewItemForm,
  newItemName,
  newItemCategory,
  careTypeInput,
  careNotesInput,
  listTypeInput,
  priceSaleInput,
  priceRentInput,
  onExpandedItemChange,
  onShowNewItemFormChange,
  onNewItemNameChange,
  onNewItemCategoryChange,
  onCareTypeInputChange,
  onCareNotesInputChange,
  onListTypeInputChange,
  onPriceSaleInputChange,
  onPriceRentInputChange,
  onCreateItem,
  onCare,
  onList,
  onUnlist,
  onRecall
}: ItemOtelViewProps) {
  return (
    <div className="sim-container">
      <div className="sim-header">
        <h2>Les Item Otel</h2>
        <p>Circular commerce workspace: personal items storage, care, and active listings.</p>
        {modeNote}
      </div>

      <div className="itemotel-dashboard">
        <div className="itemotel-stats-grid">
          <div className="stat-card">
            <span className="stat-num">{items.length}</span>
            <span className="stat-label">Toplam Eşya</span>
          </div>
          <div className="stat-card">
            <span className="stat-num">{items.filter((item) => item.status.startsWith("listed")).length}</span>
            <span className="stat-label">Aktif İlan</span>
          </div>
          <div className="stat-card">
            <span className="stat-num">450 TL</span>
            <span className="stat-label">Pasif Gelir</span>
          </div>
        </div>

        <div className="itemotel-actions-header">
          <h3>Kişisel Eşya Depom</h3>
          <button
            className="action-button primary"
            onClick={() => onShowNewItemFormChange(!showNewItemForm)}
            type="button"
          >
            {showNewItemForm ? "Formu Kapat" : "Yeni Eşya Gönder"}
          </button>
        </div>

        {showNewItemForm ? (
          <form onSubmit={onCreateItem} className="itemotel-new-item-form">
            <h4>Yeni Eşya Kabul Talebi</h4>
            <div className="form-group">
              <label htmlFor="item-name">Eşya Adı</label>
              <input
                type="text"
                id="item-name"
                placeholder="Örn: Pro-Ride Kayak Takımı"
                value={newItemName}
                onChange={(event) => onNewItemNameChange(event.target.value)}
                required
              />
            </div>
            <div className="form-group">
              <label htmlFor="item-category">Kategori</label>
              <select
                id="item-category"
                value={newItemCategory}
                onChange={(event) => onNewItemCategoryChange(event.target.value as ItemCategory)}
              >
                <option value="sports">Spor Ekipmanı</option>
                <option value="automotive">Otomotiv / Lastik</option>
                <option value="wedding">Gelinlik & Özel Gün</option>
                <option value="apparel">Giyim / Sezonluk Dolap</option>
                <option value="other">Diğer</option>
              </select>
            </div>
            <button type="submit" className="action-button primary">Depolama İçin Gönder</button>
          </form>
        ) : null}

        {loadingItems ? <p className="loading-text">Eşya listesi güncelleniyor...</p> : null}

        <div className="itemotel-grid">
          {items.map((item) => {
            const isExpanded = expandedItemId === item.id;
            const activeListing = item.listing;

            return (
              <article key={item.id} className={`itemotel-card ${item.status} ${isExpanded ? "expanded" : ""}`}>
                <button
                  className="card-expand-toggle"
                  onClick={() => onExpandedItemChange(isExpanded ? null : item.id)}
                  aria-label="Toggle details"
                  type="button"
                >
                  <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" strokeWidth="3" fill="none" strokeLinecap="round" strokeLinejoin="round" className="plus-icon"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                </button>

                <div className="itemotel-card-header">
                  <span className={`status-badge status-${item.status}`}>
                    {item.status.replace(/_/g, " ")}
                  </span>
                  <h3>{item.name}</h3>
                  <p className="item-cat-label">{item.category.toUpperCase()}</p>
                </div>

                {isExpanded ? (
                  <div className="itemotel-card-details">
                    <hr className="details-divider" />

                    <div className="details-meta-grid">
                      <div className="meta-item">
                        <span className="meta-label">Depo Konumu</span>
                        <span className="meta-val">{item.storage_location || "Yolda / Sevk Ediliyor"}</span>
                      </div>
                      <div className="meta-item">
                        <span className="meta-label">Kondisyon Skoru</span>
                        <span className="meta-val">{item.condition_rating ? `${item.condition_rating}/10` : "Belirlenmedi"}</span>
                      </div>
                    </div>

                    <div className="details-section">
                      <h4 className="section-title">Bakım & Koruma Geçmişi</h4>
                      {item.care_logs && item.care_logs.length > 0 ? (
                        <div className="care-logs-list">
                          {item.care_logs.map((log) => (
                            <div key={log.id} className="care-log-item">
                              <div className="care-log-header">
                                <strong>{log.care_type.replace(/_/g, " ").toUpperCase()}</strong>
                                <span>{new Date(log.performed_at).toLocaleDateString()}</span>
                              </div>
                              {log.notes ? <p className="care-log-notes">{log.notes}</p> : null}
                              <div className="care-log-meta">
                                <span>Yapan: {log.provider_id || "Sistem"}</span>
                                {log.certificate_id ? (
                                  <span className="cert-pill">✓ Sertifikalı: {log.certificate_id}</span>
                                ) : null}
                              </div>
                            </div>
                          ))}
                        </div>
                      ) : (
                        <p className="no-data-text">Henüz yapılmış bir bakım kaydı bulunmuyor.</p>
                      )}
                    </div>

                    {item.status !== "shipped_back" && item.status !== "sold" ? (
                      <div className="details-section care-request-section">
                        <h4 className="section-title">Profesyonel Bakım Siparişi</h4>
                        <div className="care-request-form">
                          <select
                            value={careTypeInput[item.id] || "general_maintenance"}
                            onChange={(event) =>
                              onCareTypeInputChange((prev) => ({ ...prev, [item.id]: event.target.value }))
                            }
                          >
                            <option value="general_maintenance">Genel Kontrol & Bakım</option>
                            <option value="cleaning">Kuru Temizleme / Yıkama</option>
                            <option value="repair">Profesyonel Onarım</option>
                            {item.category === "sports" ? <option value="waxing">Waxing & Cila</option> : null}
                            {item.category === "automotive" ? <option value="tire_rotation">Lastik Rotasyonu & Balans</option> : null}
                          </select>
                          <input
                            type="text"
                            placeholder="Özel istekleriniz veya notlar..."
                            value={careNotesInput[item.id] || ""}
                            onChange={(event) =>
                              onCareNotesInputChange((prev) => ({ ...prev, [item.id]: event.target.value }))
                            }
                          />
                          <button
                            className="action-button secondary"
                            onClick={() => onCare(item.id)}
                            type="button"
                          >
                            Bakım Siparişi Ver
                          </button>
                        </div>
                      </div>
                    ) : null}

                    <div className="details-section monetization-section">
                      <h4 className="section-title">Döngüsel Ticaret ve Monetizasyon</h4>

                      {activeListing ? (
                        <div className="active-listing-info">
                          <p>
                            İlan Aktif: <strong>{activeListing.listing_type.toUpperCase()}</strong>
                            {activeListing.price_rent_daily ? <span> - Günlük Kira: {activeListing.price_rent_daily} TL</span> : null}
                            {activeListing.price_sale ? <span> - Satış Bedeli: {activeListing.price_sale} TL</span> : null}
                          </p>
                          <button
                            className="action-button warning"
                            onClick={() => onUnlist(item.id)}
                            type="button"
                          >
                            İlandan Kaldır
                          </button>
                        </div>
                      ) : item.status !== "shipped_back" && item.status !== "sold" ? (
                        <div className="listing-setup-form">
                          <div className="form-row">
                            <label>Listeleme Türü</label>
                            <select
                              value={listTypeInput[item.id] || "rent"}
                              onChange={(event) =>
                                onListTypeInputChange((prev) => ({ ...prev, [item.id]: event.target.value as ItemListType }))
                              }
                            >
                              <option value="rent">Kirala (Pasif Gelir)</option>
                              <option value="sale">Doğrudan Sat</option>
                              <option value="both">İkisi De (Hem Sat hem Kirala)</option>
                            </select>
                          </div>

                          {listTypeInput[item.id] === "sale" || listTypeInput[item.id] === "both" ? (
                            <div className="form-row">
                              <label>Satış Fiyatı (TL)</label>
                              <input
                                type="number"
                                placeholder="Satış Bedeli Girin"
                                value={priceSaleInput[item.id] || ""}
                                onChange={(event) =>
                                  onPriceSaleInputChange((prev) => ({ ...prev, [item.id]: event.target.value }))
                                }
                              />
                            </div>
                          ) : null}

                          {listTypeInput[item.id] === "rent" || listTypeInput[item.id] === "both" || !listTypeInput[item.id] ? (
                            <div className="form-row">
                              <label>Günlük Kira Bedeli (TL)</label>
                              <input
                                type="number"
                                placeholder="Kira Bedeli Girin"
                                value={priceRentInput[item.id] || ""}
                                onChange={(event) =>
                                  onPriceRentInputChange((prev) => ({ ...prev, [item.id]: event.target.value }))
                                }
                              />
                            </div>
                          ) : null}

                          <button
                            className="action-button primary"
                            onClick={() => onList(item.id)}
                            type="button"
                          >
                            Pazaryerinde Yayına Al
                          </button>
                        </div>
                      ) : null}
                    </div>

                    {item.status !== "shipped_back" && item.status !== "sold" ? (
                      <div className="details-section recall-section">
                        <h4 className="section-title">Eşyayı Geri Çağır (İade)</h4>
                        <p className="info-text">Eşyanız depodan alınarak kurye ile kayıtlı adresinize teslim edilecektir.</p>
                        <button
                          className="action-button secondary"
                          onClick={() => onRecall(item.id)}
                          type="button"
                        >
                          Adresime Gönderilmesini İstiyorum
                        </button>
                      </div>
                    ) : null}
                  </div>
                ) : null}
              </article>
            );
          })}
        </div>
      </div>

      {inlineSkills}
    </div>
  );
}

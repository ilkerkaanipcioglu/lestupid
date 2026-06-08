alias Dukkadee.Repo
alias Dukkadee.ItemOtel.{Item, CareLog, Listing}

IO.puts "Seeding Item Oteli data..."

# Delete old itemotel seeds if any
Repo.delete_all(CareLog)
Repo.delete_all(Listing)
Repo.delete_all(Item)

# 1. Kayak Takımı
kayak = Repo.insert!(%Item{
  owner_identity_id: "student-demo-001",
  name: "Pro-Ride Kayak Takımı & Batonlar",
  category: "sports",
  status: "in_storage",
  storage_location: "Depo A-12",
  condition_rating: 9,
  images: ["/images/itemotel-ski.png"]
})

Repo.insert!(%CareLog{
  item_id: kayak.id,
  care_type: "waxing",
  notes: "Vakslama ve cila yapıldı, kenarlar keskinleştirildi.",
  performed_at: ~N[2026-05-15 10:00:00],
  provider_id: "Usta Kayak Servisi",
  certificate_id: "CERT-SKI-77382"
})

Repo.insert!(%CareLog{
  item_id: kayak.id,
  care_type: "cleaning",
  notes: "Genel toz temizliği ve kurutma yapıldı.",
  performed_at: ~N[2026-05-14 14:00:00],
  provider_id: "Otel Bakım Merkezi"
})

# 2. Araba Lastikleri
lastik = Repo.insert!(%Item{
  owner_identity_id: "student-demo-001",
  name: "Michelin Alpin 6 Kışlık Lastik Seti (4 Adet)",
  category: "automotive",
  status: "listed_for_rent",
  storage_location: "Depo B-04",
  condition_rating: 8,
  images: ["/images/itemotel-tires.png"]
})

Repo.insert!(%Listing{
  item_id: lastik.id,
  listing_type: "rent",
  price_rent_daily: Decimal.new("15.00"),
  price_sale: nil,
  is_active: true
})

Repo.insert!(%CareLog{
  item_id: lastik.id,
  care_type: "tire_rotation",
  notes: "Balans ayarı yapıldı, diş derinliği ölçüldü (6.5mm).",
  performed_at: ~N[2026-04-10 11:30:00],
  provider_id: "Usta Lastikçi",
  certificate_id: "CERT-TIRE-99212"
})

# 3. Gelinlik
gelinlik = Repo.insert!(%Item{
  owner_identity_id: "student-demo-001",
  name: "Vera Wang İpek Dantel Gelinlik",
  category: "wedding",
  status: "in_maintenance",
  storage_location: "Kabin C-09",
  condition_rating: 10,
  images: ["/images/itemotel-dress.png"]
})

Repo.insert!(%CareLog{
  item_id: gelinlik.id,
  care_type: "cleaning",
  notes: "Hassas kuru temizleme ve buharlı ütüleme yapıldı.",
  performed_at: ~N[2026-05-20 09:00:00],
  provider_id: "Royal Kuru Temizleme",
  certificate_id: "CERT-DRESS-1102"
})

# 4. Yazlık Kıyafetler
apparel = Repo.insert!(%Item{
  owner_identity_id: "student-demo-001",
  name: "Kutu Yazlık Elbise ve Tişört Seti",
  category: "apparel",
  status: "in_storage",
  storage_location: "Kutu D-01",
  condition_rating: 7,
  images: ["/images/itemotel-clothing.png"]
})

IO.puts "Item Oteli Seeding Completed!"

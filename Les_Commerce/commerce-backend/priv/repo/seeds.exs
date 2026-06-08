# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Dukkadee.Repo.insert!(%Dukkadee.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Dukkadee.Repo
alias Dukkadee.Accounts.User
alias Dukkadee.Stores.Store
alias Dukkadee.Products.Product
alias Dukkadee.Tutorials.Video
alias Dukkadee.Appointments.Appointment

# 1. Create/Retrieve Admin User with proper password hashing
admin_user = case Repo.get_by(User, email: "admin@dukkadee.com") do
  nil ->
    {:ok, u} = %User{
      email: "admin@dukkadee.com",
      is_admin: true
    }
    |> User.changeset(%{
      password: "password123",
      password_confirmation: "password123"
    })
    |> Repo.insert()
    u
  u ->
    u
end

# 2. Create / Update Stores

# Inkless Is More store
inkless = Repo.insert!(
  %Store{
    name: "Inkless Is More",
    slug: "inklessismore-ke",
    description: "Nairobi's Premier Laser Tattoo Removal Studio",
    primary_color: "#fddb24",
    secondary_color: "#b7acd4",
    accent_color: "#272727",
    logo: "/images/inklessismore-logo.png",
    user_id: admin_user.id
  },
  on_conflict: :replace_all,
  conflict_target: :slug
)

# Lagos Fashion Outlet store
lagos = Repo.insert!(
  %Store{
    name: "Lagos Fashion Outlet",
    slug: "lagos-fashion",
    description: "Contemporary African fashion from Nigeria's leading designers",
    primary_color: "#00AA55",
    secondary_color: "#FF6600",
    accent_color: "#333333",
    logo: "/images/lagos-fashion-logo.png",
    user_id: admin_user.id
  },
  on_conflict: :replace_all,
  conflict_target: :slug
)

# Cape Town Artisans store
capetown = Repo.insert!(
  %Store{
    name: "Cape Town Artisans",
    slug: "capetown-artisans",
    description: "Handcrafted goods from South Africa's finest craftspeople",
    primary_color: "#0066CC",
    secondary_color: "#FFCC00",
    accent_color: "#222222",
    logo: "/images/capetown-artisans-logo.png",
    user_id: admin_user.id
  },
  on_conflict: :replace_all,
  conflict_target: :slug
)

# Accra Spice Market store
accra = Repo.insert!(
  %Store{
    name: "Accra Spice Market",
    slug: "accra-spice",
    description: "Authentic Ghanaian spices and ingredients delivered to your door",
    primary_color: "#CC0000",
    secondary_color: "#00CC00",
    accent_color: "#2A2A2A",
    logo: "/images/accra-spice-logo.png",
    user_id: admin_user.id
  },
  on_conflict: :replace_all,
  conflict_target: :slug
)

# DIYABI Store (Creator DIY & Marketplace Hub)
diyabi_store = Repo.insert!(
  %Store{
    name: "Diyabi Creator Hub",
    slug: "diyabi",
    description: "Usta hiring marketplace, high-quality DIY materials, and expert woodcraft tutorials.",
    primary_color: "#5b21b6", # purple
    secondary_color: "#f43f5e", # rose
    accent_color: "#0f172a", # dark slate
    logo: "/images/diyabi-logo.png",
    user_id: admin_user.id
  },
  on_conflict: :replace_all,
  conflict_target: :slug
)

# 3. Create Products for DIYBI Store (Materials, Finished Goods, Services)

# Materials
material1 = Repo.insert!(
  %Product{
    name: "Ahşap Plaka - Meşe",
    description: "Zımparalanmış ve hazır, 1. sınıf masif meşe ahşap plaka. DIY sehpa yapımı için mükemmeldir. Ebat: 80x120cm, Kalınlık: 40mm.",
    price: Decimal.new("120.00"),
    currency: "TL",
    images: ["/images/material-wood.png"],
    requires_appointment: false,
    is_published: true,
    is_featured: true,
    is_marketplace_listed: true,
    category: "Ahşap & Kereste",
    tags: ["ahşap", "meşe", "diy", "malzeme"],
    type: "material",
    store_id: diyabi_store.id
  },
  on_conflict: :replace_all,
  conflict_target: :id
)

material2 = Repo.insert!(
  %Product{
    name: "Profesyonel Vernik",
    description: "Su bazlı, mat bitişli, çizilmeye dayanıklı ultra koruyucu ahşap verniği. 0.75 Lt.",
    price: Decimal.new("85.00"),
    currency: "TL",
    images: ["/images/varnish.png"],
    requires_appointment: false,
    is_published: true,
    is_featured: true,
    is_marketplace_listed: true,
    category: "Boya & Kimyasallar",
    tags: ["vernik", "cila", "koruyucu", "ahşap"],
    type: "material",
    store_id: diyabi_store.id
  },
  on_conflict: :replace_all,
  conflict_target: :id
)

material3 = Repo.insert!(
  %Product{
    name: "Zımpara Seti",
    description: "Farklı kum değerlerinde (80, 120, 220) 10 adet ahşap zımparası içeren başlangıç seti.",
    price: Decimal.new("45.00"),
    currency: "TL",
    images: ["/images/sandpaper.png"],
    requires_appointment: false,
    is_published: true,
    is_featured: false,
    is_marketplace_listed: true,
    category: "El Aletleri",
    tags: ["zımpara", "zımparalama", "alet"],
    type: "material",
    store_id: diyabi_store.id
  },
  on_conflict: :replace_all,
  conflict_target: :id
)

# Finished Goods
finished_good1 = Repo.insert!(
  %Product{
    name: "Doğal Meşe Sehpa",
    description: "Tamamlanmış, kullanıma hazır el yapımı masif meşe sehpa. Modern metal ayaklar, mat vernikli yüzey. 100% el işçiliği.",
    price: Decimal.new("5000.00"),
    currency: "TL",
    images: ["/images/coffee-table.png"],
    requires_appointment: false,
    is_published: true,
    is_featured: true,
    is_marketplace_listed: true,
    category: "Mobilya",
    tags: ["sehpa", "meşe", "mobilya", "el-yapimi"],
    type: "finished_good",
    store_id: diyabi_store.id
  },
  on_conflict: :replace_all,
  conflict_target: :id
)

# Services (Ustalar)
service1 = Repo.insert!(
  %Product{
    name: "Usta Ahmet Yılmaz - Ahşap & Mobilya Kurulumu",
    description: "30 yıllık marangozluk deneyimi. Evinizde ahşap sehpa montajı, panel kurulumu ve ahşap zımpara/vernik işlerini titizlikle yapar.",
    price: Decimal.new("500.00"),
    currency: "TL",
    images: ["/images/master-ahmet.png"],
    requires_appointment: true,
    is_published: true,
    is_featured: true,
    is_marketplace_listed: true,
    category: "Usta Hizmeti",
    tags: ["marangoz", "usta", "montaj", "ahsap"],
    type: "service",
    store_id: diyabi_store.id
  },
  on_conflict: :replace_all,
  conflict_target: :id
)

service2 = Repo.insert!(
  %Product{
    name: "Usta Mehmet Demir - Özel Tasarım & Marangozluk",
    description: "Özel mobilya yapımı, ahşap yatak başlığı tasarımı ve mutfak dolabı yenileme uzmanı. Kaliteli işçilik garanti edilir.",
    price: Decimal.new("600.00"),
    currency: "TL",
    images: ["/images/master-mehmet.png"],
    requires_appointment: true,
    is_published: true,
    is_featured: true,
    is_marketplace_listed: true,
    category: "Usta Hizmeti",
    tags: ["marangoz", "tasarim", "yenileme", "dolap"],
    type: "service",
    store_id: diyabi_store.id
  },
  on_conflict: :replace_all,
  conflict_target: :id
)

# 4. Create Video (DIY Tutorial) and Link Products
video = Repo.insert!(
  %Video{
    title: "Doğal Meşe Sehpa Yapımı",
    description: "Bu eğitimimizde masif meşe ahşap plaka kullanarak adım adım modern bir sehpa yapımını öğreniyoruz. Zımpara aşaması, vernikleme teknikleri ve metal ayak montajını detaylıca anlatıyoruz.",
    embed_url: "https://www.youtube.com/embed/S2C_Puw_61I",
    store_id: diyabi_store.id
  },
  on_conflict: :replace_all,
  conflict_target: :id
)

# Associate products to video using join table
Dukkadee.Tutorials.add_product_to_video(video.id, material1.id)
Dukkadee.Tutorials.add_product_to_video(video.id, material2.id)
Dukkadee.Tutorials.add_product_to_video(video.id, material3.id)
Dukkadee.Tutorials.add_product_to_video(video.id, finished_good1.id)
Dukkadee.Tutorials.add_product_to_video(video.id, service1.id)

# 5. Create some Appointments for service
Repo.insert!(
  %Appointment{
    customer_name: "Ayşe Kaplan",
    customer_email: "ayse@example.com",
    customer_phone: "+905551234567",
    start_time: DateTime.utc_now() |> DateTime.add(24 * 60 * 60, :second) |> DateTime.truncate(:second), # tomorrow
    end_time: DateTime.utc_now() |> DateTime.add(25 * 60 * 60, :second) |> DateTime.truncate(:second),
    notes: "Meşe sehpa montajı için Ahmet Usta'dan destek istiyoruz.",
    status: "confirmed",
    product_id: service1.id
  },
  on_conflict: :nothing
)

IO.puts "DIYABI & Dukkadee Database Seeded Successfully!"


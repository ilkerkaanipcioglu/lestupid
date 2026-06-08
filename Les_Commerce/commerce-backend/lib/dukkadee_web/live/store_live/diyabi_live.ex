defmodule DukkadeeWeb.StoreLive.DiyabiLive do
  use DukkadeeWeb, :live_view

  import Phoenix.HTML.Form
  import DukkadeeWeb.ErrorHelpers

  alias Dukkadee.Stores
  alias Dukkadee.Products
  alias Dukkadee.Tutorials
  alias Dukkadee.Appointments
  alias Dukkadee.Appointments.Appointment

  @impl true
  def mount(_params, _session, socket) do
    # Load the custom Diyabi Creator Hub store
    store = case Stores.get_store_by_slug("diyabi") do
      nil ->
        %{
          id: 0,
          name: "Diyabi Creator Hub",
          slug: "diyabi",
          description: "Usta hiring marketplace, high-quality DIY materials, and expert woodcraft tutorials.",
          primary_color: "#5b21b6",
          secondary_color: "#f43f5e",
          accent_color: "#0f172a",
          logo: "/images/diyabi-logo.png"
        }
      found_store -> found_store
    end

    # Fetch DIY data
    videos = if store.id == 0, do: [], else: Tutorials.list_store_videos(store.id) |> Dukkadee.Repo.preload(:products)
    ustas = if store.id == 0, do: [], else: Products.list_store_products_by_type(store.id, "service")
    materials = if store.id == 0, do: [], else: Products.list_store_products_by_type(store.id, "material")

    # Select the first video by default
    selected_video = List.first(videos)

    # Initialize checklist states
    checklist_states = initialize_checklist(selected_video)

    {:ok,
     socket
     |> assign(:page_title, "DIYABI — Creator & DIY-Commerce Portal")
     |> assign(:store, store)
     |> assign(:videos, videos)
     |> assign(:selected_video, selected_video)
     |> assign(:checklist_states, checklist_states)
     |> assign(:ustas, ustas)
     |> assign(:materials, materials)
     |> assign(:selected_usta, nil)
     |> assign(:appointment_changeset, Appointment.changeset(%Appointment{}, %{}))
     |> assign(:toast_message, nil)
     |> assign(:booking_success, nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:selected_usta, nil)
    |> assign(:booking_success, nil)
  end

  defp apply_action(socket, :video, %{"video_id" => video_id}) do
    video = Tutorials.get_video_with_products(String.to_integer(video_id))
    checklist_states = initialize_checklist(video)

    socket
    |> assign(:selected_video, video)
    |> assign(:checklist_states, checklist_states)
  end

  defp apply_action(socket, :usta, %{"product_id" => product_id}) do
    usta = Products.get_product!(String.to_integer(product_id))

    socket
    |> assign(:selected_usta, usta)
    |> assign(:booking_success, nil)
    |> assign(:appointment_changeset, Appointment.changeset(%Appointment{}, %{
      product_id: usta.id,
      status: "scheduled"
    }))
  end

  @impl true
  def handle_event("select_video", %{"id" => video_id}, socket) do
    {:noreply, push_patch(socket, to: ~p"/stores/diyabi/videos/#{video_id}")}
  end

  @impl true
  def handle_event("select_usta", %{"id" => product_id}, socket) do
    {:noreply, push_patch(socket, to: ~p"/stores/diyabi/ustas/#{product_id}")}
  end

  @impl true
  def handle_event("toggle_checklist_item", %{"id" => product_id}, socket) do
    product_id = String.to_integer(product_id)
    current_val = Map.get(socket.assigns.checklist_states, product_id, false)
    new_states = Map.put(socket.assigns.checklist_states, product_id, !current_val)

    {:noreply, assign(socket, :checklist_states, new_states)}
  end

  @impl true
  def handle_event("add_checked_to_cart", _params, socket) do
    checked_count =
      socket.assigns.checklist_states
      |> Enum.filter(fn {_id, checked} -> checked end)
      |> length()

    if checked_count > 0 do
      {:noreply,
       socket
       |> assign(:toast_message, "#{checked_count} adet DIY malzeme sepetinize eklendi! 🚀")
       |> push_event("clear-toast", %{})}
    else
      {:noreply,
       socket
       |> assign(:toast_message, "Lütfen önce sepetinize eklemek istediğiniz malzemeleri seçin.")
       |> push_event("clear-toast", %{})}
    end
  end

  @impl true
  def handle_event("close_booking_modal", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/stores/diyabi")}
  end

  @impl true
  def handle_event("clear_toast", _params, socket) do
    {:noreply, assign(socket, :toast_message, nil)}
  end

  @impl true
  def handle_event("save_appointment", %{"appointment" => params}, socket) do
    # Extract start and end datetimes
    start_time_str = params["start_time"]
    
    # Process ISO input from browser and format appropriately
    case parse_datetime(start_time_str) do
      {:ok, start_dt} ->
        end_dt = DateTime.add(start_dt, 1, :hour) # 1-hour appointment by default
        
        # Build changes with auto customer registration mapping
        appointment_params = %{
          "customer_name" => params["customer_name"],
          "customer_email" => params["customer_email"],
          "customer_phone" => params["customer_phone"],
          "notes" => params["notes"],
          "start_time" => start_dt,
          "end_time" => end_dt,
          "product_id" => socket.assigns.selected_usta.id,
          "status" => "confirmed"
        }

        case Appointments.create_appointment(appointment_params) do
          {:ok, appointment} ->
            {:noreply,
             socket
             |> assign(:booking_success, appointment)
             |> assign(:toast_message, "Randevunuz başarıyla onaylandı! Ustanız sizinle iletişime geçecektir.")}

          {:error, changeset} ->
            {:noreply, assign(socket, :appointment_changeset, changeset)}
        end

      _ ->
        changeset =
          socket.assigns.appointment_changeset
          |> Ecto.Changeset.add_error(:start_time, "Geçersiz randevu tarihi seçildi.")

        {:noreply, assign(socket, :appointment_changeset, changeset)}
    end
  end

  # Helper functions
  defp initialize_checklist(nil), do: %{}
  defp initialize_checklist(video) do
    if Ecto.assoc_loaded?(video.products) do
      Map.new(video.products, fn p -> {p.id, true} end)
    else
      %{}
    end
  end

  defp parse_datetime(nil), do: {:error, :invalid}
  defp parse_datetime(""), do: {:error, :invalid}
  defp parse_datetime(str) do
    case DateTime.from_iso8601(str <> ":00Z") do
      {:ok, dt, _} -> {:ok, DateTime.truncate(dt, :second)}
      _ ->
        case NaiveDateTime.from_iso8601(str <> ":00") do
          {:ok, ndt} -> {:ok, DateTime.from_naive!(ndt, "Etc/UTC") |> DateTime.truncate(:second)}
          _ -> {:error, :invalid}
        end
    end
  end

  defp get_checked_total(checklist_states, products) do
    products
    |> Enum.filter(fn p -> Map.get(checklist_states, p.id, false) end)
    |> Enum.reduce(Decimal.new("0.00"), fn p, acc -> Decimal.add(acc, p.price) end)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <!-- DIYABI Dark Glassmorphic Portal View -->
    <div class="min-h-screen bg-[#0f172a] text-slate-100 font-['Inter'] relative overflow-x-hidden antialiased pb-20">
      
      <!-- Static SEO & AI Agent Semantic Metadata Injection (JSON-LD) -->
      <script type="application/ld+json">
        <%= raw(Jason.encode!(%{
          "@context" => "https://schema.org",
          "@type" => "Store",
          "name" => @store.name,
          "description" => @store.description,
          "url" => DukkadeeWeb.Endpoint.url() <> "/stores/diyabi",
          "potentialAction" => %{
            "@type" => "ReserveAction",
            "target" => DukkadeeWeb.Endpoint.url() <> "/api/appointments",
            "result" => %{
              "@type" => "Reservation",
              "name" => "Marangoz Montaj & Usta Hizmeti"
            }
          }
        })) %>
      </script>

      <%= if @selected_video do %>
        <script type="application/ld+json">
          <%= raw(Jason.encode!(%{
            "@context" => "https://schema.org",
            "@type" => "VideoObject",
            "name" => @selected_video.title,
            "description" => @selected_video.description,
            "embedUrl" => @selected_video.embed_url,
            "uploadDate" => @selected_video.inserted_at,
            "about" => Enum.map(@selected_video.products, fn p -> %{
              "@type" => "Product",
              "name" => p.name,
              "price" => p.price,
              "priceCurrency" => p.currency || "TL"
            } end)
          })) %>
        </script>
      <% end %>

      <!-- Dynamic Ambient background glows -->
      <div class="absolute top-[-20%] left-[-10%] w-[50vw] h-[50vw] rounded-full bg-indigo-500/10 blur-[120px] pointer-events-none"></div>
      <div class="absolute bottom-[-10%] right-[-10%] w-[50vw] h-[50vw] rounded-full bg-rose-500/5 blur-[150px] pointer-events-none"></div>

      <!-- Agent Friendly Glow Badge -->
      <div class="fixed bottom-6 right-6 z-40 group">
        <a href={~p"/agent-manifest.json"} target="_blank" class="flex items-center gap-2.5 px-4 py-2.5 rounded-full bg-indigo-950/80 backdrop-blur-md border border-indigo-500/30 text-indigo-300 shadow-[0_0_20px_rgba(99,102,241,0.2)] hover:shadow-[0_0_30px_rgba(99,102,241,0.4)] transition-all duration-300">
          <span class="relative flex h-2 w-2">
            <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-indigo-400 opacity-75"></span>
            <span class="relative inline-flex rounded-full h-2 w-2 bg-indigo-400"></span>
          </span>
          <span class="text-xs font-semibold tracking-wider uppercase font-['JetBrains_Mono']">AI Agent Manifest</span>
        </a>
      </div>

      <!-- Header with branding -->
      <header class="border-b border-white/5 bg-slate-950/40 backdrop-blur-md sticky top-0 z-30">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-5 flex items-center justify-between">
          <div class="flex items-center gap-3">
            <div class="h-10 w-10 rounded-xl bg-gradient-to-tr from-indigo-600 to-rose-500 flex items-center justify-center font-bold text-white shadow-lg shadow-indigo-500/20">
              D
            </div>
            <div>
              <h1 class="text-xl font-bold tracking-tight text-white font-['Syne']">DIYABI</h1>
              <p class="text-[10px] text-slate-400 uppercase tracking-widest font-['JetBrains_Mono']">Harezm Ekosistemi — eny</p>
            </div>
          </div>
          
          <nav class="hidden md:flex items-center gap-8 text-sm font-medium text-slate-300">
            <a href="#tutorials" class="hover:text-indigo-400 transition-colors">Eğitimler & Checklists</a>
            <a href="#ustalar" class="hover:text-indigo-400 transition-colors">Usta Pazaryeri</a>
            <a href="#materials" class="hover:text-indigo-400 transition-colors">DIY Malzemeler</a>
          </nav>
        </div>
      </header>

      <!-- Main Portal Container -->
      <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mt-10">
        
        <!-- Toast Notifications -->
        <%= if @toast_message do %>
          <div class="mb-8 p-4 rounded-xl bg-emerald-950/80 border border-emerald-500/30 text-emerald-300 flex justify-between items-center shadow-lg backdrop-blur-md animate-fade-in">
            <div class="flex items-center gap-2">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <span class="text-sm font-medium"><%= @toast_message %></span>
            </div>
            <button phx-click="clear_toast" class="text-emerald-400 hover:text-emerald-200 transition-colors">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
        <% end %>

        <!-- SECTION 1: Tutorials & Checklists -->
        <section id="tutorials" class="scroll-mt-24 mb-16">
          <div class="flex flex-col md:flex-row gap-8">
            
            <!-- Left Side: Interactive Video Player (Glassmorphism container) -->
            <div class="flex-1 rounded-2xl bg-slate-900/40 backdrop-blur-xl border border-white/5 p-6 shadow-2xl">
              <h2 class="text-2xl font-bold text-white mb-6 font-['Syne'] flex items-center gap-2.5">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-rose-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                İnteraktif DIY Atölyesi
              </h2>

              <%= if @selected_video do %>
                <div class="aspect-w-16 aspect-h-9 rounded-xl overflow-hidden border border-white/5 bg-black shadow-inner mb-6 relative">
                  <iframe 
                    class="w-full h-[400px] rounded-xl"
                    src={@selected_video.embed_url} 
                    title={@selected_video.title} 
                    frameborder="0" 
                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                    allowfullscreen>
                  </iframe>
                </div>

                <div class="mt-4">
                  <h3 class="text-xl font-bold text-white mb-2"><%= @selected_video.title %></h3>
                  <p class="text-slate-400 text-sm leading-relaxed"><%= @selected_video.description %></p>
                </div>
              <% else %>
                <div class="h-[400px] flex items-center justify-center border border-dashed border-white/10 rounded-xl bg-slate-950/20">
                  <p class="text-slate-500 text-sm">Aktif eğitim bulunmamaktadır.</p>
                </div>
              <% end %>
            </div>

            <!-- Right Side: Interactive Checklist & Video List -->
            <div class="w-full md:w-[380px] flex flex-col gap-6">
              
              <!-- Checklist Glassmorphism Box -->
              <div class="rounded-2xl bg-slate-900/40 backdrop-blur-xl border border-white/5 p-6 shadow-2xl flex-1 flex flex-col">
                <h3 class="text-lg font-bold text-white mb-4 flex items-center gap-2 font-['Syne']">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-indigo-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                  </svg>
                  Gerekli Malzemeler
                </h3>

                <%= if @selected_video && Ecto.assoc_loaded?(@selected_video.products) && length(@selected_video.products) > 0 do %>
                  <div class="space-y-3 flex-1 overflow-y-auto max-h-[250px] pr-1">
                    <%= for item <- @selected_video.products do %>
                      <div 
                        phx-click="toggle_checklist_item" 
                        phx-value-id={item.id}
                        class={"flex items-center gap-3 p-3 rounded-xl border cursor-pointer select-none transition-all duration-200 " <> 
                               (if Map.get(@checklist_states, item.id, false), 
                                 do: "bg-indigo-600/10 border-indigo-500/30 text-indigo-200", 
                                 else: "bg-slate-950/20 border-white/5 text-slate-400 hover:bg-white/5")}
                      >
                        <div class={"h-5 w-5 rounded flex items-center justify-center border transition-all duration-200 " <> 
                                     (if Map.get(@checklist_states, item.id, false), 
                                       do: "bg-indigo-600 border-indigo-500 text-white", 
                                       else: "border-slate-600")}>
                          <%= if Map.get(@checklist_states, item.id, false) do %>
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7" />
                            </svg>
                          <% end %>
                        </div>
                        <div class="flex-1 min-w-0">
                          <p class={"text-xs font-semibold truncate " <> (if Map.get(@checklist_states, item.id, false), do: "text-white line-through opacity-70", else: "text-slate-200")}><%= item.name %></p>
                          <p class="text-[10px] text-slate-500 font-medium capitalize"><%= item.type %></p>
                        </div>
                        <div class="text-right">
                          <p class="text-xs font-bold text-white"><%= Decimal.to_string(item.price, :normal) %> TL</p>
                        </div>
                      </div>
                    <% end %>
                  </div>

                  <div class="border-t border-white/5 pt-4 mt-4">
                    <div class="flex justify-between items-center mb-4 text-xs font-medium">
                      <span class="text-slate-400">Seçilen Malzemeler Toplamı:</span>
                      <span class="text-sm font-bold text-indigo-400"><%= get_checked_total(@checklist_states, @selected_video.products) %> TL</span>
                    </div>

                    <button 
                      phx-click="add_checked_to_cart"
                      class="w-full py-3 px-4 rounded-xl bg-gradient-to-r from-indigo-600 to-indigo-700 hover:from-indigo-500 hover:to-indigo-600 text-white text-xs font-bold shadow-lg shadow-indigo-500/20 active:scale-[0.98] transition-all duration-200 flex items-center justify-center gap-2"
                    >
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z" />
                      </svg>
                      Seçilenleri Sepete Ekle
                    </button>
                  </div>
                <% else %>
                  <div class="flex-1 flex items-center justify-center text-slate-500 text-xs py-8">
                    Bu eğitim için malzeme tanımlanmamıştır.
                  </div>
                <% end %>
              </div>

              <!-- Other Tutorials List -->
              <div class="rounded-2xl bg-slate-900/40 backdrop-blur-xl border border-white/5 p-6 shadow-2xl">
                <h3 class="text-sm font-bold text-slate-300 mb-4 font-['Syne'] uppercase tracking-wider">Tüm Eğitim Serileri</h3>
                <div class="space-y-3">
                  <%= for video <- @videos do %>
                    <button 
                      phx-click="select_video" 
                      phx-value-id={video.id}
                      class={"w-full text-left p-3 rounded-xl border text-xs flex items-center gap-3 transition-all duration-200 " <> 
                             (if @selected_video && @selected_video.id == video.id, 
                               do: "bg-rose-500/10 border-rose-500/30 text-rose-300", 
                               else: "bg-slate-950/20 border-white/5 text-slate-400 hover:bg-white/5")}
                    >
                      <div class={"h-6 w-6 rounded-lg flex items-center justify-center shadow-inner " <>
                                   (if @selected_video && @selected_video.id == video.id, do: "bg-rose-500 text-white", else: "bg-slate-800 text-slate-400")}>
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z" />
                        </svg>
                      </div>
                      <span class="font-bold truncate text-slate-200"><%= video.title %></span>
                    </button>
                  <% end %>
                </div>
              </div>

            </div>
          </div>
        </section>

        <!-- SECTION 2: Usta hiring / Services directory (Pazaryeri) -->
        <section id="ustalar" class="scroll-mt-24 mb-16">
          <div class="mb-8">
            <h2 class="text-2xl font-bold text-white font-['Syne']">Usta & Kurulum Pazaryeri</h2>
            <p class="text-slate-400 text-sm mt-1">Deneyimli ustalarımızdan profesyonel montaj, ahşap işleme ve özel tasarım hizmetleri kiralayın.</p>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <%= for usta <- @ustas do %>
              <!-- Glassmorphism Card -->
              <div class="rounded-2xl bg-slate-900/40 backdrop-blur-xl border border-white/5 p-6 shadow-2xl flex flex-col md:flex-row gap-6 hover:border-indigo-500/20 transition-all duration-300 group">
                <div class="h-28 w-28 rounded-2xl bg-slate-800 flex-shrink-0 overflow-hidden border border-white/5 relative">
                  <div class="absolute inset-0 bg-gradient-to-tr from-indigo-500/20 to-rose-500/10 mix-blend-overlay"></div>
                  <div class="w-full h-full flex items-center justify-center text-3xl font-extrabold text-indigo-400/30">
                    <%= String.slice(usta.name, 0, 2) %>
                  </div>
                </div>
                
                <div class="flex-1 flex flex-col justify-between">
                  <div>
                    <div class="flex items-start justify-between gap-4 mb-2">
                      <h3 class="text-lg font-bold text-white group-hover:text-indigo-300 transition-colors"><%= usta.name %></h3>
                      <span class="px-2.5 py-1 rounded-md bg-indigo-500/10 text-indigo-300 text-[10px] font-bold uppercase tracking-wider font-['JetBrains_Mono']"><%= usta.category %></span>
                    </div>
                    <p class="text-slate-400 text-xs leading-relaxed mb-4"><%= usta.description %></p>
                    
                    <div class="flex flex-wrap gap-1.5 mb-4">
                      <%= for tag <- (usta.tags || []) do %>
                        <span class="px-2 py-0.5 rounded-full bg-slate-800 border border-white/5 text-slate-400 text-[9px] font-medium"><%= tag %></span>
                      <% end %>
                    </div>
                  </div>

                  <div class="flex items-center justify-between border-t border-white/5 pt-4 mt-2">
                    <div>
                      <p class="text-[10px] text-slate-500 uppercase tracking-widest font-semibold font-['JetBrains_Mono']">Saatlik Ücret</p>
                      <p class="text-base font-extrabold text-white"><%= Decimal.to_string(usta.price, :normal) %> TL</p>
                    </div>

                    <button 
                      phx-click="select_usta"
                      phx-value-id={usta.id}
                      class="py-2.5 px-5 rounded-xl bg-slate-800 hover:bg-slate-700 text-indigo-300 text-xs font-bold border border-indigo-500/20 shadow-md active:scale-[0.98] transition-all duration-200"
                    >
                      Hemen Randevu Al
                    </button>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
        </section>

        <!-- SECTION 3: Materials catalog -->
        <section id="materials" class="scroll-mt-24">
          <div class="mb-8">
            <h2 class="text-2xl font-bold text-white font-['Syne']">DIY Malzeme Kataloğu</h2>
            <p class="text-slate-400 text-sm mt-1">Eğitimlerde kullanılan 1. sınıf masif ahşap plakalar, cilalar ve el aletleri.</p>
          </div>

          <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
            <%= for material <- @materials do %>
              <div class="rounded-2xl bg-slate-900/40 backdrop-blur-xl border border-white/5 p-4 shadow-2xl flex flex-col justify-between hover:border-rose-500/10 transition-all duration-300 group">
                <div>
                  <div class="aspect-w-1 aspect-h-1 rounded-xl bg-slate-800 border border-white/5 overflow-hidden mb-4 relative">
                    <div class="absolute inset-0 bg-gradient-to-b from-transparent to-slate-950/20"></div>
                    <div class="w-full h-40 flex items-center justify-center text-4xl font-extrabold text-rose-500/20">
                      🛠️
                    </div>
                  </div>
                  <h3 class="text-sm font-bold text-slate-200 truncate group-hover:text-rose-300 transition-colors"><%= material.name %></h3>
                  <p class="text-[10px] text-slate-500 mt-0.5 capitalize"><%= material.category %></p>
                  <p class="text-xs text-slate-400 mt-2 line-clamp-2 leading-relaxed"><%= material.description %></p>
                </div>

                <div class="flex items-center justify-between mt-4 pt-3 border-t border-white/5">
                  <span class="text-sm font-extrabold text-white"><%= Decimal.to_string(material.price, :normal) %> TL</span>
                  <button 
                    phx-click="add_checked_to_cart"
                    phx-value-id={material.id}
                    class="h-8 w-8 rounded-lg bg-rose-500/10 hover:bg-rose-500 text-rose-300 hover:text-white flex items-center justify-center border border-rose-500/20 hover:border-transparent transition-all duration-200 active:scale-95"
                  >
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                  </button>
                </div>
              </div>
            <% end %>
          </div>
        </section>

      </main>

      <!-- Glassmorphic Booking Modal -->
      <%= if @selected_usta do %>
        <div class="fixed inset-0 bg-slate-950/80 backdrop-blur-sm flex items-center justify-center z-50 p-4 animate-fade-in">
          
          <div class="bg-slate-900/90 border border-white/10 rounded-2xl max-w-lg w-full shadow-2xl p-6 relative max-h-[90vh] overflow-y-auto">
            
            <!-- Close Button -->
            <button 
              phx-click="close_booking_modal" 
              class="absolute top-4 right-4 text-slate-400 hover:text-white transition-colors"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>

            <%= if is_nil(@booking_success) do %>
              <!-- Booking Form -->
              <h2 class="text-xl font-bold text-white mb-2 font-['Syne']">Usta Hizmet Rezervasyonu</h2>
              <p class="text-xs text-indigo-400 font-medium mb-6">Usta: <%= @selected_usta.name %></p>

              <.form :let={f} for={@appointment_changeset} phx-submit="save_appointment" class="space-y-4">
                <div>
                  <label class="block text-slate-400 text-xs font-semibold mb-1">Adınız Soyadınız *</label>
                  <%= text_input f, :customer_name, required: true, class: "w-full rounded-xl bg-slate-950/40 border border-white/10 px-4 py-2.5 text-xs text-white placeholder-slate-600 focus:border-indigo-500 focus:outline-none transition-colors", placeholder: "Ahmet Yılmaz" %>
                  <%= error_tag f, :customer_name %>
                </div>

                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <label class="block text-slate-400 text-xs font-semibold mb-1">E-Posta *</label>
                    <%= email_input f, :customer_email, required: true, class: "w-full rounded-xl bg-slate-950/40 border border-white/10 px-4 py-2.5 text-xs text-white placeholder-slate-600 focus:border-indigo-500 focus:outline-none transition-colors", placeholder: "ahmet@example.com" %>
                    <%= error_tag f, :customer_email %>
                  </div>
                  <div>
                    <label class="block text-slate-400 text-xs font-semibold mb-1">Telefon *</label>
                    <%= telephone_input f, :customer_phone, required: true, class: "w-full rounded-xl bg-slate-950/40 border border-white/10 px-4 py-2.5 text-xs text-white placeholder-slate-600 focus:border-indigo-500 focus:outline-none transition-colors", placeholder: "+90 555 123 4567" %>
                    <%= error_tag f, :customer_phone %>
                  </div>
                </div>

                <div>
                  <label class="block text-slate-400 text-xs font-semibold mb-1">Randevu Tarihi & Saati *</label>
                  <%= datetime_local_input f, :start_time, required: true, class: "w-full rounded-xl bg-slate-950/40 border border-white/10 px-4 py-2.5 text-xs text-white placeholder-slate-600 focus:border-indigo-500 focus:outline-none transition-colors" %>
                  <%= error_tag f, :start_time %>
                </div>

                <div>
                  <label class="block text-slate-400 text-xs font-semibold mb-1">Usta İçin Yapılacak İş Notu</label>
                  <%= textarea f, :notes, rows: 3, class: "w-full rounded-xl bg-slate-950/40 border border-white/10 px-4 py-2.5 text-xs text-white placeholder-slate-600 focus:border-indigo-500 focus:outline-none transition-colors", placeholder: "Masa ayaklarının montajı ve zımparalama işi yapılacak..." %>
                  <%= error_tag f, :notes %>
                </div>

                <div class="pt-4 flex gap-3">
                  <button 
                    type="button" 
                    phx-click="close_booking_modal" 
                    class="flex-1 py-3 px-4 rounded-xl bg-slate-800 hover:bg-slate-700 border border-white/5 text-slate-300 text-xs font-bold transition-all duration-200"
                  >
                    Vazgeç
                  </button>
                  <button 
                    type="submit" 
                    class="flex-1 py-3 px-4 rounded-xl bg-gradient-to-r from-indigo-600 to-indigo-700 hover:from-indigo-500 hover:to-indigo-600 text-white text-xs font-bold shadow-lg shadow-indigo-500/20 active:scale-[0.98] transition-all duration-200"
                  >
                    Randevu Al
                  </button>
                </div>
              </.form>
            <% else %>
              <!-- Booking Confirmation & Embedded JSON-LD schema summary -->
              <div class="text-center py-6 animate-fade-in">
                <div class="h-14 w-14 rounded-full bg-emerald-500/20 border border-emerald-500/30 text-emerald-400 flex items-center justify-center text-2xl mx-auto mb-4">
                  ✓
                </div>
                <h2 class="text-xl font-bold text-white font-['Syne'] mb-2">Rezervasyon Başarılı!</h2>
                <p class="text-xs text-slate-400 leading-relaxed mb-6">
                  Usta <%= @selected_usta.name %> ile randevunuz oluşturuldu. Rezervasyon detayları aşağıdadır ve otonom arayüzler tarafından otomatik izlenebilir.
                </p>

                <!-- Confirmation details card -->
                <div class="rounded-xl bg-slate-950/40 border border-white/5 p-4 text-left space-y-2 mb-6">
                  <div class="flex justify-between text-xs">
                    <span class="text-slate-500">Müşteri Adı:</span>
                    <span class="text-slate-200 font-medium"><%= @booking_success.customer_name %></span>
                  </div>
                  <div class="flex justify-between text-xs">
                    <span class="text-slate-500">Müşteri E-Posta:</span>
                    <span class="text-slate-200 font-medium font-['JetBrains_Mono']"><%= @booking_success.customer_email %></span>
                  </div>
                  <div class="flex justify-between text-xs">
                    <span class="text-slate-500">Başlangıç Saati:</span>
                    <span class="text-slate-200 font-medium"><%= Calendar.strftime(@booking_success.start_time, "%Y-%m-%d %H:%M:%S UTC") %></span>
                  </div>
                  <div class="flex justify-between text-xs">
                    <span class="text-slate-500">Durum:</span>
                    <span class="px-2 py-0.5 rounded bg-emerald-500/10 text-emerald-300 font-bold uppercase tracking-wider text-[9px] font-['JetBrains_Mono']"><%= @booking_success.status %></span>
                  </div>
                </div>

                <!-- Structured Agent Reservation Metadata block for copy/inspection -->
                <div class="text-left">
                  <p class="text-[10px] text-slate-500 uppercase tracking-widest font-semibold mb-2 font-['JetBrains_Mono']">Agent-LD Reservation Metadata</p>
                  <pre class="bg-black/40 border border-white/5 rounded-lg p-3 text-[10px] text-indigo-300 overflow-x-auto font-['JetBrains_Mono']"><%= raw(Jason.encode!(%{
                    "@context" => "https://schema.org",
                    "@type" => "Reservation",
                    "reservationNumber" => to_string(@booking_success.id),
                    "reservationStatus" => "https://schema.org/Confirmed",
                    "underName" => %{
                      "@type" => "Person",
                      "name" => @booking_success.customer_name,
                      "email" => @booking_success.customer_email
                    },
                    "startDate" => @booking_success.start_time,
                    "endDate" => @booking_success.end_time
                  }, pretty: true)) %></pre>
                </div>

                <button 
                  phx-click="close_booking_modal" 
                  class="mt-6 w-full py-3 px-4 rounded-xl bg-slate-800 hover:bg-slate-700 border border-white/5 text-white text-xs font-bold transition-all duration-200"
                >
                  Kapat
                </button>
              </div>
            <% end %>

          </div>
        </div>
      <% end %>

    </div>
    """
  end
end

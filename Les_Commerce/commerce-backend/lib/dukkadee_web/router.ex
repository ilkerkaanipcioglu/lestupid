defmodule DukkadeeWeb.Router do
  use DukkadeeWeb, :router

  import DukkadeeWeb.UserAuth
  import DukkadeeWeb.CustomerAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DukkadeeWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug :fetch_current_customer
  end

  pipeline :store_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DukkadeeWeb.Layouts, :store}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_customer
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug DukkadeeWeb.Plugs.CORS
  end

  scope "/api", DukkadeeWeb.Api do
    pipe_through :api

    get "/products", ProductController, :index
    get "/products/:id", ProductController, :show
    get "/videos", VideoController, :index
    get "/videos/:id", VideoController, :show
    post "/appointments", AppointmentController, :create

    # Item Otel endpoints
    get "/itemotel/items", ItemOtelController, :index
    post "/itemotel/items", ItemOtelController, :create
    get "/itemotel/items/:id", ItemOtelController, :show
    post "/itemotel/items/:id/care", ItemOtelController, :request_care
    post "/itemotel/items/:id/list", ItemOtelController, :list_item
    post "/itemotel/items/:id/unlist", ItemOtelController, :unlist_item
    post "/itemotel/items/:id/recall", ItemOtelController, :recall_item
  end

  scope "/", DukkadeeWeb do
    pipe_through :api # Using API pipeline so it serves pure JSON without HTML layouts

    get "/agent-manifest.json", AgentManifestController, :show
    get "/.well-known/ai-agent.json", AgentManifestController, :show
  end

  pipeline :store_owner do
    plug :put_root_layout, {DukkadeeWeb.LayoutView, :store_owner}
    # Add authentication plug to ensure user owns the store
    # plug DukkadeeWeb.Plugs.EnsureStoreOwner
  end

  # Public routes that don't require authentication
  scope "/", DukkadeeWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live "/users/register", UserRegistrationLive, :new
    live "/users/log_in", UserLoginLive, :new
    live "/users/reset_password", UserResetPasswordLive, :new
    live "/users/reset_password/:token", UserResetPasswordLive, :edit
  end

  # Customer auth routes (don't require authentication)
  scope "/customers", DukkadeeWeb do
    pipe_through [:browser, :redirect_if_customer_is_authenticated]

    live "/register", CustomerRegistrationLive, :new
    live "/log_in", CustomerLoginLive, :new
    live "/reset_password", CustomerResetPasswordLive, :new
    live "/reset_password/:token", CustomerResetPasswordLive, :edit
  end

  scope "/", DukkadeeWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update

    # Customer session routes
    delete "/customers/log_out", CustomerSessionController, :delete
    get "/customers/confirm", CustomerConfirmationController, :new
    post "/customers/confirm", CustomerConfirmationController, :create
    get "/customers/confirm/:token", CustomerConfirmationController, :edit
    post "/customers/confirm/:token", CustomerConfirmationController, :update
  end

  # Routes for store domain
  scope "/", DukkadeeWeb, host: "store." do
    pipe_through :browser

    # When accessed via custom domain
    get "/", StoreController, :home, as: :store_home

    # Store public routes
    get "/products", StoreController, :products
    get "/products/:id", StoreController, :product_details
    get "/categories/:category", StoreController, :category_products
    get "/search", StoreController, :search
    get "/page/:slug", StoreController, :page
    get "/book-appointment/:product_id", StoreController, :book_appointment
  end

  # Routes for dukkadee.com
  scope "/", DukkadeeWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/hello", HelloController, :index
    get "/test", TestController, :hello
    live "/home", HomeLive.Index, :index
    live "/marketplace", MarketplaceLive.Index, :index
    live "/marketplace/search", MarketplaceLive.Index, :search
    live "/marketplace/categories/:category", MarketplaceLive.Index, :category
    live "/open_new_store", StoreCreationLive.Index, :index
    
    # Stores list page
    live "/stores", StoreLive.ListLive, :index
    live "/stores/:slug", StoreLive.ShowLive, :show
    
    # Store discovery feature
    live "/stores/discover", StoreLive.DiscoveryLive, :index
    live "/stores/discover/search", StoreLive.DiscoveryLive, :search
    
    # Store templates routes
    get "/templates", StoreTemplateController, :index
    get "/templates/import", StoreTemplateController, :import_legacy
    post "/templates/import", StoreTemplateController, :create_from_legacy
    get "/templates/:id", StoreTemplateController, :show
    get "/templates/new/:template_id", StoreTemplateController, :new
    post "/templates/create/:template_id", StoreTemplateController, :create
    
    # Legacy store import routes
    post "/api/legacy-store/import", LegacyStoreController, :import
    get "/legacy-store/import/progress/:id", LegacyStoreController, :progress
    
    # Appointment Routes
    live "/appointments/confirmation/:id", AppointmentLive.ConfirmationLive, :show
  end
  
  # Inkless Is More Store Routes with custom layout
  scope "/stores/inklessismore-ke", DukkadeeWeb do
    pipe_through :store_browser
    
    live "/", StoreLive.TattooRemovalLive, :index
    live "/book/:product_id", StoreLive.TattooRemovalLive, :book
    
    # Inkless Is More Enhanced Features
    live "/gallery", StoreLive.GalleryLive, :index
    live "/gallery/:category", StoreLive.TattooGalleryLive, :category
    live "/testimonials", StoreLive.TestimonialsLive, :index
    live "/blog", StoreLive.TattooBlogLive, :index
    live "/blog/:slug", StoreLive.TattooBlogLive, :show
    live "/staff", StoreLive.StaffProfilesLive, :index
    live "/gift-certificates", StoreLive.GiftCertificatesLive, :index
    live "/gift-certificates/purchase", StoreLive.GiftCertificatesLive, :purchase
    live "/gift-certificates/redeem", StoreLive.GiftCertificatesLive, :redeem
    
    # New routes for the menu items in the photo
    live "/how-it-works", StoreLive.HowItWorksLive, :index
    live "/treatment-cost", StoreLive.TreatmentCostLive, :index
    live "/faq", StoreLive.FaqLive, :index
    live "/about", StoreLive.AboutLive, :index
    live "/gallery", StoreLive.GalleryLive, :index
    live "/contact", StoreLive.ContactLive, :index
  end

  # Diyabi Store Routes with custom glassmorphic layout
  scope "/stores/diyabi", DukkadeeWeb do
    pipe_through :store_browser

    live "/", StoreLive.DiyabiLive, :index
    live "/videos/:video_id", StoreLive.DiyabiLive, :video
    live "/ustas/:product_id", StoreLive.DiyabiLive, :usta
    live "/book/:product_id", StoreLive.DiyabiLive, :book
  end

  # Customer portal routes that require customer authentication
  scope "/stores/inklessismore-ke/portal", DukkadeeWeb do
    pipe_through [:browser, :require_authenticated_customer]
    
    live "/", CustomerPortal.DashboardLive, :index
    live "/appointments", CustomerPortal.AppointmentsLive, :index
    live "/appointments/new", CustomerPortal.AppointmentsLive, :new
    live "/appointments/:id", CustomerPortal.AppointmentsLive, :show
    
    live "/progress", CustomerPortal.ProgressTrackerLive, :index
    live "/progress/:id", CustomerPortal.ProgressTrackerLive, :show
    live "/progress/:id/photos", CustomerPortal.ProgressTrackerLive, :photos
    
    live "/profile", CustomerPortal.ProfileLive, :index
    live "/profile/edit", CustomerPortal.ProfileLive, :edit
    live "/profile/password", CustomerPortal.ProfileLive, :password
    
    live "/gift-certificates", CustomerPortal.GiftCertificatesLive, :index
    live "/notifications", CustomerPortal.NotificationsLive, :index
  end

  scope "/customer", DukkadeeWeb do
    pipe_through [:browser, :require_authenticated_customer]

    live "/appointments", CustomerPortal.AppointmentsLive
    live "/appointments/new", CustomerPortal.NewAppointmentLive
  end

  # Store admin routes (require authentication)
  scope "/admin", DukkadeeWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/", AdminLive.Dashboard, :index
    live "/stores", AdminLive.Stores, :index
    live "/stores/new", AdminLive.Stores, :new
    live "/stores/:id", AdminLive.Stores, :show
    live "/stores/:id/edit", AdminLive.Stores, :edit
    
    live "/stores/:store_id/products", AdminLive.Products, :index
    live "/stores/:store_id/products/new", AdminLive.Products, :new
    live "/stores/:store_id/products/:id", AdminLive.Products, :show
    live "/stores/:store_id/products/:id/edit", AdminLive.Products, :edit
    
    live "/stores/:store_id/appointments", AdminLive.Appointments, :index
    live "/stores/:store_id/appointments/new", AdminLive.Appointments, :new
    live "/stores/:store_id/appointments/:id", AdminLive.Appointments, :show
    live "/stores/:store_id/appointments/:id/edit", AdminLive.Appointments, :edit
    
    # Additional admin routes for new features
    live "/stores/:store_id/testimonials", AdminLive.Testimonials, :index
    live "/stores/:store_id/testimonials/new", AdminLive.Testimonials, :new
    live "/stores/:store_id/testimonials/:id/edit", AdminLive.Testimonials, :edit
    
    live "/stores/:store_id/gallery", AdminLive.Gallery, :index
    live "/stores/:store_id/gallery/new", AdminLive.Gallery, :new
    live "/stores/:store_id/gallery/:id/edit", AdminLive.Gallery, :edit
    
    live "/stores/:store_id/blog", AdminLive.Blog, :index
    live "/stores/:store_id/blog/new", AdminLive.Blog, :new
    live "/stores/:store_id/blog/:id/edit", AdminLive.Blog, :edit
    
    live "/stores/:store_id/staff", AdminLive.Staff, :index
    live "/stores/:store_id/staff/new", AdminLive.Staff, :new
    live "/stores/:store_id/staff/:id/edit", AdminLive.Staff, :edit
    
    live "/stores/:store_id/gift-certificates", AdminLive.GiftCertificates, :index
    live "/stores/:store_id/gift-certificates/:id", AdminLive.GiftCertificates, :show
    
    live "/stores/:store_id/customers", AdminLive.Customers, :index
    live "/stores/:store_id/customers/:id", AdminLive.Customers, :show
    live "/stores/:store_id/customers/:id/progress", AdminLive.Customers, :progress
    
    live "/stores/:store_id/pages", AdminLive.Pages, :index
    live "/stores/:store_id/pages/new", AdminLive.Pages, :new
    live "/stores/:store_id/pages/:id", AdminLive.Pages, :show
    live "/stores/:store_id/pages/:id/edit", AdminLive.Pages, :edit
    
    live "/stores/:store_id/settings", AdminLive.Settings, :index
  end

  # Marketplace routes
  scope "/", DukkadeeWeb do
    pipe_through :browser

    live "/marketplace", MarketplaceLive.Index, :index
    live "/marketplace/categories/:category", MarketplaceLive.Index, :category
    
    # Store admin routes - requires store owner authentication
    live "/stores/:store_id/admin", AdminLive.Dashboard, :index
    live "/stores/:store_id/admin/products", AdminLive.Products, :index
    live "/stores/:store_id/admin/products/new", AdminLive.Products, :new
    live "/stores/:store_id/admin/products/:id/edit", AdminLive.Products, :edit
    live "/stores/:store_id/admin/orders", AdminLive.Orders, :index
    live "/stores/:store_id/admin/orders/:id", AdminLive.Orders, :show
    live "/stores/:store_id/admin/settings", AdminLive.Settings, :index
  end

  # Public routes
  scope "/", DukkadeeWeb do
    pipe_through :browser

    # Home page
    live "/", HomeLive.Index, :index
    
    # Stores
    live "/stores", StoreLive.Index, :index
    live "/stores/:slug", StoreLive.Show, :show
    live "/stores/:store_id/products/:id", ProductLive.Show, :show
    
    # Marketplace
    live "/marketplace", MarketplaceLive.Index, :index
    live "/marketplace/categories/:category", MarketplaceLive.Index, :category
  end
  
  # Store owner routes
  scope "/", DukkadeeWeb do
    pipe_through [:browser, :store_owner]
    
    # Store admin routes - requires store owner authentication
    live "/stores/:store_id/admin", AdminLive.Dashboard, :index
    live "/stores/:store_id/admin/products", AdminLive.Products, :index
    live "/stores/:store_id/admin/products/new", AdminLive.Products, :new
    live "/stores/:store_id/admin/products/:id/edit", AdminLive.Products, :edit
    live "/stores/:store_id/admin/orders", AdminLive.Orders, :index
    live "/stores/:store_id/admin/orders/:id", AdminLive.Orders, :show
    live "/stores/:store_id/admin/settings", AdminLive.Settings, :index
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:dukkadee, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DukkadeeWeb.Telemetry
    end
  end
end

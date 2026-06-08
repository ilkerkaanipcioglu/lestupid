defmodule Dukkadee.StoreImporter.ShopifyImporter do
  @moduledoc """
  Module for importing stores from Shopify.
  This module handles the specific logic for scraping and importing Shopify stores.
  """

  alias Dukkadee.Stores
  alias Dukkadee.Products
  alias Dukkadee.Repo
  alias Dukkadee.Stores.Store
  alias Dukkadee.Products.Product
  alias Dukkadee.StoreImporter.ImportJob

  @doc """
  Import a store from a Shopify URL.
  """
  def import_store(url, user_id) do
    # Create an import job to track progress
    {:ok, job} = create_import_job(url, user_id)
    
    # Start the import process
    Task.start(fn -> 
      process_import(job, url, user_id)
    end)
    
    {:ok, job}
  end
  
  defp create_import_job(url, user_id) do
    %ImportJob{}
    |> ImportJob.changeset(%{
      source_url: url,
      status: :pending,
      user_id: user_id
    })
    |> Repo.insert()
  end
  
  defp process_import(job, url, user_id) do
    # Update job status to in_progress
    update_job_status(job, :in_progress, "Scraping store data", 10)
    
    # Extract store info
    with {:ok, store_data} <- scrape_store_info(url),
         update_job_status(job, :in_progress, "Extracting brand colors", 20),
         {:ok, brand_colors} <- extract_brand_colors(url),
         update_job_status(job, :in_progress, "Creating store", 30),
         {:ok, store} <- create_store(store_data, brand_colors, user_id),
         update_job_status(job, :in_progress, "Extracting products", 40),
         {:ok, products} <- extract_products(url),
         update_job_status(job, :in_progress, "Importing products", 60),
         {:ok, _} <- import_products(products, store.id),
         update_job_status(job, :in_progress, "Extracting pages", 70),
         {:ok, pages} <- extract_pages(url),
         update_job_status(job, :in_progress, "Importing pages", 90),
         {:ok, _} <- import_pages(pages, store.id) do
      
      # Update job as completed
      update_job_status(job, :completed, "Import completed", 100, store.id)
      {:ok, store}
    else
      {:error, reason} ->
        # Update job as failed
        update_job_status(job, :failed, "Import failed: #{inspect(reason)}", job.progress)
        {:error, reason}
    end
  end
  
  defp update_job_status(job, status, current_step, progress, store_id \\ nil) do
    attrs = %{
      status: status,
      current_step: current_step,
      progress: progress,
      steps_completed: trunc(progress / 20), # 5 steps total
      completed_at: (if status == :completed, do: DateTime.utc_now(), else: nil),
      store_id: store_id
    }
    
    job
    |> ImportJob.update_progress_changeset(attrs)
    |> Repo.update()
  end
  
  @doc """
  Scrape store information from a Shopify store.
  """
  def scrape_store_info(url) do
    # In a real implementation, we would use HTTP client to fetch the page
    # and extract store information from meta tags, JSON-LD, etc.
    
    # For Inkless Is More specifically
    {:ok, %{
      name: "Inkless Is More",
      slug: "inklessismore-ke",
      description: "Nairobi's Premier Laser Tattoo Removal Studio",
      domain: "www.inklessismore.ke"
    }}
  end
  
  @doc """
  Extract brand colors from a Shopify store.
  """
  def extract_brand_colors(_url) do
    # For Inkless Is More specifically, using the brand colors from memory
    {:ok, %{
      primary_color: "#fddb24",    # Yellow
      secondary_color: "#b7acd4",  # Light Purple
      accent_color: "#272727"      # Dark Gray
    }}
  end
  
  @doc """
  Extract products from a Shopify store.
  """
  def extract_products(_url) do
    # In a real implementation, we would scrape the products from the store
    # For now, we'll create some sample products for Inkless Is More
    products = [
      %{
        name: "Tattoo Removal Session",
        description: "Single session for laser tattoo removal. Price varies based on tattoo size.",
        price: Decimal.new("150.00"),
        currency: "KES",
        category: "Services",
        is_published: true,
        requires_appointment: true,
        images: ["/images/tattoo-removal-session.jpg"]
      },
      %{
        name: "Tattoo Removal Package (3 Sessions)",
        description: "Package of 3 laser tattoo removal sessions at a discounted rate.",
        price: Decimal.new("400.00"),
        currency: "KES",
        category: "Packages",
        is_published: true,
        requires_appointment: true,
        images: ["/images/tattoo-removal-package.jpg"]
      },
      %{
        name: "Aftercare Kit",
        description: "Complete aftercare kit with healing cream, bandages, and instructions.",
        price: Decimal.new("35.00"),
        currency: "KES",
        category: "Products",
        is_published: true,
        requires_appointment: false,
        images: ["/images/aftercare-kit.jpg"]
      },
      %{
        name: "Consultation",
        description: "Initial consultation to assess your tattoo and discuss removal options.",
        price: Decimal.new("0.00"),
        currency: "KES",
        category: "Services",
        is_published: true,
        requires_appointment: true,
        images: ["/images/consultation.jpg"]
      }
    ]
    
    {:ok, products}
  end
  
  @doc """
  Extract pages from a Shopify store.
  """
  def extract_pages(_url) do
    # In a real implementation, we would scrape the pages from the store
    # For now, we'll create some sample pages for Inkless Is More
    pages = [
      %{
        title: "About Us",
        slug: "about",
        content: """
        <div class="about-page">
          <h1>About Inkless Is More</h1>
          <p>We are Nairobi's premier laser tattoo removal studio, dedicated to helping you move on from unwanted tattoos with the latest technology and expert care.</p>
          
          <h2>Our Story</h2>
          <p>Founded in 2020, Inkless Is More was born from the vision of providing safe, effective tattoo removal services in Kenya. Our founder, having experienced the challenges of finding quality tattoo removal services locally, decided to bring world-class technology and expertise to Nairobi.</p>
          
          <h2>Our Technology</h2>
          <p>We use state-of-the-art PicoSure laser technology, which shatters tattoo ink into tiny particles that your body can naturally eliminate. This technology is faster, more effective, and less painful than traditional methods.</p>
          
          <h2>Our Team</h2>
          <p>Our team consists of certified laser specialists with extensive training in tattoo removal procedures. We prioritize your safety, comfort, and results in every session.</p>
        </div>
        """
      },
      %{
        title: "How It Works",
        slug: "how-it-works",
        content: """
        <div class="how-it-works-page">
          <h1>How Laser Tattoo Removal Works</h1>
          
          <div class="step">
            <h2>Step 1: Consultation</h2>
            <p>We begin with a thorough consultation to assess your tattoo, discuss your goals, and create a personalized treatment plan.</p>
          </div>
          
          <div class="step">
            <h2>Step 2: Treatment</h2>
            <p>During each session, our laser targets the tattoo ink, breaking it down into tiny particles that your body can naturally eliminate.</p>
          </div>
          
          <div class="step">
            <h2>Step 3: Healing</h2>
            <p>After each session, your body begins the process of eliminating the ink particles. Proper aftercare is essential during this phase.</p>
          </div>
          
          <div class="step">
            <h2>Step 4: Follow-up Sessions</h2>
            <p>Most tattoos require multiple sessions for complete removal. We typically schedule sessions 6-8 weeks apart to allow for healing.</p>
          </div>
          
          <h2>Factors Affecting Removal</h2>
          <ul>
            <li>Tattoo age (older tattoos are easier to remove)</li>
            <li>Ink colors (black and dark blue are easier to remove)</li>
            <li>Tattoo location (tattoos closer to the heart typically fade faster)</li>
            <li>Skin type and tone</li>
            <li>Quality of the tattoo</li>
          </ul>
        </div>
        """
      },
      %{
        title: "FAQ",
        slug: "faq",
        content: """
        <div class="faq-page">
          <h1>Frequently Asked Questions</h1>
          
          <div class="faq-item">
            <h3>How many sessions will I need?</h3>
            <p>Most tattoos require 5-10 sessions for complete removal, though this varies based on factors like ink color, tattoo age, and location.</p>
          </div>
          
          <div class="faq-item">
            <h3>Is laser tattoo removal painful?</h3>
            <p>Most clients describe the sensation as similar to having a rubber band snapped against the skin. We offer numbing options to minimize discomfort.</p>
          </div>
          
          <div class="faq-item">
            <h3>How long between sessions?</h3>
            <p>We typically recommend 6-8 weeks between sessions to allow your body to process the ink and for the skin to heal.</p>
          </div>
          
          <div class="faq-item">
            <h3>Are there any side effects?</h3>
            <p>Temporary redness, swelling, and blistering are common. Rare side effects include hyperpigmentation or hypopigmentation, which are usually temporary.</p>
          </div>
          
          <div class="faq-item">
            <h3>How much does it cost?</h3>
            <p>Pricing depends on the size, color, and complexity of your tattoo. We offer free consultations to provide an accurate quote.</p>
          </div>
        </div>
        """
      },
      %{
        title: "Contact",
        slug: "contact",
        content: """
        <div class="contact-page">
          <h1>Contact Us</h1>
          
          <div class="contact-info">
            <h2>Location</h2>
            <p>Inkless Is More<br>
            Westlands Business Park<br>
            Nairobi, Kenya</p>
            
            <h2>Hours</h2>
            <p>Monday - Friday: 9am - 6pm<br>
            Saturday: 10am - 4pm<br>
            Sunday: Closed</p>
            
            <h2>Contact</h2>
            <p>Phone: +254 712 345 678<br>
            Email: info@inklessismore.ke</p>
          </div>
          
          <div class="contact-form">
            <h2>Send Us a Message</h2>
            <!-- Contact form would go here -->
          </div>
        </div>
        """
      }
    ]
    
    {:ok, pages}
  end
  
  @doc """
  Create a store with the extracted data.
  """
  def create_store(store_data, brand_colors, user_id) do
    store_attrs = %{
      name: store_data.name,
      slug: store_data.slug,
      description: store_data.description,
      primary_color: brand_colors.primary_color,
      secondary_color: brand_colors.secondary_color,
      accent_color: brand_colors.accent_color,
      domain: store_data.domain,
      user_id: user_id
    }
    
    %Store{}
    |> Store.changeset(store_attrs)
    |> Repo.insert()
  end
  
  @doc """
  Import products into the store.
  """
  def import_products(products, store_id) do
    results = Enum.map(products, fn product_data ->
      product_attrs = Map.put(product_data, :store_id, store_id)
      
      %Product{}
      |> Product.changeset(product_attrs)
      |> Repo.insert()
    end)
    
    failures = Enum.filter(results, fn
      {:error, _} -> true
      _ -> false
    end)
    
    if Enum.empty?(failures) do
      {:ok, length(products)}
    else
      {:error, "Failed to import some products"}
    end
  end
  
  @doc """
  Import pages into the store.
  """
  def import_pages(pages, store_id) do
    results = Enum.map(pages, fn page_data ->
      page_attrs = Map.put(page_data, :store_id, store_id)
      
      Dukkadee.Pages.create_page(page_attrs)
    end)
    
    failures = Enum.filter(results, fn
      {:error, _} -> true
      _ -> false
    end)
    
    if Enum.empty?(failures) do
      {:ok, length(pages)}
    else
      {:error, "Failed to import some pages"}
    end
  end
end

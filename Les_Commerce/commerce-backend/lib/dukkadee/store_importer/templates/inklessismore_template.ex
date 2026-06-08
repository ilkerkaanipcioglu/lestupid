defmodule Dukkadee.StoreImporter.Templates.InklessismoreTemplate do
  @moduledoc """
  Template implementation for InklessIsMore store.
  This module provides specific functionality and settings for creating
  stores based on the InklessIsMore template.
  """

  alias Dukkadee.Stores
  # These aliases are commented out for now but will be used in the full implementation
  # alias Dukkadee.Products
  # alias Dukkadee.Pages

  @doc """
  Get the template configuration for InklessIsMore.
  """
  def get_template_config do
    %{
      id: "template_inklessismore",
      name: "InklessIsMore",
      description: "Premium stationery and office supplies template",
      version: "1.0.0",
      preview_url: "/images/templates/inklessismore-preview.jpg",
      theme: "inklessismore",
      brand_colors: %{
        primary: "#2C3E50",    # Dark blue
        secondary: "#E74C3C",  # Red
        accent: "#3498DB",     # Light blue
        text: "#333333",       # Dark gray
        background: "#FFFFFF"  # White
      },
      layout: %{
        header: %{
          logo_position: "center",
          menu_position: "below",
          show_search: true,
          show_cart: true,
          show_account: true
        },
        footer: %{
          columns: 4,
          show_social: true,
          show_newsletter: true,
          show_payment_methods: true
        },
        home: %{
          hero_style: "fullwidth",
          featured_products_count: 8,
          show_categories: true,
          show_testimonials: true
        },
        product_list: %{
          grid_columns: 3,
          show_filters: true,
          show_sorting: true,
          show_quick_view: true
        },
        product_detail: %{
          layout: "gallery",
          image_position: "left",
          show_related: true,
          show_reviews: true
        },
        cart: %{
          show_related: true,
          show_estimated_shipping: true
        },
        checkout: %{
          steps: ["information", "shipping", "payment", "review"],
          show_order_summary: true
        }
      },
      fonts: %{
        heading: "Montserrat",
        body: "Open Sans"
      },
      default_pages: [
        %{
          title: "About Us",
          slug: "about-us",
          content: get_about_page_content()
        },
        %{
          title: "Contact",
          slug: "contact",
          content: get_contact_page_content()
        },
        %{
          title: "FAQ",
          slug: "faq",
          content: get_faq_page_content()
        },
        %{
          title: "Shipping & Returns",
          slug: "shipping-returns",
          content: get_shipping_page_content()
        },
        %{
          title: "Privacy Policy",
          slug: "privacy-policy",
          content: get_privacy_page_content()
        }
      ],
      sample_products: [
        %{
          name: "Premium Notebook",
          slug: "premium-notebook",
          description: "High-quality notebook with premium paper and durable binding.",
          price: 24.99,
          images: ["/images/templates/inklessismore/products/notebook.jpg"],
          categories: ["Notebooks", "Stationery"]
        },
        %{
          name: "Fountain Pen Set",
          slug: "fountain-pen-set",
          description: "Elegant fountain pen set with multiple ink cartridges.",
          price: 49.99,
          images: ["/images/templates/inklessismore/products/pen-set.jpg"],
          categories: ["Pens", "Gift Sets"]
        },
        %{
          name: "Desk Organizer",
          slug: "desk-organizer",
          description: "Wooden desk organizer with multiple compartments.",
          price: 34.99,
          images: ["/images/templates/inklessismore/products/desk-organizer.jpg"],
          categories: ["Office Supplies", "Organization"]
        }
      ]
    }
  end

  @doc """
  Apply template-specific setup to a store.
  This includes creating sample products, pages, and settings.
  """
  def apply_to_store(store) do
    # TODO: Implement template-specific product and page creation
    # For now, we just return the store
    {:ok, store}
  end

  @doc """
  Apply the InklessIsMore template to a new store.
  """
  def apply_template(store_attrs, user_id) do
    template = get_template_config()
    
    # Merge template settings with store attributes
    store_data = Map.merge(
      %{
        theme: template.theme,
        template_id: template.id,
        brand_colors: template.brand_colors,
        user_id: user_id
      },
      store_attrs
    )
    
    with {:ok, store} <- Stores.create_store(store_data),
         :ok <- create_default_pages(store.id, template.default_pages),
         :ok <- create_sample_products(store.id, template.sample_products) do
      {:ok, store}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  # Private functions

  defp create_default_pages(_store_id, _pages) do
    # In a real implementation, this would create the default pages in the database
    # For now, just return :ok
    :ok
  end

  defp create_sample_products(_store_id, _products) do
    # In a real implementation, this would create the sample products in the database
    # For now, just return :ok
    :ok
  end

  defp get_about_page_content do
    """
    <div class="about-page">
      <h1>About Us</h1>
      <p>Welcome to our store! We are dedicated to providing high-quality products and exceptional customer service.</p>
      
      <h2>Our Story</h2>
      <p>Founded in 2023, we started with a simple mission: to provide premium stationery and office supplies that inspire creativity and productivity.</p>
      
      <h2>Our Values</h2>
      <ul>
        <li>Quality: We source only the finest materials for our products.</li>
        <li>Sustainability: We are committed to environmentally friendly practices.</li>
        <li>Customer Satisfaction: Your happiness is our top priority.</li>
      </ul>
      
      <h2>Meet the Team</h2>
      <p>Our team consists of passionate individuals who share a love for quality stationery and office supplies.</p>
    </div>
    """
  end

  defp get_contact_page_content do
    """
    <div class="contact-page">
      <h1>Contact Us</h1>
      <p>We'd love to hear from you! Please use the form below to get in touch with us.</p>
      
      <div class="contact-form">
        <form>
          <div class="form-group">
            <label for="name">Name</label>
            <input type="text" id="name" name="name" required>
          </div>
          
          <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" required>
          </div>
          
          <div class="form-group">
            <label for="subject">Subject</label>
            <input type="text" id="subject" name="subject" required>
          </div>
          
          <div class="form-group">
            <label for="message">Message</label>
            <textarea id="message" name="message" rows="5" required></textarea>
          </div>
          
          <button type="submit" class="btn-primary">Send Message</button>
        </form>
      </div>
      
      <div class="contact-info">
        <h2>Contact Information</h2>
        <p>Email: info@example.com</p>
        <p>Phone: +1 (123) 456-7890</p>
        <p>Address: 123 Main Street, City, Country</p>
      </div>
    </div>
    """
  end

  defp get_faq_page_content do
    """
    <div class="faq-page">
      <h1>Frequently Asked Questions</h1>
      
      <div class="faq-item">
        <h3>How long does shipping take?</h3>
        <p>Standard shipping typically takes 3-5 business days. Express shipping is available for 1-2 business days delivery.</p>
      </div>
      
      <div class="faq-item">
        <h3>What is your return policy?</h3>
        <p>We accept returns within 30 days of purchase. Items must be unused and in original packaging.</p>
      </div>
      
      <div class="faq-item">
        <h3>Do you ship internationally?</h3>
        <p>Yes, we ship to most countries worldwide. International shipping typically takes 7-14 business days.</p>
      </div>
      
      <div class="faq-item">
        <h3>How can I track my order?</h3>
        <p>Once your order ships, you will receive a tracking number via email that you can use to track your package.</p>
      </div>
      
      <div class="faq-item">
        <h3>Do you offer gift wrapping?</h3>
        <p>Yes, we offer gift wrapping for an additional fee. You can select this option during checkout.</p>
      </div>
    </div>
    """
  end

  defp get_shipping_page_content do
    """
    <div class="shipping-page">
      <h1>Shipping & Returns</h1>
      
      <h2>Shipping Policy</h2>
      <p>We offer the following shipping options:</p>
      <ul>
        <li>Standard Shipping: 3-5 business days</li>
        <li>Express Shipping: 1-2 business days</li>
        <li>International Shipping: 7-14 business days</li>
      </ul>
      
      <p>Orders are processed within 1-2 business days. Shipping times are estimates and not guaranteed.</p>
      
      <h2>Return Policy</h2>
      <p>We accept returns within 30 days of purchase. To be eligible for a return, your item must be unused and in the same condition that you received it. It must also be in the original packaging.</p>
      
      <h3>Return Process</h3>
      <ol>
        <li>Contact our customer service team to initiate a return</li>
        <li>Package the item securely in its original packaging</li>
        <li>Include your order number and return reason</li>
        <li>Ship the item to the provided return address</li>
      </ol>
      
      <p>Once we receive and inspect the returned item, we will process your refund. The refund will be credited to your original method of payment.</p>
    </div>
    """
  end

  defp get_privacy_page_content do
    """
    <div class="privacy-page">
      <h1>Privacy Policy</h1>
      
      <p>Last updated: March 1, 2025</p>
      
      <h2>Introduction</h2>
      <p>This Privacy Policy describes how we collect, use, and disclose your personal information when you visit our website or make a purchase.</p>
      
      <h2>Information We Collect</h2>
      <p>When you visit our site, we collect certain information about your device, your interaction with the site, and information necessary to process your purchases.</p>
      
      <h2>How We Use Your Information</h2>
      <p>We use the information we collect to:</p>
      <ul>
        <li>Process orders and send order confirmations</li>
        <li>Communicate with you about your order or account</li>
        <li>Improve our website and services</li>
        <li>Comply with legal obligations</li>
      </ul>
      
      <h2>Sharing Your Information</h2>
      <p>We share your information with service providers to help us provide our services and fulfill our contracts with you.</p>
      
      <h2>Your Rights</h2>
      <p>You have the right to access, correct, delete, or restrict the processing of your personal data.</p>
      
      <h2>Changes to This Policy</h2>
      <p>We may update this Privacy Policy from time to time to reflect changes in our practices or for other operational, legal, or regulatory reasons.</p>
    </div>
    """
  end
end

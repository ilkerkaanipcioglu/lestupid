defmodule Dukkadee.StoreImporter.LegacyStoreImporterTest do
  use ExUnit.Case

  alias Dukkadee.StoreImporter.LegacyStoreImporter

  describe "url validation" do
    test "extract_store_name/1 extracts store name from URL" do
      assert LegacyStoreImporter.extract_store_name("https://example-store.com") == "Example store"
      assert LegacyStoreImporter.extract_store_name("http://www.my-shop.com/products") == "My shop"
      assert LegacyStoreImporter.extract_store_name("https://cool_store.net") == "Cool store"
      assert LegacyStoreImporter.extract_store_name("www.fancy-boutique.store") == "Fancy boutique"
    end

    test "slugify/1 converts string to URL-friendly slug" do
      assert LegacyStoreImporter.slugify("My Cool Store") == "my-cool-store"
      assert LegacyStoreImporter.slugify("Example Store!") == "example-store"
      assert LegacyStoreImporter.slugify("Fancy & Boutique") == "fancy-boutique"
      assert LegacyStoreImporter.slugify("  Trim  Spaces  ") == "trim-spaces"
    end
  end

  describe "store scraping" do
    test "scrape_store/1 returns store data for valid URL" do
      # Mock implementation for testing
      {:ok, store_data} = LegacyStoreImporter.scrape_store("https://example-store.com")
      
      assert is_map(store_data)
      assert Map.has_key?(store_data, :name)
      assert Map.has_key?(store_data, :description)
      assert Map.has_key?(store_data, :html_content)
    end
  end

  describe "content extraction" do
    test "extract_brand_colors/1 returns color map" do
      store_data = %{html_content: "<html><head><style>.header{color:#ff0000;}</style></head></html>"}
      
      {:ok, colors} = LegacyStoreImporter.extract_brand_colors(store_data)
      
      assert is_map(colors)
      assert Map.has_key?(colors, :primary)
      assert Map.has_key?(colors, :secondary)
      assert Map.has_key?(colors, :accent)
    end

    test "extract_products/1 returns product list" do
      store_data = %{html_content: "<html><div class='product'>Product 1</div><div class='product'>Product 2</div></html>"}
      
      {:ok, products} = LegacyStoreImporter.extract_products(store_data)
      
      assert is_list(products)
      assert length(products) > 0
      product = List.first(products)
      assert Map.has_key?(product, :name)
      assert Map.has_key?(product, :description)
      assert Map.has_key?(product, :price)
    end

    test "extract_pages/1 returns page list" do
      store_data = %{html_content: "<html><div class='page'>About Us</div><div class='page'>Contact</div></html>"}
      
      {:ok, pages} = LegacyStoreImporter.extract_pages(store_data)
      
      assert is_list(pages)
      assert length(pages) > 0
      page = List.first(pages)
      assert Map.has_key?(page, :title)
      assert Map.has_key?(page, :slug)
      assert Map.has_key?(page, :content)
    end
  end

  describe "store creation" do
    test "create_store/3 creates store with extracted data" do
      store_data = %{
        name: "Test Store",
        description: "A test store",
        products_count: 5,
        pages_count: 3,
        html_content: "<html>...</html>"
      }
      
      brand_colors = %{
        primary: "#ff0000",
        secondary: "#00ff00",
        accent: "#0000ff",
        text: "#000000",
        background: "#ffffff"
      }
      
      user_id = "user_123"
      
      {:ok, store} = LegacyStoreImporter.create_store(store_data, brand_colors, user_id)
      
      assert store.name == "Test Store"
      assert store.description == "A test store"
      assert store.user_id == "user_123"
      assert store.brand_colors == brand_colors
    end
  end

  describe "full import process" do
    test "import_store/2 performs full import process" do
      url = "https://example-store.com"
      user_id = "user_123"
      
      {:ok, store} = LegacyStoreImporter.import_store(url, user_id)
      
      assert is_map(store)
      assert Map.has_key?(store, :id)
      assert Map.has_key?(store, :name)
      assert Map.has_key?(store, :url)
    end
  end
end

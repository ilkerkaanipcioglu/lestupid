defmodule Dukkadee.Repo.Migrations.CopyInklessismoreAssets do
  @moduledoc """
  Script to copy assets from the legacy inklessismore-ke site to the Deecommerce platform.
  """

  def run do
    IO.puts("Starting to copy assets for Inkless Is More...")
    
    # Create the destination directory structure
    create_directories()
    
    # Copy the logo
    copy_logo()
    
    # Copy product images
    copy_product_images()
    
    IO.puts("Asset copying completed successfully!")
  end
  
  defp create_directories do
    IO.puts("Creating directory structure...")
    
    # Main store images directory
    File.mkdir_p!("priv/static/images/stores/inklessismore")
    
    IO.puts("Directory structure created.")
  end
  
  defp copy_logo do
    IO.puts("Copying logo...")
    
    # Copy the logo file
    File.cp!(
      "legacy_sites/inklessismore-ke/images/IMG_6182.png",
      "priv/static/images/stores/inklessismore/logo.png"
    )
    
    IO.puts("Logo copied successfully.")
  end
  
  defp copy_product_images do
    IO.puts("Copying product images...")
    
    # List of main product images to copy
    main_images = [
      "1_session.jpg",
      "3sessions.jpg",
      "5sessions.jpg",
      "Unlimitedsessions.jpg",
      "BeforeandAfter.jpg",
      "7eb822a5-2ae0-4739-9065-a5939d4759d9_08acd678-41c1-4aa7-9ccb-9475ea874dcc.jpg",
      "f2cecfc5-7fbb-4fe8-b36a-58b7ec4003cd.jpg",
      "acf8a6f8-1226-43d7-9a22-11d135947a6c.jpg",
      "Inklessismore_Cover_Page.jpg"
    ]
    
    # Copy each main image
    Enum.each(main_images, fn image ->
      source_path = "legacy_sites/inklessismore-ke/images/#{image}"
      dest_path = "priv/static/images/stores/inklessismore/#{image}"
      
      if File.exists?(source_path) do
        File.cp!(source_path, dest_path)
        IO.puts("Copied #{image}")
      else
        IO.puts("Warning: Could not find #{source_path}")
      end
    end)
    
    IO.puts("Product images copied successfully.")
  end
end

# Run the script when this file is executed directly
if Code.ensure_loaded?(Mix) and Mix.env() == :dev do
  Dukkadee.Repo.Migrations.CopyInklessismoreAssets.run()
end

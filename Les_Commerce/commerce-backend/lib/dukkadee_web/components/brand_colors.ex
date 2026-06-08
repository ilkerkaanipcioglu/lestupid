defmodule DukkadeeWeb.Components.BrandColors do
  @moduledoc """
  Provides brand color definitions for the Dukkadee platform.
  This module helps maintain consistent branding across the application.
  """

  @doc """
  Primary brand colors
  """
  def primary do
    %{
      yellow: "#fddb24",
      light_purple: "#b7acd4",
      white: "#ffffff"
    }
  end

  @doc """
  Dark gray/black variations for the platform
  """
  def dark do
    %{
      darkest: "#272727",
      darker: "#282828",
      dark: "#2a2a2a",
      medium_dark: "#2c2c2c",
      medium: "#2e2e2e",
      medium_light: "#2f2f2f",
      light: "#303030",
      lighter: "#313131",
      lightest: "#323232"
    }
  end

  @doc """
  Additional dark shades
  """
  def extended_dark do
    %{
      dark_333: "#333333",
      dark_2d: "#2d2d2d",
      dark_343434: "#343434",
      dark_353535: "#353535",
      dark_363636: "#363636",
      dark_373737: "#373737",
      dark_292929: "#292929",
      dark_2b2b2b: "#2b2b2b"
    }
  end

  @doc """
  Get store specific brand colors
  Defaults to Dukkadee default colors if store doesn't have custom colors
  """
  def get_store_colors(_store_id) do
    %{
      primary: "#fddb24",
      secondary: "#b7acd4",
      dark: [
        "#272727", "#282828", "#292929", "#2a2a2a", "#2b2b2b",
        "#2c2c2c", "#2d2d2d", "#2e2e2e", "#2f2f2f", "#303030",
        "#313131", "#323232", "#333333", "#343434", "#353535",
        "#363636", "#373737"
      ]
    }
  end

  @doc """
  Get customer-specific colors, falling back to store colors if not defined.
  In the future, this will allow customers to customize their portal colors.
  """
  def get_customer_colors(_customer_id, store_id) do
    get_store_colors(store_id)
  end

  @doc """
  Generate CSS variables for all brand colors for use in templates
  """
  def css_variables do
    primary_colors = for {name, value} <- primary(), do: "--color-#{name}: #{value};"
    dark_colors = for {name, value} <- dark(), do: "--color-#{name}: #{value};"
    extended_colors = for {name, value} <- extended_dark(), do: "--color-#{name}: #{value};"
    
    Enum.join(primary_colors ++ dark_colors ++ extended_colors, "\n")
  end

  @doc """
  Converts a hex color to RGB components.
  
  ## Examples
      iex> BrandColors.hex_to_rgb("#fddb24")
      {253, 219, 36}
  """
  def hex_to_rgb(hex) do
    hex = String.replace(hex, "#", "")
    
    {r, _} = Integer.parse(String.slice(hex, 0, 2), 16)
    {g, _} = Integer.parse(String.slice(hex, 2, 2), 16)
    {b, _} = Integer.parse(String.slice(hex, 4, 2), 16)
    
    {r, g, b}
  end
  
  @doc """
  Determines if a color is dark based on its luminance.
  Returns true if the color is dark, false if it's light.
  
  ## Examples
      iex> BrandColors.is_dark_color?("#fddb24")
      false
      
      iex> BrandColors.is_dark_color?("#272727")
      true
  """
  def is_dark_color?(hex) do
    {r, g, b} = hex_to_rgb(hex)
    
    # Calculate relative luminance using sRGB
    r_srgb = r / 255
    g_srgb = g / 255
    b_srgb = b / 255
    
    # Apply gamma correction
    r_linear = if r_srgb <= 0.03928, do: r_srgb / 12.92, else: :math.pow((r_srgb + 0.055) / 1.055, 2.4)
    g_linear = if g_srgb <= 0.03928, do: g_srgb / 12.92, else: :math.pow((g_srgb + 0.055) / 1.055, 2.4)
    b_linear = if b_srgb <= 0.03928, do: b_srgb / 12.92, else: :math.pow((b_srgb + 0.055) / 1.055, 2.4)
    
    # Calculate luminance (perceived brightness)
    luminance = 0.2126 * r_linear + 0.7152 * g_linear + 0.0722 * b_linear
    
    # A luminance of 0.5 is the threshold between light and dark
    luminance < 0.5
  end
  
  @doc """
  Returns a contrasting color (black or white) based on the input color's luminance.
  Returns "#ffffff" for dark colors and "#000000" for light colors.
  """
  def contrasting_text_color(hex) do
    if is_dark_color?(hex), do: "#ffffff", else: "#000000"
  end
  
  @doc """
  Adjusts the opacity of a hex color and returns it as an rgba string.
  
  ## Examples
      iex> BrandColors.with_opacity("#fddb24", 0.5)
      "rgba(253, 219, 36, 0.5)"
  """
  def with_opacity(hex, opacity) do
    {r, g, b} = hex_to_rgb(hex)
    "rgba(#{r}, #{g}, #{b}, #{opacity})"
  end
end

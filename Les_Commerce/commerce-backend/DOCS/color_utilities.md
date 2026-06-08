# Color Utility Functions Documentation

## Overview

The Dukkadee platform implements a set of color utility functions to handle dynamic color manipulation for store branding. These utilities help maintain consistent UX while allowing for store customization.

## Implementation

The color utilities are implemented in the `DukkadeeWeb.Components.BrandColors` module, which provides functions for color manipulation, conversion, and accessibility considerations.

### Location

- **Module**: `lib/dukkadee_web/components/brand_colors.ex`
- **CSS Variables**: `assets/css/brand_colors.css`

## Core Brand Colors

The Dukkadee platform has established a core brand palette:

- **Yellow** (`#fddb24`): Primary brand color, used for CTA buttons and highlights
- **Light Purple** (`#b7acd4`): Secondary brand color
- **Dark Gray** (`#272727`): Text and UI elements

## Utility Functions

### Hex to RGB Conversion

Converts hexadecimal color codes to RGB values, which is essential for CSS operations like opacity.

```elixir
def hex_to_rgb(hex) do
  hex = String.replace(hex, "#", "")
  
  {r, _} = String.slice(hex, 0, 2) |> Integer.parse(16)
  {g, _} = String.slice(hex, 2, 2) |> Integer.parse(16)
  {b, _} = String.slice(hex, 4, 2) |> Integer.parse(16)
  
  {r, g, b}
end
```

### Dark Color Detection

Determines if a color is dark, which helps in deciding text color for contrast.

```elixir
def is_dark_color?(hex) do
  {r, g, b} = hex_to_rgb(hex)
  
  # Calculate perceived brightness using the formula
  # (0.299*R + 0.587*G + 0.114*B)
  brightness = (0.299 * r + 0.587 * g + 0.114 * b) / 255
  
  brightness < 0.5
end
```

### Contrasting Text Color

Selects either white or black text based on the background color to ensure readability.

```elixir
def contrasting_text_color(hex) do
  if is_dark_color?(hex), do: "#ffffff", else: "#272727"
end
```

### Color with Opacity

Creates a rgba() color string with the specified opacity.

```elixir
def with_opacity(hex, opacity) do
  {r, g, b} = hex_to_rgb(hex)
  "rgba(#{r}, #{g}, #{b}, #{opacity})"
end
```

## Usage Examples

### In LiveView Components

```elixir
def store_header(assigns) do
  store_color = assigns.store.primary_color || "#fddb24"
  text_color = BrandColors.contrasting_text_color(store_color)
  
  ~H"""
  <header style={"background-color: #{store_color}; color: #{text_color}"}>
    <h1><%= @store.name %></h1>
  </header>
  """
end
```

### In CSS Variables

```elixir
def store_theme_css(store) do
  primary = store.primary_color || "#fddb24"
  secondary = store.secondary_color || "#b7acd4"
  text = BrandColors.contrasting_text_color(primary)
  
  """
  :root {
    --store-primary: #{primary};
    --store-primary-rgb: #{rgb_string(primary)};
    --store-secondary: #{secondary};
    --store-text: #{text};
    --store-primary-10: #{BrandColors.with_opacity(primary, 0.1)};
    --store-primary-20: #{BrandColors.with_opacity(primary, 0.2)};
  }
  """
end

defp rgb_string(hex) do
  {r, g, b} = BrandColors.hex_to_rgb(hex)
  "#{r}, #{g}, #{b}"
end
```

## Accessibility Considerations

- The `contrasting_text_color/1` function ensures text remains readable regardless of background color
- Brightness calculation uses the perceived brightness formula, which accounts for human color perception
- Color contrast ratios follow WCAG guidelines for accessibility

## Store-Specific Customization

Each store can define its own brand colors, which are stored in the database:

```elixir
schema "stores" do
  field :name, :string
  field :domain, :string
  field :primary_color, :string, default: "#fddb24"  # Dukkadee yellow as default
  field :secondary_color, :string, default: "#b7acd4"  # Dukkadee purple as default
  # ...
end
```

## Integration with Tailwind

The color utilities work with Tailwind CSS through custom configuration:

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        'brand-yellow': '#fddb24',
        'brand-light-purple': '#b7acd4',
        'brand-dark': {
          DEFAULT: '#272727',
          '1': '#272727',
          '2': '#282828',
          // ...
        },
      }
    }
  }
}
```

## Best Practices

1. **Default to Platform Colors**: Always provide fallbacks to the platform's core colors
2. **Dynamic Contrast**: Always use `contrasting_text_color/1` for text on colored backgrounds
3. **Opacity for UI States**: Use `with_opacity/2` for hover, active, and disabled states
4. **Preserve Brand Identity**: Limit color customization to specific areas to maintain platform recognition

# Phoenix 1.7 Migration Guide

Last updated: March 2, 2025

## Overview

This document outlines the process and key changes involved in migrating the Dukkadee e-commerce platform from an older Phoenix version to Phoenix 1.7. Phoenix 1.7 introduces significant architectural changes, particularly around the view layer, which has been replaced with a component-based architecture.

## Key Architectural Changes

### 1. From Views to Components

Phoenix 1.7 replaces the traditional view modules with HTML components:

- **Old Structure (Pre-1.7):**
  ```
  lib/dukkadee_web/views/store_template_view.ex
  lib/dukkadee_web/templates/store_template/index.html.eex
  ```

- **New Structure (1.7+):**
  ```
  lib/dukkadee_web/controllers/store_template_html.ex
  lib/dukkadee_web/controllers/store_template_html/index.html.heex
  ```

### 2. Routing Changes

Phoenix 1.7 introduces the `~p` sigil for path generation:

- **Old Approach:**
  ```elixir
  Routes.store_template_path(conn, :index)
  ```

- **New Approach:**
  ```elixir
  ~p"/store_templates"
  ```

### 3. HTML Engine Changes

- `.eex` templates are replaced with `.heex` (HEEx - HTML + EEx)
- HEEx provides better HTML safety and component support

### 4. Core Components

Phoenix 1.7 provides a set of core components for common UI elements:

- `CoreComponents` module with buttons, modals, tables, etc.
- Component-based forms with improved validation display

## Migration Steps

### 1. Controller Updates

1. Update controller modules to use the new HTML component structure
2. Replace `render` calls to use the new HTML component format
3. Update redirects to use the `~p` sigil instead of `Routes.x_path`

Example:
```elixir
# Old
def index(conn, _params) do
  templates = StoreTemplates.list_templates()
  render(conn, "index.html", templates: templates)
end

# New
def index(conn, _params) do
  templates = StoreTemplates.list_templates()
  render(conn, :index, templates: templates)
end
```

### 2. HTML Component Creation

1. Create a new HTML component module for each controller
2. Import CoreComponents and other necessary components
3. Use `embed_templates` to include the template files

Example:
```elixir
defmodule DukkadeeWeb.StoreTemplateHTML do
  use DukkadeeWeb, :html

  import DukkadeeWeb.CoreComponents
  
  embed_templates "store_template_html/*"
  
  # Custom helpers can be defined here
  def error_tag(form, field) do
    # Implementation
  end
end
```

### 3. Template Migration

1. Convert `.eex` templates to `.heex`
2. Update template syntax to use component-based approach
3. Replace form helpers with component-based forms

Example:
```heex
<.header>
  Store Templates
  <:actions>
    <.link href={~p"/store_templates/new"}>
      <.button>New Template</.button>
    </.link>
  </:actions>
</.header>

<.table id="templates" rows={@templates}>
  <:col :let={template} label="Name"><%= template.name %></:col>
  <:action :let={template}>
    <.link navigate={~p"/store_templates/#{template}"}>Show</.link>
  </:action>
</.table>
```

### 4. Form Updates

1. Replace `form_for` with the new `<.simple_form>` component
2. Update input fields to use the `<.input>` component
3. Update error handling to use the component's built-in error display

Example:
```heex
<.simple_form :let={f} for={@changeset} action={@action}>
  <.error :if={@changeset.action}>
    Oops, something went wrong! Please check the errors below.
  </.error>
  
  <.input field={f[:name]} type="text" label="Name" />
  <.input field={f[:description]} type="textarea" label="Description" />
  
  <:actions>
    <.button>Save</.button>
  </:actions>
</.simple_form>
```

## Common Issues and Solutions

### 1. Function Clause Warnings

Issue: Warnings about function clause grouping in `core_components.ex`
Solution: Ensure all function clauses of the same arity are grouped together

### 2. Missing Assets

Issue: Missing hero icons directory
Solution: Install hero icons or create the directory structure:
```bash
mkdir -p priv/hero_icons/optimized
```

### 3. LiveView Component Compatibility

Issue: LiveView components may need updates for Phoenix 1.7
Solution: Review LiveView components and update to use the new component structure

## References

- [Phoenix 1.7 Release Notes](https://www.phoenixframework.org/blog/phoenix-1.7-released)
- [Phoenix 1.7 Components Guide](https://hexdocs.pm/phoenix/components.html)
- [HEEx Documentation](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html)

# Store Discovery Feature Documentation

## Overview

The Store Discovery feature allows users to browse, search, and filter stores on the Dukkadee platform. It implements pagination, featured stores, search functionality, and filtering capabilities to help users find relevant stores efficiently.

## Implementation

### Components

- **StoreLive.DiscoveryLive**: LiveView module that handles the store discovery interface
- **Stores Context**: Backend functions for retrieving and filtering stores
- **Pagination**: Implemented using Scrivener Ecto

### Key Files

- `lib/dukkadee_web/live/store_live/discovery_live.ex`: Main LiveView implementation
- `lib/dukkadee_web/live/store_live/discovery_live.html.heex`: HTML template
- `lib/dukkadee/stores.ex`: Context functions for store operations
- `lib/dukkadee/repo.ex`: Scrivener configuration

## Features

### Pagination

Store listings are paginated to improve performance and user experience when browsing large numbers of stores.

```elixir
# In the Stores context
def list_stores_paginated(params) do
  Store
  |> where([s], s.status == :active)
  |> order_by([s], desc: s.inserted_at)
  |> Repo.paginate(params)
end
```

### Featured Stores

The platform highlights selected stores as "featured" to increase their visibility.

```elixir
# In the Stores context
def list_featured_stores(limit) do
  Store
  |> where([s], s.status == :active and s.featured == true)
  |> limit(^limit)
  |> order_by([s], desc: s.inserted_at)
  |> Repo.all()
end
```

### Search Functionality

Users can search for stores by name, description, and other attributes.

```elixir
# In the Stores context
def search_stores_paginated(search_term, params) do
  search_term = "%#{search_term}%"
  
  Store
  |> where([s], s.status == :active)
  |> where([s], ilike(s.name, ^search_term) or ilike(s.description, ^search_term))
  |> order_by([s], desc: s.inserted_at)
  |> Repo.paginate(params)
end
```

### Filtering

Stores can be filtered by various criteria such as category, location, and more.

```elixir
# In the Stores context
def filter_stores(params) do
  query = from(s in Store, where: s.status == :active)

  query =
    if category_id = params["category_id"] do
      from s in query,
        join: c in assoc(s, :categories),
        where: c.id == ^category_id
    else
      query
    end

  # Additional filters can be added here

  query
  |> order_by([s], desc: s.inserted_at)
  |> Repo.paginate(params)
end
```

## LiveView Implementation

The discovery LiveView implements various callback functions to handle lifecycle events, events from the UI, and rendering.

### Mount

```elixir
def mount(_params, _session, socket) do
  {:ok,
    socket
    |> assign(:page_title, "Discover Stores")
    |> assign(:featured_stores, Stores.list_featured_stores(4))
    |> assign(:search_term, "")
    |> assign(:filter_params, %{})
    |> assign(:page, %Scrivener.Page{entries: [], page_number: 1, page_size: 12, total_entries: 0, total_pages: 0})
  }
end
```

### Handle Parameters

```elixir
def handle_params(params, _url, socket) do
  page = params["page"] || "1"
  search_term = params["search"] || ""
  
  page = 
    if search_term != "" do
      Stores.search_stores_paginated(search_term, %{page: page, page_size: 12})
    else
      filter_params = extract_filter_params(params)
      filtered_query = Stores.filter_stores(filter_params)
      Repo.paginate(filtered_query, %{page: page, page_size: 12})
    end
    
  {:noreply,
    socket
    |> assign(:page, page)
    |> assign(:search_term, search_term)
    |> assign(:filter_params, extract_filter_params(params))
  }
end
```

## Router Configuration

```elixir
# In router.ex
live "/stores/discover", StoreLive.DiscoveryLive, :index
live "/stores/discover/search", StoreLive.DiscoveryLive, :search
```

## Performance Considerations

- Store listings are paginated to handle large numbers of stores efficiently
- Selective loading of featured stores to minimize initial page load time
- Efficient search and filtering by using database indexes on relevant fields
- Use of LiveView temporary assigns for optimized re-rendering

## Future Enhancements

- Geolocation-based store recommendations
- Advanced filtering options based on store metrics
- Store tagging system for improved categorization
- Personalized store recommendations based on user preferences

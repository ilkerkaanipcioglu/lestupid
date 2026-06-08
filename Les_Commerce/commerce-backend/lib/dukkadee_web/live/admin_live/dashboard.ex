defmodule DukkadeeWeb.AdminLive.Dashboard do
  use DukkadeeWeb, :live_view
  
  alias Phoenix.PubSub

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      # Subscribe to real-time updates
      PubSub.subscribe(Dukkadee.PubSub, "admin:dashboard")
      
      # Schedule periodic updates for analytics
      Process.send_after(self(), :update_analytics, 10_000)
    end
    
    # Get user from session
    user = session["current_user"]
    
    # Get stores owned by the user
    stores = if user, do: Dukkadee.Stores.list_stores_by_owner(user.id), else: []
    
    # Initialize analytics data
    analytics = %{
      total_sales: generate_random_sales(),
      total_orders: Enum.random(50..500),
      total_customers: Enum.random(20..200),
      recent_orders: generate_random_orders(),
      sales_by_day: generate_daily_sales_data(),
      top_products: generate_top_products()
    }
    
    {:ok, assign(socket, 
      current_user: user,
      stores: stores,
      analytics: analytics,
      page_title: "Admin Dashboard"
    )}
  end
  
  @impl true
  def handle_info(:update_analytics, socket) do
    # Update analytics with new data
    updated_analytics = %{
      socket.assigns.analytics |
      total_sales: socket.assigns.analytics.total_sales + Enum.random(0..100) / 100,
      total_orders: socket.assigns.analytics.total_orders + Enum.random(0..2),
      total_customers: socket.assigns.analytics.total_customers + Enum.random(0..1),
      recent_orders: generate_random_orders() ++ Enum.take(socket.assigns.analytics.recent_orders, 4),
      sales_by_day: update_daily_sales(socket.assigns.analytics.sales_by_day)
    }
    
    # Schedule next update
    Process.send_after(self(), :update_analytics, 10_000)
    
    {:noreply, assign(socket, analytics: updated_analytics)}
  end
  
  @impl true
  def handle_info({:new_order, order}, socket) do
    # Update analytics with new order data
    updated_analytics = %{
      socket.assigns.analytics |
      total_sales: socket.assigns.analytics.total_sales + order.total,
      total_orders: socket.assigns.analytics.total_orders + 1,
      recent_orders: [order | Enum.take(socket.assigns.analytics.recent_orders, 4)]
    }
    
    {:noreply, assign(socket, analytics: updated_analytics)}
  end
  
  @impl true
  def handle_event("filter-by-store", %{"store_id" => store_id}, socket) do
    # Filter analytics by store
    # In a real app, this would query the database for store-specific data
    filtered_analytics = if store_id == "all" do
      %{socket.assigns.analytics | 
        total_sales: generate_random_sales(),
        total_orders: Enum.random(50..500),
        total_customers: Enum.random(20..200)
      }
    else
      %{socket.assigns.analytics | 
        total_sales: generate_random_sales() / 2,
        total_orders: Enum.random(10..100),
        total_customers: Enum.random(5..50)
      }
    end
    
    {:noreply, assign(socket, analytics: filtered_analytics)}
  end
  
  # Helper functions to generate mock data
  defp generate_random_sales do
    Enum.random(1000..10000) / 100
  end
  
  defp generate_random_orders do
    Enum.map(1..5, fn _ ->
      %{
        id: Enum.random(1000..9999),
        customer: Enum.random(["John Doe", "Jane Smith", "Bob Johnson", "Alice Williams", "Charlie Brown"]),
        total: Enum.random(1000..50000) / 100,
        status: Enum.random(["pending", "processing", "shipped", "delivered"]),
        date: Date.add(Date.utc_today(), -Enum.random(0..10))
      }
    end)
  end
  
  defp generate_daily_sales_data do
    today = Date.utc_today()
    
    Enum.map(-6..0, fn day_offset ->
      date = Date.add(today, day_offset)
      %{
        date: date,
        amount: Enum.random(500..2000) / 100
      }
    end)
  end
  
  defp update_daily_sales(sales_data) do
    [_oldest | rest] = sales_data
    
    today = Date.utc_today()
    new_day = %{
      date: today,
      amount: List.last(sales_data).amount + Enum.random(-100..100) / 100
    }
    
    rest ++ [new_day]
  end
  
  defp generate_top_products do
    Enum.map(1..5, fn i ->
      %{
        id: i,
        name: Enum.random([
          "Premium T-shirt",
          "Designer Jeans",
          "Leather Wallet",
          "Wireless Earbuds",
          "Smartwatch",
          "Phone Case",
          "Sunglasses",
          "Backpack",
          "Running Shoes",
          "Coffee Mug"
        ]),
        sales: Enum.random(5..50),
        revenue: Enum.random(500..5000) / 100
      }
    end)
  end
  
  @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto px-4 py-8">
      <div class="mb-8">
        <h1 class="text-2xl font-bold mb-4">Dashboard</h1>
        
        <div class="flex justify-between items-center mb-6">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Filter by Store</label>
            <select phx-change="filter-by-store" class="block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md">
              <option value="all">All Stores</option>
              <%= for store <- @stores do %>
                <option value={store.id}><%= store.name %></option>
              <% end %>
            </select>
          </div>
          
          <div class="flex space-x-2">
            <button class="bg-white border border-gray-300 rounded-md shadow-sm px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              Export Report
            </button>
            <button class="bg-indigo-600 border border-transparent rounded-md shadow-sm px-4 py-2 text-sm font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              View All Reports
            </button>
          </div>
        </div>
        
        <!-- Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div class="bg-white rounded-lg shadow p-6">
            <div class="flex items-center">
              <div class="flex-shrink-0 bg-indigo-100 rounded-md p-3">
                <svg class="h-6 w-6 text-indigo-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <div class="ml-5 w-0 flex-1">
                <dl>
                  <dt class="text-sm font-medium text-gray-500 truncate">Total Sales</dt>
                  <dd>
                    <div class="text-lg font-medium text-gray-900">$<%= :erlang.float_to_binary(@analytics.total_sales, [decimals: 2]) %></div>
                  </dd>
                </dl>
              </div>
            </div>
          </div>
          
          <div class="bg-white rounded-lg shadow p-6">
            <div class="flex items-center">
              <div class="flex-shrink-0 bg-green-100 rounded-md p-3">
                <svg class="h-6 w-6 text-green-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z" />
                </svg>
              </div>
              <div class="ml-5 w-0 flex-1">
                <dl>
                  <dt class="text-sm font-medium text-gray-500 truncate">Total Orders</dt>
                  <dd>
                    <div class="text-lg font-medium text-gray-900"><%= @analytics.total_orders %></div>
                  </dd>
                </dl>
              </div>
            </div>
          </div>
          
          <div class="bg-white rounded-lg shadow p-6">
            <div class="flex items-center">
              <div class="flex-shrink-0 bg-red-100 rounded-md p-3">
                <svg class="h-6 w-6 text-red-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                </svg>
              </div>
              <div class="ml-5 w-0 flex-1">
                <dl>
                  <dt class="text-sm font-medium text-gray-500 truncate">Total Customers</dt>
                  <dd>
                    <div class="text-lg font-medium text-gray-900"><%= @analytics.total_customers %></div>
                  </dd>
                </dl>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Sales Chart -->
        <div class="bg-white rounded-lg shadow p-6 mb-8">
          <h2 class="text-lg font-medium text-gray-900 mb-4">Sales Overview</h2>
          <div class="h-64">
            <!-- In a real app, this would be a LiveView chart component -->
            <div class="h-full flex items-end space-x-2">
              <%= for day <- @analytics.sales_by_day do %>
                <% height_percent = day.amount / 20 * 100 %>
                <div class="flex flex-col items-center flex-1">
                  <div class="w-full bg-indigo-100 rounded-t" style={"height: #{height_percent}%"}></div>
                  <div class="text-xs text-gray-500 mt-1"><%= format_day_name(day.date) %></div>
                </div>
              <% end %>
            </div>
          </div>
        </div>
        
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
          <!-- Recent Orders -->
          <div class="bg-white rounded-lg shadow overflow-hidden">
            <div class="px-6 py-5 border-b border-gray-200">
              <h3 class="text-lg font-medium text-gray-900">Recent Orders</h3>
            </div>
            <div class="divide-y divide-gray-200">
              <%= for order <- @analytics.recent_orders do %>
                <div class="px-6 py-4">
                  <div class="flex items-center justify-between">
                    <div>
                      <div class="flex items-center">
                        <div class="text-sm font-medium text-gray-900">Order #<%= order.id %></div>
                        <span class={[
                          "ml-2 px-2 inline-flex text-xs leading-5 font-semibold rounded-full",
                          order_status_color(order.status)
                        ]}>
                          <%= String.capitalize(order.status) %>
                        </span>
                      </div>
                      <div class="text-sm text-gray-500"><%= order.customer %></div>
                    </div>
                    <div class="text-right">
                      <div class="text-sm font-medium text-gray-900">$<%= :erlang.float_to_binary(order.total, [decimals: 2]) %></div>
                      <div class="text-sm text-gray-500"><%= Calendar.strftime(order.date, "%b %d, %Y") %></div>
                    </div>
                  </div>
                </div>
              <% end %>
            </div>
            <div class="bg-gray-50 px-6 py-3 border-t border-gray-200">
              <div class="text-sm">
                <a href="#" class="font-medium text-indigo-600 hover:text-indigo-500">
                  View all orders <span aria-hidden="true">&rarr;</span>
                </a>
              </div>
            </div>
          </div>
          
          <!-- Top Products -->
          <div class="bg-white rounded-lg shadow overflow-hidden">
            <div class="px-6 py-5 border-b border-gray-200">
              <h3 class="text-lg font-medium text-gray-900">Top Products</h3>
            </div>
            <div class="divide-y divide-gray-200">
              <%= for product <- @analytics.top_products do %>
                <div class="px-6 py-4">
                  <div class="flex items-center justify-between">
                    <div>
                      <div class="text-sm font-medium text-gray-900"><%= product.name %></div>
                      <div class="text-sm text-gray-500"><%= product.sales %> units sold</div>
                    </div>
                    <div class="text-right">
                      <div class="text-sm font-medium text-gray-900">$<%= :erlang.float_to_binary(product.revenue, [decimals: 2]) %></div>
                    </div>
                  </div>
                </div>
              <% end %>
            </div>
            <div class="bg-gray-50 px-6 py-3 border-t border-gray-200">
              <div class="text-sm">
                <a href="#" class="font-medium text-indigo-600 hover:text-indigo-500">
                  View all products <span aria-hidden="true">&rarr;</span>
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
  
  # Helper functions for the template
  defp format_day_name(date) do
    Calendar.strftime(date, "%a")
  end
  
  defp order_status_color(status) do
    case status do
      "pending" -> "bg-yellow-100 text-yellow-800"
      "processing" -> "bg-blue-100 text-blue-800"
      "shipped" -> "bg-purple-100 text-purple-800"
      "delivered" -> "bg-green-100 text-green-800"
      _ -> "bg-gray-100 text-gray-800"
    end
  end
end

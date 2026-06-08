/**
 * LiveView Hooks for enhanced client-side functionality
 * 
 * These hooks provide JavaScript functionality that integrates with LiveView
 * for features that require client-side interactions.
 */

const Hooks = {}

/**
 * InfiniteScroll hook for loading more content when scrolling to the bottom
 */
Hooks.InfiniteScroll = {
  page() {
    return this.el.dataset.page ? parseInt(this.el.dataset.page) : 1
  },
  
  mounted() {
    this.pending = false
    this.observer = new IntersectionObserver(entries => {
      const entry = entries[0]
      if (entry.isIntersecting && !this.pending) {
        this.pending = true
        this.pushEvent("load-more", { page: this.page() + 1 })
      }
    })
    this.observer.observe(this.el)
  },
  
  updated() {
    this.pending = false
  },
  
  destroyed() {
    this.observer.disconnect()
  }
}

/**
 * DragDropProducts hook for drag-and-drop product reordering
 */
Hooks.DragDropProducts = {
  mounted() {
    const container = this.el
    
    // Initialize sortable functionality
    this.sortable = new Sortable(container, {
      animation: 150,
      ghostClass: 'bg-indigo-100',
      onEnd: event => {
        const productId = event.item.dataset.id
        const newIndex = event.newIndex
        
        this.pushEvent("reorder-product", {
          id: productId,
          position: newIndex
        })
      }
    })
  },
  
  destroyed() {
    this.sortable.destroy()
  }
}

/**
 * LiveSearch hook for real-time search results
 */
Hooks.LiveSearch = {
  mounted() {
    this.inputTimeout = null
    this.el.addEventListener("input", e => {
      clearTimeout(this.inputTimeout)
      
      // Debounce input to avoid too many requests
      this.inputTimeout = setTimeout(() => {
        const query = e.target.value
        if (query.length >= 2) {
          this.pushEvent("search", { query })
        }
      }, 300)
    })
  }
}

/**
 * ImagePreview hook for showing image previews before upload
 */
Hooks.ImagePreview = {
  mounted() {
    this.el.addEventListener("change", e => {
      const [file] = e.target.files
      if (file) {
        const preview = document.getElementById(this.el.dataset.previewTarget)
        if (preview) {
          preview.src = URL.createObjectURL(file)
          preview.classList.remove("hidden")
        }
      }
    })
  }
}

/**
 * StockCounter hook for showing real-time stock updates
 */
Hooks.StockCounter = {
  mounted() {
    this.handleEvent("stock-updated", ({ quantity }) => {
      // Update the displayed quantity
      this.el.textContent = quantity
      
      // Add visual feedback for the update
      this.el.classList.add("text-green-600", "font-bold")
      setTimeout(() => {
        this.el.classList.remove("text-green-600", "font-bold")
      }, 2000)
      
      // Show low stock warning if needed
      if (quantity <= 5) {
        this.el.classList.add("text-red-600")
        
        // Add a low stock badge if it doesn't exist
        if (!document.getElementById(`low-stock-${this.el.dataset.productId}`)) {
          const badge = document.createElement("span")
          badge.id = `low-stock-${this.el.dataset.productId}`
          badge.className = "ml-2 px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800"
          badge.textContent = "Low Stock"
          this.el.parentNode.appendChild(badge)
        }
      } else {
        this.el.classList.remove("text-red-600")
        
        // Remove low stock badge if it exists
        const badge = document.getElementById(`low-stock-${this.el.dataset.productId}`)
        if (badge) {
          badge.remove()
        }
      }
    })
  }
}

/**
 * LiveChart hook for animated charts
 */
Hooks.LiveChart = {
  mounted() {
    const ctx = this.el.getContext('2d')
    const chartType = this.el.dataset.chartType || 'line'
    const chartData = JSON.parse(this.el.dataset.chartData || '{}')
    
    this.chart = new Chart(ctx, {
      type: chartType,
      data: chartData,
      options: {
        responsive: true,
        animation: {
          duration: 1000,
          easing: 'easeOutQuart'
        }
      }
    })
    
    this.handleEvent("chart-data-updated", data => {
      // Update chart data
      this.chart.data = data
      this.chart.update()
    })
  },
  
  destroyed() {
    if (this.chart) {
      this.chart.destroy()
    }
  }
}

/**
 * AppointmentCalendar hook for interactive appointment scheduling
 */
Hooks.AppointmentCalendar = {
  mounted() {
    const calendarEl = this.el
    const events = JSON.parse(calendarEl.dataset.events || '[]')
    
    this.calendar = new FullCalendar.Calendar(calendarEl, {
      initialView: 'timeGridWeek',
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,timeGridDay'
      },
      events: events,
      selectable: true,
      select: info => {
        this.pushEvent("slot-selected", {
          start: info.startStr,
          end: info.endStr
        })
      },
      eventClick: info => {
        this.pushEvent("event-clicked", {
          id: info.event.id
        })
      }
    })
    
    this.calendar.render()
    
    this.handleEvent("calendar-updated", ({ events }) => {
      // Remove all events and add the new ones
      const currentEvents = this.calendar.getEvents()
      currentEvents.forEach(event => event.remove())
      
      events.forEach(event => {
        this.calendar.addEvent(event)
      })
    })
  },
  
  destroyed() {
    if (this.calendar) {
      this.calendar.destroy()
    }
  }
}

/**
 * ActiveShoppers hook for showing real-time shopper counts
 */
Hooks.ActiveShoppers = {
  mounted() {
    this.handleEvent("presence-updated", ({ count }) => {
      this.el.textContent = count
      
      // Add animation for changes
      this.el.classList.add("scale-110", "text-indigo-600")
      setTimeout(() => {
        this.el.classList.remove("scale-110", "text-indigo-600")
      }, 1000)
    })
  }
}

export default Hooks

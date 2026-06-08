# Dukkadee Frontend Guidelines

## Overview

This document outlines the frontend architecture, components, and best practices for the Dukkadee e-commerce platform. The frontend is built using Phoenix LiveView with Tailwind CSS and shadcn UI components, providing a real-time, interactive user experience.

## LiveView Features

### Real-time Store Creation Flow
- Multi-step form with real-time validation
- Live preview of store as changes are made
- URL availability checker in real-time
  
### Product Management
- Drag-and-drop product organization
- Live image upload with progress indicators
- Dynamic variant management without page reload
  
### Appointment Scheduling
- Real-time availability calendar
- Slot reservation with double-booking prevention
- Push notifications for appointments
  
### Admin Dashboard
- Live analytics for sales and traffic
- Real-time inventory alerts
- Order status tracking
  
### Shopping Experience
- Live cart updates across devices
- Real-time stock indicators
- Flash sales with countdown timers
  
### Search and Filtering
- Live search results as user types
- Dynamic filtering without page reloads
- Instant product re-ordering

### LiveView Components
- Reusable UI components (product cards, reviews, cart, notifications)
- LiveView uploads for efficient file handling
- JS interoperability for enhanced UX
  
### Multi-user Features
- PubSub for real-time updates across users
- Presence tracking for active shoppers
- Collaborative shopping features
  
### Performance Optimizations
- Temporary assigns for large datasets
- Stream for efficient list updates
- Pagination for handling large product catalogs

## UI Component Library

### Shadcn UI Integration

The Dukkadee platform uses shadcn UI components adapted for Phoenix LiveView:

1. **Component Adaptation**
   - Tailwind CSS classes from shadcn components
   - LiveView-compatible event handling
   - Accessibility features preserved

2. **Core Components**
   - Buttons and form elements
   - Cards and containers
   - Navigation components
   - Modals and dialogs
   - Tables and data display

3. **Custom Components**
   - Product cards
   - Store templates
   - Appointment calendar
   - Checkout flow
   - Admin dashboard widgets

## CSS Architecture

### Tailwind Implementation

1. **Configuration**
   - Custom color palette based on Dukkadee branding
   - Extended theme for e-commerce specific components
   - Responsive breakpoints for all device sizes

2. **Organization**
   - Component-specific styles
   - Utility-first approach
   - Minimal custom CSS

3. **Best Practices**
   - Consistent naming conventions
   - Mobile-first responsive design
   - Dark mode support
   - Accessibility compliance

## JavaScript Interoperability

### LiveView Hooks

1. **Core Hooks**
   - Drag and drop functionality
   - Chart rendering
   - Advanced form validation
   - Animation controllers

2. **Third-party Integrations**
   - Payment processors
   - Map components
   - Rich text editors
   - Analytics trackers

3. **Implementation Pattern**
   ```javascript
   // assets/js/hooks.js
   const Hooks = {
     DragDrop: {
       mounted() {
         // Initialize drag and drop
       },
       updated() {
         // Update when data changes
       }
     },
     // Other hooks
   }
   ```

## Responsive Design

### Breakpoint Strategy

- **Mobile**: < 640px
- **Tablet**: 640px - 1024px
- **Desktop**: 1024px - 1280px
- **Large Desktop**: > 1280px

### Implementation

```html
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
  <!-- Responsive grid content -->
</div>
```

## Accessibility Standards

1. **WCAG 2.1 AA Compliance**
   - Proper heading structure
   - Sufficient color contrast
   - Keyboard navigation
   - Screen reader compatibility

2. **Implementation**
   - Semantic HTML
   - ARIA attributes where necessary
   - Focus management
   - Skip navigation links

## Performance Optimization

1. **Asset Optimization**
   - CSS purging with Tailwind
   - JavaScript code splitting
   - Image optimization and lazy loading
   - Font loading strategy

2. **LiveView Specific**
   - Minimal DOM updates
   - Efficient event handling
   - Proper use of temporary assigns
   - Strategic use of phx-update

## Store Themes

### Theme Structure

1. **Base Theme**
   - Core layout and components
   - Default styling
   - Common functionality

2. **Industry-specific Themes**
   - Clothing store
   - Electronics store
   - Service business (dentist, salon, etc.)
   - Digital products

3. **Theme Components**
   - Color schemes
   - Typography
   - Layout variations
   - Component styling

### Theme Customization

1. **Store Owner Controls**
   - Color picker
   - Font selector
   - Layout options
   - Component visibility toggles

2. **Implementation**
   ```elixir
   # Theme configuration in LiveView
   def mount(_params, _session, socket) do
     {:ok, assign(socket, 
       theme: get_store_theme(store_id),
       color_scheme: get_color_scheme(store_id)
     )}
   end
   ```

## Testing Frontend Components

1. **Unit Testing**
   - Component rendering
   - Event handling
   - State management

2. **Integration Testing**
   - User flows
   - Form submissions
   - Real-time updates

3. **Visual Regression Testing**
   - Component appearance
   - Responsive layouts
   - Theme variations

## Development Workflow

1. **Component Development**
   - Create component in isolation
   - Test functionality
   - Document usage
   - Integrate with LiveView

2. **LiveView Development**
   - Define mount and handle_params
   - Implement event handlers
   - Optimize renders
   - Add JavaScript hooks if needed

3. **Best Practices**
   - Consistent naming conventions
   - Component documentation
   - Code reviews
   - Performance benchmarking

## Resources

- [Phoenix LiveView Documentation](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [Shadcn UI Components](https://ui.shadcn.com/)
- [WCAG 2.1 Guidelines](https://www.w3.org/TR/WCAG21/)

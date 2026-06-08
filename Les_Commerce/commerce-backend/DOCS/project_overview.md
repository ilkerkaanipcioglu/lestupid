# Deecommerce Project Overview

Last updated: March 2, 2025

## 1. Platform Overview

Deecommerce is a dual-purpose e-commerce platform that serves as both:
1. A store creation application that enables merchants to quickly establish their online presence
2. The host for the Dukkadee global marketplace that aggregates products from individual stores

The platform is built using Elixir, Phoenix with LiveView, and shadcn UI components. It allows users to quickly open their own online stores with optional integration to the Dukkadee marketplace and support for custom domains.

## 2. Store Ownership and Access Model

### Store Ownership
- Each store on the Deecommerce platform is **independently owned** by different merchants/store owners
- Store owners maintain **full access and control** over their individual stores
- Store owners have complete autonomy over their store's:
  - Products and inventory
  - Pricing and promotions
  - Store design and branding
  - Customer data
  - Order fulfillment processes
  - Payment processing options

### Marketplace Integration
- Store owners can **optionally** list their products on the Dukkadee global marketplace
- Participation in the marketplace is **not mandatory** for store owners
- Store owners can select which products to list on the marketplace and which to keep exclusive to their store
- Marketplace listings provide additional visibility and sales opportunities
- Store owners maintain control over their marketplace listings and can remove them at any time

## 3. Hosting Options

Deecommerce provides flexible hosting options to accommodate different merchant needs:

### Deecommerce-Hosted Solution (Default)
- Stores are hosted on Deecommerce's infrastructure
- Fully managed hosting with automatic updates and maintenance
- Integrated with all Deecommerce platform features
- Custom domain support (e.g., yourstore.com or store.dukkadee.com)
- Simplified setup process with minimal technical requirements
- Includes security, backups, and performance optimization

### Self-Hosted Solution
- Store owners can host their store on their own servers/infrastructure
- Full control over hosting environment and server configuration
- API-based integration with the Dukkadee marketplace (optional)
- Synchronization mechanisms for inventory and orders
- Support for various deployment options:
  - Docker containers
  - Traditional web hosting
  - Cloud platforms (AWS, Azure, GCP, etc.)
- Technical documentation and deployment guides provided

## 4. Data Ownership and Privacy

- Store owners **own all their store data**
- Customer data belongs to the respective store owner, not Deecommerce
- Deecommerce acts as a data processor, not a data controller for store-specific data
- Clear data segregation between stores to ensure privacy and security
- Data portability allows store owners to export their data at any time

## 5. Technical Architecture

### Initial Implementation Approach
- **Direct In-App Architecture** for Deecommerce-hosted solution
  - All store functionality within the same Elixir/Phoenix application
  - Phoenix contexts for logical separation of concerns
  - Elixir processes and PubSub for real-time features
  - Maximum performance with no network overhead
  - Shared resources and database connections
  - Faster response times compared to API-based approaches

### API-First Approach (Developed in Parallel)
- RESTful and GraphQL APIs for all core functionality
- APIs primarily used for:
  - Self-hosted store integration
  - Third-party integrations
  - Mobile applications
  - Not for internal communication between components in hosted solution
- Webhook system for real-time event notifications
- Authentication and authorization system with store-specific access controls

### Synchronization Mechanisms
- Real-time or scheduled synchronization between self-hosted stores and the Dukkadee marketplace
- Conflict resolution strategies for inventory and pricing updates
- Offline capabilities with reconciliation upon reconnection

### Security Considerations
- End-to-end encryption for data in transit
- Role-based access control for store management
- API key management and rotation
- Regular security audits and penetration testing

## 6. Technical Stack

- **Backend**: Elixir, Phoenix, Phoenix LiveView
- **Frontend**: shadcn UI components, Tailwind CSS
- **Database**: PostgreSQL (via Ecto)
- **Deployment**: TBD

## 7. Project Structure

- Contexts:
  - Accounts: User management
  - Stores: Store configuration and management
  - Products: Product listings and variants
  - Appointments: Scheduling and booking
  - StoreImporter: Legacy store import and redesign
  - Pages: Static page content management
  - Marketplace: Dukkadee global listing and search functionality

## 8. Key Features

### Core Features
- User registration and authentication
- Store creation and management
- Product management with variants
- Appointment scheduling
- Order processing
- Payment integration

### Store Ownership and Hosting Model
- **Independent Store Ownership**
  - Each store is fully owned and controlled by individual merchants
  - Store owners have complete access to all aspects of their store
  - Store owners maintain ownership of all their customer and product data
  
- **Flexible Hosting Options**
  - Deecommerce-hosted solution (default)
    - Fully managed hosting on our infrastructure
    - Automatic updates and maintenance
    - Integrated with all platform features
    
  - Self-hosted solution
    - Merchants can host their store on their own servers
    - Full control over hosting environment
    - API-based integration with the Dukkadee marketplace
    
- **Marketplace Integration**
  - Optional listing of products on the Dukkadee marketplace
  - Store owners decide which products to list on the marketplace
  - Synchronization between self-hosted stores and the marketplace

### Import Features
- Instagram product import
- Legacy store import and redesign
  - Extract products, pages, and content from existing stores
  - Apply modern design with brand colors
  - Automatic creation of static pages and forms

### LiveView Features
- **Real-time Store Creation Flow**
  - Multi-step form with real-time validation
  - Live preview of store as changes are made
  - URL availability checker in real-time
  
- **Product Management**
  - Drag-and-drop product organization
  - Live image upload with progress indicators
  - Dynamic variant management without page reload
  
- **Appointment Scheduling**
  - Real-time availability calendar
  - Slot reservation with double-booking prevention
  - Push notifications for appointments
  
- **Admin Dashboard**
  - Live analytics for sales and traffic
  - Real-time inventory alerts
  - Order status tracking
  
- **Shopping Experience**
  - Live cart updates across devices
  - Real-time stock indicators
  - Flash sales with countdown timers
  
- **Search and Filtering**
  - Live search results as user types
  - Dynamic filtering without page reloads
  - Instant product re-ordering
  
- **LiveView Components**
  - Reusable UI components (product cards, reviews, cart, notifications)
  - LiveView uploads for efficient file handling
  - JS interoperability for enhanced UX
  
- **Multi-user Features**
  - PubSub for real-time updates across users
  - Presence tracking for active shoppers
  - Collaborative shopping features
  
- **Performance Optimizations**
  - Temporary assigns for large datasets
  - Stream for efficient list updates
  - Pagination for handling large product catalogs

## 9. Implementation Priorities

1. Core platform with Deecommerce-hosted solution
2. Dukkadee marketplace integration for hosted stores
3. API development for external integration
4. Self-hosting capabilities and documentation
5. Advanced synchronization features

## 10. Future Extensibility

- Headless commerce capabilities
- Integration with third-party e-commerce platforms
- Mobile app support
- Advanced analytics and reporting
- AI-powered recommendations and personalization

## 11. Documentation

### Project Documentation
- [Project Status](project_status.md): Current development status and task tracking
- [Documentation Structure](documentation_structure.md): Guidelines for documentation
- [API Documentation](api/README.md): API endpoints and usage
- [Database Schema](database/schema.md): Database tables and relationships

### Technical References
- [Phoenix Guides](phoenix_guides/index.md): Local copies of Phoenix Framework guides
- [External Documentation References](documentation_structure.md#external-documentation-references): Links to official documentation

This document will be continuously updated throughout the project development process.

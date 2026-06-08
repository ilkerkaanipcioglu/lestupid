# Dukkadee.com Project Tracker

Last updated: March 2, 2025
ALWAYS UPDATE DOCS/development_rules.md if there is a rule changed and read it when needed time to time 
## Project Overview
Building a Shopify-like e-commerce platform using Elixir, Phoenix with LiveView, and shadcn UI components. The platform will allow users to quickly open their own online stores with a global marketplace and support for custom domains. Each store is independently owned and operated by different merchants who maintain full control over their stores. Merchants can choose to host their stores on Dukkadee's infrastructure or on their own servers while still having the option to list their products on our global marketplace.

## 🚀 Current Status
- [x] Project requirements reviewed
- [x] Reviewed wireframe design
- [x] Reviewed example code snippets
- [x] Project initialization
- [x] Core data models created
- [x] Database migrations created
- [x] Basic web structure set up
- [ ] UI implementation
- [ ] Testing
- [ ] Deployment

## 📋 Completed Tasks
- Reviewed development requirements and project structure
- Analyzed example code schemas for Users, Stores, Products, Variants, Appointments, and Pages
- Reviewed project wireframe design
- Created core data models and contexts:
  - Users and authentication
  - Stores with dual hosting options
  - Products and variants
  - Appointments
  - Pages for CMS functionality
- Set up database migrations
- Created web structure with router and endpoint configuration
- Implemented store domain handling
- Created LiveView for store creation flow
- Created setup scripts and documentation
- Implemented UI prototype for legacy store import feature
- Added import summary display in store creation flow

## 🔄 In Progress
- UI implementation with Tailwind and shadcn components
- LiveView templates for key pages
- Creating project structure and plan
- Setting up initial Phoenix project
- Implementing legacy store importer backend functionality

## 📅 Upcoming Tasks
- Initialize Phoenix project with LiveView
- Set up custom domain routing
- Build appointment scheduling feature
- Create admin panel
- Implement static pages/CMS functionality
- Set up testing and deployment

## 🏗️ Technical Stack
- **Backend**: Elixir, Phoenix, Phoenix LiveView
- **Frontend**: shadcn UI components, Tailwind CSS
- **Database**: PostgreSQL (via Ecto)
- **Deployment**: TBD

## 🔄 Technology Roadmap
- **Current Phase**: Developing with Elixir and Phoenix for all functionality
- **Future Compatibility**: Planning for integration with other technologies:
    for stores not for our marketpace or main functualities 
  - Next.js for headless frontend
  - Medusa.js for alternative e-commerce backend
  - Vendure for enterprise-level stores
  - PHP-based solutions for legacy compatibility
- **API Strategy**: Building with future extensibility in mind

## 📚 Key Features to Implement
1. **Store Creation**
   - Quick 1-minute store setup
   - Instagram profile import
   - Template/theme selection
   - Hosting options:
     - Dukkadee.com managed hosting (default)
     - Self-hosting option for users with their own servers

2. **Marketplace**
   - Global product listing
   - Basic search and filtering
   - Store links

3. **Custom Store Domains**
   - Individual store pages
   - Appointment scheduling
   - Static pages with CMS capabilities
   - Admin panel

## 🔍 Technical Considerations
- Investigate integration of shadcn UI with Phoenix LiveView
- Determine optimal approach for multi-tenancy and custom domains
- Design efficient database schema for the various contexts
- Plan for scalability and performance
- Implement dual hosting architecture:
  - Centralized hosting on Dukkadee.com servers
  - Deployment tools for self-hosting users
  - Synchronization mechanisms for self-hosted stores with marketplace

## 🧩 Project Structure
- Contexts:
  - Accounts: User management
  - Stores: Store configuration and management
  - Products: Product listings and variants
  - Appointments: Scheduling and booking
  - StoreImporter: Legacy store import and redesign
  - Pages: Static page content management
  - Marketplace: Global listing and search functionality

## 📋 Features

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
  - Dukkadee-hosted solution (default)
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

## 🛠️ Development Rules

### General Development Guidelines
- Follow Elixir style guide and best practices
- Use contexts to organize related functionality
- Write tests for all new features
- Document all public functions with @doc and @moduledoc
- Keep LiveView components small and focused
- Use proper error handling and validation

### Feature-Specific Guidelines

#### Legacy Store Import Feature
- Always validate URLs before attempting to scrape
- Respect robots.txt and implement rate limiting for scraping
- Extract brand colors from CSS and design elements
- Preserve all original content while applying modern design
- Automatically create redirects from old URLs to new ones
- Implement progress tracking for long-running import jobs
- Handle errors gracefully with user-friendly messages
- Provide detailed import reports
- Allow manual adjustments after automatic import

This document will be continuously updated throughout the project development process.

# Dukkadee Platform Specifications

## Platform Overview

Dukkadee is a dual-purpose e-commerce platform that serves as both:
1. A store creation application that enables merchants to quickly establish their online presence
2. A global marketplace that aggregates products from individual stores

## Store Ownership and Access Model

### Store Ownership
- Each store on the Dukkadee platform is **independently owned** by different merchants/store owners
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

## Hosting Options

Dukkadee provides flexible hosting options to accommodate different merchant needs:

### 1. Dukkadee-Hosted Solution (Default)
- Stores are hosted on Dukkadee's infrastructure
- Fully managed hosting with automatic updates and maintenance
- Integrated with all Dukkadee platform features
- Custom domain support (e.g., yourstore.com or store.dukkadee.com)
- Simplified setup process with minimal technical requirements
- Includes security, backups, and performance optimization

### 2. Self-Hosted Solution
- Store owners can host their store on their own servers/infrastructure
- Full control over hosting environment and server configuration
- API-based integration with the Dukkadee marketplace (optional)
- Synchronization mechanisms for inventory and orders
- Support for various deployment options:
  - Docker containers
  - Traditional web hosting
  - Cloud platforms (AWS, Azure, GCP, etc.)
- Technical documentation and deployment guides provided

## Data Ownership and Privacy

- Store owners **own all their store data**
- Customer data belongs to the respective store owner, not Dukkadee
- Dukkadee acts as a data processor, not a data controller for store-specific data
- Clear data segregation between stores to ensure privacy and security
- Data portability allows store owners to export their data at any time

## Technical Architecture for Dual Hosting

### API-First Approach
- RESTful and GraphQL APIs for all core functionality
- Webhook system for real-time event notifications
- Authentication and authorization system with store-specific access controls

### Synchronization Mechanisms
- Real-time or scheduled synchronization between self-hosted stores and the marketplace
- Conflict resolution strategies for inventory and pricing updates
- Offline capabilities with reconciliation upon reconnection

### Security Considerations
- End-to-end encryption for data in transit
- Role-based access control for store management
- API key management and rotation
- Regular security audits and penetration testing

## Implementation Priorities

1. Core platform with Dukkadee-hosted solution
2. Marketplace integration for hosted stores
3. API development for external integration
4. Self-hosting capabilities and documentation
5. Advanced synchronization features

## Future Extensibility

- Headless commerce capabilities
- Integration with third-party e-commerce platforms
- Mobile app support
- Advanced analytics and reporting
- AI-powered recommendations and personalization


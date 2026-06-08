# Africa Ecommerce (Dukkadee) Development Standards

This document provides comprehensive development standards and guidelines for the Africa Ecommerce project (Dukkadee). It consolidates information from various existing documents to create a single source of truth for developers.

## Project Overview

Dukkadee.com is a platform where users can quickly open their own online store (similar to Shopify). It features a global Marketplace and supports custom store domains.

### Key Pages/Endpoints

1. **dukkadee.com/open_new_store**
   - Allows new merchants to create a store in 1 minute
   - Products can be easily imported from an Instagram profile
   - Provides different templates/themes
   - Leverages design editor for easy store creation

2. **dukkadee.com/marketplace**
   - A global marketplace showing products from all dukkadee.com stores
   - Products listed by store, with links to individual store pages
   - Basic search and filtering across all stores/products

3. **mystore.com** (custom store domain)
   - Individual merchant store with product listings, advanced filters, and search
   - Appointment scheduling feature for applicable products
   - Static pages with CMS-like editing capability
   - Admin Panel for store owners

## Technical Requirements

1. **Core Technologies**
   - Elixir & Phoenix LiveView for real-time interactivity
   - Tailwind CSS for styling
   - Proper UI component integration

2. **Data Models/Contexts**
   - **Accounts**: User/Merchant
   - **Stores**: Store settings, themes, domains
   - **Products**: Products with variants, images, descriptions
   - **Appointments**: Scheduling for applicable products
   - **Marketplace**: Global product listings

3. **Features**
   - Instagram Import
   - Templates/Themes
   - Appointment Scheduling
   - Advanced Search & Filters
   - CMS/Live Edit for static pages
   - Admin Panel

4. **Future Modules** (planned for later implementation)
   - **CRM**: Customer relationship management
   - **ERP**: Enterprise resource planning

## Development Guidelines

### Project Organization
- Respect Phoenix context boundaries
- Follow Phoenix 1.7 directory structure conventions
- Place LiveView files in appropriate directories
- Use consistent naming patterns for modules and files
- Maintain explicit boundaries between contexts
- Design database schemas with future modules in mind

### Elixir Coding Standards
- Follow Elixir style guide and conventions
- Use appropriate module documentation
- Keep functions small and focused
- Use pattern matching effectively
- Handle errors with appropriate return tuples
- Follow pipeline style when applicable
- Prefer immutability and functional approaches
- Name functions to reflect business purpose, not implementation details

### Phoenix LiveView Guidelines
- Use LiveView hooks appropriately
- Implement proper event handling
- Optimize rendering performance
- Minimize stateful operations
- Use components for reusable UI elements
- Apply proper form validation
- Handle LiveView lifecycle events correctly
- Use PubSub for real-time features
- Implement proper error boundaries

### Database Practices
- Follow Ecto schema conventions
- Use migrations properly
- Define appropriate associations
- Implement validations at the schema level
- Use Ecto queries efficiently
- Handle database errors gracefully
- Preload related data to avoid N+1 query problems
- Create appropriate database indexes for performance
- Create extensible schema designs to accommodate future modules

### Testing Standards
- Write comprehensive unit tests for context functions
- Test LiveView interactions with LiveViewTest
- Cover critical business logic
- Test context functions and boundary operations
- Verify form validations
- Mock external services appropriately
- Aim for high test coverage on core features (>80%)
- Test cross-context workflows with integration tests

### Security Standards
- Validate and sanitize all user inputs
- Protect sensitive data (API keys, credentials)
- Implement proper authentication
- Use secure route protection
- Apply CSRF protection
- Follow secure coding practices
- Regular security audits
- Proper error handling that doesn't leak sensitive information
- Design authorization system to support future role-based access

### Performance Optimization
- Optimize database queries
- Keep LiveView performance efficient
- Minimize unnecessary renders
- Use proper state management
- Optimize asset loading
- Apply pagination for large datasets
- Follow direct in-app architecture for maximum performance
- Response time targets: page loads < 500ms, API < 100ms, real-time < 50ms

### Multi-Store Approach
- Maintain proper store isolation
- Use appropriate customer authentication
- Apply store-specific branding
- Handle custom domains correctly
- Ensure secure store data access
- Design database schemas with store_id as a fundamental relationship
- Store customization through component composition

## Brand Guidelines

- Use defined brand colors for our app (#fddb24, #b7acd4, #272727) but store owners can choose any brad colours for their store 
- Apply consistent UI components
- Follow accessibility guidelines
- Maintain responsive design principles
- Store brand colors as database fields for dynamic application

## User Interface Guidelines

- Maintain accessibility features
- Adapt components for LiveView compatibility
- Preserve component styling conventions
- Use Tailwind utility classes consistently
- Follow mobile-first responsive design approach
- Ensure proper store feature discoverability
- Maintain consistent store navigation
- Implement intuitive store creation process

## Implementation Planning

1. **Project Setup**
   - Create Phoenix project with LiveView
   - Integrate Tailwind CSS
   - Configure routes

2. **Core Functionality**
   - Implement user authentication
   - Build store creation flow
   - Develop marketplace listing
   - Create store front functionality
   - Build appointment scheduling system

3. **Admin and CMS**
   - Develop admin panel
   - Implement CMS for static pages
   - Create store settings management

4. **Integrations**
   - Add Instagram import
   - Implement domain management
   - Legacy store import functionality

5. **Future Modules** (Phase 2)
   - **CRM Module**
     - Customer management
     - Communication history
     - Sales pipeline tracking
     - Customer segmentation
   - **ERP Module**
     - Inventory management
     - Supply chain tracking
     - Financial reporting
     - Procurement management

## Architecture Considerations for Future Modules

To ensure the project structure can accommodate future CRM and ERP modules:

1. **Context Boundaries**
   - Implement clear boundaries between contexts
   - Avoid circular dependencies between contexts
   - Use PubSub for cross-context communication

2. **Database Design**
   - Include foreign keys that will link to future entities
   - Use schema versioning for future migrations
   - Create extensible schemas for customer data

3. **API Endpoints**
   - Design RESTful API endpoints with versioning
   - Follow consistent URL patterns
   - Implement proper authentication/authorization checks

4. **User Interface**
   - Design the navigation structure to accommodate new modules
   - Create a consistent layout system
   - Implement a plugin system for UI components

## Deployment

- Configure for multiple custom domains
- Set up CI/CD pipeline
- Implement monitoring and logging
- Develop backup and recovery strategies 
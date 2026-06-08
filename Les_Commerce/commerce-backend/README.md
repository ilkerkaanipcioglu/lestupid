# Deecommerce E-commerce Platform

## Overview
Deecommerce is a powerful e-commerce platform that allows merchants to quickly create online stores in under 1 minute, similar to Shopify. The platform includes the Dukkadee global marketplace and supports both Deecommerce-hosted and self-hosted store options with custom domains. Each store on the platform is independently owned and fully controlled by individual merchants.

## Key Features
- Quick store creation (under 1 minute)
- Instagram product import
- Legacy store import and redesign
- Customizable store templates/themes
- Dukkadee global marketplace with optional product listing
- Custom domains for individual stores
- Appointment scheduling for service-based products
- Independent store ownership with full merchant control
- Flexible hosting options (Deecommerce-hosted or self-hosted)

## Technology Stack
- Elixir/Phoenix (with LiveView for real-time features)
- Tailwind CSS with Shadcn UI components
- PostgreSQL database

## Documentation

All project documentation is available in the `DOCS` directory:

- [Project Overview](DOCS/project_overview.md) - Comprehensive overview of the platform, features, and current status
- [Development Rules](DOCS/development_rules.md) - Detailed project requirements and implementation guidelines
- [Technology Roadmap](DOCS/technology_roadmap.md) - Future technology plans and API strategy
- [Technical Architecture](DOCS/technical_architecture.md) - Detailed architecture design and implementation approach
- [Legacy Store Import](DOCS/legacy_store_import.md) - Specific documentation for the store import feature
- [Documentation Structure](DOCS/documentation_structure.md) - Guide to our documentation organization

## Installation and Setup

### Prerequisites
- Elixir 1.14 or later
- Phoenix Framework 1.7.7
- PostgreSQL 14 or later
- Node.js 16 or later

### Setup Instructions

#### Method 1: Using the Setup Script
1. Install Elixir from [https://elixir-lang.org/install.html](https://elixir-lang.org/install.html)
2. Run the setup script:
   ```
   .\setup.ps1
   ```
3. Start the Phoenix server:
   ```
   mix phx.server
   ```
4. Visit [http://localhost:4000](http://localhost:4000) in your browser

#### Method 2: Manual Setup
1. Install Elixir from [https://elixir-lang.org/install.html](https://elixir-lang.org/install.html)
2. Install Hex package manager:
   ```
   mix local.hex --force
   ```
3. Install Phoenix:
   ```
   mix archive.install hex phx_new 1.7.7 --force
   ```
4. Install dependencies:
   ```
   mix deps.get
   ```
5. Create and migrate the database:
   ```
   mix ecto.create
   mix ecto.migrate
   ```
6. Install Node.js dependencies:
   ```
   cd assets
   npm install
   cd ..
   ```
7. Start the Phoenix server:
   ```
   mix phx.server
   ```
8. Visit [http://localhost:4000](http://localhost:4000) in your browser

## License
This project is proprietary and not licensed for public use.

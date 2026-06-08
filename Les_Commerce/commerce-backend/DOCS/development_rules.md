# Dukkadee.com Project Prompt

**Goal**: Build a Shopify-like e-commerce web application using Elixir, Phoenix (potentially with LiveView), and [shadcn](https://shadcn.com) UI components, leveraging **Windsurf Editor by Codeium** to streamline the development process.

please get documents from DOCS folder and example code from docs/example   
if needed search docs from 
https://hexdocs.pm/phoenix/overview.html
if you think I should use better technology like for example if you think I should not use shadcn please offer me your suggestion. 



---

## 1. High-Level Description

We want a platform named **dukkadee.com** where users can quickly open their own online store (like Shopify). It will also have a global **Marketplace** and support custom store domains (e.g., **mystore.com**).

### Key Pages/Endpoints

1. **dukkadee.com/open_new_store**
   - Allows new merchants to create a store in 1 minute.
   - Products can be easily imported from an Instagram profile.
   - Provide different templates/themes (e.g., clothing store, electronics store, dentist, tattoo salon, barber salon, tattoo removal salon, etc.).
   - Leverage an internal or external design editor (Windsurf Editor) for easy store creation.
   look at dukkadee-wireframe.svg for understanding 

2. **dukkadee.com/marketplace**
   - A global marketplace showing products from all dukkadee.com stores.
   - Products are listed by store, with links to individual store pages.
   - Basic search and filtering across all stores/products.
   look at dukkadee-wireframe.svg for understanding 

3. **mystore.com** (example of a custom store domain)
   - A merchant’s individual store with product listings, advanced filters, and a search bar.
   - Some products can have an **appointment scheduling** feature (e.g., doctor appointment, tattoo appointment). Customers can pick a date/time slot during checkout.
   - Supports static pages (About, Contact, etc.) with CMS-like or live editing capability.
   - An **Admin Panel** (for store owners) to manage products, appointments, and content.

---

## 2. Technical Requirements

1. **Elixir & Phoenix**  
   - Decide whether to use standard Phoenix controllers/templates or Phoenix LiveView for real-time interactivity.  
   - If using **Phoenix LiveView**:
     - Real-time product listing updates, appointment availability, and store design previews.
   - All main functionality must be developed using Elixir and Phoenix.
   - Design with future extensibility in mind for potential integration with other technologies.

2. **Shadcn UI Components**  
   - Shadcn provides a library of accessible and well-structured components (usually React + Tailwind-based).  
   - Investigate how to integrate Shadcn or similar Tailwind-based components within a Phoenix or Phoenix LiveView context. Potentially adapt the components or incorporate them via a Phoenix + React or LiveView + Tailwind workflow.

3. **Data Models / Contexts**  
   - **User / Merchant**: store owners, can manage store settings, products, and appointments.  
   - **Store**: belongs to a merchant, has themes/templates, domain (mystore.com).  
   - **Product**: belongs to a store, can have multiple variants, images, descriptions.  
   - **Appointment**: belongs to a product that requires scheduling, includes date/time, booking info, user info.  
   - **Marketplace**: queries products from all stores for listing.

4. **Features**  
   - **Instagram Import**: Connect with Instagram’s API to fetch product images/captions for quick product creation.  
   - **Templates/Themes**: Provide store layout presets (e.g., clothing, electronics, dentist, etc.) to be chosen at store creation.  
   - **Appointments**: A scheduling calendar (possibly using a 3rd party or custom solution) with time slots, integrated into the checkout flow.  
   - **Filters & Search**: Full-text search on product names, descriptions, categories, plus filters for price, category, etc.  
   - **CMS or Live Edit**: For static pages (About, Forms, Contact). Possibly store data in a “pages” table with an editor UI.  
   - **Admin Panel**: For each store. Manage inventory, appointments, store settings, domain settings, etc.

5. **Architecture**  
   - **Option A**: Single Phoenix app with multiple contexts (marketplace, store creation, store front, etc.).  
   - **Option B**: Phoenix umbrella project with separate apps for core logic, store front, and marketplace.  
   - Use **Ecto** for database interactions, **Phoenix Contexts** for domain separation.

6. **Deployment**  
   - The platform must handle multiple custom domains (e.g., mystore.com) mapped to each store.  
   - Possibly use a multi-tenant approach or dynamic host-based routing in Phoenix.

7. **Future Technology Compatibility**
    - While current development is exclusively with Elixir and Phoenix, design the system with future extensibility in mind.
    - Plan for potential integration with:
      - Next.js for headless frontend options
      - Medusa.js as an alternative e-commerce backend
      - Vendure for enterprise-level store capabilities
      - PHP-based solutions for legacy compatibility
    - Design APIs and data structures that can be consumed by multiple frontend technologies.
    - Consider eventual microservices architecture for specific components.
    - Document integration points for future technology adoption.

---

## 3. Implementation Outline

1. **Project Setup**  
   - Create a new Phoenix project (with or without LiveView).  
   - Integrate Tailwind CSS (if not already included).  
   - Investigate or adapt Shadcn UI components to Phoenix templates or LiveView components.  
   - Configure routes for:
     - `/open_new_store`
     - `/marketplace`
     - `/:store_slug` or handle custom domains via host-based routing.

2. **Contexts & Schemas**  
   - **Accounts** context:
     - `User` schema for merchants/admins.  
   - **Stores** context:
     - `Store` schema with `user_id` reference.  
     - `Theme` or `Template` schema for store layout.  
   - **Products** context:
     - `Product` schema with references to `Store`.  
     - Possibly `Variant` schema for product variations.  
   - **Appointments** context:
     - `Appointment` schema referencing `Product` and a time slot.  
   - **StoreImporter** context:
     - `LegacyStoreImporter` module for importing existing stores.
     - `ImportJob` schema to track import progress.
     - `ImportReport` schema to store import results.

3. **Store Creation Flow**  
   - A form to capture store name, domain preference, template selection.  
   - Optionally import images from Instagram via an OAuth integration or an Instagram Basic Display API.  
   - Generate initial products from fetched Instagram data (images/captions).
   - Import and redesign legacy stores by providing the store URL.
   - Extract products, pages, and brand colors from legacy stores.
   - Automatically create modern design while preserving content.

4. **Marketplace**  
   - Simple product listing at `/marketplace` with optional category filters, search.  
   - Link to each product’s store page or the store’s main page.

5. **Store Front**  
   - Route domain or subdomain to a store layout.  
   - Display products, categories, advanced filters.  
   - **Appointment-based products**: Show date/time picker at checkout.

6. **Admin Panel**  
   - Manage store settings, products, appointment schedules.  
   - Possibly use Phoenix LiveView for real-time updates.  
   - Provide a CMS-like editor for static pages (About, FAQ, etc.).

7. **Styling & Components**  
   - Use Tailwind + Shadcn components for consistent UI/UX.  
   - Provide a design system approach for store owners to pick color schemes, fonts, layouts.

8. **Testing**  
   - Use Phoenix’s built-in testing framework (ExUnit).  
   - Ensure integration tests for store creation, product listing, appointment booking, etc.

---

## 4. Step-by-Step Prompt Usage in Windsurf Editor

1. **Initialize Phoenix Project**  
   - Command:  
     ```bash
     mix phx.new dukkadee --live
     cd dukkadee
     mix ecto.create
     ```
   - Open the project in **Windsurf Editor by Codeium**.

2. **Configure Tailwind & Shadcn**  
   - If not already set, install Tailwind.  
   - Adapt or copy shadcn UI components.  
   - Create a plan for bridging React-based or HTML-based components into Phoenix templates.

3. **Create Contexts & Schemas**  
   - **In Windsurf Editor**, prompt Codeium to generate Ecto schemas for `User`, `Store`, `Product`, `Appointment`.  
   - Example prompt snippet:
     ```
     Please generate an Ecto schema for the `Store` context with fields:
     - name : string
     - domain : string
     - user_id : references(:users)
     - theme_id : references(:themes)
     ...
     ```

4. **Store Creation Flow**  
   - In **Windsurf Editor**, create a LiveView or Controller for `/open_new_store`.  
   - Prompt Codeium to integrate a step-by-step form (store info, template selection, Instagram import).

5. **Marketplace**  
   - Create a page `/marketplace` that lists all products.  
   - Prompt Codeium to build a search/filter system using Ecto queries.

6. **Custom Domain Routing**  
   - Configure `endpoint.ex` or a custom plug to handle `mystore.com` requests.  
   - Prompt Codeium with:  
     ```
     Generate a dynamic host-based router for Phoenix that checks the requested host and loads the corresponding store.
     ```

7. **Appointment Scheduling**  
   - Create an appointments context.  
   - Add a date/time picker UI in the product checkout flow.  
   - Prompt Codeium for a minimal scheduling solution or an integration with a calendar library.

8. **Admin Panel**  
   - For each store, create an admin route (e.g., `/admin/:store_id`).  
   - Prompt Codeium to scaffold a basic CRUD for products, appointments, store info.  
   - Consider using LiveView for real-time updates.

9. **Static Pages / CMS**  
   - Create a `Page` schema or a simple JSON field in the store.  
   - Prompt Codeium to generate a live editor interface for “About” or “Contact” pages.  
   - Use a WYSIWYG or a markdown-based editor.

10. **Testing & Deployment**  
    - Write tests for each context.  
    - Configure Docker or Gigalixir/Render for hosting.  
    - Prompt Codeium for a CI/CD pipeline with GitHub Actions.

---

## 5. Example Codeium Prompts

Below are sample prompts to use within **Windsurf Editor** to guide Codeium in generating code. Adapt them to your actual structure:

### Prompt A: Create Ecto Schemas

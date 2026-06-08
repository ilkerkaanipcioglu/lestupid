# Legacy Store Import Feature

## Overview
The Legacy Store Import feature allows users to migrate their existing e-commerce stores to Dukkadee with a single click. The system automatically scrapes the legacy store, extracts products, pages, and brand colors, and creates a modern, better-looking store while preserving all the original content.

## Current Implementation Status
**Note: This feature is currently implemented as a UI prototype only.** The backend functionality will be developed in the next phase. The current implementation demonstrates the user interface and flow but does not perform actual store imports.

## User Flow
1. User enters their legacy store URL in the store creation flow
2. System validates the URL and simulates the import process
3. User is shown a summary of what would be imported (products, pages, forms)
4. User can continue with store creation using the simulated data

## Technical Implementation

### Components

#### 1. Store Creation Live View
- Located at `lib/dukkadee_web/live/store_creation_live/index.ex`
- Displays the legacy store import UI
- Handles form submission and validation
- Shows a simulated import summary

#### 2. Legacy Store Importer Module (Planned)
- Located at `lib/dukkadee/store_importer/legacy_store_importer.ex`
- Will be responsible for scraping and processing legacy store data
- Will extract products, pages, and brand colors
- Will create a new store with modern design

### Future Implementation Plans

#### 1. URL Validation and Scraping
- Validate URL format and accessibility
- Respect robots.txt and implement rate limiting
- Use HTTP client to fetch HTML content
- Parse HTML to extract structure and content

#### 2. Content Extraction
- Extract product listings, images, prices, and variants
- Extract static pages and their content
- Extract forms and their structure
- Identify brand colors from CSS and design elements

#### 3. Store Creation
- Create a new store with extracted data
- Apply modern design while preserving brand identity

## Development Guidelines

### URL Validation and Scraping
- Always validate URLs before attempting to scrape
- Implement proper error handling for network issues
- Respect robots.txt directives
- Use rate limiting to avoid overloading target servers
- Handle different HTML structures and e-commerce platforms

### Content Extraction
- Extract as much metadata as possible (titles, descriptions, prices, etc.)
- Download and store images locally
- Preserve category structure
- Extract customer reviews if available
- Identify and extract contact information

### Design and Branding
- Extract primary, secondary, and accent colors
- Identify fonts and typography styles
- Preserve logo and brand identity
- Apply modern design principles while maintaining brand consistency
- Ensure mobile responsiveness

### Error Handling
- Provide clear error messages for failed imports
- Implement partial import capability for partially successful attempts
- Log detailed error information for debugging
- Allow manual retry for failed components

## Testing

### Unit Tests
- Test URL validation
- Test HTML parsing and extraction
- Test store creation with mock data
- Test error handling

### Integration Tests
- Test end-to-end import process
- Test with various e-commerce platforms (Shopify, WooCommerce, etc.)
- Test with different store sizes and complexities

## Future Enhancements
- Support for more e-commerce platforms
- AI-powered content enhancement
- Automatic SEO optimization
- Customer data migration
- Order history import

## Technology Considerations

### Current Implementation
- The legacy store import feature is currently implemented entirely in Elixir and Phoenix
- All scraping, processing, and store creation is handled by the Elixir backend
- The UI is built with Phoenix LiveView and Tailwind CSS

### Future Extensibility
- The feature is designed with future technology integrations in mind
- API endpoints will be created to allow alternative implementations using:
  - Next.js for enhanced frontend experience
  - Medusa.js for specialized e-commerce functionality
  - Vendure for enterprise-level import capabilities
  - PHP-based solutions for specific platform compatibility
- The core data structures and import workflow will remain consistent across implementations
- Import jobs will be designed to work with a potential microservices architecture

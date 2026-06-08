# Dukkadee API Documentation

## Overview

This document provides comprehensive information about the Dukkadee API, which is being developed in parallel with the direct in-app architecture. While the Dukkadee-hosted solution uses direct function calls for maximum performance, these APIs are essential for self-hosted stores, third-party integrations, and mobile applications.

## API Design Principles

1. **Resource-Oriented**: APIs are organized around resources (stores, products, users, etc.)
2. **Consistent Patterns**: All endpoints follow consistent naming, error handling, and response formats
3. **Proper Versioning**: All APIs are versioned to ensure backward compatibility
4. **Comprehensive Documentation**: Each endpoint is fully documented with examples
5. **Security-First**: Robust authentication and authorization mechanisms

## Authentication

### API Keys

For server-to-server communication, API keys are used:

```
Authorization: Bearer {api_key}
```

### OAuth 2.0

For user-based authentication and third-party integrations:

1. **Authorization Code Flow**: For web applications
2. **PKCE Flow**: For mobile applications
3. **Client Credentials**: For service accounts

## Core API Endpoints

### Stores

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/v1/stores` | GET | List all stores accessible to the authenticated user |
| `/api/v1/stores` | POST | Create a new store |
| `/api/v1/stores/:id` | GET | Get store details |
| `/api/v1/stores/:id` | PUT | Update store details |
| `/api/v1/stores/:id` | DELETE | Delete a store |

### Products

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/v1/stores/:store_id/products` | GET | List all products for a store |
| `/api/v1/stores/:store_id/products` | POST | Create a new product |
| `/api/v1/stores/:store_id/products/:id` | GET | Get product details |
| `/api/v1/stores/:store_id/products/:id` | PUT | Update product details |
| `/api/v1/stores/:store_id/products/:id` | DELETE | Delete a product |

### Users

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/v1/users` | GET | List users (admin only) |
| `/api/v1/users/:id` | GET | Get user details |
| `/api/v1/users/:id` | PUT | Update user details |
| `/api/v1/me` | GET | Get current user details |

### Appointments

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/v1/stores/:store_id/appointments` | GET | List all appointments for a store |
| `/api/v1/stores/:store_id/appointments` | POST | Create a new appointment |
| `/api/v1/stores/:store_id/appointments/:id` | GET | Get appointment details |
| `/api/v1/stores/:store_id/appointments/:id` | PUT | Update appointment details |
| `/api/v1/stores/:store_id/appointments/:id` | DELETE | Cancel an appointment |

## Webhooks

Dukkadee provides a webhook system for real-time event notifications:

| Event | Description |
|-------|-------------|
| `store.created` | A new store has been created |
| `product.created` | A new product has been created |
| `product.updated` | A product has been updated |
| `order.created` | A new order has been placed |
| `appointment.booked` | A new appointment has been booked |

## GraphQL API

In addition to REST endpoints, Dukkadee provides a GraphQL API for more flexible data querying:

```
POST /api/v1/graphql
```

Example query:

```graphql
query {
  store(id: "store_id") {
    name
    products {
      id
      name
      price
      variants {
        id
        name
        price
      }
    }
  }
}
```

## Rate Limiting

API requests are subject to rate limiting:

- 100 requests per minute for standard accounts
- 1000 requests per minute for premium accounts
- Custom limits for enterprise accounts

Rate limit headers are included in all responses:

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1614556800
```

## Error Handling

All API errors follow a consistent format:

```json
{
  "error": {
    "code": "invalid_request",
    "message": "The request was invalid",
    "details": [
      {
        "field": "name",
        "message": "Name is required"
      }
    ]
  }
}
```

## API Client Libraries

Official client libraries:

- JavaScript/TypeScript: `@dukkadee/api-client`
- Python: `dukkadee-api`
- PHP: `dukkadee/api-client`
- Ruby: `dukkadee-api`

## Implementation Timeline

| Phase | Timeline | Key Deliverables |
|-------|----------|------------------|
| Phase 1 | Q3 2025 | Core REST API endpoints |
| Phase 2 | Q4 2025 | GraphQL API |
| Phase 3 | Q1 2026 | Webhook system |
| Phase 4 | Q2 2026 | Client libraries |

## API Versioning Policy

- Major version changes (v1 → v2) may include breaking changes
- Minor version changes are backward compatible
- Deprecated endpoints remain available for at least 12 months
- Version sunset announcements are made at least 6 months in advance

## Testing and Sandbox Environment

A sandbox environment is available for testing:

```
https://api-sandbox.dukkadee.com
```

Test API keys are available in the developer dashboard.

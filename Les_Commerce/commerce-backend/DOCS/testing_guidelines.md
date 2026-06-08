# Dukkadee Testing Guidelines

## Overview

This document outlines the testing approach and guidelines for the Dukkadee e-commerce platform. It covers various testing types, best practices, and tools to ensure high-quality, reliable software delivery.

## Testing Philosophy

Dukkadee follows a comprehensive testing approach that emphasizes:

1. **Early Testing**: Testing begins in the development phase, not after
2. **Automated Testing**: Maximize automated test coverage
3. **Test Pyramid**: Balance between unit, integration, and end-to-end tests
4. **Continuous Testing**: Tests run automatically on every code change
5. **Quality Ownership**: Every developer is responsible for quality

## Test Types

### 1. Unit Testing

Unit tests verify that individual components work as expected in isolation.

#### Guidelines:

- Use ExUnit for Elixir code
- Aim for high test coverage (>80%)
- Mock external dependencies
- Focus on testing business logic
- Keep tests fast and independent

#### Example:

```elixir
defmodule Dukkadee.StoresTest do
  use Dukkadee.DataCase

  alias Dukkadee.Stores

  describe "create_store/1" do
    test "creates a store with valid data" do
      valid_attrs = %{name: "Test Store", domain: "test-store"}
      assert {:ok, store} = Stores.create_store(valid_attrs)
      assert store.name == "Test Store"
      assert store.domain == "test-store"
    end

    test "returns error with invalid data" do
      invalid_attrs = %{name: nil, domain: nil}
      assert {:error, %Ecto.Changeset{}} = Stores.create_store(invalid_attrs)
    end
  end
end
```

### 2. Integration Testing

Integration tests verify that components work together correctly.

#### Guidelines:

- Test interactions between contexts
- Test database interactions
- Test external service integrations
- Use test doubles for third-party services

#### Example:

```elixir
defmodule Dukkadee.StoreImporterTest do
  use Dukkadee.DataCase

  alias Dukkadee.Stores
  alias Dukkadee.StoreImporter
  alias Dukkadee.Products

  setup do
    # Setup test data
    {:ok, store} = Stores.create_store(%{name: "Test Store", domain: "test-store"})
    {:ok, %{store: store}}
  end

  test "imports products into store", %{store: store} do
    import_data = %{
      products: [
        %{name: "Product 1", price: 19.99},
        %{name: "Product 2", price: 29.99}
      ]
    }
    
    assert {:ok, report} = StoreImporter.import_data(store, import_data)
    assert report.imported_products == 2
    
    products = Products.list_products(store.id)
    assert length(products) == 2
  end
end
```

### 3. Controller/LiveView Testing

Tests for Phoenix controllers and LiveView modules.

#### Guidelines:

- Test request/response cycles
- Verify correct rendering of templates
- Test form submissions and validations
- Test LiveView event handling

#### Example:

```elixir
defmodule DukkadeeWeb.StoreCreationLiveTest do
  use DukkadeeWeb.ConnCase

  import Phoenix.LiveViewTest

  test "renders store creation form", %{conn: conn} do
    {:ok, view, html} = live(conn, "/open_new_store")
    assert html =~ "Create Your Store"
    assert html =~ "Store Name"
    assert html =~ "Domain"
  end

  test "validates form inputs", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/open_new_store")
    
    result = view
    |> form("#store-form", %{store: %{name: "", domain: ""}})
    |> render_submit()
    
    assert result =~ "can't be blank"
  end
end
```

### 4. End-to-End Testing

End-to-end tests verify the entire application works correctly from a user's perspective.

#### Guidelines:

- Use Wallaby or Hound for browser-based testing
- Focus on critical user flows
- Test across different browsers
- Keep E2E tests focused and minimal

#### Example:

```elixir
defmodule DukkadeeWeb.StoreCreationFlowTest do
  use DukkadeeWeb.FeatureCase
  
  import Wallaby.Browser
  
  feature "user can create a store", %{session: session} do
    session
    |> visit("/open_new_store")
    |> fill_in(text_field("store_name"), with: "My Test Store")
    |> fill_in(text_field("store_domain"), with: "my-test-store")
    |> select(select("store_template"), option: "Clothing Store")
    |> click(button("Create Store"))
    |> assert_has(css(".success-message", text: "Store created successfully"))
  end
end
```

### 5. Performance Testing

Performance tests verify the application meets performance requirements.

#### Guidelines:

- Test response times under various loads
- Test database query performance
- Test concurrent user scenarios
- Establish performance baselines and monitor regressions

#### Tools:

- k6 for load testing
- PostgreSQL EXPLAIN for query analysis
- Application performance monitoring (APM) tools

### 6. Security Testing

Security tests verify the application is secure against common threats.

#### Guidelines:

- Test for OWASP Top 10 vulnerabilities
- Perform regular dependency scanning
- Conduct penetration testing
- Review authentication and authorization mechanisms

#### Tools:

- Mix Audit for dependency scanning
- OWASP ZAP for automated security testing
- Regular manual security reviews

## Test Environment Setup

### Local Development Testing

```elixir
# Configure test database
# config/test.exs
config :dukkadee, Dukkadee.Repo,
  username: "postgres",
  password: "postgres",
  database: "dukkadee_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Run tests
mix test
```

### CI/CD Testing

```yaml
# .github/workflows/test.yml
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:14
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: dukkadee_test
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Elixir
        uses: erlef/setup-beam@v1
        with:
          elixir-version: '1.18.2'
          otp-version: '25'
      
      - name: Get dependencies
        run: mix deps.get
      
      - name: Run tests
        run: mix test
```

## Test Coverage

### Coverage Goals

- Unit Tests: >80% code coverage
- Integration Tests: Cover all critical paths
- End-to-End Tests: Cover all major user flows

### Measuring Coverage

```bash
# Generate coverage report
mix test --cover

# Detailed HTML coverage report
mix coveralls.html
```

## Test Data Management

### Test Fixtures

Use fixtures for common test data:

```elixir
# test/support/fixtures.ex
defmodule Dukkadee.Fixtures do
  alias Dukkadee.Repo
  alias Dukkadee.Accounts.User
  alias Dukkadee.Stores.Store
  
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "user#{System.unique_integer()}@example.com",
        password: "password123"
      })
      |> Dukkadee.Accounts.create_user()
      
    user
  end
  
  def store_fixture(user, attrs \\ %{}) do
    {:ok, store} =
      attrs
      |> Enum.into(%{
        name: "Store #{System.unique_integer()}",
        domain: "store-#{System.unique_integer()}"
      })
      |> Dukkadee.Stores.create_store(user)
      
    store
  end
end
```

### Factory Approach

For more complex test data, consider using a factory approach with ex_machina:

```elixir
# test/support/factory.ex
defmodule Dukkadee.Factory do
  use ExMachina.Ecto, repo: Dukkadee.Repo
  
  def user_factory do
    %Dukkadee.Accounts.User{
      email: sequence(:email, &"user#{&1}@example.com"),
      password_hash: Bcrypt.hash_pwd_salt("password123"),
      name: sequence(:name, &"User #{&1}")
    }
  end
  
  def store_factory do
    %Dukkadee.Stores.Store{
      name: sequence(:name, &"Store #{&1}"),
      domain: sequence(:domain, &"store-#{&1}"),
      user: build(:user)
    }
  end
  
  def product_factory do
    %Dukkadee.Products.Product{
      name: sequence(:name, &"Product #{&1}"),
      price: Decimal.new("19.99"),
      description: "A great product",
      store: build(:store)
    }
  end
end
```

## Testing LiveView Features

### Testing Real-time Features

```elixir
defmodule DukkadeeWeb.LiveProductListTest do
  use DukkadeeWeb.ConnCase
  
  import Phoenix.LiveViewTest
  
  test "updates product list in real-time", %{conn: conn} do
    store = insert(:store)
    product = insert(:product, store: store)
    
    {:ok, view, _html} = live(conn, "/stores/#{store.id}/products")
    
    # Verify initial render
    assert has_element?(view, "#product-#{product.id}")
    
    # Create a new product
    new_product = insert(:product, store: store)
    
    # Verify the list updates automatically
    assert_push_event view, "product-added", %{id: new_product.id}
    assert has_element?(view, "#product-#{new_product.id}")
  end
end
```

## Mocking and Test Doubles

### Mocking External Services

Use Mox for mocking external services:

```elixir
# test/support/mocks.ex
Mox.defmock(Dukkadee.MockInstagramAPI, for: Dukkadee.InstagramAPI.Behaviour)

# In your test
defmodule Dukkadee.StoreImporter.InstagramImporterTest do
  use Dukkadee.DataCase
  
  import Mox
  
  setup :verify_on_exit!
  
  test "imports products from Instagram" do
    Dukkadee.MockInstagramAPI
    |> expect(:fetch_media, fn _username ->
      {:ok, [
        %{
          id: "123",
          caption: "Product 1",
          image_url: "https://example.com/image1.jpg"
        },
        %{
          id: "456",
          caption: "Product 2",
          image_url: "https://example.com/image2.jpg"
        }
      ]}
    end)
    
    assert {:ok, report} = Dukkadee.StoreImporter.InstagramImporter.import("test_user")
    assert report.imported_products == 2
  end
end
```

## Continuous Integration

### GitHub Actions Workflow

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    name: Build and test
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:14
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: dukkadee_test
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Elixir
        uses: erlef/setup-beam@v1
        with:
          elixir-version: '1.18.2'
          otp-version: '25'
      
      - name: Cache deps
        uses: actions/cache@v3
        with:
          path: deps
          key: ${{ runner.os }}-mix-${{ hashFiles('**/mix.lock') }}
          restore-keys: ${{ runner.os }}-mix-
      
      - name: Cache _build
        uses: actions/cache@v3
        with:
          path: _build
          key: ${{ runner.os }}-build-${{ hashFiles('**/mix.lock') }}
          restore-keys: ${{ runner.os }}-build-
      
      - name: Install dependencies
        run: mix deps.get
      
      - name: Check formatting
        run: mix format --check-formatted
      
      - name: Run Credo
        run: mix credo --strict
      
      - name: Run tests with coverage
        run: mix coveralls.github
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Check for security vulnerabilities
        run: mix deps.audit
```

## Best Practices

1. **Write Tests First**: Consider test-driven development (TDD)
2. **Keep Tests Fast**: Slow tests discourage frequent running
3. **One Assertion Per Test**: Tests should verify one thing
4. **Use Descriptive Test Names**: Names should describe what is being tested
5. **Isolate Tests**: Tests should not depend on each other
6. **Avoid Test Duplication**: Use setup and helpers to reduce duplication
7. **Test Edge Cases**: Don't just test the happy path
8. **Keep Tests Simple**: Tests should be easier to understand than the code they test
9. **Regular Refactoring**: Refactor tests as the codebase evolves
10. **Test Real Code**: Avoid excessive mocking

## Troubleshooting Common Test Issues

### Flaky Tests

- Identify and fix tests that fail intermittently
- Look for race conditions, timing issues, or external dependencies
- Use `async: false` for tests that cannot run concurrently

### Slow Tests

- Profile test execution time
- Move slow tests to a separate suite
- Use `mix test --slowest` to identify slow tests

### Database-Related Issues

- Ensure proper use of Ecto.Adapters.SQL.Sandbox
- Reset database state between tests
- Use transactions to isolate test data

## Resources

- [ExUnit Documentation](https://hexdocs.pm/ex_unit/ExUnit.html)
- [Phoenix Testing Guide](https://hexdocs.pm/phoenix/testing.html)
- [LiveView Testing Guide](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveViewTest.html)
- [Wallaby Documentation](https://hexdocs.pm/wallaby/readme.html)
- [Mox Documentation](https://hexdocs.pm/mox/Mox.html)

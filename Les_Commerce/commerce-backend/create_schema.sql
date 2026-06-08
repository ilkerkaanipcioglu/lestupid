-- Connect to the database
\c dukkadee_dev

-- Create schema_migrations table
CREATE TABLE IF NOT EXISTS schema_migrations (
    version bigint PRIMARY KEY,
    inserted_at timestamp without time zone
);

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_admin BOOLEAN NOT NULL DEFAULT FALSE,
    inserted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS users_email_index ON users (email);

-- Create stores table
CREATE TABLE IF NOT EXISTS stores (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    domain VARCHAR(255),
    description TEXT,
    logo_url VARCHAR(255),
    theme VARCHAR(255) NOT NULL DEFAULT 'default',
    self_hosted BOOLEAN NOT NULL DEFAULT FALSE,
    self_hosted_url VARCHAR(255),
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    inserted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS stores_slug_index ON stores (slug);
CREATE UNIQUE INDEX IF NOT EXISTS stores_domain_index ON stores (domain);
CREATE INDEX IF NOT EXISTS stores_user_id_index ON stores (user_id);

-- Create products table
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    sku VARCHAR(255),
    store_id INTEGER NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    inserted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS products_store_id_index ON products (store_id);

-- Create product_variants table
CREATE TABLE IF NOT EXISTS product_variants (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2),
    sku VARCHAR(255),
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    inserted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS product_variants_product_id_index ON product_variants (product_id);

-- Create pages table
CREATE TABLE IF NOT EXISTS pages (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    content TEXT,
    store_id INTEGER NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    inserted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS pages_store_id_slug_index ON pages (store_id, slug);

-- Create import_jobs table
CREATE TABLE IF NOT EXISTS import_jobs (
    id SERIAL PRIMARY KEY,
    source VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    metadata JSONB,
    store_id INTEGER NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    inserted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS import_jobs_store_id_index ON import_jobs (store_id);

-- Create import_reports table
CREATE TABLE IF NOT EXISTS import_reports (
    id SERIAL PRIMARY KEY,
    success_count INTEGER NOT NULL DEFAULT 0,
    error_count INTEGER NOT NULL DEFAULT 0,
    details JSONB,
    import_job_id INTEGER NOT NULL REFERENCES import_jobs(id) ON DELETE CASCADE,
    inserted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS import_reports_import_job_id_index ON import_reports (import_job_id);

-- Create appointments table
CREATE TABLE IF NOT EXISTS appointments (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    customer_email VARCHAR(255),
    customer_name VARCHAR(255),
    notes TEXT,
    store_id INTEGER NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    inserted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS appointments_store_id_index ON appointments (store_id);

-- Add version to schema_migrations
INSERT INTO schema_migrations (version, inserted_at) 
VALUES (20250301000000, CURRENT_TIMESTAMP)
ON CONFLICT (version) DO NOTHING;

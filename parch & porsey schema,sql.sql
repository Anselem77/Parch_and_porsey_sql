-- Create region table

CREATE TABLE region (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Create sales_reps table

CREATE TABLE sales_reps (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    region_id INT NOT NULL,
    FOREIGN KEY (region_id) REFERENCES region(id) ON DELETE CASCADE
);

-- Create accounts table

CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    website VARCHAR(255),
    lat DECIMAL(9,6),
    long DECIMAL(9,6),
    primary_poc VARCHAR(150),
    sales_rep_id INT NOT NULL,
    FOREIGN KEY (sales_rep_id) REFERENCES sales_reps(id) ON DELETE SET NULL
);

-- Create web_events table

CREATE TABLE web_events (
    id SERIAL PRIMARY KEY,
    account_id INT NOT NULL,
    occurred_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    channel VARCHAR(100) NOT NULL CHECK (channel IN ('Google','Facebook','Twitter')),
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);

-- Create orders table

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    account_id INT NOT NULL,
    standard_qty INT DEFAULT 0 CHECK (standard_qty >= 0),
    poster_qty INT DEFAULT 0 CHECK (poster_qty >= 0),
    gloss_qty INT DEFAULT 0 CHECK (gloss_qty >= 0),
    total INT GENERATED ALWAYS AS (standard_qty + poster_qty + gloss_qty) STORED,
    standard_amt_usd NUMERIC(10,2) DEFAULT 0.00,
    gloss_amt_usd NUMERIC(10,2) DEFAULT 0.00,
    poster_amt_usd NUMERIC(10,2) DEFAULT 0.00,
    total_amt_usd NUMERIC(10,2) GENERATED ALWAYS AS (standard_amt_usd + gloss_amt_usd + poster_amt_usd) STORED,
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);

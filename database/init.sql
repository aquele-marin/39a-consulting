DROP TABLE IF EXISTS energy_readings CASCADE;
DROP TABLE IF EXISTS contracts CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(150) NOT NULL
);

INSERT INTO customers (name) VALUES 
('Alpha Company Ltd.'),
('Beta Industry Inc.'),
('John Doe (Individual)');

CREATE TABLE contracts (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    start_date DATE NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    
    CONSTRAINT fk_contract_customer 
        FOREIGN KEY (customer_id) 
        REFERENCES customers (id) 
        ON DELETE RESTRICT
);

CREATE INDEX idx_contracts_customer_id ON contracts(customer_id);
CREATE INDEX idx_active_contracts ON contracts(is_active) WHERE is_active = TRUE;

INSERT INTO contracts (customer_id, start_date, is_active) VALUES 
(1, '2023-01-15', TRUE),  -- Active contract for Alpha Company
(2, '2022-05-10', FALSE), -- Inactive contract for Beta Industry
(2, '2023-11-01', TRUE),  -- New active contract for the same Beta Industry
(3, '2024-02-20', TRUE);  -- Recent contract for individual

CREATE TABLE energy_readings (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    contract_id INTEGER NOT NULL,
    reading_timestamp TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    kwh_value NUMERIC(12, 4) NOT NULL CHECK (kwh_value >= 0), -- Validation: Consumption cannot be negative
    
    CONSTRAINT fk_reading_contract 
        FOREIGN KEY (contract_id) 
        REFERENCES contracts (id) 
        ON DELETE RESTRICT
);

CREATE INDEX idx_readings_contract_date ON energy_readings(contract_id, reading_timestamp DESC);

INSERT INTO energy_readings (contract_id, reading_timestamp, kwh_value) VALUES 
-- Readings Contract 1 (Alpha)
(1, '2024-03-01 08:00:00-03', 1540.5000),
(1, '2024-03-02 08:00:00-03', 1620.2550),
(1, '2024-03-03 08:00:00-03', 1580.0000),

-- Readings Contract 2 (Beta - Inactive - Old Readings)
(2, '2023-09-01 12:00:00-03', 45000.7500),
(2, '2023-10-01 12:00:00-03', 46210.1000),

-- Readings Contract 3 (Beta - New Contract)
(3, '2024-03-01 09:30:00-03', 250.0000),
(3, '2024-03-02 09:30:00-03', 265.4000),

-- Readings Contract 4 (John Doe)
(4, '2024-03-01 18:00:00-03', 12.3000),
(4, '2024-03-02 18:00:00-03', 15.1000);
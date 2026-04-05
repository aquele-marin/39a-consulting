DROP TABLE IF EXISTS energy_readings CASCADE;
DROP TABLE IF EXISTS contracts CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(150) NOT NULL
);

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
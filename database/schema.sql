Airport Operations & Passenger Booking Database
Schema Definition

-- Drop existing tables
DROP TABLE IF EXISTS boarding_pass CASCADE;
DROP TABLE IF EXISTS booking_flight CASCADE;
DROP TABLE IF EXISTS baggage_check CASCADE;
DROP TABLE IF EXISTS baggage CASCADE;
DROP TABLE IF EXISTS security_check CASCADE;
DROP TABLE IF EXISTS booking CASCADE;
DROP TABLE IF EXISTS flights CASCADE;
DROP TABLE IF EXISTS airlines CASCADE;
DROP TABLE IF EXISTS airport CASCADE;
DROP TABLE IF EXISTS passengers CASCADE;

-- ----------------------------------------------------------------------------
-- Core tables
-- ----------------------------------------------------------------------------

-- Passengers
CREATE TABLE passengers (
    passenger_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender VARCHAR(50),
    country_of_citizenship VARCHAR(50),
    country_of_residence VARCHAR(50),
    passport_number VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Airports
CREATE TABLE airport (
    airport_id INT,
    airport_name VARCHAR(50),
    country VARCHAR(50),
    state VARCHAR(50),
    city VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Airlines
CREATE TABLE airlines (
    airline_id INT,
    airline_code VARCHAR(50),
    airline_name VARCHAR(50) NOT NULL,
    airline_country VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- Operational tables
-- ----------------------------------------------------------------------------

-- Flights
CREATE TABLE flights (
    flight_id INT,
    flight_no VARCHAR(50),
    scheduled_departure TIMESTAMP,
    scheduled_arrival TIMESTAMP,
    departure_airport_id INT,
    arrival_airport_id INT,
    departing_gate VARCHAR(50),
    arriving_gate VARCHAR(50),
    airline_id INT,
    status VARCHAR(50),
    actual_departure TIMESTAMP,
    actual_arrival TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bookings
CREATE TABLE booking (
    booking_id INT,
    passenger_id INT,
    booking_platform VARCHAR(50),
    status VARCHAR(50),
    price DECIMAL(7,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Boarding passes
CREATE TABLE boarding_pass (
    boarding_pass_id INT,
    seat VARCHAR(50),
    booking_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Baggage
CREATE TABLE baggage (
    baggage_id INT,
    weight_in_kg DECIMAL(4,2),
    booking_id INT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- Relationship and tracking tables
-- ----------------------------------------------------------------------------

-- Booking ↔ Flight mapping
CREATE TABLE booking_flight (
    booking_flight_id INT,
    booking_id INT,
    flight_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Baggage checks
CREATE TABLE baggage_check (
    baggage_check_id INT,
    check_result VARCHAR(50),
    booking_id INT,
    passenger_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Security checks
CREATE TABLE security_check (
    security_check_id INT,
    check_result VARCHAR(50),
    passenger_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- Primary keys
-- ----------------------------------------------------------------------------
ALTER TABLE passengers ADD PRIMARY KEY (passenger_id);
ALTER TABLE airport ADD PRIMARY KEY (airport_id);
ALTER TABLE airlines ADD PRIMARY KEY (airline_id);
ALTER TABLE flights ADD PRIMARY KEY (flight_id);
ALTER TABLE booking ADD PRIMARY KEY (booking_id);
ALTER TABLE boarding_pass ADD PRIMARY KEY (boarding_pass_id);
ALTER TABLE baggage ADD PRIMARY KEY (baggage_id);
ALTER TABLE booking_flight ADD PRIMARY KEY (booking_flight_id);
ALTER TABLE baggage_check ADD PRIMARY KEY (baggage_check_id);
ALTER TABLE security_check ADD PRIMARY KEY (security_check_id);

-- ----------------------------------------------------------------------------
-- Foreign keys
-- ----------------------------------------------------------------------------

-- Flights
ALTER TABLE flights ADD CONSTRAINT fk_flights_airline FOREIGN KEY (airline_id) REFERENCES airlines(airline_id);
ALTER TABLE flights ADD CONSTRAINT fk_flights_departure FOREIGN KEY (departure_airport_id) REFERENCES airport(airport_id);
ALTER TABLE flights ADD CONSTRAINT fk_flights_arrival FOREIGN KEY (arrival_airport_id) REFERENCES airport(airport_id);

-- Bookings
ALTER TABLE booking ADD CONSTRAINT fk_booking_passenger FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id);

-- Boarding passes
ALTER TABLE boarding_pass ADD CONSTRAINT fk_boarding_booking FOREIGN KEY (booking_id) REFERENCES booking(booking_id);

-- Baggage
ALTER TABLE baggage ADD CONSTRAINT fk_baggage_booking FOREIGN KEY (booking_id) REFERENCES booking(booking_id);

-- Booking-flight relationships
ALTER TABLE booking_flight ADD CONSTRAINT fk_bridge_booking FOREIGN KEY (booking_id) REFERENCES booking(booking_id);
ALTER TABLE booking_flight ADD CONSTRAINT fk_bridge_flight FOREIGN KEY (flight_id) REFERENCES flights(flight_id);

-- Security and baggage checks
ALTER TABLE baggage_check ADD CONSTRAINT fk_baggage_check_passenger FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id);
ALTER TABLE baggage_check ADD CONSTRAINT fk_baggage_check_booking FOREIGN KEY (booking_id) REFERENCES booking(booking_id);
ALTER TABLE security_check ADD CONSTRAINT fk_security_passenger FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id);

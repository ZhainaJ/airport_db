-- ============================================================================
-- PROJECT: Airport Operations & Passenger Booking Database System
-- FILE: database/seed_data.sql
-- DESCRIPTION: Initial transactional test data insertions for core entities
-- ============================================================================

-- Clean up any existing data safely before re-seeding
-- (Ordered from most dependent to independent tables)
TRUNCATE TABLE security_check, baggage_check, booking_flight, baggage, boarding_pass, booking, flights, airlines, airport, passengers RESTART IDENTITY CASCADE;

-- ----------------------------------------------------------------------------
-- 1. INDEPENDENT ENTITY INSERTS
-- ----------------------------------------------------------------------------

-- A. Passengers Data
INSERT INTO passengers (passenger_id, first_name, last_name, date_of_birth, gender, country_of_citizenship, country_of_residence, passport_number, created_at, update_at) VALUES
(101, 'Elena', 'Petrova', '1992-05-14', 'Female', 'Kazakhstan', 'Kazakhstan', 'N1234567', '2026-01-10 08:00:00', '2026-01-10 08:00:00'),
(102, 'Arman', 'Saparov', '1988-11-23', 'Male', 'Kazakhstan', 'Kazakhstan', 'N7654321', '2026-01-11 09:30:00', '2026-01-11 09:30:00'),
(103, 'John', 'Smith', '1975-03-02', 'Male', 'United Kingdom', 'United Kingdom', 'UK998877', '2026-01-12 14:15:00', '2026-01-12 14:15:00'),
(104, 'Klara', 'Novotna', '1995-08-19', 'Female', 'Czech Republic', 'Czech Republic', 'CZ554433', '2026-01-13 10:45:00', '2026-01-13 10:45:00');

-- B. Airport Hubs Data
INSERT INTO airport (airport_id, airport_name, country, state, city, created_at, update_at) VALUES
(1, 'Pardubice Airport', 'Czech Republic', 'Pardubice Region', 'Pardubice', '2026-01-01 00:00:00', '2026-01-01 00:00:00'),
(2, 'Glasgow Prestwick Airport', 'United Kingdom', 'Scotland', 'Glasgow', '2026-01-01 00:00:00', '2026-01-01 00:00:00'),
(3, 'Nursultan Nazarbayev International Airport', 'Kazakhstan', 'Astana', 'Astana', '2026-01-01 00:00:00', '2026-01-01 00:00:00');

-- C. Airlines Data
INSERT INTO airlines (airline_id, airline_code, airline_name, airline_country, created_at, update_at) VALUES
(1, 'ANYN', 'Anyn Airways', 'Kazakhstan', '2026-01-01 00:00:00', '2026-01-01 00:00:00'),
(2, 'NULI', 'Nuli Air', 'Czech Republic', '2026-01-01 00:00:00', '2026-01-01 00:00:00');

-- ----------------------------------------------------------------------------
-- 2. DEPENDENT ENTITY INSERTS (Requires Parent IDs from Section 1)
-- ----------------------------------------------------------------------------

-- D. Flights Data
INSERT INTO flights (flight_id, flight_no, scheduled_departure, scheduled_arrival, departure_airport_id, arrival_airport_id, departing_gate, arriving_gate, airline_id, status, actual_departure, actual_arrival, created_at, update_at) VALUES
(501, 'AN-101', '2026-06-15 06:00:00', '2026-06-15 11:30:00', 3, 1, 'Gate A1', 'Gate B3', 1, 'Scheduled', '2026-06-15 06:02:00', '2026-06-15 11:28:00', '2026-02-01 12:00:00', '2026-02-01 12:00:00'),
(502, 'NU-302', '2026-06-16 14:00:00', '2026-06-16 16:45:00', 1, 2, 'Gate C2', 'Gate A5', 2, 'Scheduled', '2026-06-16 13:58:00', '2026-06-16 16:50:00', '2026-02-02 13:00:00', '2026-02-02 13:00:00'),
(503, 'AN-205', '2026-06-17 22:15:00', '2026-06-18 04:30:00', 2, 3, 'Gate B1', 'Gate A3', 1, 'Delayed', '2026-06-17 22:45:00', '2026-06-18 05:01:00', '2026-02-03 14:00:00', '2026-02-03 14:00:00');

-- E. Booking Transactions Data
INSERT INTO booking (booking_id, passenger_id, booking_platform, status, price, created_at, update_at) VALUES
(1001, 101, 'Mobile App', 'Confirmed', 350.00, '2026-05-01 10:15:00', '2026-05-01 10:15:00'),
(1002, 102, 'Website', 'Confirmed', 420.50, '2026-05-02 11:30:00', '2026-05-02 11:30:00'),
(1003, 103, 'Agency Portal', 'Confirmed', 510.00, '2026-05-03 15:45:00', '2026-05-03 15:45:00'),
(1004, 104, 'Website', 'Cancelled', 0.00, '2026-05-04 09:00:00', '2026-05-04 14:20:00');

-- F. Boarding Pass Data
INSERT INTO boarding_pass (boarding_pass_id, seat, booking_id, created_at, update_at) VALUES
(2001, '12A', 1001, '2026-06-15 04:30:00', '2026-06-15 04:30:00'),
(2002, '04C', 1002, '2026-06-15 04:45:00', '2026-06-15 04:45:00'),
(2003, '17D', 1003, '2026-06-16 12:15:00', '2026-06-16 12:15:00'),
(2004, '000', 1004, '2026-05-04 14:20:00', '2026-05-04 14:20:00'); -- 000 marks unassigned seats for cancellation tracking

-- G. Baggage Inventory Data
INSERT INTO baggage (baggage_id, weight_in_kg, booking_id, created_date, update_date) VALUES
(3001, 21.50, 1001, '2026-06-15 04:35:00', '2026-06-15 04:35:00'),
(3002, 18.25, 1001, '2026-06-15 04:35:00', '2026-06-15 04:35:00'),
(3003, 29.00, 1002, '2026-06-15 04:50:00', '2026-06-15 04:50:00'),
(3004, 0.00, 1004, '2026-05-04 14:20:00', '2026-05-04 14:20:00'); -- 0.00 used to represent zero weight configurations

-- ----------------------------------------------------------------------------
-- 3. JUNCTION & COMPLIANCE LEDGER INSERTS
-- ----------------------------------------------------------------------------

-- H. Booking to Flight Mapping Bridge (Many-to-Many Connections)
INSERT INTO booking_flight (booking_flight_id, booking_id, flight_id, created_at, update_at) VALUES
(4001, 1001, 501, '2026-05-01 10:15:00', '2026-05-01 10:15:00'),
(4002, 1002, 501, '2026-05-02 11:30:00', '2026-05-02 11:30:00'),
(4003, 1003, 502, '2026-05-03 15:45:00', '2026-05-03 15:45:00'),
(4004, 1004, 503, '2026-05-04 09:00:00', '2026-05-04 14:20:00');

-- I. Baggage Compliance Audit Data
INSERT INTO baggage_check (baggage_check_id, check_result, booking_id, passenger_id, created_at, update_at) VALUES
(5001, 'Passed', 1001, 101, '2026-06-15 04:40:00', '2026-06-15 04:40:00'),
(5002, 'Passed', 1002, 102, '2026-06-15 04:55:00', '2026-06-15 04:55:00'),
(5003, 'Cleared With Warning', 1003, 103, '2026-06-16 12:30:00', '2026-06-16 12:30:00'),
(5004, 'Rejected', 1004, 104, '2026-05-04 14:20:00', '2026-05-04 14:20:00');

-- J. Passenger Security Clearance Data
INSERT INTO security_check (security_check_id, check_result, passenger_id, created_at, update_at) VALUES
(6001, 'Clear', 101, '2026-06-15 05:00:00', '2026-06-15 05:00:00'),
(6002, 'Clear', 102, '2026-06-15 05:10:00', '2026-06-15 05:10:00'),
(6003, 'Secondary Screening Passed', 103, '2026-06-16 12:45:00', '2026-06-16 12:45:00'),
(6004, 'No Show', 104, '2026-06-17 00:00:00', '2026-06-17 00:00:00');

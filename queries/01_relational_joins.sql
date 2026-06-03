-- ============================================================================
-- PROJECT: Airport Operations & Passenger Booking Database System
-- FILE: queries/01_relational_joins.sql
-- DESCRIPTION: Core relational join scripts demonstrating data integrity
-- ============================================================================

-- ----------------------------------------------------------------------------
-- QUERY 01: Inner Join - Flights and Departure Airport Mapping
-- OBJECTIVE: Extract flight IDs along with their valid departure country for a specific date range.
-- ----------------------------------------------------------------------------
SELECT
    f.flight_id,
    a.country,
    f.scheduled_departure
FROM flights f
INNER JOIN airport a ON f.departure_airport_id = a.airport_id
WHERE f.scheduled_departure BETWEEN '2023-05-01' AND '2023-05-31';

-- MECHANICS: Only flights with a valid matching departure airport record are 
-- returned, preserving strict data continuity boundaries.


-- ----------------------------------------------------------------------------
-- QUERY 02: Left Join - Departing Flight Volume Analysis per Airport
-- OBJECTIVE: Count all departing flights per airport, ensuring hubs with zero departures are included.
-- ----------------------------------------------------------------------------
SELECT
    a.airport_name,
    COUNT(f.flight_id) AS departing_flights
FROM airport a
LEFT JOIN flights f ON f.departure_airport_id = a.airport_id
GROUP BY a.airport_name
ORDER BY a.airport_name;

-- MECHANICS: Outputs all rows from the left table (airport). Unmatched airports 
-- receive a default counting weight mapping value of 0.


-- ----------------------------------------------------------------------------
-- QUERY 03: Left Join - Passenger Booking Coverage Audit
-- OBJECTIVE: List all registered passengers paired with their booking transaction IDs, if any.
-- ----------------------------------------------------------------------------
SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS passenger,
    b.booking_id
FROM passengers p
LEFT JOIN booking b ON p.passenger_id = b.passenger_id;

-- MECHANICS: Retains 100% visibility of the passenger roster; unregistered 
-- or non-booking flyers show up with a blank transaction row marker.


-- ----------------------------------------------------------------------------
-- QUERY 04: Full Outer Join - Airline and Scheduled Flight Cross-Audit
-- OBJECTIVE: Map all airlines to their scheduled flights, exposing orphan records on either side.
-- ----------------------------------------------------------------------------
SELECT
    a.airline_name,
    f.flight_id
FROM airlines a
FULL OUTER JOIN flights f ON a.airline_id = f.airline_id
ORDER BY a.airline_name;

-- MECHANICS: Combines left and right tables completely. Identifies airlines 
-- without flights as well as flights missing structural airline assignments.


-- ----------------------------------------------------------------------------
-- QUERY 05: Cross Join - Cross-Border Combinatorial Destination Paths
-- OBJECTIVE: Generate every possible combination of airlines and foreign target destination countries.
-- ----------------------------------------------------------------------------
SELECT
    a.airline_name,
    ar.country AS destination_country
FROM airlines a
CROSS JOIN airport ar
WHERE a.airline_country IS NOT NULL
  AND ar.country IS NOT NULL
  AND ar.country <> a.airline_country
ORDER BY a.airline_name, ar.country;

-- MECHANICS: Creates a Cartesian product pairing every single row from the 
-- airlines table with every single row from the airport matrix.


-- ----------------------------------------------------------------------------
-- QUERY 06: Inner Join (Self-Join) - Concurrent Gate Departure Audits
-- OBJECTIVE: Locate separate flights departing from the same airport on the exact same date.
-- ----------------------------------------------------------------------------
SELECT
    f1.flight_no AS flight_1,
    f2.flight_no AS flight_2,
    f1.departure_airport_id,
    CAST(f1.scheduled_departure AS DATE) AS departure_date
FROM flights f1
INNER JOIN flights f2 ON f1.departure_airport_id = f2.departure_airport_id
    AND CAST(f1.scheduled_departure AS DATE) = CAST(f2.scheduled_departure AS DATE)
    AND f1.flight_no < f2.flight_no;

-- MECHANICS: Compares a table against itself. The `<` constraint prevents 
-- duplicate reflective pairings and blocks a flight from pairing with itself.


-- ----------------------------------------------------------------------------
-- QUERY 07: Multi-Table Inner Join - Comprehensive Passenger Manifest
-- OBJECTIVE: Trace an uninterrupted data chain linking passengers directly to their operating airlines.
-- ----------------------------------------------------------------------------
SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS passenger_fullname,
    f.flight_id,
    a.airline_name
FROM booking b
INNER JOIN passengers p ON p.passenger_id = b.passenger_id
INNER JOIN booking_flight bkf ON b.booking_id = bkf.booking_id
INNER JOIN flights f ON f.flight_id = bkf.flight_id
INNER JOIN airlines a ON f.airline_id = a.airline_id;

-- MECHANICS: Connects 5 tables sequentially. A row drops out entirely if any 
-- piece of the structural constraint chain is broken or missing.


-- ----------------------------------------------------------------------------
-- QUERY 08: Left Join - Airport Arrival Schedule Grid
-- OBJECTIVE: Map all global terminal positions to their inbound scheduled arrival dates.
-- ----------------------------------------------------------------------------
SELECT
    a.airport_name,
    f.scheduled_arrival
FROM airport a
LEFT JOIN flights f ON a.airport_id = f.arrival_airport_id;

-- MECHANICS: Ensures full hub analytical evaluation; facilities experiencing 
-- no inbound traffic streams remain visible on the dashboard grid.


-- ----------------------------------------------------------------------------
-- QUERY 09: Left Join - Seating Document Validation Link
-- OBJECTIVE: Verify physical seating assignments against their master booking transactions.
-- ----------------------------------------------------------------------------
SELECT
    bp.boarding_pass_id,
    bp.seat,
    b.booking_id,
    b.passenger_id,
    b.created_at
FROM boarding_pass bp
LEFT JOIN booking b ON bp.booking_id = b.booking_id;

-- MECHANICS: Prioritizes downstream boarding safety layers, isolating issued 
-- passes that might be unlinked from active administrative booking files.


-- ----------------------------------------------------------------------------
-- QUERY 10: Complex Condition Manifest - 2024 Travel Audit
-- OBJECTIVE: Extract all passenger names and confirmed seats for flights scheduled in 2024.
-- ----------------------------------------------------------------------------
SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS passenger_fullname,
    bp.seat
FROM passengers p
INNER JOIN booking b ON p.passenger_id = b.passenger_id
INNER JOIN boarding_pass bp ON b.booking_id = bp.booking_id
INNER JOIN booking_flight bf ON b.booking_id = bf.booking_id
INNER JOIN flights f ON bf.flight_id = f.flight_id
WHERE EXTRACT(YEAR FROM f.scheduled_departure) = 2024;

-- MECHANICS: Combines multi-layered structural validation joins with specific temporal 
-- scalar filters, capturing a highly targeted operational subset.

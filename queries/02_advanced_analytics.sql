-- ============================================================================
-- PROJECT: Airport Operations & Passenger Booking Database System
-- FILE: queries/02_advanced_analytics.sql
-- DESCRIPTION: Advanced business intelligence and window analytics scripts
-- ============================================================================

-- ----------------------------------------------------------------------------
-- QUERY 01: Platform Metrics Aggregation
-- OBJECTIVE: Analyze transaction distributions across different booking channels.
-- ----------------------------------------------------------------------------
SELECT 
    booking_platform, 
    COUNT(*) AS total_bookings, 
    AVG(price) AS avg_ticket_price
FROM booking
GROUP BY booking_platform;

-- MECHANICS: Groups operational data streams by channel, utilizing basic 
-- aggregate counters and financial averages.


-- ----------------------------------------------------------------------------
-- QUERY 02: Destination Traffic Volume
-- OBJECTIVE: Measure terminal performance based on total inbound flight arrivals.
-- ----------------------------------------------------------------------------
SELECT 
    a.airport_name, 
    COUNT(f.flight_id) AS arrived_flights
FROM flights f
INNER JOIN airport a ON f.arrival_airport_id = a.airport_id
GROUP BY a.airport_name;

-- MECHANICS: Uses a relational link to consolidate flight histories into discrete 
-- aggregate volume counters per global aviation hub.


-- ----------------------------------------------------------------------------
-- QUERY 03: High-Performing Platform Filter (Subquery & HAVING)
-- OBJECTIVE: Isolate active channels processing metrics above global benchmarks.
-- ----------------------------------------------------------------------------
SELECT 
    booking_platform, 
    COUNT(*) AS total_bookings, 
    SUM(price) AS revenue,
    MIN(price) AS min_price, 
    MAX(price) AS max_price,
    AVG(price) AS avg_price, 
    (MAX(price) - MIN(price)) AS price_spread
FROM booking
GROUP BY booking_platform
HAVING COUNT(*) >= 2
   AND AVG(price) > (SELECT AVG(price) FROM booking);

-- MECHANICS: Employs a nested scalar subquery inside a HAVING filter to dynamically 
-- drop platforms that underperform compared to the global enterprise baseline.


-- ----------------------------------------------------------------------------
-- QUERY 04: Premium Carrier Identification
-- OBJECTIVE: Locate airlines whose pricing tier exceeds the global standard.
-- ----------------------------------------------------------------------------
SELECT 
    al.airline_name, 
    AVG(b.price) AS avg_ticket_price
FROM airlines al
INNER JOIN flights f ON al.airline_id = f.airline_id
INNER JOIN booking_flight bf ON f.flight_id = bf.flight_id
INNER JOIN booking b ON bf.booking_id = b.booking_id
GROUP BY al.airline_name
HAVING AVG(b.price) > (SELECT AVG(price) FROM booking);

-- MECHANICS: Traces paths from carrier definitions to ticket sales tables, using 
-- conditional evaluations to pinpoint premium flight options.


-- ----------------------------------------------------------------------------
-- QUERY 05: Revenue Optimization - Top 10 Routes
-- OBJECTIVE: Highlight the 10 most profitable travel corridors with proven volume.
-- ----------------------------------------------------------------------------
SELECT 
    dep.airport_name || ' -> ' || arr.airport_name AS route,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.price) AS revenue
FROM flights f
INNER JOIN airport dep ON f.departure_airport_id = dep.airport_id
INNER JOIN airport arr ON f.arrival_airport_id = arr.airport_id
INNER JOIN booking_flight bf ON f.flight_id = bf.flight_id
INNER JOIN booking b ON bf.booking_id = b.booking_id
GROUP BY dep.airport_name, arr.airport_name
HAVING COUNT(b.booking_id) >= 5
ORDER BY revenue DESC
LIMIT 10;

-- MECHANICS: String concatenation merges geographic endpoints. The results are 
-- mathematically ordered by total yields and truncated via a row-count constraint.


-- ----------------------------------------------------------------------------
-- QUERY 06: Window Function - Passenger Purchase Chronology
-- OBJECTIVE: Sequentially number transactions for every unique flyer profile.
-- ----------------------------------------------------------------------------
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS passenger_fullname,
    b.booking_id,
    ROW_NUMBER() OVER (PARTITION BY p.passenger_id ORDER BY b.booking_id) AS booking_no
FROM passengers p
INNER JOIN booking b ON p.passenger_id = b.passenger_id;

-- MECHANICS: `ROW_NUMBER()` initializes an ordered sequence starting from 1 
-- for each customer window, tracking chronological purchasing habits over time.


-- ----------------------------------------------------------------------------
-- QUERY 07: Window Function - Internal Flight Ticket Ranking
-- OBJECTIVE: Rank ticket sales values inside each individual flight compartment.
-- ----------------------------------------------------------------------------
SELECT 
    bf.flight_id,
    b.booking_id,
    b.price AS ticket_price,
    RANK() OVER (PARTITION BY bf.flight_id ORDER BY b.price DESC) AS price_rank
FROM booking_flight bf
INNER JOIN booking b ON bf.booking_id = b.booking_id;

-- MECHANICS: `RANK()` isolates transaction details by `flight_id` boundaries, assigning 
-- positions by cost. Duplicate values receive identical ranks, leaving a gap for subsequent positions.


-- ----------------------------------------------------------------------------
-- QUERY 08: Window Function - Look-Ahead Gate Departure Timelines
-- OBJECTIVE: Map consecutive departures at the same terminal gate to prevent scheduling conflicts.
-- ----------------------------------------------------------------------------
SELECT 
    departure_airport_id, 
    departing_gate, 
    scheduled_departure,
    LEAD(scheduled_departure) OVER (
        PARTITION BY departure_airport_id, departing_gate 
        ORDER BY scheduled_departure
    ) AS next_departure
FROM flights;

-- MECHANICS: `LEAD()` reaches forward into the next row of the window partition, providing 
-- a clear chronological preview of downstream gate commitments.


-- ----------------------------------------------------------------------------
-- QUERY 09: Window Function - Look-Behind Carrier Operational Cadence
-- OBJECTIVE: Check elapsed timeline intervals between sequential flights for each airline.
-- ----------------------------------------------------------------------------
SELECT 
    airline_id, 
    flight_id, 
    scheduled_departure,
    LAG(scheduled_departure) OVER (
        PARTITION BY airline_id 
        ORDER BY scheduled_departure
    ) AS previous_departure
FROM flights;

-- MECHANICS: `LAG()` pulls values from the preceding data record within the 
-- airline boundary partition to analyze fleet turnaround pacing.


-- ----------------------------------------------------------------------------
-- QUERY 10: Nested Window Analysis - Fleet Capacity Leaderboard
-- OBJECTIVE: Calculate absolute flight volumes per carrier and rank them globally.
-- ----------------------------------------------------------------------------
SELECT 
    airline_name, 
    flight_count,
    RANK() OVER (ORDER BY flight_count DESC) AS airline_rank
FROM (
    SELECT 
        al.airline_name, 
        COUNT(f.flight_id) AS flight_count
    FROM airlines al
    INNER JOIN flights f ON al.airline_id = f.airline_id
    GROUP BY al.airline_name
) operational_summary;

-- MECHANICS: An inner summary inline-view pre-aggregates flights per carrier name. 
-- The outer layer applies global analytical ranking based on total operating volumes.

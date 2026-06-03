# Airport Operations & Passenger Booking Database System

## Project Overview
This repository contains a fully normalized relational database schema designed to manage complex, real-time aviation ecosystems. Built using **PostgreSQL**, the system accurately models the interconnected operational lifecycle of commercial aviation, including flight management, global airport routing, passenger bookings, financial transactions, luggage weights, and airport security audits. 

The primary goal of this project is to demonstrate strong data modeling fundamentals, robust referential integrity, and structural schema design suitable for production-level database management or enterprise data analytics.

---

## Core Database Architecture
The database is structured into 10 highly interconnected tables handling data normalization, transactional integrity, and comprehensive audit tracking.

### 1. Flight & Aviation Logistics
* **`Airlines`**: Maps airline operators, industry standard codes, and countries of origin.
* **`Airport`**: Establishes global aviation hubs with precise geographic positioning (City, State, Country).
* **`Flights`**: The core operational table linking airlines to departure/arrival airports, tracking designated terminal gates, and comparing `scheduled` versus `actual` operational timelines.

### 2. Passenger & Transaction Ecosystem
* **`Passengers`**: Stores sensitive traveler demographic metadata, including contact foundations, date of birth, citizenship profiles, and passport identifiers.
* **`Booking`**: Captures passenger ticket transactions, filtering sales performance by platform channels, processing tracking states, and cataloging financial valuations (`price`).
* **`Booking_Flight`**: A dedicated junction table resolving the many-to-many relationship between individual bookings and scheduled flights.
* **`Boarding_Pass`**: Finalizes physical seating assignments mapped directly back to transaction pathways.

### 3. Safety, Security & Baggage Auditing
* **`Baggage`**: Tracks physical baggage allowances, recording exact weight thresholds in kilograms (`weight_in_kg`) associated with specific passenger bookings.
* **`Baggage_Check`**: Acts as a compliance ledger logging the outcomes of luggage processing stages mapped to both the booking and the specific passenger.
* **`Security_Check`**: A dedicated checkpoint logging table auditing security screening verification results (`check_result`) per traveler prior to boarding area entry.

---

## Technical Database Features
* **Referential Integrity**: Implements rigorous cascade chains and foreign key declarations to protect against orphaned operational or transaction records.
* **Audit Synchronization Trails**: Every core transactional and administrative entity contains automatic temporal tracking fields (`created_at`, `update_at` / `update_date`) to preserve transaction timing baselines.
* **Optimized Data Typings**: Utilizes targeted numeric precisions (such as `DECIMAL(7,2)` for financial transactions and `DECIMAL(4,2)` for baggage metrics) to guarantee storage efficiency and mathematical accuracy.

---

## Data Schema Quick Reference

| Table Name | Primary Key | Foreign Key Relations | Key Fields |
| :--- | :--- | :--- | :--- |
| **`Airlines`** | `airline_id` | *None* | `airline_code`, `airline_name` |
| **`Airport`** | `airport_id` | *None* | `airport_name`, `country`, `city` |
| **`Flights`** | `flight_id` | `airline_id`, `departure_airport_id`, `arrival_airport_id` | `scheduled_departure`, `departing_gate`, `status` |
| **`Passengers`** | `passenger_id` | *None* | `first_name`, `last_name`, `passport_number` |
| **`Booking`** | `booking_id` | `passenger_id` | `booking_platform`, `status`, `price` |
| **`Booking_Flight`** | `booking_flight_id` | `booking_id`, `flight_id` | Audit Timestamps |
| **`Boarding_Pass`** | `boarding_pass_id` | `booking_id` | `seat` |
| **`Baggage`** | `baggage_id` | `booking_id` | `weight_in_kg` |
| **`Baggage_Check`** | `baggage_check_id` | `booking_id`, `passenger_id` | `check_result` |
| **`Security_Check`** | `security_check_id` | `passenger_id` | `check_result` |

---

## Database Setup & Initialization

To instantiate this database schema locally in your PostgreSQL environment, execute the following commands:

1. **Clone the Repository:**
   ```bash
   git clone [https://github.com/your-username/your-repository-name.git](https://github.com/your-username/your-repository-name.git)
   cd your-repository-name

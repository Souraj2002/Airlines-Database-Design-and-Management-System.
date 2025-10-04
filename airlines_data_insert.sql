-- ============================================================================
-- AIRLINES DATABASE - SAMPLE DATA INSERTION
-- M.Sc. Statistics Project
-- ============================================================================
-- Description: Comprehensive sample data for statistical analysis
-- ============================================================================

USE airlines_db;

-- ============================================================================
-- Insert Airports
-- ============================================================================
INSERT INTO airports (airport_code, airport_name, city, state, country, timezone, latitude, longitude, elevation_ft) VALUES
('JFK', 'John F. Kennedy International Airport', 'New York', 'New York', 'USA', 'America/New_York', 40.641311, -73.778139, 13),
('LAX', 'Los Angeles International Airport', 'Los Angeles', 'California', 'USA', 'America/Los_Angeles', 33.942791, -118.410042, 125),
('ORD', 'O''Hare International Airport', 'Chicago', 'Illinois', 'USA', 'America/Chicago', 41.979595, -87.904464, 672),
('LHR', 'Heathrow Airport', 'London', NULL, 'UK', 'Europe/London', 51.469603, -0.453566, 83),
('CDG', 'Charles de Gaulle Airport', 'Paris', NULL, 'France', 'Europe/Paris', 49.009724, 2.547778, 392),
('DXB', 'Dubai International Airport', 'Dubai', NULL, 'UAE', 'Asia/Dubai', 25.252778, 55.364444, 62),
('SIN', 'Singapore Changi Airport', 'Singapore', NULL, 'Singapore', 'Asia/Singapore', 1.364167, 103.991531, 22),
('HND', 'Tokyo Haneda Airport', 'Tokyo', NULL, 'Japan', 'Asia/Tokyo', 35.552258, 139.779694, 35),
('SFO', 'San Francisco International Airport', 'San Francisco', 'California', 'USA', 'America/Los_Angeles', 37.621313, -122.378955, 13),
('MIA', 'Miami International Airport', 'Miami', 'Florida', 'USA', 'America/New_York', 25.795865, -80.287046, 8),
('DFW', 'Dallas/Fort Worth International Airport', 'Dallas', 'Texas', 'USA', 'America/Chicago', 32.899809, -97.040335, 607),
('ATL', 'Hartsfield-Jackson Atlanta International Airport', 'Atlanta', 'Georgia', 'USA', 'America/New_York', 33.640067, -84.427985, 1026),
('BOS', 'Boston Logan International Airport', 'Boston', 'Massachusetts', 'USA', 'America/New_York', 42.365855, -71.009624, 20),
('SEA', 'Seattle-Tacoma International Airport', 'Seattle', 'Washington', 'USA', 'America/Los_Angeles', 47.448889, -122.309444, 433),
('DEN', 'Denver International Airport', 'Denver', 'Colorado', 'USA', 'America/Denver', 39.861656, -104.673178, 5431);

-- ============================================================================
-- Insert Airlines
-- ============================================================================
INSERT INTO airlines (airline_code, airline_name, country, founded_year, headquarters, fleet_size) VALUES
('AA', 'American Airlines', 'USA', 1926, 'Fort Worth, Texas', 865),
('DL', 'Delta Air Lines', 'USA', 1924, 'Atlanta, Georgia', 750),
('UA', 'United Airlines', 'USA', 1926, 'Chicago, Illinois', 800),
('BA', 'British Airways', 'UK', 1974, 'London, England', 250),
('AF', 'Air France', 'France', 1933, 'Paris, France', 220),
('EK', 'Emirates', 'UAE', 1985, 'Dubai, UAE', 270),
('SQ', 'Singapore Airlines', 'Singapore', 1947, 'Singapore', 180),
('JL', 'Japan Airlines', 'Japan', 1951, 'Tokyo, Japan', 165);

-- ============================================================================
-- Insert Aircraft Types
-- ============================================================================
INSERT INTO aircraft_types (model_name, manufacturer, capacity_economy, capacity_business, capacity_first_class, cruise_speed_kmh, range_km, fuel_capacity_liters) VALUES
('Boeing 737-800', 'Boeing', 150, 12, 0, 850, 5765, 26020),
('Boeing 777-300ER', 'Boeing', 264, 42, 8, 905, 13649, 181283),
('Airbus A320', 'Airbus', 150, 12, 0, 840, 6150, 24210),
('Airbus A350-900', 'Airbus', 253, 40, 6, 910, 15000, 138000),
('Boeing 787-9', 'Boeing', 234, 30, 6, 913, 14140, 126206),
('Airbus A380', 'Airbus', 399, 76, 14, 903, 15200, 323546),
('Boeing 747-400', 'Boeing', 366, 63, 16, 913, 13450, 216840),
('Embraer E190', 'Embraer', 94, 6, 0, 829, 4537, 13000);

-- ============================================================================
-- Insert Aircraft
-- ============================================================================
INSERT INTO aircraft (aircraft_type_id, airline_id, registration_number, manufacture_date, last_maintenance_date, next_maintenance_date, status, total_flight_hours) VALUES
(1, 1, 'N801AA', '2015-03-15', '2024-09-01', '2025-03-01', 'active', 28500.50),
(2, 1, 'N802AA', '2018-06-20', '2024-08-15', '2025-02-15', 'active', 15200.25),
(3, 2, 'N803DL', '2016-05-10', '2024-09-10', '2025-03-10', 'active', 24100.75),
(4, 2, 'N804DL', '2019-08-25', '2024-07-20', '2025-01-20', 'active', 12800.00),
(5, 3, 'N805UA', '2017-11-12', '2024-09-05', '2025-03-05', 'active', 18900.50),
(6, 4, 'G-XLEB', '2014-02-18', '2024-08-25', '2024-12-25', 'maintenance', 32500.00),
(7, 5, 'F-GIUA', '2013-07-22', '2024-09-12', '2025-03-12', 'active', 35200.25),
(8, 6, 'A6-EUA', '2020-01-10', '2024-08-30', '2025-02-28', 'active', 8500.00),
(1, 3, 'N806UA', '2016-04-15', '2024-09-15', '2025-03-15', 'active', 26300.00),
(2, 4, 'G-XLEC', '2017-09-08', '2024-08-20', '2025-02-20', 'active', 19800.50);

-- ============================================================================
-- Insert Flight Schedules
-- ============================================================================
INSERT INTO flight_schedules (airline_id, flight_number, origin_airport, destination_airport, departure_time, arrival_time, duration_minutes, aircraft_type_id, operates_monday, operates_tuesday, operates_wednesday, operates_thursday, operates_friday, operates_saturday, operates_sunday, effective_from, effective_to) VALUES
(1, 'AA100', 'JFK', 'LAX', '08:00:00', '11:30:00', 330, 1, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, '2024-01-01', '2025-12-31'),
(1, 'AA200', 'LAX', 'JFK', '13:00:00', '21:30:00', 330, 1, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, '2024-01-01', '2025-12-31'),
(2, 'DL500', 'ATL', 'LAX', '09:00:00', '11:45:00', 285, 3, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, '2024-01-01', '2025-12-31'),
(2, 'DL600', 'LAX', 'ATL', '14:00:00', '21:45:00', 285, 3, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, '2024-01-01', '2025-12-31'),
(3, 'UA800', 'ORD', 'SFO', '07:30:00', '10:15:00', 285, 5, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, '2024-01-01', '2025-12-31'),
(3, 'UA900', 'SFO', 'ORD', '12:00:00', '18:15:00', 255, 5, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, '2024-01-01', '2025-12-31'),
(4, 'BA100', 'LHR', 'JFK', '10:00:00', '13:00:00', 480, 2, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, '2024-01-01', '2025-12-31'),
(4, 'BA200', 'JFK', 'LHR', '18:00:00', '06:00:00', 420, 2, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, '2024-01-01', '2025-12-31'),
(5, 'AF300', 'CDG', 'JFK', '11:00:00', '14:00:00', 480, 4, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, '2024-01-01', '2025-12-31'),
(6, 'EK500', 'DXB', 'LHR', '03:00:00', '07:30:00', 450, 6, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, '2024-01-01', '2025-12-31');

-- ============================================================================
-- Insert Flights (Sample for analysis)
-- ============================================================================
-- Generate flights for statistical analysis (multiple dates)
INSERT INTO flights (schedule_id, aircraft_id, flight_date, scheduled_departure, scheduled_arrival, actual_departure, actual_arrival, status, gate, terminal, delay_minutes) VALUES
-- September 2024 flights
(1, 1, '2024-09-01', '2024-09-01 08:00:00', '2024-09-01 11:30:00', '2024-09-01 08:15:00', '2024-09-01 11:45:00', 'arrived', 'A12', '4', 15),
(1, 1, '2024-09-02', '2024-09-02 08:00:00', '2024-09-02 11:30:00', '2024-09-02 08:05:00', '2024-09-02 11:35:00', 'arrived', 'A12', '4', 5),
(1, 1, '2024-09-03', '2024-09-03 08:00:00', '2024-09-03 11:30:00', '2024-09-03 08:45:00', '2024-09-03 12:15:00', 'arrived', 'A12', '4', 45),
(2, 1, '2024-09-01', '2024-09-01 13:00:00', '2024-09-01 21:30:00', '2024-09-01 13:10:00', '2024-09-01 21:40:00', 'arrived', 'B15', '5', 10),
(2, 1, '2024-09-02', '2024-09-02 13:00:00', '2024-09-02 21:30:00', '2024-09-02 13:00:00', '2024-09-02 21:30:00', 'arrived', 'B15', '5', 0),
(3, 3, '2024-09-01', '2024-09-01 09:00:00', '2024-09-01 11:45:00', '2024-09-01 09:20:00', '2024-09-01 12:05:00', 'arrived', 'C10', '2', 20),
(3, 3, '2024-09-02', '2024-09-02 09:00:00', '2024-09-02 11:45:00', NULL, NULL, 'cancelled', NULL, NULL, NULL),
(4, 3, '2024-09-01', '2024-09-01 14:00:00', '2024-09-01 21:45:00', '2024-09-01 14:05:00', '2024-09-01 21:50:00', 'arrived', 'D20', '3', 5),
(5, 5, '2024-09-01', '2024-09-01 07:30:00', '2024-09-01 10:15:00', '2024-09-01 07:30:00', '2024-09-01 10:15:00', 'arrived', 'E5', '1', 0),
(5, 5, '2024-09-02', '2024-09-02 07:30:00', '2024-09-02 10:15:00', '2024-09-02 07:35:00', '2024-09-02 10:20:00', 'arrived', 'E5', '1', 5),
-- October 2024 flights
(1, 1, '2024-10-01', '2024-10-01 08:00:00', '2024-10-01 11:30:00', '2024-10-01 08:10:00', '2024-10-01 11:40:00', 'arrived', 'A12', '4', 10),
(1, 1, '2024-10-02', '2024-10-02 08:00:00', '2024-10-02 11:30:00', '2024-10-02 09:30:00', '2024-10-02 13:00:00', 'arrived', 'A12', '4', 90),
(2, 1, '2024-10-01', '2024-10-01 13:00:00', '2024-10-01 21:30:00', '2024-10-01 13:05:00', '2024-10-01 21:35:00', 'arrived', 'B15', '5', 5),
(3, 3, '2024-10-01', '2024-10-01 09:00:00', '2024-10-01 11:45:00', '2024-10-01 09:10:00', '2024-10-01 11:55:00', 'arrived', 'C10', '2', 10),
(4, 3, '2024-10-01', '2024-10-01 14:00:00', '2024-10-01 21:45:00', '2024-10-01 14:00:00', '2024-10-01 21:45:00', 'arrived', 'D20', '3', 0),
(5, 5, '2024-10-01', '2024-10-01 07:30:00', '2024-10-01 10:15:00', '2024-10-01 08:00:00', '2024-10-01 10:45:00', 'arrived', 'E5', '1', 30),
(6, 5, '2024-10-01', '2024-10-01 12:00:00', '2024-10-01 18:15:00', '2024-10-01 12:00:00', '2024-10-01 18:15:00', 'arrived', 'E8', '1', 0),
(7, 10, '2024-10-01', '2024-10-01 10:00:00', '2024-10-01 13:00:00', '2024-10-01 10:15:00', '2024-10-01 13:15:00', 'arrived', 'F12', '5', 15);

-- ============================================================================
-- Insert Passengers
-- ============================================================================
INSERT INTO passengers (first_name, last_name, date_of_birth, gender, nationality, passport_number, email, phone, frequent_flyer_number, total_miles, membership_tier, registration_date) VALUES
('John', 'Smith', '1985-04-15', 'M', 'USA', 'P1234567', 'john.smith@email.com', '+1-555-0101', 'FF1001', 125000, 'gold', '2020-01-15'),
('Emma', 'Johnson', '1990-07-22', 'F', 'USA', 'P2345678', 'emma.j@email.com', '+1-555-0102', 'FF1002', 85000, 'silver', '2021-03-20'),
('Michael', 'Williams', '1978-11-08', 'M', 'UK', 'P3456789', 'michael.w@email.com', '+44-20-5550103', 'FF1003', 250000, 'platinum', '2018-06-10'),
('Sarah', 'Brown', '1992-02-14', 'F', 'Canada', 'P4567890', 'sarah.b@email.com', '+1-416-5550104', 'FF1004', 45000, 'silver', '2022-05-12'),
('David', 'Jones', '1988-09-30', 'M', 'USA', 'P5678901', 'david.j@email.com', '+1-555-0105', 'FF1005', 180000, 'gold', '2019-11-25'),
('Lisa', 'Garcia', '1995-06-18', 'F', 'Spain', 'P6789012', 'lisa.g@email.com', '+34-91-5550106', 'FF1006', 12000, 'standard', '2023-08-07'),
('Robert', 'Miller', '1982-12-25', 'M', 'USA', 'P7890123', 'robert.m@email.com', '+1-555-0107', 'FF1007', 95000, 'silver', '2020-09-18'),
('Jennifer', 'Davis', '1987-03-11', 'F', 'USA', 'P8901234', 'jennifer.d@email.com', '+1-555-0108', 'FF1008', 62000, 'silver', '2021-12-05'),
('William', 'Rodriguez', '1975-08-05', 'M', 'Mexico', 'P9012345', 'william.r@email.com', '+52-55-5550109', 'FF1009', 310000, 'platinum', '2017-04-22'),
('Maria', 'Martinez', '1993-10-20', 'F', 'USA', 'P0123456', 'maria.m@email.com', '+1-555-0110', 'FF1010', 28000, 'standard', '2023-02-14'),
('James', 'Anderson', '1991-01-17', 'M', 'Australia', 'P1234568', 'james.a@email.com', '+61-2-5550111', 'FF1011', 73000, 'silver', '2021-07-30'),
('Patricia', 'Taylor', '1986-05-09', 'F', 'USA', 'P2345679', 'patricia.t@email.com', '+1-555-0112', 'FF1012', 145000, 'gold', '2019-10-08'),
('Richard', 'Thomas', '1980-07-28', 'M', 'Canada', 'P3456780', 'richard.t@email.com', '+1-604-5550113', 'FF1013', 52000, 'silver', '2022-01-19'),
('Linda', 'Hernandez', '1994-12-03', 'F', 'USA', 'P4567891', 'linda.h@email.com', '+1-555-0114', 'FF1014', 38000, 'standard', '2023-04-25'),
('Charles', 'Moore', '1983-04-26', 'M', 'UK', 'P5678902', 'charles.m@email.com', '+44-20-5550115', 'FF1015', 198000, 'gold', '2018-12-11');

-- ============================================================================
-- Insert Bookings
-- ============================================================================
INSERT INTO bookings (booking_reference, passenger_id, booking_date, total_amount, payment_status, payment_method, booking_status) VALUES
('BK001A', 1, '2024-08-15 10:30:00', 450.00, 'confirmed', 'credit_card', 'confirmed'),
('BK002B', 2, '2024-08-16 14:22:00', 380.00, 'confirmed', 'debit_card', 'confirmed'),
('BK003C', 3, '2024-08-17 09:15:00', 1250.00, 'confirmed', 'credit_card', 'confirmed'),
('BK004D', 4, '2024-08-18 16:45:00', 520.00, 'confirmed', 'paypal', 'confirmed'),
('BK005E', 5, '2024-08-19 11:20:00', 890.00, 'confirmed', 'credit_card', 'confirmed'),
('BK006F', 6, '2024-08-20 13:30:00', 320.00, 'confirmed', 'debit_card', 'confirmed'),
('BK007G', 7, '2024-08-21 08:50:00', 675.00, 'confirmed', 'credit_card', 'confirmed'),
('BK008H', 8, '2024-08-22 15:10:00', 410.00, 'confirmed', 'credit_card', 'confirmed'),
('BK009I', 9, '2024-08-23 10:05:00', 2100.00, 'confirmed', 'credit_card', 'confirmed'),
('BK010J', 10, '2024-08-24 12:40:00', 295.00, 'confirmed', 'debit_card', 'confirmed'),
('BK011K', 11, '2024-08-25 09:25:00', 550.00, 'confirmed', 'paypal', 'confirmed'),
('BK012L', 12, '2024-08-26 14:55:00', 980.00, 'confirmed', 'credit_card', 'confirmed'),
('BK013M', 13, '2024-08-27 11:15:00', 465.00, 'confirmed', 'debit_card', 'confirmed'),
('BK014N', 14, '2024-08-28 16:20:00', 340.00, 'confirmed', 'credit_card', 'confirmed'),
('BK015O', 15, '2024-08-29 10:30:00', 1150.00, 'confirmed', 'credit_card', 'confirmed'),
('BK016P', 1, '2024-09-25 09:15:00', 480.00, 'confirmed', 'credit_card', 'confirmed'),
('BK017Q', 3, '2024-09-26 13:20:00', 1300.00, 'confirmed', 'credit_card', 'confirmed'),
('BK018R', 5, '2024-09-27 10:45:00', 920.00, 'confirmed', 'credit_card', 'confirmed');

-- ============================================================================
-- Insert Tickets
-- ============================================================================
INSERT INTO tickets (booking_id, flight_id, passenger_id, ticket_number, class_type, seat_number, fare_amount, baggage_allowance, checked_in, check_in_time, boarding_pass_issued) VALUES
(1, 1, 1, 'TK1000001', 'economy', '12A', 450.00, 23, TRUE, '2024-09-01 06:30:00', TRUE),
(2, 2, 2, 'TK1000002', 'economy', '15C', 380.00, 23, TRUE, '2024-09-02 06:45:00', TRUE),
(3, 3, 3, 'TK1000003', 'business', '2A', 1250.00, 32, TRUE, '2024-09-03 06:15:00', TRUE),
(4, 4, 4, 'TK1000004', 'economy', '18B', 520.00, 23, TRUE, '2024-09-01 11:30:00', TRUE),
(5, 5, 5, 'TK1000005', 'economy', '20D', 890.00, 23, TRUE, '2024-09-02 11:15:00', TRUE),
(6, 6, 6, 'TK1000006', 'economy', '22A', 320.00, 23, TRUE, '2024-09-01 07:20:00', TRUE),
(7, 8, 7, 'TK1000007', 'economy', '25C', 675.00, 23, TRUE, '2024-09-01 12:30:00', TRUE),
(8, 9, 8, 'TK1000008', 'economy', '8B', 410.00, 23, TRUE, '2024-09-01 05:50:00', TRUE),
(9, 10, 9, 'TK1000009', 'first_class', '1A', 2100.00, 50, TRUE, '2024-09-02 05:45:00', TRUE),
(10, 11, 10, 'TK1000010', 'economy', '14D', 295.00, 23, TRUE, '2024-10-01 06:20:00', TRUE),
(11, 12, 11, 'TK1000011', 'economy', '17A', 550.00, 23, TRUE, '2024-10-02 07:00:00', TRUE),
(12, 13, 12, 'TK1000012', 'business', '3C', 980.00, 32, TRUE, '2024-10-01 11:20:00', TRUE),
(13, 14, 13, 'TK1000013', 'economy', '19B', 465.00, 23, TRUE, '2024-10-01 07:30:00', TRUE),
(14, 15, 14, 'TK1000014', 'economy', '21D', 340.00, 23, TRUE, '2024-10-01 12:15:00', TRUE),
(15, 16, 15, 'TK1000015', 'business', '4A', 1150.00, 32, TRUE, '2024-10-01 10:20:00', TRUE);

-- ============================================================================
-- Insert Flight Prices
-- ============================================================================
INSERT INTO flight_prices (flight_id, class_type, base_price, current_price, available_seats) VALUES
(1, 'economy', 450.00, 450.00, 138),
(1, 'business', 1250.00, 1250.00, 12),
(2, 'economy', 380.00, 380.00, 142),
(2, 'business', 1100.00, 1100.00, 11),
(3, 'economy', 400.00, 520.00, 125),
(3, 'business', 1200.00, 1250.00, 10),
(4, 'economy', 350.00, 380.00, 140),
(4, 'business', 1050.00, 1100.00, 12),
(5, 'economy', 420.00, 450.00, 135),
(5, 'business', 1180.00, 1220.00, 11),
(6, 'economy', 310.00, 320.00, 148),
(6, 'business', 980.00, 1000.00, 12),
(8, 'economy', 330.00, 350.00, 145),
(8, 'business', 1020.00, 1050.00, 12),
(9, 'economy', 390.00, 410.00, 137),
(9, 'business', 1150.00, 1200.00, 11),
(10, 'economy', 280.00, 295.00, 150),
(10, 'business', 920.00, 950.00, 12);

-- ============================================================================
-- Insert Crew Members
-- ============================================================================
INSERT INTO crew_members (first_name, last_name, date_of_birth, gender, nationality, employee_id, role, hire_date, license_number, license_expiry, total_flight_hours, status, base_airport) VALUES
('Captain', 'Anderson', '1975-06-12', 'M', 'USA', 'EMP1001', 'captain', '2000-03-15', 'ATP123456', '2026-06-12', 12500.00, 'active', 'JFK'),
('First Officer', 'Bradley', '1982-09-20', 'M', 'USA', 'EMP1002', 'first_officer', '2008-07-22', 'ATP234567', '2026-09-20', 8200.00, 'active', 'JFK'),
('Captain', 'Chen', '1978-03-08', 'F', 'USA', 'EMP1003', 'captain', '2002-11-10', 'ATP345678', '2026-03-08', 11800.00, 'active', 'LAX'),
('First Officer', 'Davis', '1985-12-15', 'M', 'USA', 'EMP1004', 'first_officer', '2010-05-18', 'ATP456789', '2027-12-15', 7500.00, 'active', 'LAX'),
('Sarah', 'Edwards', '1988-07-22', 'F', 'USA', 'EMP2001', 'cabin_crew_lead', '2012-04-10', NULL, NULL, 5200.00, 'active', 'JFK'),
('Mark', 'Foster', '1990-11-05', 'M', 'USA', 'EMP2002', 'cabin_crew', '2015-08-22', NULL, NULL, 3800.00, 'active', 'JFK'),
('Emily', 'Garcia', '1992-02-18', 'F', 'USA', 'EMP2003', 'cabin_crew', '2016-03-14', NULL, NULL, 3500.00, 'active', 'LAX'),
('Captain', 'Harrison', '1976-08-30', 'M', 'UK', 'EMP1005', 'captain', '2001-06-20', 'ATP567890', '2026-08-30', 13200.00, 'active', 'LHR'),
('First Officer', 'Ibrahim', '1983-04-12', 'M', 'UAE', 'EMP1006', 'first_officer', '2009-09-15', 'ATP678901', '2027-04-12', 7800.00, 'active', 'DXB'),
('Jessica', 'Kim', '1989-10-25', 'F', 'USA', 'EMP2004', 'cabin_crew_lead', '2013-11-08', NULL, NULL, 4600.00, 'active', 'ORD');

-- ============================================================================
-- Insert Crew Qualifications
-- ============================================================================
INSERT INTO crew_qualifications (crew_id, aircraft_type_id, certification_date, expiry_date, qualification_type) VALUES
(1, 1, '2015-03-15', '2026-03-15', 'type_rating'),
(1, 2, '2018-06-20', '2026-06-20', 'type_rating'),
(2, 1, '2016-05-10', '2026-05-10', 'type_rating'),
(3, 3, '2016-11-12', '2026-11-12', 'type_rating'),
(3, 4, '2019-08-25', '2027-08-25', 'type_rating'),
(4, 3, '2017-02-18', '2027-02-18', 'type_rating'),
(8, 2, '2014-07-22', '2026-07-22', 'type_rating'),
(8, 7, '2016-09-10', '2026-09-10', 'type_rating'),
(9, 6, '2020-01-10', '2028-01-10', 'type_rating');

-- ============================================================================
-- Insert Flight Crew Assignments
-- ============================================================================
INSERT INTO flight_crew_assignment (flight_id, crew_id, role) VALUES
(1, 1, 'captain'),
(1, 2, 'first_officer'),
(1, 5, 'cabin_crew_lead'),
(1, 6, 'cabin_crew'),
(2, 1, 'captain'),
(2, 2, 'first_officer'),
(2, 5, 'cabin_crew_lead'),
(2, 6, 'cabin_crew'),
(3, 1, 'captain'),
(3, 2, 'first_officer'),
(3, 5, 'cabin_crew_lead'),
(6, 3, 'captain'),
(6, 4, 'first_officer'),
(6, 7, 'cabin_crew_lead'),
(9, 3, 'captain'),
(9, 4, 'first_officer'),
(9, 7, 'cabin_crew_lead');

-- ============================================================================
-- Insert Baggage
-- ============================================================================
INSERT INTO baggage (ticket_id, baggage_tag, weight_kg, baggage_type, status, extra_charge) VALUES
(1, 'BAG1000001', 22.5, 'checked', 'arrived', 0.00),
(2, 'BAG1000002', 18.3, 'checked', 'arrived', 0.00),
(3, 'BAG1000003', 25.8, 'checked', 'arrived', 0.00),
(4, 'BAG1000004', 20.1, 'checked', 'arrived', 0.00),
(5, 'BAG1000005', 23.7, 'checked', 'arrived', 0.00),
(6, 'BAG1000006', 19.5, 'checked', 'arrived', 0.00),
(7, 'BAG1000007', 21.2, 'checked', 'arrived', 0.00),
(8, 'BAG1000008', 17.8, 'checked', 'arrived', 0.00),
(9, 'BAG1000009', 28.5, 'checked', 'arrived', 0.00),
(10, 'BAG1000010', 16.9, 'checked', 'arrived', 0.00);

-- ============================================================================
-- Insert Customer Feedback
-- ============================================================================
INSERT INTO customer_feedback (ticket_id, rating, service_rating, cleanliness_rating, food_rating, comfort_rating, comments, feedback_date) VALUES
(1, 4, 5, 4, 3, 4, 'Good flight overall, friendly crew. Food could be better.', '2024-09-02 14:30:00'),
(2, 5, 5, 5, 4, 5, 'Excellent service! Very comfortable flight.', '2024-09-03 10:15:00'),
(3, 5, 5, 5, 5, 5, 'Outstanding business class experience. Will fly again!', '2024-09-04 09:20:00'),
(4, 3, 3, 4, 3, 3, 'Average experience. Nothing special.', '2024-09-02 16:45:00'),
(5, 4, 4, 4, 4, 4, 'Solid flight. Everything went smoothly.', '2024-09-03 12:30:00'),
(6, 2, 2, 3, 2, 3, 'Disappointed with the service. Long delays and poor communication.', '2024-09-02 18:20:00'),
(7, 4, 5, 4, 4, 4, 'Great crew members, very helpful and professional.', '2024-09-02 20:15:00'),
(8, 5, 5, 5, 4, 5, 'Perfect flight! On time and comfortable.', '2024-09-02 13:45:00'),
(9, 5, 5, 5, 5, 5, 'First class was amazing! Worth every penny.', '2024-09-03 15:30:00'),
(10, 4, 4, 4, 3, 4, 'Good value for money. Would recommend.', '2024-10-02 11:20:00');

-- ============================================================================
-- Insert Maintenance Logs
-- ============================================================================
INSERT INTO maintenance_logs (aircraft_id, maintenance_date, maintenance_type, description, duration_hours, cost, performed_by, next_maintenance_due) VALUES
(1, '2024-09-01', 'routine', 'Regular A-check inspection and minor repairs', 8.5, 15000.00, 'MaintenanceCo USA', '2025-03-01'),
(2, '2024-08-15', 'routine', 'Scheduled maintenance - engine inspection', 12.0, 28000.00, 'MaintenanceCo USA', '2025-02-15'),
(3, '2024-09-10', 'inspection', 'Annual safety inspection', 6.0, 8500.00, 'MaintenanceCo USA', '2025-03-10'),
(4, '2024-07-20', 'routine', 'B-check maintenance', 24.0, 45000.00, 'MaintenanceCo USA', '2025-01-20'),
(5, '2024-09-05', 'repair', 'Landing gear hydraulic system repair', 16.5, 32000.00, 'MaintenanceCo USA', '2025-03-05'),
(6, '2024-08-25', 'upgrade', 'Avionics system upgrade', 48.0, 125000.00, 'TechAviation Ltd', '2024-12-25');

-- ============================================================================
-- Insert Flight Incidents
-- ============================================================================
INSERT INTO flight_incidents (flight_id, incident_date, incident_type, severity, description, resolved, resolution_details) VALUES
(3, '2024-09-03 09:30:00', 'technical', 'minor', 'Minor cabin pressure fluctuation detected, resolved in-flight', TRUE, 'Crew adjusted pressurization system. Aircraft landed safely.'),
(6, '2024-09-01 10:15:00', 'medical', 'moderate', 'Passenger experienced chest pain mid-flight', TRUE, 'Medical personnel on board provided assistance. Paramedics met aircraft upon landing.'),
(12, '2024-10-02 10:30:00', 'weather', 'minor', 'Light turbulence encountered at cruising altitude', TRUE, 'Seatbelt sign activated. Flight proceeded normally.');

-- ============================================================================
-- DATA INSERTION COMPLETE
-- ============================================================================
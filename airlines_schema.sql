-- ============================================================================
-- AIRLINES DATABASE MANAGEMENT SYSTEM
-- M.Sc. Statistics Project
-- Database Schema Creation Script
-- ============================================================================
-- Description: Comprehensive airline operations database with statistical
--              analysis capabilities for flights, passengers, crew, and reservations
-- Author: M.Sc. Statistics Student
-- Date: October 2025
-- ============================================================================

-- Drop existing database if exists
DROP DATABASE IF EXISTS airlines_db;
CREATE DATABASE airlines_db;
USE airlines_db;

-- ============================================================================
-- SECTION 1: CORE ENTITIES
-- ============================================================================

-- Table: airports
-- Purpose: Store airport information worldwide
CREATE TABLE airports (
    airport_code CHAR(3) PRIMARY KEY,
    airport_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50),
    country VARCHAR(50) NOT NULL,
    timezone VARCHAR(50),
    latitude DECIMAL(10, 6),
    longitude DECIMAL(10, 6),
    elevation_ft INT,
    INDEX idx_city (city),
    INDEX idx_country (country)
);

-- Table: airlines
-- Purpose: Store airline company information
CREATE TABLE airlines (
    airline_id INT PRIMARY KEY AUTO_INCREMENT,
    airline_code CHAR(2) UNIQUE NOT NULL,
    airline_name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    founded_year INT,
    headquarters VARCHAR(100),
    fleet_size INT DEFAULT 0,
    INDEX idx_airline_code (airline_code)
);

-- Table: aircraft_types
-- Purpose: Store different aircraft models and specifications
CREATE TABLE aircraft_types (
    aircraft_type_id INT PRIMARY KEY AUTO_INCREMENT,
    model_name VARCHAR(50) NOT NULL,
    manufacturer VARCHAR(50) NOT NULL,
    capacity_economy INT NOT NULL,
    capacity_business INT NOT NULL,
    capacity_first_class INT NOT NULL,
    total_capacity INT GENERATED ALWAYS AS (capacity_economy + capacity_business + capacity_first_class) STORED,
    cruise_speed_kmh INT,
    range_km INT,
    fuel_capacity_liters INT,
    INDEX idx_model (model_name)
);

-- Table: aircraft
-- Purpose: Store individual aircraft in the fleet
CREATE TABLE aircraft (
    aircraft_id INT PRIMARY KEY AUTO_INCREMENT,
    aircraft_type_id INT NOT NULL,
    airline_id INT NOT NULL,
    registration_number VARCHAR(20) UNIQUE NOT NULL,
    manufacture_date DATE,
    last_maintenance_date DATE,
    next_maintenance_date DATE,
    status ENUM('active', 'maintenance', 'retired') DEFAULT 'active',
    total_flight_hours DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (aircraft_type_id) REFERENCES aircraft_types(aircraft_type_id),
    FOREIGN KEY (airline_id) REFERENCES airlines(airline_id),
    INDEX idx_status (status),
    INDEX idx_next_maintenance (next_maintenance_date)
);

-- ============================================================================
-- SECTION 2: FLIGHT OPERATIONS
-- ============================================================================

-- Table: flight_schedules
-- Purpose: Store recurring flight schedule information
CREATE TABLE flight_schedules (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    airline_id INT NOT NULL,
    flight_number VARCHAR(10) NOT NULL,
    origin_airport CHAR(3) NOT NULL,
    destination_airport CHAR(3) NOT NULL,
    departure_time TIME NOT NULL,
    arrival_time TIME NOT NULL,
    duration_minutes INT NOT NULL,
    aircraft_type_id INT NOT NULL,
    operates_monday BOOLEAN DEFAULT FALSE,
    operates_tuesday BOOLEAN DEFAULT FALSE,
    operates_wednesday BOOLEAN DEFAULT FALSE,
    operates_thursday BOOLEAN DEFAULT FALSE,
    operates_friday BOOLEAN DEFAULT FALSE,
    operates_saturday BOOLEAN DEFAULT FALSE,
    operates_sunday BOOLEAN DEFAULT FALSE,
    effective_from DATE NOT NULL,
    effective_to DATE,
    FOREIGN KEY (airline_id) REFERENCES airlines(airline_id),
    FOREIGN KEY (origin_airport) REFERENCES airports(airport_code),
    FOREIGN KEY (destination_airport) REFERENCES airports(airport_code),
    FOREIGN KEY (aircraft_type_id) REFERENCES aircraft_types(aircraft_type_id),
    UNIQUE KEY uk_flight (airline_id, flight_number, origin_airport, destination_airport),
    INDEX idx_origin (origin_airport),
    INDEX idx_destination (destination_airport),
    INDEX idx_flight_number (flight_number)
);

-- Table: flights
-- Purpose: Store actual flight instances
CREATE TABLE flights (
    flight_id INT PRIMARY KEY AUTO_INCREMENT,
    schedule_id INT NOT NULL,
    aircraft_id INT NOT NULL,
    flight_date DATE NOT NULL,
    scheduled_departure DATETIME NOT NULL,
    scheduled_arrival DATETIME NOT NULL,
    actual_departure DATETIME,
    actual_arrival DATETIME,
    status ENUM('scheduled', 'boarding', 'departed', 'in_air', 'landed', 'arrived', 'cancelled', 'delayed') DEFAULT 'scheduled',
    gate VARCHAR(10),
    terminal VARCHAR(10),
    delay_minutes INT DEFAULT 0,
    cancellation_reason VARCHAR(200),
    FOREIGN KEY (schedule_id) REFERENCES flight_schedules(schedule_id),
    FOREIGN KEY (aircraft_id) REFERENCES aircraft(aircraft_id),
    INDEX idx_flight_date (flight_date),
    INDEX idx_status (status),
    INDEX idx_scheduled_departure (scheduled_departure),
    INDEX idx_delay (delay_minutes)
);

-- Table: flight_prices
-- Purpose: Store dynamic pricing for different flight classes
CREATE TABLE flight_prices (
    price_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_id INT NOT NULL,
    class_type ENUM('economy', 'business', 'first_class') NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL,
    current_price DECIMAL(10, 2) NOT NULL,
    available_seats INT NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id),
    UNIQUE KEY uk_flight_class (flight_id, class_type),
    INDEX idx_class (class_type)
);

-- ============================================================================
-- SECTION 3: PASSENGERS AND BOOKINGS
-- ============================================================================

-- Table: passengers
-- Purpose: Store passenger information
CREATE TABLE passengers (
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('M', 'F', 'Other') NOT NULL,
    nationality VARCHAR(50) NOT NULL,
    passport_number VARCHAR(20) UNIQUE,
    email VARCHAR(100),
    phone VARCHAR(20),
    frequent_flyer_number VARCHAR(20) UNIQUE,
    total_miles INT DEFAULT 0,
    membership_tier ENUM('standard', 'silver', 'gold', 'platinum') DEFAULT 'standard',
    registration_date DATE DEFAULT (CURRENT_DATE),
    INDEX idx_email (email),
    INDEX idx_frequent_flyer (frequent_flyer_number),
    INDEX idx_membership (membership_tier)
);

-- Table: bookings
-- Purpose: Store reservation information
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_reference VARCHAR(10) UNIQUE NOT NULL,
    passenger_id INT NOT NULL,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('pending', 'confirmed', 'failed', 'refunded') DEFAULT 'pending',
    payment_method ENUM('credit_card', 'debit_card', 'paypal', 'bank_transfer', 'cash') NOT NULL,
    booking_status ENUM('confirmed', 'cancelled', 'completed') DEFAULT 'confirmed',
    FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id),
    INDEX idx_booking_date (booking_date),
    INDEX idx_payment_status (payment_status),
    INDEX idx_booking_reference (booking_reference)
);

-- Table: tickets
-- Purpose: Store individual ticket information for each flight segment
CREATE TABLE tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    flight_id INT NOT NULL,
    passenger_id INT NOT NULL,
    ticket_number VARCHAR(15) UNIQUE NOT NULL,
    class_type ENUM('economy', 'business', 'first_class') NOT NULL,
    seat_number VARCHAR(5),
    fare_amount DECIMAL(10, 2) NOT NULL,
    baggage_allowance INT DEFAULT 20,
    checked_in BOOLEAN DEFAULT FALSE,
    check_in_time DATETIME,
    boarding_pass_issued BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id),
    FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id),
    INDEX idx_flight (flight_id),
    INDEX idx_passenger (passenger_id),
    INDEX idx_checked_in (checked_in)
);

-- ============================================================================
-- SECTION 4: CREW MANAGEMENT
-- ============================================================================

-- Table: crew_members
-- Purpose: Store crew member information
CREATE TABLE crew_members (
    crew_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('M', 'F', 'Other') NOT NULL,
    nationality VARCHAR(50) NOT NULL,
    employee_id VARCHAR(20) UNIQUE NOT NULL,
    role ENUM('captain', 'first_officer', 'flight_engineer', 'cabin_crew_lead', 'cabin_crew') NOT NULL,
    hire_date DATE NOT NULL,
    license_number VARCHAR(50),
    license_expiry DATE,
    total_flight_hours DECIMAL(10, 2) DEFAULT 0,
    status ENUM('active', 'on_leave', 'training', 'retired') DEFAULT 'active',
    base_airport CHAR(3),
    FOREIGN KEY (base_airport) REFERENCES airports(airport_code),
    INDEX idx_role (role),
    INDEX idx_status (status),
    INDEX idx_base_airport (base_airport)
);

-- Table: crew_qualifications
-- Purpose: Store crew certifications and qualifications
CREATE TABLE crew_qualifications (
    qualification_id INT PRIMARY KEY AUTO_INCREMENT,
    crew_id INT NOT NULL,
    aircraft_type_id INT NOT NULL,
    certification_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    qualification_type ENUM('type_rating', 'instructor', 'examiner', 'medical') NOT NULL,
    FOREIGN KEY (crew_id) REFERENCES crew_members(crew_id),
    FOREIGN KEY (aircraft_type_id) REFERENCES aircraft_types(aircraft_type_id),
    INDEX idx_expiry (expiry_date)
);

-- Table: flight_crew_assignment
-- Purpose: Assign crew members to specific flights
CREATE TABLE flight_crew_assignment (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_id INT NOT NULL,
    crew_id INT NOT NULL,
    role ENUM('captain', 'first_officer', 'flight_engineer', 'cabin_crew_lead', 'cabin_crew') NOT NULL,
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id),
    FOREIGN KEY (crew_id) REFERENCES crew_members(crew_id),
    UNIQUE KEY uk_flight_crew_role (flight_id, crew_id),
    INDEX idx_flight (flight_id),
    INDEX idx_crew (crew_id)
);

-- ============================================================================
-- SECTION 5: OPERATIONAL DATA
-- ============================================================================

-- Table: maintenance_logs
-- Purpose: Track aircraft maintenance history
CREATE TABLE maintenance_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    aircraft_id INT NOT NULL,
    maintenance_date DATE NOT NULL,
    maintenance_type ENUM('routine', 'inspection', 'repair', 'upgrade', 'emergency') NOT NULL,
    description TEXT,
    duration_hours DECIMAL(5, 2),
    cost DECIMAL(10, 2),
    performed_by VARCHAR(100),
    next_maintenance_due DATE,
    FOREIGN KEY (aircraft_id) REFERENCES aircraft(aircraft_id),
    INDEX idx_aircraft (aircraft_id),
    INDEX idx_date (maintenance_date)
);

-- Table: flight_incidents
-- Purpose: Log any incidents during flights
CREATE TABLE flight_incidents (
    incident_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_id INT NOT NULL,
    incident_date DATETIME NOT NULL,
    incident_type ENUM('technical', 'medical', 'security', 'weather', 'bird_strike', 'other') NOT NULL,
    severity ENUM('minor', 'moderate', 'major', 'critical') NOT NULL,
    description TEXT,
    resolved BOOLEAN DEFAULT FALSE,
    resolution_details TEXT,
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id),
    INDEX idx_flight (flight_id),
    INDEX idx_severity (severity),
    INDEX idx_date (incident_date)
);

-- Table: baggage
-- Purpose: Track passenger baggage
CREATE TABLE baggage (
    baggage_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT NOT NULL,
    baggage_tag VARCHAR(15) UNIQUE NOT NULL,
    weight_kg DECIMAL(5, 2) NOT NULL,
    baggage_type ENUM('checked', 'cabin', 'special') NOT NULL,
    status ENUM('checked_in', 'loaded', 'in_transit', 'arrived', 'lost', 'found') DEFAULT 'checked_in',
    extra_charge DECIMAL(8, 2) DEFAULT 0,
    FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id),
    INDEX idx_ticket (ticket_id),
    INDEX idx_status (status)
);

-- Table: customer_feedback
-- Purpose: Store passenger feedback and ratings
CREATE TABLE customer_feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    service_rating INT CHECK (service_rating BETWEEN 1 AND 5),
    cleanliness_rating INT CHECK (cleanliness_rating BETWEEN 1 AND 5),
    food_rating INT CHECK (food_rating BETWEEN 1 AND 5),
    comfort_rating INT CHECK (comfort_rating BETWEEN 1 AND 5),
    comments TEXT,
    feedback_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id),
    INDEX idx_ticket (ticket_id),
    INDEX idx_rating (rating),
    INDEX idx_date (feedback_date)
);

-- ============================================================================
-- SECTION 6: AUDIT AND LOGGING
-- ============================================================================

-- Table: audit_log
-- Purpose: Track all database changes for compliance
CREATE TABLE audit_log (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(50) NOT NULL,
    operation_type ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    record_id INT NOT NULL,
    user_id VARCHAR(50),
    change_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    old_values JSON,
    new_values JSON,
    INDEX idx_table (table_name),
    INDEX idx_timestamp (change_timestamp)
);

-- ============================================================================
-- DATABASE CREATION COMPLETE
-- ============================================================================
-- ============================================================================
-- AIRLINES DATABASE - STATISTICAL ANALYSIS QUERIES
-- M.Sc. Statistics Project
-- ============================================================================
-- Description: Advanced statistical queries for airline operations analysis
-- Topics: Descriptive statistics, hypothesis testing, regression, time series
-- ============================================================================

USE airlines_db;

-- ============================================================================
-- SECTION 1: DESCRIPTIVE STATISTICS
-- ============================================================================

-- Query 1.1: Flight Delay Statistics by Airline
-- Calculate mean, median, mode, variance, and standard deviation
SELECT 
    a.airline_name,
    COUNT(f.flight_id) AS total_flights,
    ROUND(AVG(f.delay_minutes), 2) AS mean_delay,
    ROUND(STDDEV(f.delay_minutes), 2) AS std_dev_delay,
    ROUND(VARIANCE(f.delay_minutes), 2) AS variance_delay,
    MIN(f.delay_minutes) AS min_delay,
    MAX(f.delay_minutes) AS max_delay,
    -- Calculate percentiles for boxplot analysis
    (SELECT delay_minutes FROM flights WHERE delay_minutes IS NOT NULL 
     ORDER BY delay_minutes LIMIT 1 OFFSET (SELECT COUNT(*) FROM flights WHERE delay_minutes IS NOT NULL) * 25 / 100) AS Q1,
    (SELECT delay_minutes FROM flights WHERE delay_minutes IS NOT NULL 
     ORDER BY delay_minutes LIMIT 1 OFFSET (SELECT COUNT(*) FROM flights WHERE delay_minutes IS NOT NULL) * 50 / 100) AS median,
    (SELECT delay_minutes FROM flights WHERE delay_minutes IS NOT NULL 
     ORDER BY delay_minutes LIMIT 1 OFFSET (SELECT COUNT(*) FROM flights WHERE delay_minutes IS NOT NULL) * 75 / 100) AS Q3
FROM flights f
JOIN flight_schedules fs ON f.schedule_id = fs.schedule_id
JOIN airlines a ON fs.airline_id = a.airline_id
WHERE f.delay_minutes IS NOT NULL
GROUP BY a.airline_id, a.airline_name
ORDER BY mean_delay DESC;

-- Query 1.2: Distribution of Flight Classes
-- Analyze booking patterns and revenue by class
SELECT 
    t.class_type,
    COUNT(*) AS bookings_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM tickets), 2) AS percentage,
    ROUND(AVG(t.fare_amount), 2) AS avg_fare,
    ROUND(MIN(t.fare_amount), 2) AS min_fare,
    ROUND(MAX(t.fare_amount), 2) AS max_fare,
    ROUND(STDDEV(t.fare_amount), 2) AS std_dev_fare,
    ROUND(SUM(t.fare_amount), 2) AS total_revenue
FROM tickets t
GROUP BY t.class_type
ORDER BY avg_fare DESC;

-- Query 1.3: Passenger Demographics Analysis
SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) < 25 THEN '18-24'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) < 35 THEN '25-34'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) < 45 THEN '35-44'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) < 55 THEN '45-54'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) < 65 THEN '55-64'
        ELSE '65+'
    END AS age_group,
    gender,
    COUNT(*) AS passenger_count,
    ROUND(AVG(total_miles), 2) AS avg_miles,
    ROUND(STDDEV(total_miles), 2) AS std_dev_miles
FROM passengers
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- Query 1.4: Aircraft Utilization Statistics
SELECT 
    at.model_name,
    at.manufacturer,
    COUNT(DISTINCT a.aircraft_id) AS fleet_count,
    ROUND(AVG(a.total_flight_hours), 2) AS avg_flight_hours,
    ROUND(STDDEV(a.total_flight_hours), 2) AS std_dev_hours,
    MIN(a.total_flight_hours) AS min_hours,
    MAX(a.total_flight_hours) AS max_hours,
    COUNT(f.flight_id) AS total_flights
FROM aircraft_types at
JOIN aircraft a ON at.aircraft_type_id = a.aircraft_type_id
LEFT JOIN flights f ON a.aircraft_id = f.aircraft_id
GROUP BY at.aircraft_type_id, at.model_name, at.manufacturer
ORDER BY avg_flight_hours DESC;

-- ============================================================================
-- SECTION 2: CORRELATION ANALYSIS
-- ============================================================================

-- Query 2.1: Correlation between Delay and Route Distance
-- Using Pearson correlation coefficient approximation
WITH route_stats AS (
    SELECT 
        f.flight_id,
        f.delay_minutes,
        fs.duration_minutes AS flight_duration,
        ROUND(6371 * 2 * ASIN(SQRT(
            POWER(SIN((dest.latitude - orig.latitude) * PI() / 180 / 2), 2) +
            COS(orig.latitude * PI() / 180) * COS(dest.latitude * PI() / 180) *
            POWER(SIN((dest.longitude - orig.longitude) * PI() / 180 / 2), 2)
        )), 2) AS distance_km
    FROM flights f
    JOIN flight_schedules fs ON f.schedule_id = fs.schedule_id
    JOIN airports orig ON fs.origin_airport = orig.airport_code
    JOIN airports dest ON fs.destination_airport = dest.airport_code
    WHERE f.delay_minutes IS NOT NULL
)
SELECT 
    COUNT(*) AS sample_size,
    ROUND(AVG(delay_minutes), 2) AS avg_delay,
    ROUND(AVG(distance_km), 2) AS avg_distance,
    ROUND(
        (SUM(delay_minutes * distance_km) - SUM(delay_minutes) * SUM(distance_km) / COUNT(*)) /
        (SQRT(SUM(delay_minutes * delay_minutes) - POWER(SUM(delay_minutes), 2) / COUNT(*)) *
         SQRT(SUM(distance_km * distance_km) - POWER(SUM(distance_km), 2) / COUNT(*))),
    4) AS pearson_correlation
FROM route_stats;

-- Query 2.2: Customer Satisfaction vs Flight Performance
SELECT 
    CASE 
        WHEN f.delay_minutes = 0 THEN 'On Time'
        WHEN f.delay_minutes <= 15 THEN 'Slight Delay (1-15 min)'
        WHEN f.delay_minutes <= 30 THEN 'Moderate Delay (16-30 min)'
        ELSE 'Significant Delay (>30 min)'
    END AS delay_category,
    COUNT(cf.feedback_id) AS feedback_count,
    ROUND(AVG(cf.rating), 2) AS avg_overall_rating,
    ROUND(AVG(cf.service_rating), 2) AS avg_service_rating,
    ROUND(AVG(cf.comfort_rating), 2) AS avg_comfort_rating,
    ROUND(STDDEV(cf.rating), 2) AS std_dev_rating
FROM customer_feedback cf
JOIN tickets t ON cf.ticket_id = t.ticket_id
JOIN flights f ON t.flight_id = f.flight_id
GROUP BY delay_category
ORDER BY 
    CASE delay_category
        WHEN 'On Time' THEN 1
        WHEN 'Slight Delay (1-15 min)' THEN 2
        WHEN 'Moderate Delay (16-30 min)' THEN 3
        ELSE 4
    END;

-- Query 2.3: Price Elasticity Analysis
-- Relationship between price and seat occupancy
WITH flight_occupancy AS (
    SELECT 
        fp.flight_id,
        fp.class_type,
        fp.current_price,
        at.total_capacity,
        COUNT(t.ticket_id) AS seats_sold,
        ROUND((COUNT(t.ticket_id) * 100.0 / CASE fp.class_type
            WHEN 'economy' THEN at.capacity_economy
            WHEN 'business' THEN at.capacity_business
            ELSE at.capacity_first_class
        END), 2) AS occupancy_rate
    FROM flight_prices fp
    JOIN flights f ON fp.flight_id = f.flight_id
    JOIN aircraft a ON f.aircraft_id = a.aircraft_id
    JOIN aircraft_types at ON a.aircraft_type_id = at.aircraft_type_id
    LEFT JOIN tickets t ON f.flight_id = t.flight_id AND t.class_type = fp.class_type
    GROUP BY fp.flight_id, fp.class_type, fp.current_price, at.total_capacity, 
             at.capacity_economy, at.capacity_business, at.capacity_first_class
)
SELECT 
    class_type,
    ROUND(AVG(current_price), 2) AS avg_price,
    ROUND(AVG(occupancy_rate), 2) AS avg_occupancy_rate,
    ROUND(STDDEV(current_price), 2) AS std_dev_price,
    ROUND(STDDEV(occupancy_rate), 2) AS std_dev_occupancy,
    COUNT(*) AS sample_size
FROM flight_occupancy
GROUP BY class_type;

-- ============================================================================
-- SECTION 3: TIME SERIES ANALYSIS
-- ============================================================================

-- Query 3.1: Monthly Flight Trends
SELECT 
    DATE_FORMAT(flight_date, '%Y-%m') AS month,
    COUNT(*) AS total_flights,
    SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_flights,
    ROUND(AVG(delay_minutes), 2) AS avg_delay,
    ROUND(STDDEV(delay_minutes), 2) AS std_dev_delay,
    -- Calculate cancellation rate
    ROUND(SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS cancellation_rate
FROM flights
WHERE flight_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY DATE_FORMAT(flight_date, '%Y-%m')
ORDER BY month;

-- Query 3.2: Day-of-Week Performance Analysis
SELECT 
    DAYNAME(flight_date) AS day_of_week,
    DAYOFWEEK(flight_date) AS day_num,
    COUNT(*) AS total_flights,
    ROUND(AVG(delay_minutes), 2) AS avg_delay,
    ROUND(STDDEV(delay_minutes), 2) AS std_dev_delay,
    -- Calculate on-time performance (delays <= 15 minutes)
    ROUND(SUM(CASE WHEN delay_minutes <= 15 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS on_time_percentage
FROM flights
WHERE delay_minutes IS NOT NULL
GROUP BY day_of_week, day_num
ORDER BY day_num;

-- Query 3.3: Peak Travel Times Analysis
SELECT 
    HOUR(scheduled_departure) AS departure_hour,
    COUNT(*) AS flight_count,
    ROUND(AVG(delay_minutes), 2) AS avg_delay,
    COUNT(DISTINCT passenger_id) AS total_passengers
FROM flights f
JOIN tickets t ON f.flight_id = t.flight_id
WHERE f.delay_minutes IS NOT NULL
GROUP BY HOUR(scheduled_departure)
ORDER BY departure_hour;

-- ============================================================================
-- SECTION 4: HYPOTHESIS TESTING PREPARATION
-- ============================================================================

-- Query 4.1: Two-Sample T-Test Data Preparation
-- Compare delays between different aircraft types
SELECT 
    'Boeing' AS manufacturer_group,
    f.delay_minutes
FROM flights f
JOIN aircraft a ON f.aircraft_id = a.aircraft_id
JOIN aircraft_types at ON a.aircraft_type_id = at.aircraft_type_id
WHERE at.manufacturer = 'Boeing' AND f.delay_minutes IS NOT NULL

UNION ALL

SELECT 
    'Airbus' AS manufacturer_group,
    f.delay_minutes
FROM flights f
JOIN aircraft a ON f.aircraft_id = a.aircraft_id
JOIN aircraft_types at ON a.aircraft_type_id = at.aircraft_type_id
WHERE at.manufacturer = 'Airbus' AND f.delay_minutes IS NOT NULL;

-- Query 4.2: ANOVA Preparation - Compare Delays Across Airlines
SELECT 
    a.airline_name AS airline_group,
    f.delay_minutes,
    a.airline_id
FROM flights f
JOIN flight_schedules fs ON f.schedule_id = fs.schedule_id
JOIN airlines a ON fs.airline_id = a.airline_id
WHERE f.delay_minutes IS NOT NULL
ORDER BY a.airline_id, f.delay_minutes;

-- Query 4.3: Chi-Square Test Data - Flight Status by Time of Day
SELECT 
    CASE 
        WHEN HOUR(scheduled_departure) >= 6 AND HOUR(scheduled_departure) < 12 THEN 'Morning'
        WHEN HOUR(scheduled_departure) >= 12 AND HOUR(scheduled_departure) < 18 THEN 'Afternoon'
        WHEN HOUR(scheduled_departure) >= 18 AND HOUR(scheduled_departure) < 22 THEN 'Evening'
        ELSE 'Night'
    END AS time_period,
    CASE 
        WHEN delay_minutes = 0 THEN 'On Time'
        WHEN delay_minutes > 0 AND delay_minutes <= 30 THEN 'Delayed'
        ELSE 'Significant Delay'
    END AS delay_status,
    COUNT(*) AS frequency
FROM flights
WHERE delay_minutes IS NOT NULL AND status != 'cancelled'
GROUP BY time_period, delay_status
ORDER BY 
    CASE time_period 
        WHEN 'Morning' THEN 1 
        WHEN 'Afternoon' THEN 2 
        WHEN 'Evening' THEN 3 
        ELSE 4 
    END,
    delay_status;

-- ============================================================================
-- SECTION 5: REGRESSION ANALYSIS PREPARATION
-- ============================================================================

-- Query 5.1: Multiple Regression - Factors Affecting Ticket Price
SELECT 
    t.ticket_id,
    t.fare_amount AS dependent_var,
    t.class_type,
    TIMESTAMPDIFF(DAY, b.booking_date, f.flight_date) AS days_before_flight,
    f.delay_minutes,
    fs.duration_minutes AS flight_duration,
    p.membership_tier,
    ROUND(6371 * 2 * ASIN(SQRT(
        POWER(SIN((dest.latitude - orig.latitude) * PI() / 180 / 2), 2) +
        COS(orig.latitude * PI() / 180) * COS(dest.latitude * PI() / 180) *
        POWER(SIN((dest.longitude - orig.longitude) * PI() / 180 / 2), 2)
    )), 2) AS distance_km,
    DAYOFWEEK(f.flight_date) AS day_of_week,
    MONTH(f.flight_date) AS month
FROM tickets t
JOIN bookings b ON t.booking_id = b.booking_id
JOIN flights f ON t.flight_id = f.flight_id
JOIN flight_schedules fs ON f.schedule_id = fs.schedule_id
JOIN passengers p ON t.passenger_id = p.passenger_id
JOIN airports orig ON fs.origin_airport = orig.airport_code
JOIN airports dest ON fs.destination_airport = dest.airport_code;

-- Query 5.2: Logistic Regression - Predict Flight Cancellation
SELECT 
    f.flight_id,
    CASE WHEN f.status = 'cancelled' THEN 1 ELSE 0 END AS is_cancelled,
    MONTH(f.flight_date) AS month,
    DAYOFWEEK(f.flight_date) AS day_of_week,
    HOUR(f.scheduled_departure) AS departure_hour,
    fs.duration_minutes,
    a.total_flight_hours AS aircraft_age_hours,
    DATEDIFF(a.next_maintenance_date, f.flight_date) AS days_to_maintenance,
    COUNT(t.ticket_id) AS advance_bookings
FROM flights f
JOIN flight_schedules fs ON f.schedule_id = fs.schedule_id
JOIN aircraft a ON f.aircraft_id = a.aircraft_id
LEFT JOIN tickets t ON f.flight_id = t.flight_id
GROUP BY f.flight_id, f.status, f.flight_date, f.scheduled_departure, 
         fs.duration_minutes, a.total_flight_hours, a.next_maintenance_date;

-- ============================================================================
-- SECTION 6: REVENUE AND PROFITABILITY ANALYSIS
-- ============================================================================

-- Query 6.1: Revenue by Route
SELECT 
    CONCAT(fs.origin_airport, ' → ', fs.destination_airport) AS route,
    a.airline_name,
    COUNT(DISTINCT f.flight_id) AS total_flights,
    COUNT(t.ticket_id) AS tickets_sold,
    ROUND(SUM(t.fare_amount), 2) AS total_revenue,
    ROUND(AVG(t.fare_amount), 2) AS avg_ticket_price,
    ROUND(STDDEV(t.fare_amount), 2) AS std_dev_price,
    -- Calculate average load factor
    ROUND(COUNT(t.ticket_id) * 100.0 / (COUNT(DISTINCT f.flight_id) * at.total_capacity), 2) AS avg_load_factor
FROM flight_schedules fs
JOIN airlines a ON fs.airline_id = a.airline_id
JOIN flights f ON fs.schedule_id = f.schedule_id
LEFT JOIN tickets t ON f.flight_id = t.flight_id
JOIN aircraft_types at ON fs.aircraft_type_id = at.aircraft_type_id
GROUP BY fs.origin_airport, fs.destination_airport, a.airline_name, at.total_capacity
HAVING total_flights > 0
ORDER BY total_revenue DESC;

-- Query 6.2: Customer Lifetime Value Analysis
SELECT 
    p.passenger_id,
    CONCAT(p.first_name, ' ', p.last_name) AS passenger_name,
    p.membership_tier,
    COUNT(DISTINCT b.booking_id) AS total_bookings,
    COUNT(t.ticket_id) AS total_flights,
    ROUND(SUM(t.fare_amount), 2) AS total_spent,
    ROUND(AVG(t.fare_amount), 2) AS avg_transaction,
    ROUND(SUM(t.fare_amount) / COUNT(DISTINCT b.booking_id), 2) AS avg_booking_value,
    MIN(b.booking_date) AS first_booking_date,
    MAX(b.booking_date) AS last_booking_date,
    DATEDIFF(MAX(b.booking_date), MIN(b.booking_date)) AS customer_lifespan_days
FROM passengers p
JOIN bookings b ON p.passenger_id = b.passenger_id
JOIN tickets t ON b.booking_id = t.booking_id
GROUP BY p.passenger_id, p.first_name, p.last_name, p.membership_tier
HAVING total_bookings > 1
ORDER BY total_spent DESC;

-- Query 6.3: Profitability by Aircraft Type
SELECT 
    at.model_name,
    at.manufacturer,
    COUNT(DISTINCT f.flight_id) AS total_flights,
    ROUND(SUM(t.fare_amount), 2) AS total_revenue,
    ROUND(AVG(t.fare_amount), 2) AS avg_revenue_per_ticket,
    -- Estimate operational cost (simplified)
    ROUND(COUNT(DISTINCT f.flight_id) * fs.duration_minutes * 50, 2) AS estimated_fuel_cost,
    COUNT(t.ticket_id) AS total_passengers,
    ROUND(COUNT(t.ticket_id) * 100.0 / (COUNT(DISTINCT f.flight_id) * at.total_capacity), 2) AS avg_occupancy_rate
FROM aircraft_types at
JOIN aircraft a ON at.aircraft_type_id = a.aircraft_type_id
JOIN flights f ON a.aircraft_id = f.aircraft_id
JOIN flight_schedules fs ON f.schedule_id = fs.schedule_id
LEFT JOIN tickets t ON f.flight_id = t.flight_id
GROUP BY at.aircraft_type_id, at.model_name, at.manufacturer, at.total_capacity, fs.duration_minutes
ORDER BY total_revenue DESC;

-- ============================================================================
-- SECTION 7: ADVANCED STATISTICAL QUERIES
-- ============================================================================

-- Query 7.1: Moving Average of Daily Flights (7-day window)
WITH daily_flights AS (
    SELECT 
        flight_date,
        COUNT(*) AS flights_count,
        AVG(delay_minutes) AS avg_delay
    FROM flights
    WHERE flight_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
    GROUP BY flight_date
)
SELECT 
    df1.flight_date,
    df1.flights_count,
    ROUND(df1.avg_delay, 2) AS daily_avg_delay,
    ROUND(AVG(df2.flights_count), 2) AS moving_avg_flights_7day,
    ROUND(AVG(df2.avg_delay), 2) AS moving_avg_delay_7day
FROM daily_flights df1
JOIN daily_flights df2 ON df2.flight_date BETWEEN DATE_SUB(df1.flight_date, INTERVAL 6 DAY) AND df1.flight_date
GROUP BY df1.flight_date, df1.flights_count, df1.avg_delay
ORDER BY df1.flight_date;

-- Query 7.2: Cohort Analysis - Passenger Retention
WITH passenger_cohorts AS (
    SELECT 
        p.passenger_id,
        DATE_FORMAT(MIN(b.booking_date), '%Y-%m') AS cohort_month,
        DATE_FORMAT(b.booking_date, '%Y-%m') AS booking_month
    FROM passengers p
    JOIN bookings b ON p.passenger_id = b.passenger_id
    GROUP BY p.passenger_id, DATE_FORMAT(b.booking_date, '%Y-%m')
)
SELECT 
    cohort_month,
    booking_month,
    COUNT(DISTINCT passenger_id) AS active_passengers,
    PERIOD_DIFF(
        CAST(REPLACE(booking_month, '-', '') AS UNSIGNED),
        CAST(REPLACE(cohort_month, '-', '') AS UNSIGNED)
    ) AS months_since_first_booking
FROM passenger_cohorts
GROUP BY cohort_month, booking_month
ORDER BY cohort_month, booking_month;

-- Query 7.3: Outlier Detection - Abnormal Delays
WITH delay_stats AS (
    SELECT 
        AVG(delay_minutes) AS mean_delay,
        STDDEV(delay_minutes) AS std_delay
    FROM flights
    WHERE delay_minutes IS NOT NULL
)
SELECT 
    f.flight_id,
    fs.flight_number,
    a.airline_name,
    f.flight_date,
    f.delay_minutes,
    ROUND((f.delay_minutes - ds.mean_delay) / ds.std_delay, 2) AS z_score,
    CASE 
        WHEN ABS((f.delay_minutes - ds.mean_delay) / ds.std_delay) > 3 THEN 'Extreme Outlier'
        WHEN ABS((f.delay_minutes - ds.mean_delay) / ds.std_delay) > 2 THEN 'Outlier'
        ELSE 'Normal'
    END AS outlier_status
FROM flights f
JOIN flight_schedules fs ON f.schedule_id = fs.schedule_id
JOIN airlines a ON fs.airline_id = a.airline_id
CROSS JOIN delay_stats ds
WHERE f.delay_minutes IS NOT NULL
HAVING outlier_status != 'Normal'
ORDER BY ABS(z_score) DESC;

-- ============================================================================
-- SECTION 8: PREDICTIVE ANALYTICS QUERIES
-- ============================================================================

-- Query 8.1: Seasonal Decomposition - Identify Patterns
SELECT 
    YEAR(flight_date) AS year,
    MONTH(flight_date) AS month,
    QUARTER(flight_date) AS quarter,
    COUNT(*) AS flight_count,
    ROUND(AVG(delay_minutes), 2) AS avg_delay,
    SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_count,
    ROUND(COUNT(DISTINCT t.passenger_id) * 1.0 / COUNT(DISTINCT f.flight_id), 2) AS avg_passengers_per_flight
FROM flights f
LEFT JOIN tickets t ON f.flight_id = t.flight_id
GROUP BY YEAR(flight_date), MONTH(flight_date), QUARTER(flight_date)
ORDER BY year, month;

-- Query 8.2: Customer Segmentation - RFM Analysis
SELECT 
    p.passenger_id,
    CONCAT(p.first_name, ' ', p.last_name) AS passenger_name,
    -- Recency: Days since last flight
    DATEDIFF(CURDATE(), MAX(f.flight_date)) AS recency_days,
    -- Frequency: Number of flights
    COUNT(t.ticket_id) AS frequency,
    -- Monetary: Total spending
    ROUND(SUM(t.fare_amount), 2) AS monetary_value,
    -- Segment classification
    CASE 
        WHEN DATEDIFF(CURDATE(), MAX(f.flight_date)) <= 90 AND COUNT(t.ticket_id) >= 3 AND SUM(t.fare_amount) >= 1000 THEN 'Champions'
        WHEN DATEDIFF(CURDATE(), MAX(f.flight_date)) <= 180 AND COUNT(t.ticket_id) >= 2 THEN 'Loyal Customers'
        WHEN DATEDIFF(CURDATE(), MAX(f.flight_date)) > 365 THEN 'At Risk'
        ELSE 'Potential'
    END AS customer_segment
FROM passengers p
JOIN tickets t ON p.passenger_id = t.passenger_id
JOIN flights f ON t.flight_id = f.flight_id
GROUP BY p.passenger_id, p.first_name, p.last_name
ORDER BY monetary_value DESC;

-- ============================================================================
-- END OF STATISTICAL ANALYSIS QUERIES
-- ============================================================================
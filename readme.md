# Airlines Database Management System

## M.Sc. Statistics Project

**Author:** M.Sc. Statistics Student  
**Date:** October 2025  
**Database:** MySQL 8.0+

---

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Database Schema](#database-schema)
3. [Statistical Analysis Features](#statistical-analysis-features)
4. [Installation Guide](#installation-guide)
5. [Usage Instructions](#usage-instructions)
6. [Statistical Methodologies](#statistical-methodologies)
7. [Query Examples](#query-examples)
8. [Research Applications](#research-applications)
9. [Future Enhancements](#future-enhancements)
10. [References](#references)

---

## 🎯 Project Overview

### Purpose

This project implements a comprehensive relational database management system for airline operations with a strong emphasis on **statistical analysis** and **data-driven decision-making**. Designed specifically for M.Sc. Statistics students, it provides a realistic dataset for applying advanced statistical techniques to real-world business problems.

### Key Features

- **Fully Normalized Schema**: 3NF compliance ensuring data integrity and minimal redundancy
- **20+ Interconnected Tables**: Covering flights, passengers, crew, aircraft, and operations
- **Statistical Analysis Ready**: Pre-built queries for descriptive statistics, hypothesis testing, regression, and time series analysis
- **Rich Sample Data**: Realistic data across multiple dimensions for meaningful analysis
- **Performance Optimized**: Strategic indexing for fast query execution
- **Audit Trail**: Complete logging system for compliance and tracking

### Business Context

The database models a mid-sized international airline with:
- 8 airline companies
- 15 major airports across 6 countries
- 8 different aircraft types
- Multiple flight routes and schedules
- Comprehensive passenger booking system
- Complete crew management
- Maintenance tracking and incident reporting

---

## 🗄️ Database Schema

### Entity-Relationship Design

The database follows a star schema with dimension and fact tables optimized for both OLTP and OLAP operations.

#### Core Entities

**1. Airports**
- Stores global airport information
- Geographic coordinates for distance calculations
- Timezone data for scheduling

**2. Airlines**
- Company information
- Fleet size tracking
- Performance metrics

**3. Aircraft & Aircraft Types**
- Detailed aircraft specifications
- Capacity by class (Economy, Business, First)
- Maintenance history
- Utilization tracking

**4. Flight Operations**
- **flight_schedules**: Recurring flight patterns
- **flights**: Actual flight instances
- **flight_prices**: Dynamic pricing by class
- **flight_crew_assignment**: Crew rostering

**5. Passengers & Bookings**
- Passenger demographics and profiles
- Frequent flyer program integration
- Multi-segment booking support
- Payment tracking

**6. Crew Management**
- Crew member profiles
- Qualifications and certifications
- Flight hour tracking
- License management

**7. Operational Data**
- Maintenance logs
- Flight incidents
- Baggage tracking
- Customer feedback

### Normalization

The database is normalized to **Third Normal Form (3NF)**:

✅ **1NF**: All attributes are atomic, no repeating groups  
✅ **2NF**: No partial dependencies on composite keys  
✅ **3NF**: No transitive dependencies

**Example:** Flight pricing is separated into `flight_prices` table rather than being stored in the `flights` table, eliminating redundancy and update anomalies.

### Key Relationships

```
airlines (1) ──────< (M) flight_schedules (M) >────── (1) airports
     │                           │
     │                           │
     └─< aircraft               flights >─── tickets ─< bookings ─< passengers
            │                     │
            └── aircraft_types    └── flight_crew_assignment ─< crew_members
```

### Indexing Strategy

Strategic indexes for optimal query performance:

- **Primary Keys**: All tables (clustered index)
- **Foreign Keys**: All relationships
- **Frequently Queried Columns**: 
  - flight_date, scheduled_departure
  - booking_date, payment_status
  - airport codes, flight numbers
- **Statistical Columns**: delay_minutes, fare_amount, ratings

---

## 📊 Statistical Analysis Features

### 1. Descriptive Statistics

**Available Metrics:**
- Central Tendency: Mean, Median, Mode
- Dispersion: Variance, Standard Deviation, Range
- Shape: Skewness, Kurtosis
- Position: Percentiles, Quartiles, IQR

**Key Analyses:**
- Flight delay distributions by airline
- Fare price distributions by class
- Customer demographics
- Aircraft utilization patterns

### 2. Inferential Statistics

**Hypothesis Testing Preparation:**
- Two-sample t-tests (Boeing vs Airbus delays)
- ANOVA (delays across multiple airlines)
- Chi-square tests (categorical associations)
- Proportion tests (on-time performance)

**Correlation Analysis:**
- Pearson correlation (delay vs distance)
- Spearman rank correlation (ordinal variables)
- Multiple correlation matrices

### 3. Regression Analysis

**Linear Regression:**
- Ticket pricing models
- Delay prediction models
- Revenue forecasting

**Multiple Regression:**
- Factors affecting fare: distance, class, booking time, seasonality
- Performance metrics: delay factors, cancellation predictors

**Logistic Regression:**
- Flight cancellation probability
- Customer churn prediction
- Upgrade likelihood modeling

### 4. Time Series Analysis

**Components:**
- Trend analysis: Flight volume over time
- Seasonal decomposition: Monthly/quarterly patterns
- Moving averages: 7-day, 30-day windows
- Forecasting preparation: ARIMA-ready data

**Applications:**
- Demand forecasting
- Revenue trend analysis
- Operational efficiency tracking

### 5. Advanced Analytics

**Cohort Analysis:**
- Customer retention tracking
- Lifetime value calculation
- Churn analysis

**RFM Segmentation:**
- Recency: Days since last flight
- Frequency: Number of bookings
- Monetary: Total spending

**Outlier Detection:**
- Z-score calculation
- IQR method
- Statistical anomaly identification

---

## 🚀 Installation Guide

### Prerequisites

```bash
- MySQL 8.0 or higher
- MySQL Workbench (optional, recommended)
- Minimum 500MB free disk space
- Basic SQL knowledge
```

### Step-by-Step Installation

#### Method 1: Command Line

```bash
# 1. Login to MySQL
mysql -u root -p

# 2. Execute schema creation
source /path/to/airlines_schema.sql

# 3. Insert sample data
source /path/to/airlines_data_insert.sql

# 4. Verify installation
USE airlines_db;
SHOW TABLES;
SELECT COUNT(*) FROM flights;
```

#### Method 2: MySQL Workbench

1. Open MySQL Workbench
2. Connect to your MySQL server
3. Go to **File → Open SQL Script**
4. Select `airlines_schema.sql` and execute (⚡ Lightning icon)
5. Select `airlines_data_insert.sql` and execute
6. Verify tables in Navigator panel

### Verification

Run this verification query:

```sql
SELECT 
    'airlines' AS table_name, COUNT(*) AS record_count FROM airlines
UNION ALL
SELECT 'airports', COUNT(*) FROM airports
UNION ALL
SELECT 'flights', COUNT(*) FROM flights
UNION ALL
SELECT 'passengers', COUNT(*) FROM passengers
UNION ALL
SELECT 'bookings', COUNT(*) FROM bookings
UNION ALL
SELECT 'tickets', COUNT(*) FROM tickets;
```

Expected output: Multiple tables with data counts

---

## 📖 Usage Instructions

### Basic Queries

#### 1. View All Flights for a Specific Date

```sql
SELECT 
    fs.flight_number,
    a.airline_name,
    fs.origin_airport,
    fs.destination_airport,
    f.scheduled_departure,
    f.status,
    f.delay_minutes
FROM flights f
JOIN flight_schedules fs ON f.schedule_id = fs.schedule_id
JOIN airlines a ON fs.airline_id = a.airline_id
WHERE f.flight_date = '2024-09-01';
```

#### 2. Passenger Booking History

```sql
SELECT 
    p.first_name,
    p.last_name,
    b.booking_reference,
    b.booking_date,
    b.total_amount,
    COUNT(t.ticket_id) AS number_of_flights
FROM passengers p
JOIN bookings b ON p.passenger_id = b.passenger_id
JOIN tickets t ON b.booking_id = t.booking_id
WHERE p.email = 'john.smith@email.com'
GROUP BY p.first_name, p.last_name, b.booking_id, b.booking_reference, 
         b.booking_date, b.total_amount;
```

### Statistical Analysis Queries

#### 3. Calculate Flight Delay Statistics

```sql
SELECT 
    a.airline_name,
    COUNT(*) AS total_flights,
    ROUND(AVG(f.delay_minutes), 2) AS mean_delay,
    ROUND(STDDEV(f.delay_minutes), 2) AS std_dev,
    MIN(f.delay_minutes) AS min_delay,
    MAX(f.delay_minutes) AS max_delay
FROM flights f
JOIN flight_schedules fs ON f.schedule_id = fs.schedule_id
JOIN airlines a ON fs.airline_id = a.airline_id
WHERE f.delay_minutes IS NOT NULL
GROUP BY a.airline_name;
```

#### 4. Customer Satisfaction Analysis

```sql
SELECT 
    class_type,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(service_rating), 2) AS avg_service,
    ROUND(AVG(comfort_rating), 2) AS avg_comfort,
    COUNT(*) AS feedback_count
FROM customer_feedback cf
JOIN tickets t ON cf.ticket_id = t.ticket_id
GROUP BY class_type;
```

### Advanced Analytics

#### 5. Revenue Analysis by Route

```sql
SELECT 
    CONCAT(fs.origin_airport, ' → ', fs.destination_airport) AS route,
    COUNT(t.ticket_id) AS tickets_sold,
    ROUND(SUM(t.fare_amount), 2) AS total_revenue,
    ROUND(AVG(t.fare_amount), 2) AS avg_fare
FROM tickets t
JOIN flights f ON t.flight_id = f.flight_id
JOIN flight_schedules fs ON f.schedule_id = fs.schedule_id
GROUP BY route
ORDER BY total_revenue DESC
LIMIT 10;
```

#### 6. Predictive Maintenance Analysis

```sql
SELECT 
    a.registration_number,
    at.model_name,
    a.total_flight_hours,
    a.last_maintenance_date,
    a.next_maintenance_date,
    DATEDIFF(a.next_maintenance_date, CURDATE()) AS days_until_maintenance,
    CASE 
        WHEN DATEDIFF(a.next_maintenance_date, CURDATE()) < 30 THEN 'URGENT'
        WHEN DATEDIFF(a.next_maintenance_date, CURDATE()) < 60 THEN 'SOON'
        ELSE 'SCHEDULED'
    END AS maintenance_priority
FROM aircraft a
JOIN aircraft_types at ON a.aircraft_type_id = at.aircraft_type_id
WHERE a.status = 'active'
ORDER BY days_until_maintenance;
```

---

## 🔬 Statistical Methodologies

### Descriptive Statistics

**Purpose:** Summarize and describe the main features of the dataset

**Techniques Implemented:**
1. **Measures of Central Tendency**
   - Mean delay times across airlines
   - Median fare prices by route
   - Modal customer age groups

2. **Measures of Dispersion**
   - Standard deviation of delays
   - Variance in pricing strategies
   - Range of customer satisfaction scores

3. **Distribution Analysis**
   - Frequency distributions of flight times
   - Histogram data for passenger demographics
   - Percentile ranks for performance metrics

**R/Python Integration:**
Export query results and analyze using:

```r
# R Example
library(DBI)
library(RMySQL)

con <- dbConnect(MySQL(), 
                 user="root", 
                 password="your_password",
                 dbname="airlines_db", 
                 host="localhost")

# Query and analyze
delay_data <- dbGetQuery(con, "
  SELECT airline_name, delay_minutes 
  FROM flights f
  JOIN flight_schedules fs ON f.schedule_id = fs.schedule_id
  JOIN airlines a ON fs.airline_id = a.airline_id
  WHERE delay_minutes IS NOT NULL
")

# Statistical analysis
summary(delay_data$delay_minutes)
hist(delay_data$delay_minutes)
shapiro.test(delay_data$delay_minutes)  # Normality test
```

### Hypothesis Testing

**Research Questions Supported:**

1. **Two-Sample T-Test**
   - H₀: No difference in delay times between Boeing and Airbus aircraft
   - H₁: Significant difference exists
   - Query provided in statistical_analysis.sql

2. **ANOVA**
   - H₀: All airlines have equal mean delays
   - H₁: At least one airline differs significantly
   - F-statistic calculation ready

3. **Chi-Square Test**
   - Independence test: Flight delays vs. time of day
   - Goodness of fit: Expected vs. observed cancellations

**Statistical Power Considerations:**
- Sample sizes included in all queries
- Effect size calculations supported
- Confidence interval computations enabled

### Regression Models

**1. Simple Linear Regression**

Model: Fare = β₀ + β₁(Distance) + ε

```sql
-- Data extraction for regression
SELECT 
    ticket_id,
    fare_amount AS y,
    ROUND(6371 * 2 * ASIN(SQRT(
        POWER(SIN((dest.latitude - orig.latitude) * PI() / 180 / 2), 2) +
        COS(orig.latitude * PI() / 180) * COS(dest.latitude * PI() / 180) *
        POWER(SIN((dest.longitude - orig.longitude) * PI() / 180 / 2), 2)
    )), 2) AS x_distance
FROM tickets t
JOIN flights f ON t.flight_id = f.flight_id
JOIN flight_schedules fs ON f.schedule_id = fs.schedule_id
JOIN airports orig ON fs.origin_airport = orig.airport_code
JOIN airports dest ON fs.destination_airport = dest.airport_code;
```

**2. Multiple Regression**

Model: Fare = β₀ + β₁(Distance) + β₂(Days_Advance) + β₃(Class) + β₄(Season) + ε

Variables:
- Dependent: Ticket fare
- Independent: Distance, booking advance time, class type, seasonality, day of week

**3. Logistic Regression**

Model: P(Cancellation) = 1 / (1 + e^-(β₀ + β₁X₁ + ... + βₙXₙ))

Predicting binary outcomes:
- Flight cancellation probability
- Customer churn likelihood
- Upgrade acceptance prediction

### Time Series Analysis

**Components:**

1. **Trend:** Long-term movement in flight volumes
2. **Seasonality:** Regular patterns (monthly, quarterly)
3. **Cyclical:** Business cycle effects
4. **Random:** Irregular variations

**Decomposition Method:**

```sql
-- Seasonal decomposition query
SELECT 
    DATE_FORMAT(flight_date, '%Y-%m') AS month,
    COUNT(*) AS flight_count,
    AVG(COUNT(*)) OVER (ORDER BY DATE_FORMAT(flight_date, '%Y-%m') 
                        ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS trend,
    COUNT(*) - AVG(COUNT(*)) OVER (ORDER BY DATE_FORMAT(flight_date, '%Y-%m') 
                                   ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS seasonal_component
FROM flights
GROUP BY DATE_FORMAT(flight_date, '%Y-%m')
ORDER BY month;
```

**Forecasting Methods:**
- Moving averages (7-day, 30-day)
- Exponential smoothing
- ARIMA model preparation

### Correlation Analysis

**Pearson Correlation Coefficient:**

r = Σ[(X - X̄)(Y - Ȳ)] / √[Σ(X - X̄)² × Σ(Y - Ȳ)²]

**Implemented Correlations:**
1. Delay vs. Flight Distance
2. Price vs. Occupancy Rate
3. Customer Satisfaction vs. On-time Performance
4. Aircraft Age vs. Maintenance Frequency

**Interpretation Guidelines:**
- |r| > 0.7: Strong correlation
- 0.3 < |r| < 0.7: Moderate correlation
- |r| < 0.3: Weak correlation

---

## 💡 Query Examples

### Business Intelligence Queries

#### Top Performing Routes by Revenue

```sql
SELECT 
    CONCAT(fs.origin_airport, ' → ', fs.destination_airport) AS route,
    a.airline_name,
    COUNT(DISTINCT f.flight_id) AS total_flights,
    COUNT(t.ticket_id) AS passengers_carried,
    ROUND(SUM(t.fare_amount), 2) AS total_revenue,
    ROUND(AVG(fp.current_price), 2) AS avg_ticket_price,
    ROUND(COUNT(t.ticket_id) * 100.0 / 
          (COUNT(DISTINCT f.flight_id) * at.total_capacity), 2) AS load_factor_pct
FROM flight_schedules fs
JOIN airlines a ON fs.airline_id = a.airline_id
JOIN flights f ON fs.schedule_id = f.schedule_id
JOIN aircraft ac ON f.aircraft_id = ac.aircraft_id
JOIN aircraft_types at ON ac.aircraft_type_id = at.aircraft_type_id
LEFT JOIN tickets t ON f.flight_id = t.flight_id
LEFT JOIN flight_prices fp ON f.flight_id = fp.flight_id
WHERE f.status NOT IN ('cancelled')
GROUP BY route, a.airline_name, at.total_capacity
HAVING total_flights >= 3
ORDER BY total_revenue DESC
LIMIT 10;
```

#### Customer Segmentation Analysis

```sql
WITH customer_metrics AS (
    SELECT 
        p.passenger_id,
        CONCAT(p.first_name, ' ', p.last_name) AS name,
        p.membership_tier,
        COUNT(DISTINCT b.booking_id) AS booking_count,
        COUNT(t.ticket_id) AS flight_count,
        SUM(t.fare_amount) AS total_spent,
        MAX(f.flight_date) AS last_flight_date,
        DATEDIFF(CURDATE(), MAX(f.flight_date)) AS days_since_last_flight,
        AVG(DATEDIFF(f.flight_date, b.booking_date)) AS avg_booking_advance_days
    FROM passengers p
    JOIN bookings b ON p.passenger_id = b.passenger_id
    JOIN tickets t ON b.booking_id = t.booking_id
    JOIN flights f ON t.flight_id = f.flight_id
    GROUP BY p.passenger_id, p.first_name, p.last_name, p.membership_tier
)
SELECT 
    CASE 
        WHEN days_since_last_flight <= 60 AND total_spent >= 2000 THEN 'VIP Active'
        WHEN days_since_last_flight <= 90 AND booking_count >= 3 THEN 'Frequent Flyer'
        WHEN days_since_last_flight <= 180 THEN 'Regular Customer'
        WHEN days_since_last_flight <= 365 THEN 'Occasional Traveler'
        ELSE 'Inactive - Risk of Churn'
    END AS customer_segment,
    COUNT(*) AS customers_in_segment,
    ROUND(AVG(total_spent), 2) AS avg_lifetime_value,
    ROUND(AVG(flight_count), 1) AS avg_flights,
    ROUND(AVG(days_since_last_flight), 0) AS avg_days_since_last_flight
FROM customer_metrics
GROUP BY customer_segment
ORDER BY avg_lifetime_value DESC;
```

#### Operational Efficiency Dashboard

```sql
SELECT 
    a.airline_name,
    COUNT(DISTINCT f.flight_id) AS total_flights,
    -- On-time performance
    ROUND(SUM(CASE WHEN f.delay_minutes <= 15 THEN 1 ELSE 0 END) * 100.0 / 
          COUNT(f.flight_id), 2) AS on_time_performance_pct,
    -- Average delay
    ROUND(AVG(CASE WHEN f.delay_minutes > 0 THEN f.delay_minutes END), 2) AS avg_delay_when_delayed,
    -- Cancellation rate
    ROUND(SUM(CASE WHEN f.status = 'cancelled' THEN 1 ELSE 0 END) * 100.0 / 
          COUNT(f.flight_id), 2) AS cancellation_rate_pct,
    -- Customer satisfaction
    ROUND(AVG(cf.rating), 2) AS avg_customer_rating,
    -- Load factor
    ROUND(COUNT(t.ticket_id) * 100.0 / 
          (COUNT(DISTINCT f.flight_id) * AVG(at.total_capacity)), 2) AS avg_load_factor_pct,
    -- Revenue
    ROUND(SUM(t.fare_amount), 2) AS total_revenue
FROM airlines a
JOIN flight_schedules fs ON a.airline_id = fs.airline_id
JOIN flights f ON fs.schedule_id = f.schedule_id
JOIN aircraft ac ON f.aircraft_id = ac.aircraft_id
JOIN aircraft_types at ON ac.aircraft_type_id = at.aircraft_type_id
LEFT JOIN tickets t ON f.flight_id = t.flight_id
LEFT JOIN customer_feedback cf ON t.ticket_id = cf.ticket_id
GROUP BY a.airline_id, a.airline_name
ORDER BY on_time_performance_pct DESC;
```

---

## 🎓 Research Applications

### Suitable for M.Sc. Statistics Projects

#### 1. Predictive Modeling Projects

**Title:** "Predictive Models for Flight Delay Patterns"

**Research Questions:**
- Can we predict delays based on historical patterns?
- What factors contribute most to flight delays?
- How do weather patterns correlate with cancellations?

**Methods:**
- Multiple linear regression
- Random forests
- Neural networks
- Time series forecasting (ARIMA, Prophet)

**Deliverables:**
- Prediction accuracy metrics (RMSE, MAE)
- Feature importance analysis
- Model comparison study

#### 2. Customer Analytics Projects

**Title:** "Customer Lifetime Value and Churn Prediction in Airlines"

**Research Questions:**
- What factors influence customer loyalty?
- Can we predict which customers are likely to churn?
- How effective are loyalty programs?

**Methods:**
- Survival analysis
- Logistic regression
- Clustering (K-means, hierarchical)
- RFM segmentation

**Deliverables:**
- Churn probability models
- Customer segmentation strategy
- Retention recommendations

#### 3. Operations Research Projects

**Title:** "Optimization of Aircraft Scheduling and Resource Allocation"

**Research Questions:**
- How can we optimize fleet utilization?
- What is the optimal crew scheduling strategy?
- How to minimize turnaround times?

**Methods:**
- Linear programming
- Network optimization
- Simulation modeling
- Queuing theory

**Deliverables:**
- Cost-benefit analysis
- Optimization algorithms
- Simulation results

#### 4. Quality Control Projects

**Title:** "Statistical Process Control in Airline Operations"

**Research Questions:**
- Are delay patterns within statistical control?
- What are the key performance indicators?
- How to improve service quality?

**Methods:**
- Control charts (X-bar, R-chart, p-chart)
- Capability analysis
- Six Sigma methodologies
- ANOVA for quality factors

**Deliverables:**
- Control charts and monitoring systems
- Process capability indices
- Quality improvement recommendations

#### 5. Econometric Studies

**Title:** "Price Elasticity and Revenue Management in Aviation"

**Research Questions:**
- How does pricing affect demand?
- What is the optimal pricing strategy?
- How do competitors' prices impact bookings?

**Methods:**
- Demand elasticity estimation
- Panel data regression
- Instrumental variables
- Dynamic pricing models

**Deliverables:**
- Elasticity coefficients
- Revenue optimization strategies
- Pricing recommendations

---

## 📈 Performance Optimization

### Index Strategy

The database includes strategic indexes for:

```sql
-- Example: Check existing indexes
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) AS COLUMNS
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'airlines_db'
GROUP BY TABLE_NAME, INDEX_NAME;
```

### Query Optimization Tips

1. **Use EXPLAIN for query analysis:**
```sql
EXPLAIN SELECT * FROM flights WHERE flight_date = '2024-09-01';
```

2. **Avoid SELECT * in production:**
```sql
-- Bad
SELECT * FROM flights;

-- Good
SELECT flight_id, flight_number, status FROM flights;
```

3. **Use appropriate JOINs:**
```sql
-- Use INNER JOIN when you need matching records only
-- Use LEFT JOIN when you need all records from left table
```

4. **Leverage covering indexes:**
```sql
CREATE INDEX idx_flight_date_status ON flights(flight_date, status);
```

### Partitioning Strategy

For large-scale deployments, consider partitioning:

```sql
-- Partition flights table by date range
ALTER TABLE flights
PARTITION BY RANGE (YEAR(flight_date)) (
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);
```

---

## 🔐 Data Security & Privacy

### Best Practices Implemented

1. **Password Hashing:** Use SHA-256 for sensitive data
2. **Access Control:** Role-based permissions
3. **Audit Logging:** All changes tracked in audit_log table
4. **Data Masking:** PII protection in reports

### GDPR Compliance Considerations

```sql
-- Example: Right to be forgotten
DELIMITER //
CREATE PROCEDURE anonymize_passenger(IN p_id INT)
BEGIN
    UPDATE passengers 
    SET 
        first_name = 'REDACTED',
        last_name = 'REDACTED',
        email = CONCAT('deleted_', p_id, '@airline.com'),
        phone = NULL,
        passport_number = NULL
    WHERE passenger_id = p_id;
END //
DELIMITER ;
```

---

## 🚀 Future Enhancements

### Phase 2 Development

1. **Machine Learning Integration**
   - Python/R stored procedures
   - Real-time prediction APIs
   - Automated anomaly detection

2. **Visualization Dashboard**
   - Tableau/Power BI integration
   - Real-time KPI monitoring
   - Interactive reports

3. **Advanced Features**
   - Dynamic pricing algorithms
   - Network optimization
   - Weather data integration
   - Social media sentiment analysis

4. **Scalability**
   - NoSQL integration for unstructured data
   - Data warehousing (star schema)
   - ETL pipelines
   - Cloud deployment (AWS RDS, Azure SQL)

---

## 📚 References

### Database Design
- Date, C.J. (2019). *Database Design and Relational Theory*
- Elmasri, R. & Navathe, S. (2015). *Fundamentals of Database Systems*

### Statistical Methods
- Montgomery, D.C. (2019). *Introduction to Statistical Quality Control*
- James, G. et al. (2021). *An Introduction to Statistical Learning*
- Box, G.E.P. et al. (2015). *Time Series Analysis: Forecasting and Control*

### Aviation Industry
- Belobaba, P. et al. (2015). *The Global Airline Industry*
- Vasigh, B. et al. (2018). *Introduction to Air Transport Economics*

### Online Resources
- MySQL Documentation: https://dev.mysql.com/doc/
- Statistical Analysis: https://www.statology.org/
- R for Data Science: https://r4ds.had.co.nz/

---

## 👥 Contributing

This project is open for educational purposes. Suggestions for improvements:

1. Fork the repository
2. Create feature branch
3. Submit pull request with detailed description

---

## 📧 Contact & Support

For questions or issues:
- Email: your.email@university.edu
- GitHub Issues: [Project Repository]
- Office Hours: [Schedule]

---

## 📄 License

This project is licensed for educational use only.  
© 2025 M.Sc. Statistics Program

---

## 🎉 Acknowledgments

Special thanks to:
- Department of Statistics
- Database Systems course instructors
- Aviation industry data partners
- Open-source community

---

**Last Updated:** October 2025  
**Version:** 1.0  
**Status:** Production Ready

---

## Quick Start Checklist

- [ ] MySQL 8.0+ installed
- [ ] Execute `airlines_schema.sql`
- [ ] Execute `airlines_data_insert.sql`
- [ ] Verify data with sample queries
- [ ] Run statistical analysis queries
- [ ] Export data for R/Python analysis
- [ ] Begin your research project!

**Happy Analyzing! 📊✈️**
-- ============================================================
-- FILE: 02_customer_analytics.sql
-- PROJECT: Apple iTunes Music Store Analysis
-- PURPOSE: Customer behavior, spending, and retention analysis
-- ============================================================


-- Q1: Top 10 highest spending customers
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.country,
    ROUND(SUM(i.total), 2)             AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 10;


-- Q2: Average Customer Lifetime Value (CLV)
SELECT
    ROUND(AVG(customer_total), 2) AS avg_clv
FROM (
    SELECT customer_id, SUM(total) AS customer_total
    FROM invoice
    GROUP BY customer_id
);


-- Q3: Repeat vs One-time customers (with percentage)
SELECT
    purchase_type,
    COUNT(*)                                                      AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1)            AS percentage
FROM (
    SELECT
        customer_id,
        CASE WHEN COUNT(*) = 1 THEN 'One-time' ELSE 'Repeat' END AS purchase_type
    FROM invoice
    GROUP BY customer_id
)
GROUP BY purchase_type;


-- Q4: Revenue per country (top 10 countries)
SELECT
    c.country,
    COUNT(DISTINCT c.customer_id)                                  AS total_customers,
    ROUND(SUM(i.total), 2)                                         AS total_revenue,
    ROUND(SUM(i.total) / COUNT(DISTINCT c.customer_id), 2)         AS revenue_per_customer
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.country
ORDER BY total_revenue DESC
LIMIT 10;


-- Q5: Inactive customers (no purchase in last 2 years)
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    MAX(i.invoice_date)                AS last_purchase_date
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id
HAVING MAX(i.invoice_date) < DATE('now', '-2 years')
ORDER BY last_purchase_date ASC;

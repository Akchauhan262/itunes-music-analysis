-- ============================================================
-- FILE: 03_sales_revenue.sql
-- PROJECT: Apple iTunes Music Store Analysis
-- PURPOSE: Sales trends, invoice analysis, employee performance
-- ============================================================


-- Q6: Monthly revenue trends
SELECT
    STRFTIME('%Y-%m', invoice_date) AS month,
    COUNT(invoice_id)               AS total_invoices,
    ROUND(SUM(total), 2)            AS monthly_revenue
FROM invoice
GROUP BY month
ORDER BY month ASC;


-- Q7: Average, min, max invoice value
SELECT
    ROUND(AVG(total), 2) AS avg_invoice_value,
    ROUND(MIN(total), 2) AS min_invoice,
    ROUND(MAX(total), 2) AS max_invoice
FROM invoice;


-- Q8: Revenue by sales representative
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    e.title,
    COUNT(DISTINCT c.customer_id)      AS customers_handled,
    COUNT(i.invoice_id)                AS total_invoices,
    ROUND(SUM(i.total), 2)             AS total_revenue
FROM employee e
JOIN customer c ON e.employee_id  = c.support_rep_id
JOIN invoice  i ON c.customer_id  = i.customer_id
GROUP BY e.employee_id
ORDER BY total_revenue DESC;


-- Q9: Revenue by quarter (peak sales analysis)
SELECT
    STRFTIME('%Y', invoice_date) AS year,
    CASE
        WHEN STRFTIME('%m', invoice_date) IN ('01','02','03') THEN 'Q1'
        WHEN STRFTIME('%m', invoice_date) IN ('04','05','06') THEN 'Q2'
        WHEN STRFTIME('%m', invoice_date) IN ('07','08','09') THEN 'Q3'
        ELSE 'Q4'
    END                          AS quarter,
    ROUND(SUM(total), 2)         AS quarterly_revenue
FROM invoice
GROUP BY year, quarter
ORDER BY year, quarter;

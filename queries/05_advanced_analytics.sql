-- ============================================================
-- FILE: 05_advanced_analytics.sql
-- PROJECT: Apple iTunes Music Store Analysis
-- PURPOSE: Window functions, CTEs, geographic & advanced analysis
-- ============================================================


-- Q16: Customer revenue ranking (global)
SELECT
    c.first_name || ' ' || c.last_name        AS customer_name,
    c.country,
    ROUND(SUM(i.total), 2)                    AS total_spent,
    RANK() OVER (ORDER BY SUM(i.total) DESC)  AS revenue_rank
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id
ORDER BY revenue_rank;


-- Q17: Customer ranking within each country (PARTITION BY)
SELECT
    c.first_name || ' ' || c.last_name          AS customer_name,
    c.country,
    ROUND(SUM(i.total), 2)                      AS total_spent,
    RANK() OVER (
        PARTITION BY c.country
        ORDER BY SUM(i.total) DESC
    )                                            AS rank_in_country
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id
ORDER BY c.country, rank_in_country;


-- Q18: Running (cumulative) total revenue by month
SELECT
    STRFTIME('%Y-%m', invoice_date)    AS month,
    ROUND(SUM(total), 2)               AS monthly_revenue,
    ROUND(SUM(SUM(total)) OVER (
        ORDER BY STRFTIME('%Y-%m', invoice_date)
    ), 2)                              AS cumulative_revenue
FROM invoice
GROUP BY month
ORDER BY month;


-- Q19: Month-over-month revenue growth % (using LAG)
SELECT
    month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (ORDER BY month)   AS prev_month_revenue,
    ROUND(
        (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month))
        * 100.0 /
        LAG(monthly_revenue) OVER (ORDER BY month)
    , 1)                                          AS growth_pct
FROM (
    SELECT
        STRFTIME('%Y-%m', invoice_date) AS month,
        ROUND(SUM(total), 2)            AS monthly_revenue
    FROM invoice
    GROUP BY month
)
ORDER BY month;


-- Q20: Customer segmentation — VIP / Regular / Low Value (CTE)
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        c.country,
        ROUND(SUM(i.total), 2)             AS total_spent
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id
)
SELECT
    customer_name,
    country,
    total_spent,
    CASE
        WHEN total_spent >= 45 THEN 'VIP'
        WHEN total_spent <= 35 THEN 'Low Value'
        ELSE 'Regular'
    END AS customer_segment
FROM customer_spending
ORDER BY total_spent DESC;


-- Q21: Top artist per genre (CTE + RANK + PARTITION BY)
WITH artist_genre_revenue AS (
    SELECT
        g.name                                      AS genre,
        ar.name                                     AS artist,
        ROUND(SUM(il.unit_price * il.quantity), 2)  AS revenue,
        RANK() OVER (
            PARTITION BY g.genre_id
            ORDER BY SUM(il.unit_price * il.quantity) DESC
        )                                           AS rank_in_genre
    FROM genre g
    JOIN track        t  ON g.genre_id   = t.genre_id
    JOIN album        a  ON t.album_id   = a.album_id
    JOIN artist       ar ON a.artist_id  = ar.artist_id
    JOIN invoice_line il ON t.track_id   = il.track_id
    GROUP BY g.genre_id, ar.artist_id
)
SELECT genre, artist, revenue
FROM artist_genre_revenue
WHERE rank_in_genre = 1
ORDER BY revenue DESC;


-- Q22: Average time between purchases per customer (LAG + JULIANDAY)
WITH purchase_gaps AS (
    SELECT
        customer_id,
        invoice_date,
        LAG(invoice_date) OVER (
            PARTITION BY customer_id
            ORDER BY invoice_date
        )                                     AS prev_purchase_date,
        JULIANDAY(invoice_date) - JULIANDAY(
            LAG(invoice_date) OVER (
                PARTITION BY customer_id
                ORDER BY invoice_date
            )
        )                                     AS days_between
    FROM invoice
)
SELECT
    c.first_name || ' ' || c.last_name  AS customer_name,
    COUNT(*)                             AS total_purchases,
    ROUND(AVG(pg.days_between), 0)       AS avg_days_between_purchases
FROM purchase_gaps pg
JOIN customer c ON pg.customer_id = c.customer_id
WHERE pg.days_between IS NOT NULL
GROUP BY pg.customer_id
ORDER BY avg_days_between_purchases ASC;


-- Q23: Revenue by country with global share %
SELECT
    billing_country                                  AS country,
    COUNT(invoice_id)                                AS total_orders,
    ROUND(SUM(total), 2)                             AS total_revenue,
    ROUND(
        SUM(total) * 100.0 / SUM(SUM(total)) OVER()
    , 2)                                             AS global_revenue_share_pct
FROM invoice
GROUP BY billing_country
ORDER BY total_revenue DESC;


-- Q24: Most popular genre per country (CTE + PARTITION BY)
WITH country_genre AS (
    SELECT
        c.country,
        g.name                     AS genre,
        COUNT(il.invoice_line_id)  AS tracks_sold,
        RANK() OVER (
            PARTITION BY c.country
            ORDER BY COUNT(il.invoice_line_id) DESC
        )                          AS genre_rank
    FROM customer c
    JOIN invoice      i  ON c.customer_id = i.customer_id
    JOIN invoice_line il ON i.invoice_id  = il.invoice_id
    JOIN track        t  ON il.track_id   = t.track_id
    JOIN genre        g  ON t.genre_id    = g.genre_id
    GROUP BY c.country, g.genre_id
)
SELECT country, genre, tracks_sold
FROM country_genre
WHERE genre_rank = 1
ORDER BY tracks_sold DESC;

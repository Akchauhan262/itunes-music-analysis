-- ============================================================
-- FILE: 04_product_analysis.sql
-- PROJECT: Apple iTunes Music Store Analysis
-- PURPOSE: Track, genre, artist, and media type analysis
-- ============================================================


-- Q10: Top 10 revenue generating tracks
SELECT
    t.name                                     AS track_name,
    ar.name                                    AS artist_name,
    g.name                                     AS genre,
    COUNT(il.invoice_line_id)                  AS times_purchased,
    ROUND(SUM(il.unit_price * il.quantity), 2) AS total_revenue
FROM track t
JOIN invoice_line il ON t.track_id   = il.track_id
JOIN album a         ON t.album_id   = a.album_id
JOIN artist ar       ON a.artist_id  = ar.artist_id
JOIN genre g         ON t.genre_id   = g.genre_id
GROUP BY t.track_id
ORDER BY total_revenue DESC
LIMIT 10;


-- Q11: Tracks that have NEVER been purchased (dead inventory)
SELECT
    t.track_id,
    t.name       AS track_name,
    ar.name      AS artist_name,
    g.name       AS genre,
    t.unit_price
FROM track t
LEFT JOIN invoice_line il ON t.track_id  = il.track_id
JOIN album a              ON t.album_id  = a.album_id
JOIN artist ar            ON a.artist_id = ar.artist_id
JOIN genre g              ON t.genre_id  = g.genre_id
WHERE il.invoice_line_id IS NULL
ORDER BY ar.name;


-- Q12: Average track price by genre
SELECT
    g.name                        AS genre,
    COUNT(t.track_id)             AS total_tracks,
    ROUND(AVG(t.unit_price), 2)   AS avg_price,
    ROUND(MIN(t.unit_price), 2)   AS min_price,
    ROUND(MAX(t.unit_price), 2)   AS max_price
FROM genre g
JOIN track t ON g.genre_id = t.genre_id
GROUP BY g.genre_id
ORDER BY avg_price DESC;


-- Q13: Top 5 revenue generating artists
SELECT
    ar.name                                    AS artist_name,
    COUNT(DISTINCT t.track_id)                 AS tracks_sold,
    ROUND(SUM(il.unit_price * il.quantity), 2) AS total_revenue
FROM artist ar
JOIN album a         ON ar.artist_id = a.artist_id
JOIN track t         ON a.album_id   = t.album_id
JOIN invoice_line il ON t.track_id   = il.track_id
GROUP BY ar.artist_id
ORDER BY total_revenue DESC
LIMIT 5;


-- Q14: Genre popularity — tracks sold + revenue share %
SELECT
    g.name                                              AS genre,
    COUNT(il.invoice_line_id)                           AS tracks_sold,
    ROUND(SUM(il.unit_price * il.quantity), 2)          AS total_revenue,
    ROUND(
        SUM(il.unit_price * il.quantity) * 100.0 /
        SUM(SUM(il.unit_price * il.quantity)) OVER(), 1
    )                                                   AS revenue_share_pct
FROM genre g
JOIN track        t  ON g.genre_id  = t.genre_id
JOIN invoice_line il ON t.track_id  = il.track_id
GROUP BY g.genre_id
ORDER BY total_revenue DESC;


-- Q15: Media type usage and revenue share
SELECT
    mt.name                                              AS media_type,
    COUNT(il.invoice_line_id)                            AS times_purchased,
    ROUND(SUM(il.unit_price * il.quantity), 2)           AS total_revenue,
    ROUND(
        COUNT(il.invoice_line_id) * 100.0 /
        SUM(COUNT(il.invoice_line_id)) OVER(), 1
    )                                                    AS usage_pct
FROM media_type mt
JOIN track        t  ON mt.media_type_id = t.media_type_id
JOIN invoice_line il ON t.track_id       = il.track_id
GROUP BY mt.media_type_id
ORDER BY times_purchased DESC;

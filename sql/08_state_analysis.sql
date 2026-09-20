SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT c.customer_unique_id) AS total_customers,
    ROUND(SUM(i.price), 2) AS total_revenue,
    ROUND(SUM(i.price) / COUNT(DISTINCT o.order_id),2) AS avg_order_value
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
JOIN items AS i
    ON o.order_id = i.order_id
GROUP BY customer_state
ORDER BY total_revenue DESC;

SELECT
    c.customer_state,
    c.customer_city,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT c.customer_unique_id) AS total_customers,
    ROUND(SUM(i.price), 2) AS total_revenue,
    ROUND(SUM(i.price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id
JOIN items AS i ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state, c.customer_city
ORDER BY total_orders DESC;

SELECT
    g.geolocation_zip_code_prefix,
    ROUND(AVG(g.geolocation_lat), 6) AS latitude,
    ROUND(AVG(g.geolocation_lng), 6) AS longitude,
    COUNT(DISTINCT c.customer_unique_id) AS customers,
    ROUND(SUM(i.price), 2) AS revenue
FROM geolocation AS g
JOIN customers AS c ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
JOIN orders AS o ON o.customer_id = c.customer_id
JOIN items AS i ON i.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY g.geolocation_zip_code_prefix
ORDER BY revenue DESC;

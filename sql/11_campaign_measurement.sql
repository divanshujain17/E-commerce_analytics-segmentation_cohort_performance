USE ecommerce_analysis;

-- Campaign-ready audience counts and value estimates.
WITH customer_metrics AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(i.price) AS monetary,
        DATEDIFF(
            (SELECT MAX(order_purchase_timestamp) FROM orders),
            MAX(o.order_purchase_timestamp)
        ) AS recency_days
    FROM customers AS c
    JOIN orders AS o ON c.customer_id = o.customer_id
    JOIN items AS i ON o.order_id = i.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    CASE
        WHEN recency_days > 365 AND monetary >= 500 THEN 'Re-engage high-value customers'
        WHEN recency_days > 365 THEN 'Win back inactive customers'
        WHEN frequency > 1 THEN 'Reward loyal customers'
        WHEN recency_days <= 90 THEN 'Convert recent first-time buyers'
        ELSE 'Nurture regular customers'
    END AS campaign_audience,
    COUNT(*) AS customers,
    ROUND(SUM(monetary), 2) AS historical_revenue,
    ROUND(AVG(monetary), 2) AS average_customer_value
FROM customer_metrics
GROUP BY campaign_audience
ORDER BY historical_revenue DESC;

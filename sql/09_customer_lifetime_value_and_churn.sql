USE ecommerce_analysis;

-- Customer value, purchase cadence, Pareto rank, and churn-risk flag.
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,
        SUM(i.price) AS order_value,
        LAG(o.order_purchase_timestamp) OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS previous_purchase
    FROM customers AS c
    JOIN orders AS o ON c.customer_id = o.customer_id
    JOIN items AS i ON o.order_id = i.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, o.order_id, o.order_purchase_timestamp
), customer_value AS (
    SELECT
        customer_unique_id,
        COUNT(*) AS total_orders,
        SUM(order_value) AS total_revenue,
        AVG(DATEDIFF(order_purchase_timestamp, previous_purchase)) AS avg_days_between_purchases,
        MIN(order_purchase_timestamp) AS first_purchase_date,
        MAX(order_purchase_timestamp) AS last_purchase_date
    FROM customer_orders
    GROUP BY customer_unique_id
), ranked_customers AS (
    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
        COUNT(*) OVER () AS customer_count,
        SUM(total_revenue) OVER () AS overall_revenue,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue,
        DATEDIFF(
            (SELECT MAX(order_purchase_timestamp) FROM orders),
            last_purchase_date
        ) AS recency_days
    FROM customer_value
)
SELECT
    customer_unique_id,
    total_orders,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(total_revenue / NULLIF(total_orders, 0), 2) AS average_order_value,
    ROUND(avg_days_between_purchases, 1) AS avg_days_between_purchases,
    first_purchase_date,
    last_purchase_date,
    recency_days,
    revenue_rank,
    ROUND(100 * revenue_rank / customer_count, 2) AS customer_percentile,
    ROUND(100 * cumulative_revenue / overall_revenue, 2) AS cumulative_revenue_percent,
    CASE
        WHEN recency_days > 365 AND total_revenue >= 500 THEN 'High Value At Risk'
        WHEN recency_days > 365 THEN 'At Risk'
        WHEN total_orders > 1 AND total_revenue >= 500 THEN 'High Value Active'
        ELSE 'Regular Customers'
    END AS churn_segment
FROM ranked_customers
ORDER BY revenue_rank;

-- Average CLV by actionable segment.
WITH customer_value AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(i.price) AS total_revenue,
        DATEDIFF(MAX(o.order_purchase_timestamp), MIN(o.order_purchase_timestamp)) AS lifespan_days
    FROM customers AS c
    JOIN orders AS o ON c.customer_id = o.customer_id
    JOIN items AS i ON o.order_id = i.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    CASE
        WHEN total_orders > 1 AND total_revenue >= 500 THEN 'High Value Active'
        WHEN total_orders = 1 AND total_revenue >= 500 THEN 'High Value At Risk'
        WHEN total_orders > 1 THEN 'Regular Customers'
        ELSE 'One-Time Customers'
    END AS segment,
    COUNT(*) AS customers,
    ROUND(AVG(total_revenue), 2) AS average_clv,
    ROUND(AVG(lifespan_days), 1) AS average_lifespan_days
FROM customer_value
GROUP BY segment
ORDER BY average_clv DESC;

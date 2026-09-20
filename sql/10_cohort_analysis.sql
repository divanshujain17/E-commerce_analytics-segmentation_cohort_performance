USE ecommerce_analysis;

-- Monthly customer cohorts, retention, and revenue contribution.
WITH customer_cohort AS (
    SELECT
        c.customer_unique_id,
        DATE_FORMAT(MIN(o.order_purchase_timestamp), '%Y-%m-01') AS cohort_month
    FROM customers AS c
    JOIN orders AS o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
), customer_activity AS (
    SELECT DISTINCT
        c.customer_unique_id,
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01') AS purchase_month,
        SUM(i.price) AS order_revenue
    FROM customers AS c
    JOIN orders AS o ON c.customer_id = o.customer_id
    JOIN items AS i ON o.order_id = i.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, o.order_id, purchase_month
), cohort_activity AS (
    SELECT
        cc.cohort_month,
        TIMESTAMPDIFF(MONTH, cc.cohort_month, ca.purchase_month) AS months_since_first_purchase,
        COUNT(DISTINCT cc.customer_unique_id) AS active_customers,
        SUM(ca.order_revenue) AS revenue
    FROM customer_cohort AS cc
    JOIN customer_activity AS ca
        ON cc.customer_unique_id = ca.customer_unique_id
    GROUP BY cc.cohort_month, months_since_first_purchase
), cohort_size AS (
    SELECT cohort_month, MAX(active_customers) AS cohort_customers
    FROM cohort_activity
    WHERE months_since_first_purchase = 0
    GROUP BY cohort_month
)
SELECT
    ca.cohort_month,
    ca.months_since_first_purchase,
    ca.active_customers,
    cs.cohort_customers,
    ROUND(100 * ca.active_customers / cs.cohort_customers, 2) AS retention_rate,
    ROUND(ca.revenue, 2) AS revenue,
    ROUND(ca.revenue / NULLIF(ca.active_customers, 0), 2) AS revenue_per_active_customer
FROM cohort_activity AS ca
JOIN cohort_size AS cs ON ca.cohort_month = cs.cohort_month
ORDER BY ca.cohort_month, ca.months_since_first_purchase;

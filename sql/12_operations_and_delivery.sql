USE ecommerce_analysis;

-- Delivery and order-lifecycle KPIs. Revenue is limited to delivered orders
-- where a delivery timestamp is available.
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_status = 'delivered') AS delivered_orders,
    SUM(order_status = 'canceled') AS cancelled_orders,
    ROUND(AVG(CASE WHEN order_status = 'delivered'
        THEN DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) END), 2) AS avg_delivery_days,
    ROUND(100 * AVG(CASE WHEN order_status = 'delivered'
        THEN order_delivered_customer_date <= order_estimated_delivery_date END), 2) AS on_time_delivery_percent,
    SUM(order_status = 'delivered' AND order_delivered_customer_date > order_estimated_delivery_date) AS late_orders,
    ROUND(AVG(TIMESTAMPDIFF(HOUR, order_purchase_timestamp, order_approved_at)) / 24, 2) AS avg_approval_days,
    ROUND(AVG(TIMESTAMPDIFF(HOUR, order_approved_at, order_delivered_carrier_date)) / 24, 2) AS avg_processing_days,
    ROUND(AVG(TIMESTAMPDIFF(HOUR, order_delivered_carrier_date, order_delivered_customer_date)) / 24, 2) AS avg_carrier_to_customer_days
FROM orders;

-- Delivery performance by customer state.
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 2) AS avg_delivery_days,
    ROUND(100 * AVG(o.order_delivered_customer_date <= o.order_estimated_delivery_date), 2) AS on_time_percent,
    SUM(o.order_delivered_customer_date > o.order_estimated_delivery_date) AS late_orders
FROM orders AS o
JOIN customers AS c ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC;

-- Payment mix and installment behavior.
SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(payment_value), 2) AS payment_value,
    ROUND(AVG(payment_value), 2) AS average_transaction_value,
    ROUND(AVG(payment_installments), 2) AS average_installments
FROM transactions
GROUP BY payment_type
ORDER BY payment_value DESC;

-- Delivery performance by product category.
SELECT
        p.product_category_name AS category,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 2) AS avg_delivery_days,
        ROUND(100 * AVG(o.order_delivered_customer_date > o.order_estimated_delivery_date), 2) AS late_percent,
        ROUND(AVG(i.freight_value), 2) AS average_freight
FROM orders AS o
JOIN items AS i ON i.order_id = o.order_id
JOIN products AS p ON p.product_id = i.product_id
WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
GROUP BY p.product_category_name
ORDER BY late_percent DESC;

-- Payment method by category for transaction-level analysis.
SELECT
        p.product_category_name AS category,
        t.payment_type,
        COUNT(DISTINCT o.order_id) AS orders,
        ROUND(SUM(t.payment_value), 2) AS payment_value
FROM transactions AS t
JOIN orders AS o ON o.order_id = t.order_id
JOIN items AS i ON i.order_id = o.order_id
JOIN products AS p ON p.product_id = i.product_id
GROUP BY p.product_category_name, t.payment_type
ORDER BY payment_value DESC;
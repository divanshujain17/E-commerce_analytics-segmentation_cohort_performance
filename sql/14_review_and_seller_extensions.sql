USE ecommerce_analysis;

-- Optional extension. The current checkout does not include reviews or sellers.
-- Load olist_order_reviews_dataset.csv and olist_sellers_dataset.csv first,
-- using the table definitions below, then run the analysis queries.

CREATE TABLE IF NOT EXISTS reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

CREATE TABLE IF NOT EXISTS sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

-- Review score and delivery-delay relationship.
SELECT
    r.review_score,
    COUNT(*) AS reviews,
    ROUND(100 * AVG(o.order_delivered_customer_date > o.order_estimated_delivery_date), 2) AS late_order_percent
FROM reviews AS r
JOIN orders AS o ON o.order_id = r.order_id
GROUP BY r.review_score
ORDER BY r.review_score;

-- Seller scorecard inputs. Keep order-level and item-level metrics separate.
SELECT
    i.seller_id,
    COUNT(DISTINCT i.order_id) AS seller_orders,
    ROUND(SUM(i.price), 2) AS seller_revenue,
    ROUND(SUM(i.price) / COUNT(DISTINCT i.order_id), 2) AS seller_aov,
    ROUND(100 * AVG(o.order_delivered_customer_date <= o.order_estimated_delivery_date), 2) AS on_time_percent,
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM items AS i
JOIN orders AS o ON o.order_id = i.order_id
LEFT JOIN reviews AS r ON r.order_id = o.order_id
GROUP BY i.seller_id
ORDER BY seller_revenue DESC;
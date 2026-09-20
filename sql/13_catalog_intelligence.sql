USE ecommerce_analysis;

-- Product attributes, demand, and freight relationship.
SELECT
    p.product_category_name AS category,
    COUNT(DISTINCT p.product_id) AS catalog_products,
    COUNT(DISTINCT i.product_id) AS products_with_sales,
    ROUND(AVG(p.product_weight_g), 2) AS avg_weight_g,
    ROUND(AVG(p.product_length_cm * p.product_height_cm * p.product_width_cm), 2) AS avg_volume_cm3,
    ROUND(AVG(i.price), 2) AS avg_price,
    ROUND(AVG(i.freight_value), 2) AS avg_freight,
    COUNT(DISTINCT i.order_id) AS orders,
    ROUND(SUM(i.price), 2) AS revenue
FROM products AS p
LEFT JOIN items AS i ON i.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;

-- Products in the catalog with no observed order-item sales.
SELECT
    p.product_id,
    p.product_category_name,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM products AS p
LEFT JOIN items AS i ON i.product_id = p.product_id
WHERE i.product_id IS NULL
ORDER BY p.product_category_name, p.product_id;
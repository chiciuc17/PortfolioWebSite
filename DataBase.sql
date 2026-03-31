WITH MonthlySales AS (
    SELECT 
        product_id,
        DATE_TRUNC('month', order_date) AS sale_month,
        SUM(quantity * unit_price) AS total_revenue,
        AVG(SUM(quantity * unit_price)) OVER (
            PARTITION BY product_id 
            ORDER BY DATE_TRUNC('month', order_date) 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS rolling_avg_3m
    FROM order_items
    JOIN orders ON order_items.order_id = orders.id
    WHERE order_date >= '2024-01-01'
    GROUP BY 1, 2
),
RankedProducts AS (
    SELECT 
        ms.*,
        p.category,
        DENSE_RANK() OVER (PARTITION BY p.category ORDER BY ms.total_revenue DESC) AS rank_in_category
    FROM MonthlySales ms
    LEFT JOIN products p ON ms.product_id = p.id
)
SELECT * FROM RankedProducts 
WHERE rank_in_category <= 5 
  AND rolling_avg_3m > 1000 
ORDER BY category, rank_in_category;
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(o.id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    MAX(o.order_date) AS last_order_date,
    CASE 
        WHEN COUNT(o.id) >= 10 THEN 'VIP'
        WHEN COUNT(o.id) >= 5 THEN 'Gold'
        WHEN COUNT(o.id) >= 2 THEN 'Silver'
        ELSE 'Bronze'
    END AS customer_segment
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
HAVING COUNT(o.id) > 0
ORDER BY total_spent DESC;

Order_items

SELECT
    p.product_id,
    p.product_name,
    p.category,
    COUNT(oi.order_item_id) AS total_ordered,
    SUM(oi.quantity) AS total_quantity_sold,
    (SUM(oi.quantity) * p.unit_price) AS total_revenue,
    AVG(oi.quantity) AS avg_quantity_per_order,
    CASE 
        WHEN SUM(oi.quantity) > 100 THEN 'High Volume'
        WHEN SUM(oi.quantity) > 50 THEN 'Medium Volume'
        ELSE 'Low Volume'
    END AS volume_category
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.category, p.unit_price
HAVING COUNT(oi.order_item_id) > 10
ORDER BY total_revenue DESC;

WITH CustomerOrderCounts AS (
    SELECT 
        customer_id,
        COUNT(order_id) AS order_count
    FROM orders
    GROUP BY customer_id
),
CustomerRevenue AS (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spent
    FROM orders
    GROUP BY customer_id
),
CustomerActivity AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        COALESCE(coc.order_count, 0) AS order_count,
        COALESCE(cr.total_spent, 0) AS total_spent,
        MAX(o.order_date) AS last_order_date,
        CASE 
            WHEN COALESCE(coc.order_count, 0) >= 10 THEN 'VIP'
            WHEN COALESCE(coc.order_count, 0) >= 5 THEN 'Gold'
            WHEN COALESCE(coc.order_count, 0) >= 2 THEN 'Silver'
            ELSE 'Bronze'
        END AS customer_segment
    FROM customers c
    LEFT JOIN CustomerOrderCounts coc ON c.customer_id = coc.customer_id
    LEFT JOIN CustomerRevenue cr ON c.customer_id = cr.customer_id
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.email, coc.order_count, cr.total_spent
)
SELECT * FROM CustomerActivity
WHERE order_count > 0
ORDER BY total_spent DESC;

WITH MonthlySales AS (
    SELECT 
        product_id,
        DATE_TRUNC('month', order_date) AS sale_month,
        SUM(quantity * unit_price) AS total_revenue,
        AVG(SUM(quantity * unit_price)) OVER (
            PARTITION BY product_id 
            ORDER BY DATE_TRUNC('month', order_date) 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS rolling_avg_3m
    FROM order_items
    JOIN orders ON order_items.order_id = orders.id
    WHERE order_date >= '2024-01-01'
    GROUP BY 1, 2
),
RankedProducts AS (
    SELECT 
        ms.*,
        p.category,
        DENSE_RANK() OVER (PARTITION BY p.category ORDER BY ms.total_revenue DESC) AS rank_in_category
    FROM MonthlySales ms
    LEFT JOIN products p ON ms.product_id = p.id
)
SELECT * FROM RankedProducts 
WHERE rank_in_category <= 5 
  AND rolling_avg_3m > 1000 
ORDER BY category, rank_in_category;

SELECT
    p.product_id,
    p.product_name,
    p.category,
    COUNT(oi.order_item_id) AS total_ordered,
    SUM(oi.quantity) AS total_quantity_sold,
    (SUM(oi.quantity) * p.unit_price) AS total_revenue,
    AVG(oi.quantity) AS avg_quantity_per_order,
    CASE 
        WHEN SUM(oi.quantity) > 100 THEN 'High Volume'
        WHEN SUM(oi.quantity) > 50 THEN 'Medium Volume'
        ELSE 'Low Volume'
    END AS volume_category
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.category, p.unit_price
HAVING COUNT(oi.order_item_id) > 10
ORDER BY total_revenue DESC;

ORDER_ITEMS

WITH MonthlySales AS (
    SELECT 
        product_id,
        DATE_TRUNC('month', order_date) AS sale_month,
        SUM(quantity * unit_price) AS total_revenue,
        AVG(SUM(quantity * unit_price)) OVER (
            PARTITION BY product_id 
            ORDER BY DATE_TRUNC('month', order_date) 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS rolling_avg_3m
    FROM order_items
    JOIN orders ON order_items.order_id = orders.id
    WHERE order_date >= '2024-01-01'
    GROUP BY 1, 2
),
RankedProducts AS (
    SELECT 
        ms.*,
        p.category,
        DENSE_RANK() OVER (PARTITION BY p.category ORDER BY ms.total_revenue DESC) AS rank_in_category
    FROM MonthlySales ms
    LEFT JOIN products p ON ms.product_id = p.id
)
SELECT * FROM RankedProducts 
WHERE rank_in_category <= 5 
  AND rolling_avg_3m > 1000 
ORDER BY category, rank_in_category;
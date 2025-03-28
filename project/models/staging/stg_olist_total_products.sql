SELECT
    product_id,
    COUNT(order_item_id) AS total_sold_products,
    ROUND(SUM(price), 2) AS total_revenue
FROM {{ source('sources', 'olist_order_items_dataset') }}
GROUP BY 1
ORDER BY 2 DESC
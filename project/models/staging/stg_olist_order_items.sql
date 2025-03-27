SELECT *
FROM {{ source('sources', 'olist_order_items_dataset') }}
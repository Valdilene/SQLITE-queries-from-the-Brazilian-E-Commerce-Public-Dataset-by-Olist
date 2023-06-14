SELECT PROD_TRANS.product_category_name_english AS PROD_CATEGORY,
       COUNT(ITEM.order_id) AS ITEMS_QTT, 
	   CUST.customer_state as STATE
FROM olist_order_items_dataset as ITEM
INNER JOIN olist_products_dataset as PROD ON PROD.product_id = ITEM.product_id
LEFT JOIN product_category_name_translation as PROD_TRANS on PROD_TRANS.product_category_name = PROD.product_category_name
INNER JOIN olist_orders_dataset as ORD ON ORD.order_id = ITEM.order_id
INNER JOIN olist_customers_dataset as CUST ON CUST. customer_id = ORD.customer_id
WHERE PROD_CATEGORY IS NOT NULL
GROUP BY PROD_CATEGORY, STATE
HAVING ITEMS_QTT > 1000
ORDER BY ITEMS_QTT ASC
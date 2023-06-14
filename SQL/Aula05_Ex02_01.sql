/*Retorne a quantidade de itens vendidos em cada categoria por estado do cliente. 
Mostre somente categorias/estados que tenha vendido uma quantidade de itens acima de 1000 itens.*/

SELECT PROD.product_category_name AS PROD_CATEGORY,
       COUNT(ITEM.order_id) AS ITEMS_QTT, 
	   CUST.customer_state as STATE
FROM olist_order_items_dataset as ITEM
INNER JOIN olist_products_dataset as PROD ON PROD.product_id = ITEM.product_id
INNER JOIN olist_orders_dataset as ORD ON ORD.order_id = ITEM.order_id
INNER JOIN olist_customers_dataset as CUST ON CUST. customer_id = ORD.customer_id
WHERE PROD_CATEGORY IS NOT NULL
GROUP BY PROD_CATEGORY, STATE

--GROUP BY PROD_NAME.product_category_name_english, CUST.customer_state
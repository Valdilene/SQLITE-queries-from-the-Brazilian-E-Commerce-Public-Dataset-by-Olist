/*Crie uma tabela analítica de todos os itens que foram vendidos, somente mostrando pedidos interestaduais. 
Queremos saber quantos dias os fornecedores demoram para postar o produto, se o produto chegou ou não dentro do prazo.*/

SELECT ITEMS.product_id as ITEM,
       CUST.customer_state as CUST_STATE,
	   SELLERS.seller_state as SELLER_STATE,
	   ORDERS.order_status as ORDER_STATUS,
	   ORDERS.order_approved_at as ORDER_APROVED_AT_,
	   ORDERS.order_delivered_carrier_date as ORDER_POSTED_AT_,
	   CAST(julianday(ORDERS.order_delivered_carrier_date) - julianday(ORDERS.order_approved_at) AS INTEGER) as NUMBER_DAYS_TO_POST,
	   ORDERS.order_estimated_delivery_date as ORDER_ESIMATED_DELIVERY,
	   ORDERS.order_delivered_customer_date as ORDER_DELIVERED_TO_CUSTOMER,
	   CASE
	   WHEN CAST(julianday(ORDERS.order_delivered_customer_date) - julianday(ORDERS.order_estimated_delivery_date) AS INTEGER) > 0 THEN 'NO'
	   WHEN CAST(julianday(ORDERS.order_delivered_customer_date) - julianday(ORDERS.order_estimated_delivery_date) AS INTEGER) <= 0 THEN 'YES'
	   ELSE 'INDEFINIDO'
	   END ARRIVED_IN_TIME_
FROM olist_order_items_dataset as ITEMS
INNER JOIN olist_sellers_dataset as SELLERS ON ITEMS.seller_id = SELLERS.seller_id
INNER JOIN olist_orders_dataset as ORDERS ON ITEMS.order_id = ORDERS.order_id
INNER JOIN olist_customers_dataset as CUST ON ORDERS.customer_id = CUST.customer_id
WHERE CUST_STATE != SELLER_STATE AND ORDER_STATUS NOT IN ('unavailable','canceled','created', 'invoiced')
   
	  
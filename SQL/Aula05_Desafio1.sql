/*E se eu quisesse saber a quantidade de compras por cliente e o valor médio dessas compras?
Sendo que uma informação está na tabela de clientes, a outra na de orders e a outra na de pagamento?*/

SELECT CUST.customer_unique_id as CLIENTE,
	   COUNT(DISTINCT ORD.order_id) as QTD_PEDIDOS,
	   avg (PAY.payment_value) as MEDIA_PAG	
FROM olist_customers_dataset as CUST
INNER JOIN olist_orders_dataset as ORD ON CUST.customer_id = ORD.customer_id
INNER JOIN olist_order_payments_dataset as PAY ON ORD.order_id = PAY.order_id
GROUP BY CUST.customer_unique_id
--HAVING QTD_PEDIDOS>1
--ORDER BY QTD_PEDIDOS ASC

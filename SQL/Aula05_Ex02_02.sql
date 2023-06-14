/*Mostre os 5 clientes (customer_unique_id) que tem o maior valor total de compras (considerar apenas o valor do produto).
Qual foi o valor total de todas as compras, quantidade de compras, e valor médio gasto por cada um deles?*/

--Considerando o pagamento (valor do produto + frete)
SELECT CUST.customer_unique_id as CLIENT,
	   COUNT(DISTINCT(ORD.order_id)) as TOTAL_ORDERS,
	   sum(PAY.payment_value) as TOT_PAY, 
	   avg(PAY.payment_value) as AVG_PAY
FROM olist_customers_dataset as CUST
LEFT JOIN olist_orders_dataset as ORD ON CUST.customer_id = ORD.customer_id
LEFT JOIN olist_order_payments_dataset as PAY ON PAY.order_id = ORD. order_id
GROUP BY CLIENT
ORDER BY TOT_PAY DESC
LIMIT 5

-- Considerando apenas o valor do produto

SELECT CUST.customer_unique_id as CLIENT,
	   COUNT(DISTINCT(ORD.order_id)) as TOTAL_ORDERS,
	   sum(OID.price) as TOT_PRICE, 
	   avg(OID.price) as AVG_PRICE
FROM olist_customers_dataset as CUST
INNER JOIN olist_orders_dataset as ORD ON CUST.customer_id = ORD.customer_id
INNER JOIN olist_order_items_dataset as OID ON ORD.order_id = OID. order_id
GROUP BY CLIENT
ORDER BY AVG_PRICE DESC
LIMIT 5

/*Tarefa: Desafios de SQL 1
4. Retorne pedidos que foram feitos somente no ano de 2017.*/
SELECT order_id, customer_id, order_status, strftime('%Y',order_purchase_timestamp) AS year
FROM olist_orders_dataset
WHERE year = '2017';

--Sol. alternativa (mais simples)
SELECT *
FROM olist_orders_dataset
WHERE order_purchase_timestamp LIKE '2017%';

--Sol. alternativa 2
SELECT *
FROM olist_orders_dataset
WHERE order_purchase_timestamp BETWEEN '2017-01-01 00:00:00' AND '2017-12-31 23:59:59';

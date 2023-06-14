/*Queries
Com a base de dados aberta, crie queries que:

crie uma tabela analítica de todos os itens que foram vendidos, mostrando somente pedidos interestaduais. Queremos saber quantos dias os fornecedores demoram para postar o produto, se o produto chegou ou não no prazo.
retorne todos os pagamentos do cliente, com suas datas de aprovação, valor da compra e o valor total que o cliente já gastou em todas as suas compras, mostrando somente os clientes onde o valor da compra é diferente do valor total já gasto.
retorne as categorias válidas, suas somas totais dos valores de vendas, um ranqueamento de maior valor para menor valor junto com o somatório acumulado dos valores pela mesma regra do ranqueamento.*/

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

--

SELECT *
FROM (
SELECT CUST.customer_unique_id as CLIENT,
	   ORD.order_id as ORDER_,
	   ORD.order_approved_at as APPROVED_ORDER,
	   sum(PAY.payment_value) over (partition by ORD.order_id) as TOTAL_PAY_ORDER,
	   sum(PAY.payment_value) over (partition by CUST.customer_unique_id) as TOTAL_PAY_CLIENT
FROM olist_customers_dataset as CUST 
INNER JOIN olist_orders_dataset as ORD ON CUST.customer_id = ORD.customer_id
INNER JOIN olist_order_payments_dataset as PAY ON ORD.order_id = PAY.order_id
GROUP BY ORDER_,
         CLIENT,
		 APPROVED_ORDER
ORDER BY TOTAL_PAY_CLIENT DESC
) TB
WHERE TOTAL_PAY_ORDER <> TOTAL_PAY_CLIENT

--

SELECT PROD_CAT,
	   SUM_SOLD_PROD,
       RANK() OVER(ORDER BY SUM_SOLD_PROD DESC) as RANK_SUM_PROD,
	   SUM(SUM_SOLD_PROD) OVER(ORDER BY SUM_SOLD_PROD DESC) as CUM_SUM
FROM (SELECT PROD.product_category_name as PROD_CAT,
	   COUNT (OID.product_id) as QTT_PROD, 
	   ROUND (sum(OID.price),2) as SUM_SOLD_PROD
FROM olist_order_items_dataset as OID
INNER JOIN olist_products_dataset as PROD ON OID.product_id = PROD.product_id
GROUP BY PROD_CAT)
ORDER BY SUM_SOLD_PROD DESC
/* Crie uma consulta que retorne por estado:
a quantidade de compras;
média do valor das compras;
a soma do valor das compras;
a compra de maior valor;
a compra de menor valor
Retornar os estados que tiverem a soma do valor das compras acima de 300.000 */

SELECT CUST.customer_state as STATE,
	   COUNT(DISTINCT ORD.order_id) as ORDERS,
	   avg(PAY.payment_value) as AVG_PAYMENT_TYPE, --media por tipo de pagamento
	   sum(PAY.payment_value) as TOTAL_PAY,
	   sum(PAY.payment_value)/ COUNT(DISTINCT ORD.order_id) as AVG_PER_ORDER,
	   max(PAY.payment_value) as MAX_PAY,
	   min(PAY.payment_value) as MIN_PAY
FROM olist_orders_dataset AS ORD
INNER JOIN olist_order_payments_dataset as PAY ON ORD.order_id = PAY.order_id
INNER JOIN olist_customers_dataset as CUST ON CUST.customer_id = ORD.customer_id
WHERE ORD.order_status NOT IN ('unavailable','canceled','created','invoiced')
GROUP BY STATE
HAVING TOTAL_PAY>300000
ORDER BY TOTAL_PAY DESC
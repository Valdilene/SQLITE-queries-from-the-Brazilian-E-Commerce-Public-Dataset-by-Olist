/* Crie uma query SQL que me retorne todos os pagamentos do cliente, com suas datas de aprovação, valor da compra e o valor total que o cliente já gastou em todas as suas compras, 
me mostrando somente os clientes onde o valor da compra é diferente do valor total já gasto.*/

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
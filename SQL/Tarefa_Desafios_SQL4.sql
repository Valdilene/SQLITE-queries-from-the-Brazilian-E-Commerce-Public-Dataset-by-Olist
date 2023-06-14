/* Crie queries que:

Crie uma view (SELLER_STATS) para mostrar por fornecedor, a quantidade de itens enviados, o tempo médio de postagem após a aprovação da compra, a quantidade total de pedidos de cada Fornecedor, 
note que trabalharemos na mesma query com 2 granularidades diferentes. */

CREATE VIEW SELLER_STATS as 
select SEL.seller_id as seller, 
	   COUNT(DISTINCT(ORD.order_id)) as total_orders,
	   COUNT(OID.order_item_id) as sold_items,
	   avg(CAST(julianday(ORD.order_delivered_carrier_date)AS INTEGER) - CAST(julianday(ORD.order_approved_at) AS INTEGER)) as number_days_to_post_average
from olist_sellers_dataset as SEL
INNER JOIN olist_order_items_dataset as OID ON SEL.seller_id = OID.seller_id
INNER JOIN olist_orders_dataset as ORD ON ORD.order_id = OID.order_id
WHERE ORD.order_status IN ('delivered','shipped')
	AND ORD.order_approved_at < ORD.order_delivered_carrier_date 
GROUP BY seller
ORDER BY number_days_to_post_average DESC;

/* Queremos dar um cupom de 10% do valor da última compra do cliente. Porém os clientes elegíveis a este cupom devem ter feito uma compra anterior a última 
(a partir da data de aprovação do pedido) que tenha sido maior ou igual o valor da última compra. Crie uma querie que retorne os valores dos cupons para cada um dos clientes elegíveis.*/

SELECT *, (0.10 * price) as voucher
FROM (
	SELECT *,
		   RANK() OVER (PARTITION BY client ORDER BY date_approval DESC) as rank_date_approval,
		   LEAD(price,1) OVER (PARTITION BY client ORDER BY date_approval DESC) AS price_of_previous_purchase
		   
	FROM (
			SELECT CUST.customer_unique_id as client,
							   ORD.order_id as order_,
							   sum(OID.price) as price,
							   ORD.order_approved_at as date_approval
			FROM olist_customers_dataset as CUST
			INNER JOIN olist_orders_dataset as ORD ON CUST.customer_id = ORD.customer_id
			INNER JOIN olist_order_items_dataset as OID ON OID.order_id = ORD.order_id
			WHERE ORD.order_status IN ('delivered', 'shipped')
			GROUP BY order_, client, date_approval 
			)
	)
WHERE rank_date_approval = 1 AND price >= price_of_previous_purchase 



/* Crie queries que:

Crie uma view (SELLER_STATS) para mostrar por fornecedor, a quantidade de itens enviados, o tempo médio de postagem após a aprovação da compra, a quantidade total de pedidos de cada Fornecedor, 
note que trabalharemos na mesma query com 2 granularidades diferentes.*/


--CREATE VIEW SELLER_STATS as 
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
ORDER BY number_days_to_post_average DESC





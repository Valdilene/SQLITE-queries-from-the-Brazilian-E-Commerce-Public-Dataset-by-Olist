/* Crie queries que:
Queremos dar um cupom de 10% do valor da última compra do cliente. Porém os clientes elegíveis a este cupom devem ter feito uma compra anterior a última 
(a partir da data de aprovação do pedido) que tenha sido maior ou igual o valor da última compra. Crie uma querie que retorne os valores dos cupons para cada um dos clientes elegíveis. */

--Minha primeira solucao:

SELECT *, (0.10 * price) as voucher
FROM (
	SELECT *,
		   RANK() OVER (PARTITION BY client ORDER BY price DESC) as rank_price
	FROM (
			SELECT CUST.customer_unique_id as client,
							   ORD.order_id as order_,
							   sum(OID.price) as price,
							   ORD.order_approved_at as date_approval,
							   RANK() OVER (PARTITION BY CUST.customer_unique_id ORDER BY ORD.order_approved_at DESC) as rank_date_approval
			FROM olist_customers_dataset as CUST
			INNER JOIN olist_orders_dataset as ORD ON CUST.customer_id = ORD.customer_id
			INNER JOIN olist_order_items_dataset as OID ON OID.order_id = ORD.order_id
			WHERE ORD.order_status IN ('delivered', 'shipped')
			--AND CUST.customer_unique_id IN ('8d50f5eadf50201ccdcedfb9e2ac8455', '3e43e6105506432c953e165fb2acf44c', '6469f99c1f9dfae7733b25662e7f1782', 'ca77025e7201e3b30c44b472ff346268' )
			GROUP BY order_, client
			ORDER BY rank_date_approval DESC
	)
	WHERE rank_date_approval IN (1,2)
)
WHERE rank_date_approval = 2 AND rank_price = 1; 	

--1495 rowns

/* A solucao acima eh problematica pq na funcao rank, quando eu tenho dois valores consecutivos que sao iguais, o rankeamento sera: 1 - 1 - 3 (see https://www.sqlitetutorial.net/sqlite-window-functions/sqlite-rank/).*/


------------- CORREÇÃO GUILHERME
-- 1580 ROWS. Aqui foi usado o pagamento total do pedido: preco do(s) produto(s) + frete
SELECT client,
	   date_approval,
	   price,
	   price_of_previous_purchase,
	   price*0.10 AS voucher
FROM (
		SELECT *,
			   LEAD(price,1) OVER (PARTITION BY client ORDER BY date_approval DESC) AS price_of_previous_purchase, --- AQUI A FUNÇÃO LEAD VAI 1 POSIÇÃO A FRENTE DA ATUAL, ENTÃO A ÚLTIMA COMPRA VAI TRAZER O VALOR DA PENULTINA COMPRA
			   RANK() OVER (PARTITION BY client ORDER BY date_approval DESC) as rank_date_approval
		FROM (
				--- AQUI BUSCAMOS TODOS OS PEDIDOS E SOMAMOS SEUS PAGAMENTOS, POR TERMOS ALGUMAS RELAÇÕES 1:N VAMOS DEIXAR O RANK PARA O PRÓXIMO PASSO
				SELECT CUST.customer_unique_id as client,
					   ORD.order_id as order_ID,
					   ORD.order_approved_at as date_approval,
					   sum(PAY.payment_value) as price
				FROM olist_customers_dataset as CUST
				INNER JOIN olist_orders_dataset as ORD ON CUST.customer_id = ORD.customer_id
				INNER JOIN olist_order_payments_dataset as PAY ON ORD.order_id = PAY.order_id
				WHERE ORD.order_status IN ('delivered', 'shipped')
				GROUP BY CUST.customer_unique_id,
						 ORD.order_id,
						 ORD.order_approved_at
				) TABELA_1
		) TABELA_2
WHERE rank_date_approval = 1 --- AQUI FILTRAMOS SOMENTE PARA PEGAR A ÚLTIMA COMPRA DE CADA CLIENTE
  AND price >= price_of_previous_purchase --- AQUI FILTRAMOS SOMENTE OS CLIENTES QUE TIVERAM NA ÚLTIMA COMPRA UM VALOR MAIOR OU IGUAL A PENULTIMA COMPRA. O CLIENTE 8d50f5eadf50201ccdcedfb9e2ac8455 COMPROU MENOS NA ÚLTIMA COMPRA DO QUE NA PENÚLTIMA E POR ESTE MOTIVO NÃO DEVE RECEBER O VOUCHER
								--- JÁ O CLIENTE 3e43e6105506432c953e165fb2acf44c SIM, NESTE CASO ELE TEM UM VOUCHER DE 12.36



-- Minha solucao final.  
--1608 rowns. Aqui foi usado o preco do(s) produtos(apenas)

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
			--AND CUST.customer_unique_id IN ('8d50f5eadf50201ccdcedfb9e2ac8455', '3e43e6105506432c953e165fb2acf44c', '6469f99c1f9dfae7733b25662e7f1782', 'ca77025e7201e3b30c44b472ff346268' )
			GROUP BY order_, client, date_approval 
			)
	)
WHERE rank_date_approval = 1 AND price >= price_of_previous_purchase
	





			
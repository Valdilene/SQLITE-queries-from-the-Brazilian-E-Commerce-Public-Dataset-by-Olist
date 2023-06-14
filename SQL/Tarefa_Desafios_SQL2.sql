/*Queries
Com a base de dados aberta, crie queries que:

retorne a quantidade de itens vendidos em cada categoria por estado em que o cliente se encontra, mostrando somente categorias que tenham vendido uma quantidade de items acima de 1000.
mostre os 5 clientes (customer_id) que gastaram mais dinheiro em compras, qual foi o valor total de todas as compras deles, quantidade de compras, e valor médio gasto por compras. Ordene os mesmos por ordem decrescente pela média do valor de compra.
mostre o valor vendido total de cada vendedor (seller_id) em cada uma das categorias de produtos, somente retornando os vendedores que nesse somatório e agrupamento venderam mais de $1000. Desejamos ver a categoria do produto e os vendedores. Para cada uma dessas categorias, mostre seus valores de venda de forma decrescente.*/

SELECT PROD_TRANS.product_category_name_english AS PROD_CATEGORY,
       COUNT(ITEM.order_id) AS ITEMS_QTT, 
	   CUST.customer_state as STATE
FROM olist_order_items_dataset as ITEM
INNER JOIN olist_products_dataset as PROD ON PROD.product_id = ITEM.product_id
LEFT JOIN product_category_name_translation as PROD_TRANS on PROD_TRANS.product_category_name = PROD.product_category_name
INNER JOIN olist_orders_dataset as ORD ON ORD.order_id = ITEM.order_id
INNER JOIN olist_customers_dataset as CUST ON CUST. customer_id = ORD.customer_id
WHERE PROD_CATEGORY IS NOT NULL
GROUP BY PROD_CATEGORY, STATE
HAVING ITEMS_QTT > 1000
ORDER BY ITEMS_QTT ASC

--

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

--

SELECT ORD.seller_id as SELLER, 
	   PROD.product_category_name AS PROD_CATEG,
	   SUM(PAY.payment_value) as TOTAL_SOLD
FROM olist_order_items_dataset AS ORD
LEFT JOIN olist_order_payments_dataset AS PAY ON ORD.order_id = PAY.order_id
LEFT JOIN olist_products_dataset AS PROD ON PROD.product_id = ORD.product_id
WHERE PROD_CATEG IS NOT NULL
GROUP BY SELLER, PROD_CATEG
HAVING TOTAL_SOLD > 1000
ORDER BY TOTAL_SOLD DESC

/* Mostre o valor vendido total de cada vendedor(seller_id) em cada uma das categorias de produtos, 
somente retornando os vendedores que nesse somatório e agrupamento venderam mais de $1000, 
desejamos ver a categoria do produto e os vendedores, para cada uma dessas categorias mostre seus valores de venda de forma decrescente.*/

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
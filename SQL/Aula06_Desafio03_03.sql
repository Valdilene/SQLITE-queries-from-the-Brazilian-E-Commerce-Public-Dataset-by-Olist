/* Queremos saber sobre as categorias de produtos válidas, suas soma total dos valores de vendas, um ranqueamento de maior valor para menor valor junto com o somatório acumulado dos valores pela mesma regra do ranqueamento. */

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



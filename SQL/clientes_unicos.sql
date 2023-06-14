/*Exercicio: Desafios de SQL 1
1. Quantos clientes únicos temos na base?*/
SELECT COUNT (DISTINCT(customer_unique_id)) AS clientes_unicos
FROM olist_customers_dataset;

-- Sol. alternativa
SELECT customer_unique_id, count(1) as QTD -- 1 customer_ID poder estar em mais de 1 linha
FROM olist_customers_dataset
GROUP BY customer_unique_id
ORDER BY QTD DESC


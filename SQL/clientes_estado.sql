/*Exercicio: Desafios de SQL 1
2.Quantos clientes temos por estado?*/
SELECT customer_state, COUNT (DISTINCT(customer_unique_id)) AS cliente_por_estado
FROM olist_customers_dataset
GROUP BY customer_state
ORDER BY customer_state ASC;
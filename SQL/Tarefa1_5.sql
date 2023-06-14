/*Tarefa: Desafios de SQL 1
5. Encontre os clientes do estado de SP e que não morem na cidade de São Paulo.*/
SELECT *
FROM olist_customers_dataset
WHERE customer_state = 'SP' AND UPPER(TRIM(customer_city)) NOT LIKE 'S_O PAULO'
ORDER BY customer_city

--Sol. alternativa
SELECT *
FROM olist_customers_dataset
WHERE customer_state = 'SP' COLLATE NOCASE --para nao difereciar maiscula de minuscula e acento, mas nao funciona para caracter especial.
	AND UPPER(TRIM(customer_city)) NOT LIKE 'S_O PAULO' COLLATE NOCASE
ORDER BY customer_city
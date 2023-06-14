/*Queries:
Com a base de dados aberta, crie queries que:

selecione os dados da tabela de pagamentos onde só apareçam os tipos de pagamento “VOUCHER” e “BOLETO”.
retorne os campos da tabela de produtos e calcule o volume de cada produto em um novo campo.
retorne somente os reviews que não tem comentários.
retorne pedidos que foram feitos somente no ano de 2017.
encontre os clientes do estado de SP e que não morem na cidade de São Paulo.*/

SELECT *
FROM olist_order_payments_dataset
WHERE UPPER (TRIM (payment_type)) IN ('BOLETO', 'VOUCHER') -- UPPER capitalise all letters and TRIM delete blank spaces surrounding the words

--

SELECT *, (product_height_cm * product_length_cm * product_width_cm) as VOL
FROM olist_products_dataset
WHERE VOL is NOT NULL
ORDER BY VOL;

--

SELECT *
FROM olist_order_reviews_dataset
WHERE review_comment_message is NULL;

--

SELECT *
FROM olist_orders_dataset
WHERE order_purchase_timestamp LIKE '2017%';

--

SELECT *
FROM olist_customers_dataset
WHERE customer_state = 'SP' AND UPPER(TRIM(customer_city)) NOT LIKE 'S_O PAULO'
ORDER BY customer_city

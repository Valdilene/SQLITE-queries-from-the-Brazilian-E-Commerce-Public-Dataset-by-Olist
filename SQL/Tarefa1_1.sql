/*Tarefa: Desafios de SQL 1
1. Selecione os dados da tabela de pagamentos onde só apareçam os tipos de pagamento “VOUCHER” e “BOLETO”.*/
SELECT *
FROM olist_order_payments_dataset
WHERE payment_type = 'voucher' or payment_type = 'boleto'
ORDER BY payment_type ASC;

--Sol. alternativa
--SELECT *
--FROM olist_order_payments_dataset
--WHERE UPPER (TRIM (payment_type)) IN ('BOLETO', 'VOUCHER') -- UPPER capitalise all letters and TRIM delete blank spaces surrounding the words


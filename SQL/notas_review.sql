/*Exercicio: Desafios de SQL 1
3.Quantas notas temos por review_score?*/
SELECT review_score, COUNT (1) AS QTD_TOTAL_REVIEWS, COUNT(DISTINCT(review_id)) AS UNIQUE_REVIEWS --clientes podem revisar reviews, entao uma review pode ser atualizada e ter a nota alterada
FROM olist_order_reviews_dataset
GROUP BY review_score
ORDER BY review_score;

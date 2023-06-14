/*Tarefa: Desafios de SQL 1
3. Retorne somente os reviews que não tem comentários.*/
SELECT *
FROM olist_order_reviews_dataset
WHERE review_comment_message is NULL;

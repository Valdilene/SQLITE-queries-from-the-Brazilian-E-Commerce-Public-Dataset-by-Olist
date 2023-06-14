/*Tarefa: Desafios de SQL 1
--Retorne os campos da tabela de produtos e calcule o volume de cada produto em um novo campo. Ordene do menor para o maior volume e exclua os nulos*/
ALTER TABLE olist_products_dataset 
ADD COLUMN product_volume_cm3 AS (product_height_cm * product_length_cm * product_width_cm);
SELECT *
FROM olist_products_dataset
WHERE product_volume_cm3 is NOT NULL
ORDER BY product_volume_cm3 ASC

--Sol. alternativa (mais simples)
SELECT *, (product_height_cm * product_length_cm * product_width_cm) as VOL
FROM olist_products_dataset
WHERE VOL is NOT NULL
ORDER BY VOL;




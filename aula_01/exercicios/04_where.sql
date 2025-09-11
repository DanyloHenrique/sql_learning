-- Selecione produtos que contêm ‘churn’ no nome

SELECT *
FROM produtos

-- ========== FORMA 1 - USANDO OR ==============
-- WHERE DescProduto = 'Churn_10pp'
-- OR DescProduto = 'Churn_2pp' 
-- OR DescProduto = 'Churn_5pp'

-- ========== FORMA 2 - USANDO IN ==============
-- WHERE DescProduto in ('Churn_10pp', 'Churn_2pp', 'Churn_5pp')

-- ========== FORMA 3 - USANDO LIKE ==============
-- WHERE DescProduto LIKE 'churn%'

-- ========== FORMA 4 - BUSCANDO NA CATEGORIA ========
WHERE DescCateogriaProduto = 'churn_model'



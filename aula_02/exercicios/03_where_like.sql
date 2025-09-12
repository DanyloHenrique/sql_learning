-- E: Lista de produtos com nome que começa com “Venda de”;
SELECT *
FROM produtos
WHERE DescProduto LIKE 'Venda de%';

-- F: Lista de produtos com nome que termina com “Lover”;
SELECT *
FROM produtos
WHERE DescProduto LIKE '%Lover';

-- G: Lista de produtos que são “chapéu”;
SELECT *
FROM produtos
WHERE DescProduto LIKE '%chapéu%';

-- H: Lista de transações com o produto “Resgatar Ponei”;
SELECT *
FROM transacao_produto
-- WHERE DescProduto LIKE '%Resgatar Ponei%';
WHERE IdProduto = 15;



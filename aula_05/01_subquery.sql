-- 1. Primeira Subquery
-- Primeiro é executado a query dentro do WHERE
-- Após isso, seu resultado é usado como filtro da segunda query

SELECT *

FROM transacao_produto AS t1

WHERE t1.IdProduto IN (
    SELECT IdProduto
    FROM produtos
    WHERE DescProduto = 'Resgatar Ponei'
)



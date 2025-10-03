-- Categorias de produtos com mais transações

SELECT 
    t3.DescCateogriaProduto, 
    count(DISTINCT t1.IdTransacao) as QtdeTransacoes
FROM transacoes AS t1

LEFT JOIN transacao_produto AS t2 
ON t1.IdTransacao = t2.IdTransacao

LEFT JOIN produtos AS t3 
ON t2.IdProduto = t3.IdProduto

WHERE t1.DtCriacao >= '2024-01-01'
AND t1.DtCriacao < '2025-01-01'

GROUP BY t3.DescCateogriaProduto
HAVING count(DISTINCT t1.IdTransacao) > 1000

ORDER BY count(DISTINCT t1.IdTransacao) DESC
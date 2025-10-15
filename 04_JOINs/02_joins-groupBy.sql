SELECT
    t1.IdProduto,
    t2.DescCateogriaProduto,
    count(DISTINCT IdTransacao) AS QtdeTransacoes
FROM transacao_produto AS t1

LEFT JOIN produtos AS t2
ON t1.IdProduto = t2.IdProduto

GROUP BY t1.IdProduto
ORDER BY count(DISTINCT IdTransacao) DESC

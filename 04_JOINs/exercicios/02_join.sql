-- 2. Quais clientes mais perderam pontos por Lover?
SELECT
    t1.IdCliente,
    count(DISTINCT t2.IdTransacao) AS QtdeTransacoes,
    sum(t1.QtdePontos) AS QtdePontosPerdidos
FROM transacoes AS t1

LEFT JOIN transacao_produto AS t2
ON t1.IdTransacao = t2.IdTransacao

INNER JOIN produtos AS t3
ON t2.IdProduto = t3.IdProduto

WHERE t1.QtdePontos < 0
AND t3.DescCateogriaProduto = 'lovers'

GROUP BY t1.IdCliente

ORDER BY sum(t1.QtdePontos)

LIMIT 10;
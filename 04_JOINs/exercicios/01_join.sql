-- Qual o total de pontos trocados no Stream Elements em Junho de 2025?
SELECT 
    t3.*,
    count(DISTINCT t1.IdTransacao) AS QtdePontosTrocados
FROM transacoes AS t1

LEFT JOIN transacao_produto AS t2
ON t1.IdTransacao = t2.IdTransacao

LEFT JOIN produtos AS t3
ON t2.IdProduto = t3.IdProduto

WHERE t1.DtCriacao >= '2025-06-01'
AND t1.DtCriacao < '2025-07-01'

GROUP BY t3.DescCateogriaProduto

ORDER BY count(DISTINCT t1.IdTransacao) DESC








-- 3. Quais clientes assinaram a lista de presença no dia 2025/07/28?
SELECT 
    t1.IdCliente,
    t3.DescProduto
FROM transacoes AS t1

LEFT JOIN transacao_produto AS t2
ON t1.IdTransacao = t2.IdTransacao

LEFT JOIN produtos AS T3
ON t2.IdProduto = t3.IdProduto

WHERE substr(t1.DtCriacao, 1, 10) = '2025-07-28'
AND t3.DescProduto = 'Lista de presença'

ORDER BY t1.DtCriacao DESC

-- De 2025/07/25 a 2025/07/29, quantos clientes assinaram a lista de presença?
SELECT 
    count(DISTINCT t1.IdCliente) AS QtdeClientesDiferentes,
    t3.DescProduto
FROM transacoes AS t1

LEFT JOIN transacao_produto AS t2
ON t1.IdTransacao = t2.IdTransacao

LEFT JOIN produtos AS T3
ON t2.IdProduto = t3.IdProduto

WHERE t1.DtCriacao > '2025-07-25'
AND t1.DtCriacao <= '2025-07-29'
AND t3.DescProduto = 'Lista de presença'

ORDER BY t1.DtCriacao DESC;

Clientes mais antigos, tem mais frequência de transação?
SELECT
    t1.IdCliente,
    julianday('now') - julianday(substr(t1.DtCriacao,1,19)) AS idadeBase,
    count(DISTINCT t2.IdTransacao),
    julianday('now') - julianday(substr(t1.DtCriacao,1,19)) / count(DISTINCT t2.IdTransacao)  AS TransacaoPorIdade



FROM clientes AS t1 

LEFT JOIN transacoes AS t2
ON t1.IdCliente = t2.IdCliente

GROUP BY t1.IdCliente, idadeBase;

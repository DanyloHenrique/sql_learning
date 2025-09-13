-- Uso do DISTINCT e COUNT para descobrir quantidades totais

-- Quantas transações ocorreram no mes de julho
SELECT 
    count(*)
FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'
ORDER BY DtCriacao DESC;

-- Quantos clientes transacionaram no mes de julho
SELECT 
    count(IdTransacao),
    count(DISTINCT IdCliente)
FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'
ORDER BY DtCriacao DESC;
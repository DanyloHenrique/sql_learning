-- De quanto em quanto tempo os clientes
--voltam a assistir a live
-- (Recorrencia)



-- Buscando cada dia que cada cliente fez transações
WITH tb_cliente_dia AS (
    SELECT
        DISTINCT
        IdCliente,
        substr(DtCriacao, 1, 10) AS dtDia
    FROM transacoes

    WHERE substr(DtCriacao, 1, 4) = '2025'

    ORDER BY IdCliente, dtDia
),

-- realizando o lag entre os dias que o cliente realizou transação
tb_lag AS (
    SELECT *,
        lag(dtDia) OVER (PARTITION BY IdCliente ORDER BY dtDia) AS lagDia
    FROM tb_cliente_dia
),

-- Calculando a diferença entre os dias
tb_diff AS (
    SELECT *,
        julianday(dtDia) - julianday(lagDia) AS dtDiff
    FROM tb_lag
)

-- Calculando a média de dias que cada cliente volta a live
SELECT 
    IdCliente,
    avg(dtDiff)
FROM tb_diff
GROUP BY IdCliente
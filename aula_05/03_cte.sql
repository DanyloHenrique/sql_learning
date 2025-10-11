-- CTE: COMMON TABLE EXPRESSION

WITH tb_cliente_primeiro_dia AS (
    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE substr(transacoes.DtCriacao, 1, 10) = '2025-08-25'
),

tb_cliente_ultimo_dia AS (
    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE substr(transacoes.DtCriacao, 1, 10) = '2025-08-29'
),

tb_join AS (
    SELECT 
        t1.IdCliente AS primeiroCliente,
        t2.IdCliente AS segundoCliente
    FROM tb_cliente_primeiro_dia AS t1
    LEFT JOIN tb_cliente_ultimo_dia AS t2
    ON t1.IdCliente = t2.IdCliente
)

SELECT 
    count(primeiroCliente),
    count(segundoCliente),
    count(segundoCliente) - count(primeiroCliente),
    1. * count(segundoCliente) / count(primeiroCliente)
FROM tb_join
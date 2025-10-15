-- Qual o dia da semana mais ativo de cada usuário?

WITH tb_clientes_diaSemana AS (
    SELECT 
        IdCliente,
        STRFTIME('%w', dateTime(substr(DtCriacao, 1, 19))) AS dtDia,
        count(DISTINCT IdTransacao) AS QtdeTransacoes
    FROM transacoes

    GROUP BY IdCliente, dtDia
    ORDER BY IdCliente, dtDia
),

tb_rn AS (
    SELECT *,
        row_number() OVER (PARTITION BY IdCliente ORDER BY QtdeTransacoes DESC, QtdeTransacoes) AS rn
    FROM tb_clientes_diaSemana
)

SELECT *
FROM tb_rn
WHERE rn = 1
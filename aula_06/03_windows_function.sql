-- Interações acumuladas por cliente
-- Diferencial das interações dos clientes a cada dia

-- Buscando todas a transações por dia de cada cliente durante o curso
WITH tb_transacoes_curso AS (
    SELECT 
        IdCliente, 
        dateTime(substr(DtCriacao, 1, 10)) AS dtDia,
        count(DISTINCT IdTransacao) AS qtTransacao
    FROM transacoes

    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-31'

    GROUP BY IdCliente, dtDia
),

-- Calculando a soma das transações e a diferença entre os dias
tb_lag AS (
    SELECT *,
        sum(qtTransacao) OVER (PARTITION BY IdCliente ORDER BY dtDia) AS qtTransacaoAcum,
        lag(qtTransacao) OVER (PARTITION BY IdCliente ORDER BY dtDia) AS lagTransacoes
    FROM tb_transacoes_curso
)

-- calculo percentual do engajamento (diferença da quantidade de interações entre os dias)
SELECT 
    *,
    1.* qtTransacao / lagTransacoes AS tendenciaEngajamento
FROM tb_lag
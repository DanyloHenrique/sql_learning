-- Quantidade de transações Acumuladas ao longo do tempo?

-- Obtendo a soma das transações diárias
WITH tb_dia_transacoes AS (
    SELECT
        substr(DtCriacao, 1, 10) AS DtDia,
        COUNT(DISTINCT IdTransacao) AS QtDeTransacoes
    FROM transacoes
    GROUP BY DtDia
)

-- Calculando a soma de todas transações diárias uma a uma
SELECT *,
    sum(QtDeTransacoes) OVER (ORDER BY DtDia) AS QtDeTransacoesAcum
FROM tb_dia_transacoes;


-- Pode ser útil para perguntas como: quando que a gente atingiu 100mil transações

-- Obtendo a soma das transações diárias
WITH tb_dia_transacoes AS (
    SELECT
        substr(DtCriacao, 1, 10) AS DtDia,
        COUNT(DISTINCT IdTransacao) AS QtDeTransacoes
    FROM transacoes
    GROUP BY DtDia
),

tb_transacoes_acumuladas AS (
    SELECT *,
        sum(QtDeTransacoes) OVER (ORDER BY DtDia) AS QtDeTransacoesAcum
    FROM tb_dia_transacoes
)

SELECT *
FROM tb_transacoes_acumuladas

WHERE QtDeTransacoesAcum >= 100000
ORDER BY QtDeTransacoesAcum

LIMIT 1;


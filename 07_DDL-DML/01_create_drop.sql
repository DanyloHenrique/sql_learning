-- CRIAR UMA TABELA A PARTIR DE UMA QUERY

-- 1. Para evitar erros ao tentar utilizar a criação mais de uma vez
-- o primeiro passo é, se a tabela existir, então apaga-lá

-- 2. Depois é usado o comando de CREATE TABLE que cria uma nova tabela no bd
-- Caso a tabela já não exista anterior

-- 3. Depois disso, a tabela criada pode ser buscada com SELECT FROM

DROP TABLE IF EXISTS relatorio_diario;

CREATE TABLE IF NOT EXISTS relatorio_diario AS 
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
FROM tb_transacoes_acumuladas;


SELECT * FROM relatorio_diario;
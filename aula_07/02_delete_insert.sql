-- DELETAR O CONTEUDO DA TABELA

-- O comando delete apaga os dados presente na tabela
-- Mas mantém a tabela, só que vazia

DELETE FROM relatorio_diario;

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

INSERT INTO relatorio_diario

SELECT *
FROM tb_transacoes_acumuladas;

SELECT * FROM relatorio_diario;

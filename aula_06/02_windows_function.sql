-- Acumulado de transações durante o curso

-- Buscando quantas transações houveram cada dia
WITH tb_usuarios_dias AS (
    SELECT 
        substr(DtCriacao, 1, 10) AS dtDia,
        count(DISTINCT IdTransacao) AS qtTransacao
    FROM transacoes

    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-31'

    GROUP BY dtDia
)

-- Fazendo a soma acumulada nas transações por dia
SELECT *,
    sum(qtTransacao) OVER (ORDER BY dtDia) AS qtTransacaoAcum
FROM tb_usuarios_dias
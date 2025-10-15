-- 11. Quem iniciou o curso no primeiro dia, em média assistiu quantas aulas?

-- A. ACHAR QUEM ESTAVA NO PRIMEIRO DIA
-- B. SABENDO QUEM ESTAVA, ACHAR QUANTOS DIAS CADA PESSOA PARTICIPOU
-- C. DEPOIS FAZER A MEDIA DE TODOS

WITH tb_primeiro_dia AS (
    SELECT 
        DISTINCT IdCliente
    FROM transacoes
    WHERE substr(transacoes.DtCriacao, 1, 10) = '2025-08-25'
),

tb_contagem_dias AS (
    SELECT 
        t1.IdCliente,
        count(DISTINCT substr(t2.DtCriacao, 1, 10)) AS qtDeDias
    FROM tb_primeiro_dia AS t1
    
    LEFT JOIN transacoes AS t2
    ON t1.IdCliente = t2.IdCliente

    WHERE t2.DtCriacao >= '2025-08-25'
    AND t2.DtCriacao < '2025-09-01'

    GROUP BY t1.IdCliente
    ORDER BY t2.DtCriacao DESC
)

SELECT 
    AVG(qtDeDias),
    1. * 6 / sum(qtDeDias)
FROM tb_contagem_dias


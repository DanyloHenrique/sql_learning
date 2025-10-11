-- 10. Como foi a curva de Churn do Curso de SQL?

-- Maneira errada

-- resultado da query:
/* 
452	2025-08-25
334	2025-08-26
312	2025-08-27
273	2025-08-28
304	2025-08-29
 */
-- Nesse resultado, não está sendo garantido que
-- as pessoas dos dias posteriores são as mesmas do dia 1
-- Ou seja, pode ser que o resultado do segundo dia não demonstre
-- cada resultado está mostrando apenas a diferença, ou o engajamento
-- Pois pode ser que pessoas diferentes entraram no curso


SELECT 
    count(DISTINCT IdCliente) AS QtdeClientes,
    substr(DtCriacao, 1, 10) AS dia
FROM transacoes
WHERE DtCriacao >= '2025-08-25'
AND DtCriacao < '2025-08-31'

GROUP BY substr(DtCriacao, 1, 10);

--=====================JEITO CERTO===================================
WITH tb_cliente_primeiro_dia AS (
    SELECT 
        DISTINCT IdCliente 
    FROM transacoes
    WHERE substr(DtCriacao,1, 10) = '2025-08-25'
),

tb_todos_dias AS (
    SELECT
        IdCliente,
        substr(DtCriacao,1, 10) AS dia
    FROM transacoes

    WHERE DtCriacao > '2025-08-25'
    AND DtCriacao <= '2025-08-31'
)


SELECT 
    count(DISTINCT t1.IdCliente) AS QtdeClientes,
    t2.dia

FROM tb_cliente_primeiro_dia AS t1

INNER JOIN tb_todos_dias AS t2
ON t1.IdCliente = t2.IdCliente

GROUP BY t2.dia
ORDER BY dia;
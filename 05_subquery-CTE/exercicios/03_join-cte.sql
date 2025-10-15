-- 12. Dentre os clientes de janeiro/2025,
-- quantos assistiram o curso de SQL?


WITH tb_clientes_janeiro AS (
    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE DtCriacao >= '2025-01-01'
    AND DtCriacao < '2025-02-01'
),

tb_clientes_curso_sql AS (
    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-30'
)

SELECT 
    count(DISTINCT t1.IdCliente) AS clientesJaneiro,
    count(DISTINCT t2.IdCliente) AS clientesCurso
FROM tb_clientes_janeiro AS t1

LEFT JOIN tb_clientes_curso_sql AS t2
ON t1.IdCliente = t2.IdCliente
-- 13. Qual o dia com maior engajamento de cada aluno que iniciou o curso no dia 01?

-- Pegando os clientes do primeiro dia
WITH tb_clientes_primeiro_dia AS(
    SELECT DISTINCT idCliente
    FROM transacoes
    WHERE substr(DtCriacao, 1, 10) = '2025-08-25'
),

-- contando as interações dos clientes em todos os dias do curso
tb_qt_interacoes AS (
    SELECT 
        IdCliente,
        substr(DtCriacao, 1, 10) AS dia,
        count(DISTINCT IdTransacao) as QtdeInteracoes
    FROM transacoes

    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-31'

    GROUP BY IdCliente, dateTime(substr(DtCriacao, 1, 10))
),

--fazendo cruzamento dos clientes do primeiro dia e das interações todos os dias
tb_join AS (
    SELECT t2.* 
    FROM tb_clientes_primeiro_dia AS t1

    LEFT JOIN tb_qt_interacoes AS t2
    ON t1.IdCliente = t2.IdCliente
),

-- enumerando as linhas
tb_rn AS (
    SELECT *,
        row_number() OVER (PARTITION BY IdCliente ORDER BY QtdeInteracoes DESC, dia) AS RowNumber
    FROM tb_join AS t1
)

-- selecionando só as linhas enumeradas com 1 (mais interações)
SELECT * FROM tb_rn
WHERE RowNumber = 1


-- Quantidade de usuários cadastrados (absoluto e acumulado) 
-- ao longo do tempo?

-- Busca quantos clientes se cadastraram em cada dia
WITH tb_clientes_dia AS (
    SELECT  
        substr(DtCriacao, 1, 10) AS DtDiaCriacao,
        count(DISTINCT IdCliente) AS QtdeClientes
    FROM clientes

    GROUP BY DtDiaCriacao
    ORDER BY DtDiaCriacao
),

-- Calcula a soma total de clientes
tb_sum AS (
    SELECT 
        *,
        sum(QtdeClientes) OVER (ORDER BY DtDiaCriacao) AS sum 
    FROM tb_clientes_dia
)

SELECT *
FROM tb_sum
ORDER BY DtDiaCriacao



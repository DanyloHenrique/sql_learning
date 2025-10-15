-- Saldo de pontos acumulado de cada usuário

-- Busca os clientes 
-- e a quantidade de pontos de cada dia
WITH tb_pontos_dia AS (
    SELECT 
        IdCliente,
        substr(DtCriacao, 1, 10) AS DtDia,
        QtdePontos
    FROM transacoes

    GROUP BY IdCliente, DtDia
    ORDER BY IdCliente, DtDia
)

-- Faz a soma dia a dia dos pontos de cada cliente
SELECT *,
    sum(QtdePontos) OVER (PARTITION BY IdCliente ORDER BY DtDia) AS QtdePontosAcum
FROM tb_pontos_dia

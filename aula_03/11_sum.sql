SELECT 
    sum(QtdePontos),

    sum(CASE
        WHEN QtdePontos > 0 THEN QtdePontos
    END) AS QtdePontosPositivos,

    sum(CASE
        WHEN QtdePontos < 0 THEN QtdePontos
    END) AS QtdePontosNegativos,

    count(CASE
        WHEN QtdePontos < 0 THEN QtdePontos
    END) AS QtdeTransacoesNegativos 

FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'
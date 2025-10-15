SELECT 
    avg(QtdePontos),
    1. * sum(QtdePontos) / count(IdCliente), -- forma manual
    round(avg(QtdePontos), 2), -- fazendo arredondado
    min(QtdePontos) AS minCarteira,
    max(QtdePontos) AS maxCarteira,
    sum(FlTwitch),
    sum(FlEmail)
FROM clientes
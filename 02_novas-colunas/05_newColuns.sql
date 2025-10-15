-- Criando uma coluna para somar 100 pontos a mais para cada cliente
-- e uma outra coluna para dobrar a quantidade de pontos

SELECT 
    IdCliente,
    QtdePontos,
    QtdePontos + 100,
    QtdePontos * 2
FROM clientes   
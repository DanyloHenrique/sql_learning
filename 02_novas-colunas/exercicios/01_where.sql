-- A: Lista de transações com apenas 1 ponto;
SELECT *
FROM transacoes 
WHERE QtdePontos = 1

-- B: Lista de clientes com 0 (zero) pontos;
SELECT *
FROM clientes
WHERE QtdePontos = 0

-- C: Lista de clientes com 100 a 200 pontos (inclusive ambos);
SELECT *
FROM clientes
WHERE QtdePontos >= 100 AND QtdePontos <= 200
-- Ordernar a tabela por um campo
-- ORDER BY, que por padrão ordena do menor para o maior,
-- para ser o contrario é preciso passar o comando DESC

-- USAR O LIMIT PARA FAZER RANKS, COMO TOP 10
SELECT *
FROM clientes
ORDER BY QtdePontos DESC
LIMIT 10;

-- Clientes mais antigos e com mais pontos
SELECT *
FROM clientes
-- usando 2 critérios de ordenação
ORDER BY DtCriacao ASC, QtdePontos DESC;

-- Clientes mais antigos e com mais pontos, MAS APENAS CLIENTES QUE TEM TWITCH
SELECT *
FROM clientes
WHERE FlTwitch = 1
-- usando 2 critérios de ordenação
ORDER BY DtCriacao ASC, QtdePontos DESC
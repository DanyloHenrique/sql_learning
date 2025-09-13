-- Verificar a quantidade de linhas que existem na tabela

SELECT count(*)
FROM clientes;

-- DISTINCT - Busca os registros únicos de uma linha
SELECT DISTINCT FlEmail, FlTwitch
FROM clientes;
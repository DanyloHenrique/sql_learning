-- Contar as transações para um produto só
-- Desse jeito não é possível fazer para mais de um produto ao mesmo tempo
SELECT 
    IdProduto,
    count(*)
FROM transacao_produto
WHERE IdProduto = 15;

-- 1. Pega todas as linhas da tabela
-- 2. verifica quais tem o mesmo ID e cria um grupo para eles
-- 3. Dentro de cada grupo, o COUNT(*) conta quantas linhas existem.
-- 4. Faz o select para exibir o resultado
SELECT IdProduto,
        count(*)
FROM transacao_produto
GROUP BY IdProduto;


-- 1. Pega todas as linhas de transações de JULHO
-- 2.  verifica quais tem o mesmo IdCliente e cria um grupo para eles
-- 3. Faz o filtro no grupo (HAVING) e pega apenas os clientes (grupos) que possuem mais de 4 mil pontos
-- 4. Seleciona o IdCliente e cria as novas colunas
-- 5. Ordena pelo cliente que fez mais pontos
SELECT IdCliente,
    sum(QtdePontos) AS SomadePontos,
    round(avg(QtdePontos), 2) AS MediadePontos,
    count(IdTransacao) AS QtTransacoes
FROM transacoes

WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'

GROUP BY IdCliente
HAVING sum(QtdePontos) > 4000

ORDER BY sum(QtdePontos) DESC;
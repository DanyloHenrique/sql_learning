-- Qual cliente juntou mais pontos positivos em 2025-05?
SELECT 
    IdCliente,
    sum(QtdePontos)
FROM transacoes
WHERE DtCriacao >= '2025-05-01'
AND DtCriacao < '2025-06-01'
AND QtdePontos > 0

GROUP BY IdCliente

ORDER BY sum(QtdePontos) DESC
LIMIT 1;

-- ==============================================
-- Qual cliente fez mais transações no ano de 2024?
SELECT 
    IdCliente,
    count(IdTransacao) AS QtdeTransacoes
FROM transacoes
WHERE DtCriacao >= '2024-01-01'
AND DtCriacao < '2025-01-01'

GROUP BY IdCliente

ORDER BY count(IdTransacao) DESC
LIMIT 1;


-- ==============================================
-- Quantos produtos são de rpg?
SELECT count(*)
FROM produtos
WHERE DescCateogriaProduto = 'rpg';

-- OU

SELECT
    DescCateogriaProduto,
    count(*)
FROM produtos

GROUP BY DescCateogriaProduto;

-- ==============================================
-- Qual o valor médio de pontos positivos por dia?
SELECT 
    count(DISTINCT substr(DtCriacao, 1, 10)) AS totalDiasUnicos,
    sum(QtdePontos),
    sum(QtdePontos) /  count(DISTINCT substr(DtCriacao, 1, 10))

FROM transacoes
WHERE QtdePontos > 0

ORDER BY 1;

-- ==============================================
-- Qual o valor médio de pontos positivos de cada dia?
SELECT 
    substr(DtCriacao, 1, 10),
    avg(QtdePontos)
FROM transacoes
WHERE QtdePontos > 0

GROUP BY substr(DtCriacao, 1, 10)

ORDER BY avg(QtdePontos) DESC;

-- ==============================================
-- Qual dia da semana tem mais pedidos em 2025?
-- obs: começa por DOMINGO - 0
-- obs2: GROUP BY 1 significa ordernar pela primeira coluna
SELECT
    strftime('%w', dateTime(substr(DtCriacao, 1, 10))) AS diaDaSemana,
    count(IdTransacao) AS qtTransacoes

FROM transacoes
WHERE substr(DtCriacao, 1, 4) = '2025'

GROUP BY 1
ORDER BY count(IdTransacao) DESC;


-- ==============================================
-- Qual o produto mais transacionado?
SELECT 
    IdProduto,
    count(*) AS QtdeTransacoes
FROM transacao_produto

GROUP BY IdProduto
ORDER BY QtdeTransacoes DESC;

-- ==============================================
-- Qual o produto com mais pontos transacionados?
SELECT 
    IdProduto,
    sum(VlProduto * QtdeProduto) AS TotalValor,
    sum(QtdeProduto) AS QtdeVendas

FROM transacao_produto

GROUP BY IdProduto
ORDER BY sum(VlProduto) DESC;
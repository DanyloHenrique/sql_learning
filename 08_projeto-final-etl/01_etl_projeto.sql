/* 
Vamos construir uma tabela (Feature Store) com o perfil comportamental dos nossos usuários.
1-Quantidade de transações históricas (vida, D7, D14, D28, D56);
2-Dias desde a última transação
3-Idade na base
4-Produto mais usado (vida, D7, D14, D28, D56);
5-Saldo de pontos atual;
6-Pontos acumulados positivos (vida, D7, D14, D28, D56);
7-Pontos acumulados negativos (vida, D7, D14, D28, D56);
8-Dias da semana mais ativos (D28)
9-Período do dia mais ativo (D28)
10-Engajamento em D28 versus Vida
 */


-- CREATE TABLE tb_feature_store_cliente AS

 WITH tb_transacao AS (
    SELECT 
        IdTransacao,
        IdCliente,
        QtdePontos,

        dateTime(substr(DtCriacao, 1, 19)) AS DtCriacao,
        julianDay('2025-07-01') - julianday(substr(DtCriacao, 1, 10)) AS diffDate,

        CAST(strftime('%H', substr(DtCriacao, 1, 19)) AS INTEGER) AS dtHora
    
    FROM transacoes
    WHERE DtCriacao < '2025-07-01'
),

tb_sumario_transacoes AS (
    SELECT 
        IdCliente,
        count(IdTransacao) AS QtDeTransacoes,

        count(CASE WHEN diffDate <= 56 THEN IdTransacao END) AS QtDeTransacoes56,
        count(CASE WHEN diffDate <= 28 THEN IdTransacao END) AS QtDeTransacoes28,
        count(CASE WHEN diffDate <= 14 THEN IdTransacao END) AS QtDeTransacoes14,
        count(CASE WHEN diffDate <= 7 THEN IdTransacao END) AS QtDeTransacoes7,
        
        min(diffDate) AS diasUltimaTransacao,
        sum(QtdePontos) AS saldoTotal,

        sum(CASE WHEN QtdePontos >= 0 THEN QtdePontos END) AS SaldoPositivoVida,
        sum(CASE WHEN QtdePontos >= 0 AND diffDate <= 56 THEN QtdePontos END) AS SaldoPositivo56,
        sum(CASE WHEN QtdePontos >= 0 AND diffDate <= 28 THEN QtdePontos END) AS SaldoPositivo28,
        sum(CASE WHEN QtdePontos >= 0 AND diffDate <= 14 THEN QtdePontos END) AS SaldoPositivo14,
        sum(CASE WHEN QtdePontos >= 0 AND diffDate <= 7 THEN QtdePontos END) AS SaldoPositivo7,

        sum(CASE WHEN QtdePontos < 0 THEN QtdePontos END) AS SaldoNegativoVida,
        sum(CASE WHEN QtdePontos < 0 AND diffDate <= 56 THEN QtdePontos END) AS SaldoNegativo56,
        sum(CASE WHEN QtdePontos < 0 AND diffDate <= 28 THEN QtdePontos END) AS SaldoNegativo28,
        sum(CASE WHEN QtdePontos < 0 AND diffDate <= 14 THEN QtdePontos END) AS SaldoNegativo14,
        sum(CASE WHEN QtdePontos < 0 AND diffDate <= 7 THEN QtdePontos END) AS SaldoNegativo7    

    FROM tb_transacao
    GROUP BY IdCliente
),

tb_cliente AS (
    SELECT 
        IdCliente,
        substr(DtCriacao, 1, 10) AS DtCadastroCliente,
        julianDay('2025-07-01') - julianday(substr(DtCriacao, 1, 10)) AS idadeBase
    FROM clientes
),

tb_transacao_produto AS (
    SELECT 
        t1.*,
        t3.IdProduto,
        t3.DescProduto
    FROM tb_transacao AS t1

    LEFT JOIN transacao_produto AS t2
    ON t1.IdTransacao = t2.IdTransacao

    LEFT JOIN produtos AS t3
    ON t2.IdProduto = t3.IdProduto
),

tb_cliente_produto AS (
    SELECT
        IdCliente,
        DescProduto,
        count(IdProduto) AS QtVida,
        count(CASE WHEN diffDate <= 56 THEN IdTransacao END) AS Qt56,
        count(CASE WHEN diffDate <= 28 THEN IdTransacao END) AS Qt28,
        count(CASE WHEN diffDate <= 14 THEN IdTransacao END) AS Qt14,
        count(CASE WHEN diffDate <= 7 THEN IdTransacao END) AS Qt7
    FROM tb_transacao_produto

    GROUP BY IdCliente, DescProduto
    ORDER BY IdCliente
),

tb_cliente_produto_rn AS (
    SELECT *,
            row_number() OVER (PARTITION BY IdCliente ORDER BY QtVida DESC) AS rnVida,
            row_number() OVER (PARTITION BY IdCliente ORDER BY Qt56 DESC) AS rn56,
            row_number() OVER (PARTITION BY IdCliente ORDER BY Qt28 DESC) AS rn28,
            row_number() OVER (PARTITION BY IdCliente ORDER BY Qt14 DESC) AS rn14,
            row_number() OVER (PARTITION BY IdCliente ORDER BY Qt7 DESC) AS rn7
    FROM tb_cliente_produto
),

tb_transacao_diaSemana AS (
    SELECT 
        IdCliente,
        count(DISTINCT IdTransacao) AS QtdeTransacoesDia,
        strftime('%w', DtCriacao) AS dtDia
    FROM tb_transacao

    WHERE diffDate <= 28

    GROUP BY IdCliente, dtDia
    ORDER BY IdCliente
),

tb_cliente_dia_rn AS (
    SELECT 
        *,
        row_number() OVER (PARTITION BY IdCliente ORDER BY QtdeTransacoesDia DESC) AS rnDia
    FROM tb_transacao_diaSemana
),

tb_cliente_periodo AS (
    SELECT 
        IdCliente,

        CASE 
            WHEN dtHora BETWEEN 7 AND 12 THEN 'MANHÃ' 
            WHEN dtHora BETWEEN 13 AND 18  THEN 'TARDE' 
            WHEN dtHora BETWEEN 19 AND 23  THEN 'NOITE' 
            ELSE 'MADRUGADA'
        END AS periodo,

        count(DISTINCT IdTransacao) AS QtDeTransacoesPeriodo
    
    FROM tb_transacao
    WHERE diffDate <= 28
    GROUP BY 1, 2
),

tb_cliente_periodo_rn AS (
    SELECT *,
        row_number() OVER (PARTITION BY IdCliente ORDER BY QtDeTransacoesPeriodo DESC) AS rnPeriodo
    FROM tb_cliente_periodo
),

tb_join AS (
    SELECT
            t1.*,
            t2.DtCadastroCliente,
            t2.idadeBase,
            t3.DescProduto AS produtoVida,
            t4.DescProduto AS produto56,
            t5.DescProduto AS produto28,
            t6.DescProduto AS produto14,
            t7.DescProduto AS produto7,
            COALESCE(t8.DtDia, -1) AS DtDia,
            COALESCE(t9.periodo , 'SEM INFORMAÇÃO') AS periodoMaisTransacao28

    FROM tb_sumario_transacoes AS t1 

    LEFT JOIN tb_cliente AS t2
    ON t1.IdCliente = t2.IdCliente

    LEFT JOIN tb_cliente_produto_rn AS t3
    ON t1.IdCliente = t3.IdCliente
    AND t3.rnVida = 1

    LEFT JOIN tb_cliente_produto_rn AS t4
    ON t1.IdCliente = t4.IdCliente
    AND t4.rn56 = 1

    LEFT JOIN tb_cliente_produto_rn AS t5
    ON t1.IdCliente = t5.IdCliente
    AND t5.rn28 = 1

    LEFT JOIN tb_cliente_produto_rn AS t6
    ON t1.IdCliente = t6.IdCliente
    AND t6.rn14 = 1

    LEFT JOIN tb_cliente_produto_rn AS t7
    ON t1.IdCliente = t7.IdCliente
    AND t7.rn7 = 1

    LEFT JOIN tb_cliente_dia_rn AS t8
    ON t1.IdCliente = t8.IdCliente
    AND t8.rnDia = 1

    LEFT JOIN tb_cliente_periodo_rn AS t9
    ON t1.IdCliente = t9.IdCliente
    AND t9.rnPeriodo = 1
)

INSERT INTO tb_feature_store_cliente

SELECT 
    -- dtRef para safra
    '2025-07-01' AS dtRef,
    *,
    1. * QtDeTransacoes28 / QtDeTransacoes AS engajamento28Vida
FROM tb_join
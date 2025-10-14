-- CRIAR UMA TABELA DO ZERO

-- No arquivo 01 foi visto como criar uma tabela a partir de uma consula
-- Nesse, é como criar uma tabela do zero, ou seja, a estrutura da tabala

--Criando a estrutura da tabela
CREATE TABLE IF NOT EXISTS clientes_d28 (
	IdCliente varchar(250) PRIMARY KEY,
	QtdeTransacoes INTEGER
);

--vendo a estrutura
.schema clientes_d28

--limpando
DELETE FROM clientes_d28;

--inserindo dados
INSERT INTO clientes_d28

SELECT 
    IdCliente,
    count(distinct IdTransacao) AS Qtdetransacoes
FROM transacoes

WHERE julianday('2025-09-03') - julianday (substr(DtCriacao, 1,10)) <= 28
GROUP BY IdCliente
;

--buscando a tabela
SELECT * FROM clientes_d28;
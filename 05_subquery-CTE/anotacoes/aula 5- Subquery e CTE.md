As subquerys e o CTE são operações para aninhar ou preparar dados. São formas de criar resultados intermediários e temporários, que servem como um passo até o objetivo final. São duas ferramentas importantes para realizar consultas complexas e que são usadas quando a resposta depende de mais de uma tabela.

# Subquery 

É uma subconsulta ou subselect. A principal função de uma subquery é retornar dados que serão utilizados pela consulta externa para filtrar, comparar ou compor o resultado final.

## Sintaxe

 ```sql
 SELECT nome_produto, preco 
 FROM produtos 
 WHERE preco > (SELECT AVG(preco) FROM produtos);
 ```

```sql
SELECT cliente, total_pedidos
FROM (SELECT id_cliente, COUNT(id_pedido) AS total_pedidosFROM pedidos GROUP BY id_cliente) AS pedidos_por_cliente;
```

```sql
SELECT 
	nome_cliente, 
	(SELECT MAX(data_pedido) 
		FROM pedidos WHERE pedidos.id_cliente = clientes.id_cliente) AS ultimo_pedido
	
FROM clientes;
```

# CTE - Common Table Express

Uma Common Table Expression, ou CTE, é um conjunto de resultados temporário e nomeado. Ela funciona transformando uma consulta em uma tabela temporária cujo é definido um nome e essa tabela temporária pode ser utilizada para a realização de novas consultas. 

Nesse sentido, a CTE é uma forma de realizar consultas complexas por partes menores. Seu principal benefício é a melhora na legibilidade e manutenção, permitindo que a lógica seja dividida em blocos distintos e reutilizáveis.

De certa forma, é como colocar uma tabela como variável, ou mais precisamente, usando um `ALIAS` para uma consulta inteira.

## Sintaxe

Utilizado o comando **WITH** para definir que criaremos uma CTE. Logo em seguida é dado um nome para a tabela temporária, usamos então o AS e dentro de ( ) realizamos a consulta.

`WITH nome_tabela_temporaria AS ( SELECT * FROM tabela )`

Logo depois desse passo. Podemos criar novas CTE ao colocar uma vírgula no final da CTE anterior e **sem utilizar o WITH novamente**

`nome_tabela_temporaria_2 AS ( SELECT * FROM nome_tabela_temporaria )` `

Para finalizar a CTE fazer um último `SELECT` utilizando as tabelas temporárias necessárias.

`SELECT * FROM nome_tabela_temporaria_2`

```sql
WITH VendasPorVendedor AS (
    SELECT id_vendedor, COUNT(id_venda) AS total_vendas
    FROM vendas
    GROUP BY id_vendedor
)

SELECT v.nome, vpv.total_vendas
FROM vendedores v
JOIN VendasPorVendedor vpv ON v.id = vpv.id_vendedor;
```

# Ver as tabelas que estão no banco de dados

mysql: .table

outros sgbd: -- show tables

#### Aspas
aspas simples ' são usadas para acessar o valor de um campo
Em outros bancos aspas duplas são para acessar o campo
e é comum usar aspas duplas para comparar 2 valores diferentes

# Consultas na tabela
Buscando todos os dados de uma tabela chamada clientes
SELECT * FROM clientes

**SELECT** - define o comando de seleção
**Asterisco ( * )** - define que vamos pegar todas as informações (linhas e colunas)
**FROM** - Serve para que digamos em qual tabela os dados vão ser buscados
**clientes** - o nome da tabela que vão ter seus dados resgatados

<mark style="background: #ADCCFFA6;">É comum fazer essa operação de forma inicial para conhecer a tabela, mas essa ação pode ser custosa do ponto de vista computacional.  Por isso, é recomendado usar o comando LIMIT junto de algum valor como 10 para que sejam resgatados apenas 10 entidades daquela tabela</mark>
#### Selecionando apenas alguns campos desejados
Invés de * é passado os nomes das colunas que desejam ser mostradas

```sql
SELECT IdCliente, QtdePontos, DtCriacao FROM clientes
```

Resultado (LIMIT 3)

| IdCliente                            | QtdePontos | DtCriacao                     |
| ------------------------------------ | ---------- | ----------------------------- |
| 000ff655-fa9f-4baa-a108-47f581ec52a1 | 19986      | 2024-02-01 00:00:00 +0000 UTC |
| 001749bd-37b5-4b1e-8111-f9fbba90f530 | 50         | 2024-02-01 00:00:00 +0000 UTC |
| 0019bb9e-26d4-4ebf-8727-fc911ea28a92 | 2          | 2024-02-01 00:00:00 +0000 UTC |

## Where
é uma cláusula, serve para definir uma condição que os dados precisam seguir para serem buscados

Exemplo: Buscar dados da tabela produto que sejam da categoria de RPG
```sql
SELECT *
FROM produtos
WHERE DescCateogriaProduto = 'rpg'
```
Nesse sentido, apenas os produtos que na DescCateogriaProduto sejam do tipo rpg serão buscados

<table><tr><th>IdProduto</th><th>DescProduto</th><th>DescCateogriaProduto</th><tr><tr><td>10</td><td>Daily Loot</td><td>rpg</td></tr><tr><td>18</td><td>Venda de Item: 1 - Bota das Sombras (200)</td><td>rpg</td></tr><tr><td>19</td><td>Venda de Item: 10 - Couraça das Sombras (300)</td><td>rpg</td></tr><tr><td>20</td><td>Venda de Item: 12 - Túnica Arcana (500)</td><td>rpg</td></tr><tr></table>


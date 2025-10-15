# Introdução

`Join` é uma clausula do SQL para combinar (Cruzar) os dados de mais de uma tabela com base em uma informação comum entre as tabelas. Nesse sentido, o `Join` serve para fazer uma consulta em mais de uma tabela ao mesmo tempo, onde é necessário identificar uma coluna que exista nas duas tabelas (Utilizamos o `ON` para isso).

Parte dos códigos ao final do texto: [[#Códigos JOIN]]
## Por exemplo
**Tabela produto**

| idProduto | Nome   | Preço |
| --------- | ------ | ----- |
| 1         | Banana | 10    |
| 2         | Maça   | 7     |
| 3         | Pera   | 5     |
**Tabela transações**

| idTransação | idProduto | QuantidadeComprada |
| ----------- | --------- | ------------------ |
| A           | 1         | 3                  |
| B           | 2         | 1                  |
| C           | 3         | 4                  |

**Consulta com JOIN**
Ao realizar a consulta utilizando Join é necessário identificar qual a coluna que vai ser usada para combinar as tabelas. No caso do exemplo, será a coluna idProduto

Resultado:

| idProduto | Nome   | Preço | QuantidadeComprada | idTransação | idProduto | QuantidadeComprada |
| --------- | ------ | ----- | ------------------ | ----------- | --------- | ------------------ |
| 1         | Banana | 10    | 3                  | A           | 1         | 3                  |
| 2         | Maça   | 7     | 1                  | B           | 2         | 1                  |
| 3         | Pera   | 5     | 4                  | C           | 3         | 4                  |
<mark style="background: #FFB86CA6;">O resultado é, de forma simples, como definir que a partir da tabela produto, vamos buscar os dados da tabela transação e para isso utilizar como base a coluna IdProduto</mark>

Obs: idProduto aparece 2 vezes pois ele está presente nas duas tabelas

# Tipos de JOINS

Um ponto de atenção é o fato de que uma tabela pode ter uma entidade (ocorrência ou linha) que a outra não tem e para lidar com isso existem algumas possibilidades de realizar os Joins e cada um funciona com suas particularidades.
## Left Join
Nesta mecânica, o SQL se baseia na tabela da esquerda (ou primeira) para buscar os dados da segunda tabela, caso um dado da primeira tabela não esteja presente na segunda, ele fará a busca apenas da primeira parte e colocará null nas colunas pertencentes a tabela 2

| idProduto | Nome   | Preço |
| --------- | ------ | ----- |
| 1         | Banana | 10    |
| 2         | Maça   | 7     |

| idTransação | idProduto | QuantidadeComprada |
| ----------- | --------- | ------------------ |
| A           | 1         | 3                  |
| C           | 3         | 4                  |
**Resultado LEFT JOIN**

| idProduto | Nome   | Preço | idTransação | idProduto | QuantidadeComprada |
| --------- | ------ | ----- | ----------- | --------- | ------------------ |
| 1         | Banana | 10    | A           | 1         | 3                  |
| 2         | Maça   | 7     | null        | null      | null               |
Nesse resultado é possível ver:
- Como o produto 1 veio totalmente preenchido pois existe nas 2 tabelas
- O produto 2 veio com dados null nas colunas pertencentes a segunda tabela pois ele não está presente na mesma
- A transação 3 e idProduto 3 não foi listada, pois estamos buscando os dados com base na primeira tabela e não existe um produto de idProduto 3 nesta.


## INNER JOIN

Nessa operação, o SQL faz a busca apenas dos dados que existem nas 2 tabelas, ignorando os produtos que não estão presentes em alguma.

| idProduto | Nome   | Preço |
| --------- | ------ | ----- |
| 1         | Banana | 10    |
| 2         | Maça   | 7     |

| idTransação | idProduto | QuantidadeComprada |
| ----------- | --------- | ------------------ |
| A           | 1         | 3                  |
| C           | 3         | 4                  |

**Resultado INNER JOIN**

| idProduto | Nome   | Preço | idTransação | idProduto | QuantidadeComprada |
| --------- | ------ | ----- | ----------- | --------- | ------------------ |
| 1         | Banana | 10    | A           | 1         | 3                  |
Nesse resultado vemos:
- O produto 1 é listado pois existe nas duas tabelas
- O produto 2 não foi listado pois não existe na segunda tabela
- A transação C não foi listada pois não existe na primeira tabela

## RIGHT JOIN

<mark style="background: #ADCCFFA6;">Não suportado pelo SQLite</mark>

É o inverso do LEFT JOIN, ele faz a busca na tabela 1 com base na tabela 2
Obs: é o mesmo que fazer `FROM tabela 2 LEFT JOIN tabela 1`

| idProduto | Nome   | Preço |
| --------- | ------ | ----- |
| 1         | Banana | 10    |
| 2         | Maça   | 7     |

| idTransação | idProduto | QuantidadeComprada |
| ----------- | --------- | ------------------ |
| A           | 1         | 3                  |
| C           | 3         | 4                  |
**Resultado do RIGHT JOIN**

| idProduto | Nome   | Preço | idTransação | idProduto | QuantidadeComprada |
| --------- | ------ | ----- | ----------- | --------- | ------------------ |
| 1         | Banana | 10    | A           | 1         | 3                  |
| null      | null   | null  | C           | 3         | 4                  |

- Vemos o produto 1 ser listado perfeitamente
- O produto 2 não é listado pois não existe na tabela 2
- E a transação C é listada com null nas colunas da tabela 1

# Códigos JOIN

## Passo a Passo
1. Primeiro usamos o `SELECT FROM` 
2. Depois usamos o `LEFT JOIN` ou `INNER JOIN`
3. Por fim usamos o `ON` para dizermos qual a coluna de cada tabela vamos usar para cruzar os dados

<mark style="background: #ADCCFFA6;">OBS: Também é possível utilizar o AS para renomear as tabelas</mark>
## Left Join

```SQL
SELECT
    *,
FROM transacoes
LEFT JOIN produto
ON transacoes.IdProduto = produto.IdProduto
```

## Inner Join

```SQL
SELECT
    *,
FROM transacoes AS t1
INNER JOIN produto AS t2
ON t1.IdProduto = t2.IdProduto
```

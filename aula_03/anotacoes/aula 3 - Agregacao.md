Sintetizar (Agregar ou sumarizar) a informação é o processo de pegar dados de várias linhas e combiná-los em um único valor que resuma a informação.

<mark style="background: #FF5582A6;">Funções para sintetizar os dados</mark>

- **Contagem de linhas** - count( * )
- **Contagem de linhas distintas** - count(distinct column)
- **Soma** - sum(column)
- **Média** - avg(column)
- **Máximo** - max(column)

# Função de Agregação - resumir
## Distinct

saber quantos clientes fizeram tranasações


### count(idClient)
conta registro totais

### count(DISTINCT idClient)
conta apenas os registros sem repetir os clientes

### Exemplo:

tabela
emy
emy
danylo

count(idClient) = 3 pq tem 3 registros de clientes
count(DISTINCT idClient) = 2 porque conta apenas 1 registro por cliente

## Sum
Toda vez que fazemos a soma criamos uma coluna nova

movimentação geral de pontos (positivos e negativos): sum(qtdPontos)

quando for necessario criar mais colunas pode ser usado o case when then
e para espremer essas novas colunas deve ser usado a função sum e passar como parametro o case

```sql
SELECT 
```


## Estatísticas

AVG - calcular a média das transações

```sql
SELECT avg(QtdePontos) AS mediaCarteira

FROM clientes
```


min - pega o menor valor

```sql
SELECT min(QtdePontos) AS minimoCarteira

FROM clientes
```

max - pega o maior valor

```sql
SELECT max(QtdePontos) AS maximoCarteira

FROM clientes
```


Quantas pessoas tem tiwtch

pode ser usado porque o FlTwitch  tem valores 1 para quem tem twitch e 0 para quem não tem
então a soma fica 

```sql
SELECT sum(FlTwitch)
FROM clientes
```


# GroupBY

"agrupar por"

agrupar por idProduto

faz a sum de todas as transações separando por idProduto


posso pegar varios dados de um mesmo cliente e transformar em uma linha so de um cliente e espreme a outra coluna 

# Having

Um filtro depois da agregação

# Anotações
granuralidade

nivel

agregação espreme a tabela inteira e agroupby espreme a tabela no nivel de um dado escolhido

primeiro agrupa e depois ordena porque não tem como ordenar por uma var que ainda não existe

se quiser limitar pode usar o limit depois de ordenar (sempre vai ser o ultimo)


where é um momento de pegar os dados do banco,  então não é possível filtrar agregações ou fazer manipulações
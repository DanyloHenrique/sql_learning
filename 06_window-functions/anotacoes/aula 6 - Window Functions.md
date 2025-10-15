# Window Functions

## 1- Introdução

No SQL, as operações de comparação geralmente acontecem entre dados da mesma linha. Entretanto, existem situações em que naturalmente é necessário a comparação ou cálculos dependendo de dados de outras linhas ou com um determinado subconjunto dentro da consulta.

Por exemplo: em uma tabela onde cada compra ocupa uma linha, pode ser necessário calcular o intervalo de dias entre uma compra atual e a anterior do mesmo cliente. Porém, como esses dados estão em linhas diferentes, não é possível, de uma forma simples, fazer essa comparação de forma direta com operadores tradicionais.

É nesse cenário que entra as **Window Functions**. São uma ferramenta que permite, para cada linha, criar novas colunas com valores derivados de outras linhas ou do subconjunto.

**Exemplo de tabela**

| id_cliente | data_compra |
| ---------- | ----------- |
| 101        | 2023-01-15  |
| 101        | 2023-01-25  |
| 101        | 2023-03-02  |

**Tabela após Window Function** 

Exemplo de tabela após realizar Window Functions e uma operação de comparação entre as datas

| id_cliente | data_compra | data_compra_anterior | dias_desde_ultima_compra |
| ---------- | ----------- | -------------------- | ------------------------ |
| 101        | 2023-01-15  | NULL                 | NULL                     |
| 101        | 2023-01-25  | 2023-01-15           | 10                       |
| 101        | 2023-03-02  | 2023-01-25           | 36                       |

Sendo possível perceber a terceira coluna que foi criada com o dado de ‘data_compra’ da linha anterior

E a última coluna que é a comparação entre o da compra atual (coluna 2) — a data da compra anterior (coluna 3), tal comparação se torna possível pois ambos os dados foram colocados na mesma linha

Um ponto importante é que, diferente das funções de agregação com o `GROUP BY` que agregam diversas linhas em apenas uma, as funções de janela mantêm as linhas originais na tabela, permitindo a mistura dos valores.

## 2- Entendendo na prática

O Window Functions é utilizado em combinação com funções do SQL que podem ser divididas em 3 tipos:

- Ranqueamento (Classificação): `row_number`, `rank` e `dense_rank`
- Agregação: `sum`, `avg` e `count`
- Deslocamento: `lag` e `lead`

Um ponto importante é que as funções de **agregação** já existem isoladamente no SQL e são usadas com a cláusula `GROUP BY`. Porém, quando usadas com a clausula `OVER` são transformadas em **Funções de Janela de Agregação**. Além disso, as funções de **ranqueamento** e **deslocamento** só podem ser usadas junto das Window Functions.

logo após a função escolhida, é usado a cláusula `OVER` para definir a Window Functions

### 2.1- OVER

O Window Functions utiliza a cláusula `OVER()`, ela serve para definir que vamos utilizar Window Functions e dentro de seus parênteses são passados os parâmetros para a função

### 2.2- PARTITION BY

O primeiro parâmetro (Que em alguns casos não é necessário) é o `PARTITION BY`, com ele definimos qual o grupo de linhas que a Window Functions vai iterar até reiniciar, essa é a ação de particionar a tabela, ou seja, dividir a tabela em partes diferentes.

Por exemplo: Em uma consulta com questões escolares, podemos particionar a tabela pela disciplina de cada questão. Nesse sentido, um cálculo seria feito com as questões de matemática, depois um cálculo com as questões de português, depois ciências e assim por diante.

### 2.3- ORDER BY

logo depois de realizar a partição, deve ser utilizada `ORDER BY` dentro da cláusula `OVER` para definir qual a ordem que as linhas serão operadas e definido qual a coluna que servira de base para a ordenação.

Não deve ser confundindo com o uso do `ORDER BY` na parte final da query para ordenação da tabela, dentro da Window Functions ele é utilizado apenas para o cálculo do resultado.

### 2.4 -  Coluna de desempate (opcional)

Após o `ORDER BY`, é possível adicionar uma ou mais colunas extras para desempate quando houver valores iguais na ordenação principal.  
 Isso garante que o resultado da janela seja determinístico (ou seja, a ordem não varia entre execuções quando há empates).

### 2.5- Sintaxe final

**Estrutura:**

```sql
função_de_janela() OVER (PARTITION BY coluna_para_dividir_tabela ORDER BY coluna_de_ordenação, coluna_de_desempate)
```

**Exemplo:**

```sql
ROW_NUMBER() OVER (  
 PARTITION BY disciplina  
 ORDER BY QtDeRespostas DESC, dataCriacao ASC  
)
```

## 3- Funções do Window Functions

### 3.1- Ranqueamento com Row_number, Rank, Dense_rank

A função de enumerar as linhas `row_number` tem grande importância dentro do SQL para consultas avançadas. Ela é utilizada para criar uma coluna com a posição de cada linha de um determinado grupo

A função `rank` funciona de forma semelhante, com a diferença de que a numeração da linha é repetida em caso de valores iguais. Nesse caso de empate, uma **lacuna aparece na sequência** para cada classificação duplicada. Exemplo: duas linhas recebem a classificação 2, a próxima ocorrência recebe a classificação 4, ao invés de 3.

Já na função `dense_rank` não existe a lacuna, caso duas linhas recebem a classificação 2, a próxima ocorrência seria a número 3 normalmente.

**Exemplo com tabela de personagens:**


| Nome          | origem | Episodios |
| ------------- | ------ | --------- |
| Luffy         | anime  | 1000      |
| Naruto        | anime  | 1000      |
| Kira          | anime  | 500       |
| Michael Scott | série  | 150       |
| Jake Peralta  | série  | 90        |

**Ao utilizar a row_number, rank e dense_rank:**

```sql
SELECT 
	row_number() OVER (PARTITION BY origem ORDER BY Episodios DESC)
	rank() OVER (PARTITION BY origem ORDER BY Episodios DESC)
	dense_rank() OVER (PARTITION BY origem ORDER BY Episodios DESC)
FROM personagens
```

| Nome          | origem | Episodios | row_number() | rank() | dense_rank() |
| ------------- | ------ | --------- | ------------ | ------ | ------------ |
| Luffy         | anime  | 1000      | 1            | 1      | 1            |
| Naruto        | anime  | 1000      | 2            | 1      | 1            |
| Kira          | anime  | 100       | 3            | 3      | 2            |
| Jake Peralta  | série  | 150       | 1            | 1      | 1            |
| Michael Scott | série  | 90        | 2            | 2      | 2            |

É possível observar como para cada tipo diferente de origem a função de janela vai fazendo a ordenação e a contagem. Além disso, a cerca do resultado temos:

- A função `row_number` realiza a numeração sem se preocupar com valores repetidos.
- A função `rank` pulou o número 2 para o grupo de anime, pois houve duas ocorrências na primeira posição
- A função `dense_rank` também colocou duas ocorrências na primeira posição dos personagens de anime, porém continuou a numeração sem pular nenhum valor

#### Utilização prática das funções de ranqueamento

Com o `ORDER BY` por padrão sendo ascendente, temos que a row_number com valor 1 é sempre a entidade com o menor valor da coluna que foi ordenada. Nesse caso, com um simples `WHERE row_number = 1` seria possível pegar todas as entidades com o menor valor. Ou o contrário caso o `ORDER BY` seja Decrescente 

**Exemplos de utilizações com ORDER BY ASCENDENTE:**

- Buscar o mês que cada cliente fez menos compras
- Buscar o dia da semana que cada produto menos vende
- Buscar o funcionário com o menor salário de cada departamento

**Exemplos de utilizações com ORDER BY DECRESCENTE:**

- Buscar o mês que cada cliente fez **MAIS** compras
- Buscar o dia da semana que cada produto **MAIS** vende
- Buscar o funcionário com o **MAIOR** salário de cada departamento

### 3.2- Funções de agregação Sum e Avg

Ao utilizar a função `sum` em uma cláusula `OVER()`, é possível criar uma **soma acumulada** (ou soma móvel) para executar tarefas que mostrem o aumento gradual de um valor ao longo do tempo. Ela recebe como parâmetro a coluna que queremos somar.

De forma similar, a função `avg` é utilizada para realizar a **média móvel**. Ela funciona calculando a média do valor da linha atual e de todas as linhas anteriores dentro da mesma **partição** (ou subgrupo).

**Utilizando sum e avg:**

```sql
SELECT
	*,
	sum(saldo) OVER(PARTITION BY idCliente ORDER BY dia_transacao) AS sum,
	avg(saldo) OVER(PARTITION BY idCliente ORDER BY dia_transacao) AS avg
FROM transacoes
```

| idCliente | dia_transacao | saldo | sum  | avg     |
| --------- | ------------- | ----- | ---- | ------- |
| 1         | 2025-10-09    | 100   | 100  | 100     |
| 1         | 2025-10-11    | 200   | 300  | 150     |
| 2         | 2025-09-20    | 500   | 500  | 500     |
| 2         | 2025-09-22    | 1000  | 1500 | 750     |
| 2         | 2025-09-28    | 2000  | 3500 | 1167.67 |

**Resultado:**

- É possível ver que foram criadas uma coluna `sum` e uma coluna `avg`
- Para cada cliente, a sum() é a soma do saldo naquela linha + o valor da coluna sum() da linha anterior
- Para cada cliente, a coluna `avg()` é a **média de todos os saldos** desde a primeira linha até a linha atual (sempre dentro do grupo daquele cliente).

### Utilização prática das funções de agregação

Diferente das funções de ranqueamento que determinam a _posição_ de uma linha, as funções de agregação de janela (`SUM`, `AVG`, `COUNT`, etc.) calculam um valor a partir de um conjunto de linhas e retornam esse resultado em cada linha. Isso é extremamente útil para criar cálculos contextuais, como totais acumulados, médias móveis e análises de proporção.

A utilização mais comum se divide em duas categorias:

- **Cálculos Acumulados (com** `**ORDER BY**`**):** Para ver a progressão de um valor ao longo do tempo.
- **Cálculos de Grupo (sem** `**ORDER BY**`**):** Para comparar o valor de uma linha com o total de seu grupo.

## 3.3 Funções de deslocamento Lag e Lead

A função `LAG` é uma função de deslocamento utilizada para trazer valores de linhas anteriores para a linha atual. Já a função `LEAD`, faz o oposto, ela serve para trazer valores de linhas posteriores a atual.

Isso torna possível comparar valores que originalmente estavam em linhas diferentes, sendo bastante útil para:

- Comparar datas ou números entre registros
- Calcular intervalos entre eventos
- Identificar variações e tendências linha a linha

### Exemplo prático

Considere uma tabela de transações com os clientes e as datas das compras:

| idCliente | dia_transacao |
| --------- | ------------- |
| 1         | 2025-10-09    |
| 1         | 2025-10-11    |
| 2         | 2025-09-20    |
| 2         | 2025-09-22    |
| 2         | 2025-09-28    |

Se quisermos saber qual foi a compra anterior e posterior de cada cliente, podemos usar `LAG` e `LEAD`

```sql
SELECT 
	*,
	lag(dia_transacao) OVER (PARTITION BY idCliente ORDER BY dia_transacao) AS lag_transacao,
	lead(dia_transacao) OVER (PARTITION BY idCliente ORDER BY dia_transacao) AS lead_transacao
FROM transacoes
```

**Saída:**

| idCliente | dia_transacao | lag_transacao | lead_transacao |
| --------- | ------------- | ------------- | -------------- |
| 1         | 2025-10-09    | null          | 2025-10-11     |
| 1         | 2025-10-11    | 2025-10-09    | null           |
| 2         | 2025-09-20    | null          | 2025-09-22     |
| 2         | 2025-09-22    | 2025-09-20    | 2025-09-28     |
| 2         | 2025-09-28    | 2025-09-22    | null           |

**Resultado da consulta:**

- `PARTITION BY idCliente` separou os dados por cliente
- `ORDER BY dia_transacao` ordenou as compras cronologicamente;
- A função `LAG` traz o valor da linha anterior para a coluna `lag_transacao`; quando não existe linha anterior, o valor é `NULL`.
- A função `LEAD` traz o valor da linha posterior para a nova coluna `lead_transacao` e seu valor é `NULL` quando não existe linha posterior

### Realizando as comparações com CTE

Uma das vantagens das Window Functions é que elas podem ser combinadas com CTEs (Common Table Expressions) para gerar cálculos derivados.

No exemplo anterior, com a criação da coluna lag_transacao, através da função `lag`, é possível verificar qual o intervalo de dias entre as transações do clientes

```sql
WITH tb_lag_lead AS (
	SELECT
		idCliente,
		dia_transacao,
		lag(dia_transacao) OVER (PARTITION BY idCliente ORDER BY dia_transacao) AS lag_transacao
	FROM transacoes
)

SELECT *,
	dia_transacao - lag_transacao AS diferencaDias
FROM tb_lag_lead
```

| idCliente | dia_transacao | lag_transacao | diferencaDias |
| --------- | ------------- | ------------- | ------------- |
| 1         | 2025-10-09    | null          | null          |
| 1         | 2025-10-11    | 2025-10-09    | 2             |
| 2         | 2025-09-20    | null          | null          |
| 2         | 2025-09-22    | 2025-09-20    | 2             |
| 2         | 2025-09-28    | 2025-09-22    | 6             |

**Resultado da consulta:**

- Temos agora uma coluna com a informação de quanto tempo um cliente leva para realizar novas transações
- Esse resultado pode ser agregado com a função `AVG` para calcular a média de dias que cada cliente leva para fazer transações

**Conclusão:** As funções `LAG` e `LEAD` são ferramentas poderosas para análises comparativas em SQL, permitindo acessar dados de linhas anteriores ou posteriores sem perder o detalhamento linha a linha.

## 4- Desempenho das Window Functions

Um ponto sempre crucial quando o assunto é banco de dados é o **desempenho**. O resultado da query obtido ao utilizar Window Functions também pode ser obtido com mais trabalho escrevendo querys manuais com CTE, Subquerys e JOINs

Geralmente, as **Window Functions têm um desempenho excelente** e são quase sempre a opção mais eficiente para as tarefas que realizam. Na maioria dos sistemas de banco de dados modernos (PostgreSQL, SQL Server, Oracle, BigQuery, etc.), elas são altamente otimizadas.

Existem 2 fatores principais para as Window Functions serem a opção de melhor desempenho:

- **Varredura única:** Consultas analíticas complexas se tornam rápidas porque o cálculo pode ser realizado usando apenas uma única varredura na tabela
- **processamento em paralelo:** Quando a cláusula `PARTITION BY` é utilizada, o otimizador de consulta pode executar cada agregação (ou função de classificação) em paralelo, distribuindo a carga de trabalho em várias fatias

## 5- Conclusão geral

As Window Functions representam uma das ferramentas mais poderosas e modernas do SQL, pois permitem realizar cálculos avançados sem perder o nível de detalhamento linha a linha.
Com funções como `LAG`, `LEAD`, `ROW_NUMBER`, `RANK`, `SUM` e `AVG`, é possível comparar registros, identificar padrões, calcular intervalos, criar rankings e obter totais acumulados de forma simples e legível.
Além disso, o uso combinado com CTEs torna o código mais organizado e facilita cálculos derivados, como a diferença entre eventos ou médias por cliente.
Em resumo, Window Functions unem **flexibilidade, eficiência e clareza**, sendo ideais para análises comparativas, cálculos progressivos e manipulação de dados em nível detalhado.

# DDL E DML

## 1- Introdução

### Contexto do Problema: Otimizando Dashboards com Tabelas de Relatório

Imagine uma plataforma de dashboards muito utilizada em uma empresa. Vários usuários, de diferentes áreas, acessam esses painéis simultaneamente. Por trás de cada gráfico e número, a plataforma dispara consultas (queries) para o banco de dados.

O problema surge quando:

- Vários usuários acessam simultaneamente

- As mesmas consultas são complexas ou envolvem agregações pesadas

- O banco precisa recalcular tudo em tempo real

Isso pode causar lentidão e sobrecarga da engine do banco de dados.

**A solução prática** é executar a query complexa uma vez e salvar o resultado em uma tabela permanente dentro do banco. Assim, as ferramentas de Dashboard consultam essa tabela pronta, e o banco não precisa recalcular tudo novamente sempre.

É aqui que entram os conceitos de DDL e DML, os pilares para construir e manter essa solução.

### A Importância de DDL e DML: Arquiteto vs. Operário

Para gerenciar nosso banco de dados, usamos dois tipos de linguagem SQL:

- **DDL (Data Definition Language - Linguagem de Definição de Dados):** Pense no DDL como o **arquiteto** do banco de dados. São os comandos que criam, alteram e destroem a **estrutura** dos dados. Eles não mexem nos dados em si, mas sim nos "contêineres" que os armazena

    - `CREATE`: Constrói uma nova tabela, definindo suas colunas e tipos

	- `DROP`: Demole uma tabela existente

	- `ALTER`: Reforma uma tabela, adicionando ou removendo colunas

- **DML (Data Manipulation Language - Linguagem de Manipulação de Dados):** Pense no DML como o **operário** que trabalha com os dados **dentro** das estruturas criadas pelo DDL
    - `SELECT`: Lê e busca os dados

    - `INSERT`: Adiciona novos dados (novas linhas) em uma tabela

    - `UPDATE`: Modifica dados que já existem em uma tabela

    - `DELETE`: Remove dados (linhas) de uma tabela

Para nossa solução de otimização, precisaremos de ambos: DDL para criar nossa tabela de relatório e DML para mantê-la sempre atualizada.

## 2 - Na prática

### 2.1- Código da consulta

```sql
WITH tb_dia_transacoes AS (
    SELECT
        substr(DtCriacao, 1, 10) AS DtDia,
        COUNT(DISTINCT IdTransacao) AS QtDeTransacoes
    FROM transacoes
    GROUP BY DtDia
),

  

tb_transacoes_acumuladas AS (
    SELECT *,
        sum(QtDeTransacoes) OVER (ORDER BY DtDia) AS QtDeTransacoesAcum
    FROM tb_dia_transacoes
)

  

SELECT *
FROM tb_transacoes_acumuladas
```

**Saída:**

| DtDia      | QtDeTransacoes | QtDeTransacoesAcum |
| ---------- | -------------- | ------------------ |
| 2024-01-27 | 15             | 15                 |
| 2024-01-29 | 460            | 475                |
| 2024-01-30 | 400            | 875                |
| 2024-01-31 | 534            | 1409               |
| 2024-02-01 | 568            | 1977               |
| 2024-02-02 | 720            | 2697               |
| 2024-02-05 | 1710           | 4407               |
| 2024-02-06 | 1442           | 5849               |
| 2024-02-07 | 572            | 6421               |
| 2024-02-08 | 481            | 6902               |

### 2.2 Criando uma nova tabela no banco de dados

Para armazenar o resultado em uma nova tabela no banco de dados é necessário usar o comando `CREATE TABLE` antes da consulta. Logo após o comando passamos o nome que queremos dar para a tabela e finalizamos a linha usando o `AS`.

**Sintaxe:**
`CREATE TABLE nome_da_tabela AS`

**Com o código anterior:**

```sql
CREATE TABLE relatorio_diario AS

WITH tb_dia_transacoes AS (
    SELECT
        substr(DtCriacao, 1, 10) AS DtDia,
        COUNT(DISTINCT IdTransacao) AS QtDeTransacoes
    FROM transacoes
    GROUP BY DtDia
),

tb_transacoes_acumuladas AS (
    SELECT *,
        sum(QtDeTransacoes) OVER (ORDER BY DtDia) AS QtDeTransacoesAcum
    FROM tb_dia_transacoes
)

SELECT *
FROM tb_transacoes_acumulada
```

**Para verificar o resultado:**

Essa nova tabela que foi criada pode ser consultada igual uma tabela normal:

```sql
SELECT *
FROM relatorio_diario
```

E seu resultado será exatamente o mesmo resultado da query anterior, porém sem exigir que o banco de dados faça todo o cálculo de novo. Com um pequeno detalhes que essa mesma query dará erro na segunda vez que for executada, pois o banco identificará que a tabela já existe.

### 2.3 Drop Table

Uma mesma tabela não pode ser criada mais de uma vez com o mesmo nome e nem seria recomendado ficar criando a mesma tabela com nomes diferentes.
A solução prática adotada é: Antes de realizar a criação da tabela é executado um comando para deletar essa mesma tabela. Assim o banco de dados fica livre para a criação da mesma.

Para deletar a tabela usamos o comando `DROP TABLE` seguido do nome da tabela.

**Código:**

```sql
DROP TABLE relatorio_diario
CREATE TABLE relatorio_diario AS

WITH tb_dia_transacoes AS (
    SELECT
        substr(DtCriacao, 1, 10) AS DtDia,
        COUNT(DISTINCT IdTransacao) AS QtDeTransacoes
    FROM transacoes
    GROUP BY DtDia
),

tb_transacoes_acumuladas AS (
    SELECT *,
        sum(QtDeTransacoes) OVER (ORDER BY DtDia) AS QtDeTransacoesAcum
    FROM tb_dia_transacoes
)

SELECT *
FROM tb_transacoes_acumulada
```

O resultado dessa query é que sempre que essa query for executada ele tentará apagar a tabela para limpeza e então criará a tabela. No entanto pode existir um erro na primeira vez que a query for executada, onde a tabela não existe no banco de dados e o comando de `DROP TABLE` irá ocasionar em um erro.

A solução para isso é colocar uma condicional no comando de apagar e no comando de criar a tabela.

### 2.4 VERIFICAÇÃO COM IF EXIST

O comando IF EXIST é uma condição onde um comando só será realizado, caso exista o conteúdo. Nesse sentido, queremos apenas executar o comando de `DROP TABLE` caso a tabela `relatorio_diario` exista.

A condição `IF EXIST` também pode ser combinado com o operador `NOT`: Nesse caso, um comando só será executado caso o conteúdo não exista. Essa expressão será útil para o nosso comando de `CREATE TABLE` onde queremos criar a tabela apenas caso ela não exista.

**Como ficará o código:**

```Sql
DROP TABLE IF EXIST relatorio_diario
CREATE TABLE IF NOT EXIST relatorio_diario AS
```

Essas duas linhas serão executadas da seguinte forma:

- Caso a tabela **exista** ele executará o comando de `DROP TABLE`

- Caso a tabela **não exista** ele executará o comando de `CREATE TABLE`

Um problema nesse cenário é que nem sempre queremos excluir a tabela inteira, nesse caso de exclusão, caso alguém esteja conectado no Dashboard o conteúdo relacionado a essa tabela deixará de aparecer. Em muitos caso, o recomendado é apagar o conteúdo de dentro da tabela (Fazendo a tabela ficar vazia) e preenchendo de novo com o novo conteúdo.

### 2.5 Apagar o conteúdo da tabela com DELETE

Em muitos casos, não é ideal apagar e recriar a tabela inteira com `DROP TABLE`, principalmente quando outros usuários ou dashboards dependem dela. A alternativa é manter a estrutura e apenas remover os dados.

Para isso, usamos o comando `DELETE`, que faz parte do DML e atua **apenas no conteúdo, não na tabela em si**:

`DELETE FROM relatorio_diario`

Após esse comando:

- A tabela continua existindo normalmente;

- Um `SELECT` nela não dará erro, mas retornará vazia;

- A estrutura (colunas e tipos) permanece intacta.

Esse tipo de limpeza é útil quando a tabela será preenchida novamente com dados atualizados, sem interromper quem já está usando.

### 2.6 Colocando dados na tabela com INSERT

Depois de limpar a tabela, precisamos preenchê-la novamente com os dados atualizados. Para inserir novos registros, usamos o comando `INSERT`, também da linguagem DML.

Quando usamos o resultado de uma query ou CTE, o `INSERT` deve vir **antes do SELECT final**

```sql
DELETE FROM relatorio_diario

WITH tb_dia_transacoes AS (
    SELECT
        substr(DtCriacao, 1, 10) AS DtDia,
        COUNT(DISTINCT IdTransacao) AS QtDeTransacoes
    FROM transacoes
    GROUP BY DtDia
),

tb_transacoes_acumuladas AS (
    SELECT *,
        sum(QtDeTransacoes) OVER (ORDER BY DtDia) AS QtDeTransacoesAcum
    FROM tb_dia_transacoes
)

INSERT INTO relatorio_diario

SELECT *
FROM tb_transacoes_acumulada

SELECT * FROM relatorio_diario
```

Após isso, pode ser usado o `SELECT * FROM relatorio_diario` para buscar os dados novamente na tabela.

⚠️ **Atenção importante:**  
Se o comando `INSERT` for executado mais de uma vez sem antes limpar a tabela, os dados serão duplicados.

Por isso, o ciclo recomendado nesse caso é:

1. `DELETE` para limpar os registros antigos

2. `INSERT` para carregar os dados atualizados

3. `SELECT` apenas para visualização, se necessário

### 2.7 Alterando os dados com o UPDATE

Nem sempre é necessário remover e recarregar todos os registros de uma tabela. Em alguns casos, basta **alterar apenas parte dos dados já existentes**, e para isso utilizamos o comando `UPDATE`, que também faz parte do DML.

O `UPDATE` modifica linhas específicas com base em uma condição. A estrutura básica é:

```sql
UPDATE nome_da_tabela
SET coluna = novo_valor
WHERE condição
```

Aplicando no contexto do relatório:

```sql
SELECT * FROM relatorio_diario

UPDATE relatorio_diario
SET qtdTransacao = 1000
WHERE dtDia >= '2025-08-25'
```

Esse exemplo atualiza apenas os registros onde a data é maior ou igual ao dia informado. Se não houver cláusula `WHERE`, **toda a tabela será alterada**, o que pode ser perigoso em ambientes de produção.

#### Quando usar UPDATE?

- Para corrigir valores pontuais
- Para ajustar dados de um intervalo específico
- Para complementar cálculos já existentes
- Quando não é necessário recriar ou limpar a tabela inteira

Diferente do `INSERT` (que adiciona) e do `DELETE` (que remove), o `UPDATE` **altera registros já existentes**, mantendo a estrutura e os outros dados intactos.

### 2.8 Criando uma tabela do zero

Até aqui, foi mostrado como criar uma tabela a partir do resultado de uma consulta (`CREATE TABLE ... AS SELECT`). Agora, vamos ver como criar uma tabela **sem depender de outra previamente**, ou seja, definindo manualmente sua estrutura.

#### Exemplo: Criando uma tabela para armazenar clientes do último mês

Suponha que queremos criar uma tabela chamada `clientes_d28`, contendo:

- `IdCliente` → identificador único (chave primária)

- `QtdeTransacoes` → quantidade de transações do cliente

Antes de criar a tabela, é boa prática garantir que não exista uma tabela com o mesmo nome, evitando erro de duplicidade:

```sql
DROP TABLE IF EXISTS clientes_d28

CREATE TABLE IF NOT EXISTS clientes_d28 (
	IdCliente varchar(250) PRIMARY KEY,
	QtdeTransacoes INTEGER
)
```

**Verificar a estrutura da tabela:**

`.schema clientes_d28`

O resultado desse comando é:

```sql
CREATE TABLE clientes_d28 (
	IdCliente varchar(250) PRIMARY KEY,
	QtdeTransacoes INTEGER
)
```

Essa abordagem é útil quando:

- A tabela será preenchida manualmente ou por futuras queries

- Você quer controlar a tipagem de cada coluna

- Precisa de chaves primárias, constraints ou colunas específicas

Mais adiante, os dados podem ser inseridos com `INSERT`, atualizados com `UPDATE` ou apagados com `DELETE`, seguindo o mesmo fluxo do restante do conteúdo

## Ciclo completo

Ao trabalhar com tabelas que armazenam resultados de consultas complexas, especialmente para uso em dashboards, é comum repetir um fluxo que envolve **criação, limpeza, atualização e inserção de dados**. Para isso, combinamos comandos DDL e DML ao longo do processo.

O ciclo completo pode de duas formas:

### Deletando e inserindo dados

```sql
--cria a tabela
CREATE TABLE IF NOT EXISTS clientes_d28 (
    IdCliente varchar(250) PRIMARY KEY,
    Qtdetransacoes INTEGER
);

--limpando os dados da tabela
DELETE FROM clientes_d28;

--fazendo a inserção de dados
INSERT INTO clientes_d28
SELECT 
    IdCliente,
    count(distinct IdTransacao) AS Qtdetransacoes
FROM transacoes
WHERE julianday('now') - julianday (substr(DtCriacao, 1,10)) <= 28
GROUP BY IdCliente
;

-- buscando os dados dessa nova tabela
SELECT * FROM clientes_d28;
```

### Apagando e reconstruindo a tabela

```sql
DROP TABLE IF EXISTS clientes_d28;

CREATE TABLE clientes_d28 (
    IdCliente varchar(250) PRIMARY KEY,
    Qtdetransacoes INTEGER
);

INSERT INTO clientes_d28
SELECT 
    IdCliente,
    count(distinct IdTransacao) AS Qtdetransacoes
FROM transacoes
WHERE 
    julianday('now') - julianday (substr(DtCriacao, 1,10)) <= 28
GROUP BY 
    IdCliente
;

SELECT * FROM clientes_d28;
```

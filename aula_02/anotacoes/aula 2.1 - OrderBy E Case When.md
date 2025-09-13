# OrderBy
Order By (tradução: ordenar por) é usado para ordernar uma tabela com base em algum campo da tabela. É possível com esse comando, por exemplo, ordenar uma tabela pelos clientes que mais tem pontos.

Esse comando é usado depois do Where ou do From, e antes do limit que é sempre a última coisa.
<mark style="background: #FF5582A6;">Por padrão esse comando lista do menor para o maior (Ascendente) para mudar para o método descrescente (Maior para o menor) basta dar o comando DESC depois do nome da coluna</mark>

<mark style="background: #FF5582A6;">OrderBy + Limit serve para fazer ranks tipo top 10</mark>

```sql
SELECT *
FROM clientes
ORDER BY QtdePontos DESC
LIMIT 3;
```

| IdCliente                            | FlEmail | FlTwitch | FlYouTube | FlBlueSky | FlInstagram | QtdePontos | DtCriacao                         | DtAtualizacao                     |
| ------------------------------------ | ------- | -------- | --------- | --------- | ----------- | ---------- | --------------------------------- | --------------------------------- |
| 4fade907-6e0f-4581-a674-aad6622b1b10 | 0       | 1        | 0         | 0         | 0           | 40411      | 2025-03-07 12:59:27.541 +0000 UTC | 2025-09-10 13:58:36.67 +0000 UTC  |
| 000ff655-fa9f-4baa-a108-47f581ec52a1 | 0       | 0        | 0         | 0         | 0           | 19986      | 2024-02-01 00:00:00 +0000 UTC     | 2025-09-10 12:43:36.947 +0000 UTC |
| 1b08989c-039d-4c82-879b-0f56159a1ebb | 0       | 1        | 0         | 0         | 0           | 17095      | 2025-03-07 12:56:55.709 +0000 UTC | 2025-09-10 14:37:47.008 +0000 UTC |
# Case When

"O `CASE WHEN` em SQL é uma declaração que permite a você criar lógica condicional, similar a uma declaração **`IF-THEN-ELSE`** em outras linguagens de programação. Ele avalia uma ou mais condições e retorna um valor diferente para cada condição que é verdadeira"

"Ele permite que você "traduza" valores numéricos, datas ou até mesmo textos de uma coluna existente em rótulos ou categorias mais fáceis de entender."

Estrutura básica:

```sql
CASE
    WHEN condição1 THEN resultado1
    WHEN condição2 THEN resultado2
    ...
    ELSE resultado_final
END
```

## Exemplo 1: Criando uma nova coluna de categoria 
```sql
-- Criando apenas uma coluna nova

SELECT
    IdCliente,
    QtdePontos,
    
    CASE
        WHEN QtdePontos <= 500 THEN 'Ponei'
        WHEN QtdePontos <= 1000 THEN 'Ponei Premium'
        WHEN QtdePontos <= 5000 THEN 'Mago Aprendiz'
        WHEN QtdePontos <= 10000 THEN 'Mago Mestre'
        ELSE 'Mago Supremo'
    END AS NomeGrupo

FROM clientes
ORDER BY QtdePontos DESC
LIMIT 3
```

<table><tr><th>IdCliente</th><th>QtdePontos</th><th>NomeGrupo</th><tr><tr><td>4fade907-6e0f-4581-a674-aad6622b1b10</td><td>40411</td><td>Mago Supremo</td></tr><tr><td>000ff655-fa9f-4baa-a108-47f581ec52a1</td><td>19986</td><td>Mago Supremo</td></tr><tr><td>1b08989c-039d-4c82-879b-0f56159a1ebb</td><td>17095</td><td>Mago Supremo</td></tr></table>

## Criando uma categoria no estilo One Hot Encoding
Nessa estilo é possível criar uma estrutura de categoria onde existe uma coluna para cada tipo de categoria e os valores são de 0 ou 1.

Esse método tem 2 utilidades principais:
- Filtragem da tabela
- Projetos de machine learning

Por exemplo: Para uma tabela com preços, é possível ter categorias:
Barato, Médio ou Caro
Nessa estrutura, existe uma coluna para cada uma dessas 3 possibilidades e caso a entidade pertença a um dos grupos o valor fica 1 e 0 para o restante

| Nome   | Preço | Barato | Medio | Caro |
| ------ | ----- | ------ | ----- | ---- |
| Banana | 10    | 0      | 0     | 1    |
| Maça   | 5     | 1      | 0     | 0    |

Exemplo no código:
```sql
SELECT
    IdCliente,
    QtdePontos,

    CASE
        WHEN QtdePontos <= 1000 THEN 1
    END AS FlPonei,
    
    CASE
        WHEN QtdePontos > 1000 THEN 1
    END AS FlPone

FROM clientes
ORDER BY QtdePontos DESC;
```
Exemplo de resultado

| IdCliente                            | QtdePontos | FlPonei | FlPone |
| ------------------------------------ | ---------- | ------- | ------ |
| 4fade907-6e0f-4581-a674-aad6622b1b10 | 40411      | NULL    | 1      |
| 002970bd-65c2-42bf-a17d-2bc5e95e2f0b | 0          | 1       | NULL   |

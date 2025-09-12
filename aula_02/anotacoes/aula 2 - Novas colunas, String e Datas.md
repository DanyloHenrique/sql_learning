Além dos campos que já existem na tabela do banco de dados, também é possível realizar operações para criar novas colunas.
Além disso, é importante mexer com campos do tipo texto (string) e conseguir buscar partes específicas de um texto inteiro, além de trabalhar com datas.

Documentação SQLite funções de data: https://sqlite.org/lang_datefunc.html
# Novas colunas

Dado uma tabela de `Clientes` que possui `IdCliente` e `QtdePontos` é possível criar novas colunas com operações matemáticas
<mark style="background: #FF5582A6;">AS</mark> - Para renomear as novas colunas criadas, basta dar o comando AS e escrever o nome da nova coluna
é importante entender que nenhuma das operações resulta em alterações reais do banco de dados, estamos apenas manipulando os dados que foram buscados e essas manipulações não ficam salvas

```sql
SELECT
    IdCliente,
    QtdePontos,
    --Novas colunas
    QtdePontos + 100,
    QtdePontos * 2 AS DobrodePontos
FROM clientes
```

# Strings
Dentro de um campo de texto, pode ser necessário que se faça uma busca específica em apenas uma parte daquele texto e não o seu conteúdo completo. 
<mark style="background: #FF5582A6">substr</mark> - é uma função do sql para recorte de uma parte do texto, ela recebe como parâmetros 3 coisas: O campo de texto que desejamos buscar o conteúdo, a posição inicial do caractere que queremos e o comprimento do subtexto (opcional, a função funciona sem o comprimento definido, pegando todo o conteúdo que vem depois da posição inicial)

### Exemplo:
Se um texto possui uma mensagem com saudação e o nome da pessoa
"Olá, Marya"

Pegar apenas o "olá" - substr recebe o texto, posição inicial 1 (é a primeira letra do texto) e o comprimento de 3

Pegar apenas o "Marya" - substr recebe o texto, posição inicial 6 e o comprimento de 5, ou para caso desejamos pegar nomes que podem ser maiores, podemos não passar o comprimento do texto

## Exemplo em código
Exemplo de entidade do DtCriacao = 2024-02-01 00:00:00 +0000 UTC
Para pegar apenas o ano, mês e dia desse campo, usamos a substr pegando a posição 1 e o comprimento de 10 (os - contam como caractere)
```sql
SELECT
    IdCliente,
    DtCriacao,
    
    --pegando apenas os 10 primeiros caracteres
    substr(DtCriacao, 1, 10) AS anoMesDia,
FROM clientes
```

Resultado: 
<table><tr><th>IdCliente</th><th>DtCriacao</th><th>anoMesDia</th><tr><tr><td>000ff655-fa9f-4baa-a108-47f581ec52a1</td><td>2024-02-01 00:00:00 +0000 UTC</td><td>2024-02-01</td></tr><tr><td>001749bd-37b5-4b1e-8111-f9fbba90f530</td><td>2024-02-01 00:00:00 +0000 UTC</td><td>2024-02-01</td></tr><tr><td>0019bb9e-26d4-4ebf-8727-fc911ea28a92</td><td>2024-02-01 00:00:00 +0000 UTC</td><td>2024-02-01</td></tr></table>-

# Manipulando Datas

# Convertendo do string para o tipo data
O Mysql tem a função <mark style="background: #FF5582A6;">dateTime</mark> para fazer a conversão do texto para o tipo data, isso é importante para ser possível utilizar funções ou manipulações específicas de datas
Uma precaução é que mesmo enquanto o dado for do tipo texto, ele deve estar bem formatado para ser convertido corretamente. O texto de ver a data e o horario no seguinte formato: YYYY-MM-DD HH:MM:SS (ano-mes-dia hora:minuto:segundo)

Dentro do campo DtCriacao, os 19 primeiros caracteres são da data e horário, vamos combinar o dateTime com a substr pegando os 19 primeiros caracteres

```sql
SELECT
    IdCliente,
    DtCriacao,
    --convertendo os 19 primeiros caracteres do DtCriacao para o tipo data
    dateTime(substr(DtCriacao, 1, 19)) AS dataCriacaoConvertido
FROM clientes
LIMIT 3
```

<table>
<tr><th>IdCliente</th><th>DtCriacao</th><th>dataCriacaoConvertido</th><tr>
<tr><td>0019bb9e-26d4-4ebf-8727-fc911ea28a92</td><td>2024-02-01 00:00:00 +0000 UTC</td><td>2024-02-01 00:00:00</td></tr><tr><td>002970bd-65c2-42bf-a17d-2bc5e95e2f0b</td><td>2025-07-16 09:36:45.831 +0000 UTC</td><td>2025-07-16 09:36:45</td></tr><tr><td>0033b737-8235-4c0f-9801-dc4ca185af00</td><td>2025-02-19 12:48:24.632 +0000 UTC</td><td>2025-02-19 12:48:24</td></tr>
</table>
 
# Encontrado o dia da semana a partir de uma data
Agora que já temos o campo de data, podemos usar funções extras do SQL para manipulações, tipo encontrar qual o dia da semana daquela determinada data, para isso usamos a função <mark style="background: #FF5582A6;">strftime</mark>
"A função strftime() retorna a data formatada de acordo com a string de formato especificada como primeiro argumento."

| parametro | retorno                                                                                 |
| --------- | --------------------------------------------------------------------------------------- |
| %w        | Retorna um inteiro (de 0 a 6) que representa o dia da semana, começando por domingo (0) |

**Código**
```sql
SELECT
    IdCliente,
    DtCriacao,
    --Encontrando o dia da semana de uma determinada data
    strftime('%w', dateTime(substr(DtCriacao, 1, 19))) AS diaSemana
FROM clientes
LIMIT 3
```

**Resultado**
Começa a contar o dia da semana por 0 que significa domingo
Então nos 3 resultado temos:
primeiro é o 2 que significa terça-feira
depois vem o 4 que seria quinta-feira
e por último o 1 - segunda feira

| IdCliente                            | DtCriacao                         | DiadaSemana |
| ------------------------------------ | --------------------------------- | ----------- |
| 007b8e64-a244-4404-8992-3b8098b33ccc | 2025-06-10 16:13:43.144 +0000 UTC | 2           |
| 0097ab76-4637-4ece-8ebc-ab6abd61d662 | 2024-02-01 00:00:00 +0000 UTC     | 4           |
| 00a2aa20-fd00-4c09-bab0-caf674e5cd30 | 2025-05-05 12:13:35.566 +0000 UTC | 1           |

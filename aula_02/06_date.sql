--trabalhar com datas no sql
-- substr: para definir qual o intervalo de caracteres que vamos pegar de uma string
-- dateTime: para converter para o formato de data e hora
-- strftime: para pegar o dia da semana apartir de uma data (começa por 0 - domingo)
-- AS define um nome para a coluna

SELECT 
    IdCliente, 
    DtCriacao,
    --pegando apenas os 10 primeiros caracteres
    substr(DtCriacao, 1, 10) AS anoMesDia,

    dateTime(substr(DtCriacao, 1, 19)) AS dataCriacaoConvertido,

    strftime('%w', dateTime(substr(DtCriacao, 1, 19))) AS diaSemana
FROM clientes
-- D: Lista de pedidos realizados no fim de semana;
SELECT 
    *,
    strfTime('%w', dateTime(substr(DtCriacao, 1, 19))) AS diaSemana
FROM transacoes
WHERE diaSemana IN ('0', '6')




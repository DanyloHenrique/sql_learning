-- ATUALIZAR DADOS DA TABELA

-- ESTRUTURA:
/* 
UPDATE nome_da_tabela
SET coluna = novo_valor
WHERE condição 
*/

UPDATE relatorio_diario
SET QtDeTransacoes = 1000
WHERE dtDia >= '2025-08-25';

SELECT * FROM relatorio_diario;

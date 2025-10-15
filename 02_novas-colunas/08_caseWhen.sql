-- Intervalos
-- de 0 a 500 -> ponei
-- de 501 a 1000 -> ponei premium
-- de 1001 a 5000 -> mago aprendiz
-- de 5001 a 10000 -> mago mestre
-- +10000 -> mago supremo

-- CASE WHEN testa por ordem, caso uma entidade esteja dentro de uma regra ele não executa as proximas
-- para evitar processamento desnecessário

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
ORDER BY QtdePontos DESC;


-- criando uma estrutura de one hot encoding
-- melhor para fazer filtragem
-- imporante para machine learning
-- pode ser feito no python: Beneficil: automatizado e escalável. Malefício: é mais custoso computacionalmente

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
ORDER BY QtdePontos;
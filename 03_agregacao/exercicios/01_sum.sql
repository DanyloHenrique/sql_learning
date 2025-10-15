-- Qual o saldo de pontos total do sistema?
SELECT sum(QtdePontos)
FROM clientes;

-- Quantos pontos já foram subtraídos dos clientes?
SELECT sum(QtdePontos)
FROM transacoes
WHERE QtdePontos < 0;

-- Quantos clientes tem Twitch?
SELECT sum(FlTwitch)
FROM clientes;

-- Qual a média de saldo em carteira?
SELECT avg(QtdePontos)
FROM clientes;

-- Quantos clientes tem email cadastrado?
SELECT sum(FlEmail)
FROM clientes;
SELECT
    t1.*,
    t2.DescCateogriaProduto

FROM transacao_produto AS t1

LEFT JOIN produtos AS t2
ON t1.IdProduto = t2.IdProduto
LIMIT 1;










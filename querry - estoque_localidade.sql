SELECT localidade, SUM(quantidade) AS quantidade_em_estoque
FROM estoquesProdutos
GROUP BY localidade;

SELECT p.nome AS nome_peca, sp.quantidade_utilizada
FROM pecas p
JOIN servico_pecas sp ON p.idPeca = sp.idPeca
WHERE sp.idServico = 1;
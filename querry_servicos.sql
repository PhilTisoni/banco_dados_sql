SELECT COUNT(*) AS total_servicos
FROM servicos s
JOIN carros c ON s.idCarro = c.idCarro
WHERE c.placa = 'ABC-1234';
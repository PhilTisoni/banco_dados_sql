-- Drop the database if it exists
DROP DATABASE IF EXISTS ecommerce_refinado;

-- Create the database
CREATE DATABASE ecommerce_refinado;
USE ecommerce_refinado;

-- Table: clientes (Customers)
CREATE TABLE clientes (
    idCliente INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    dataNascimento DATE NOT NULL,
    primeiroNome VARCHAR(50) NOT NULL,
    nomeMeio CHAR(3),
    sobrenome VARCHAR(50),
    endereco VARCHAR(100)
);

-- Table: tipoClientes (Customer Types)
CREATE TABLE tipoClientes (
    idTipo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('CPF', 'CNPJ') DEFAULT 'CPF',
    numero VARCHAR(15) NOT NULL,
    CONSTRAINT unique_numero_tipoCliente UNIQUE (numero),
    CONSTRAINT fk_cliente_tipoCliente FOREIGN KEY (idTipo) REFERENCES clientes (idCliente)
);

-- Table: pagamentos (Payments)
CREATE TABLE pagamentos (
    idPagamento INT AUTO_INCREMENT NOT NULL PRIMARY KEY,	
    tipoPagamento ENUM('PIX', 'Boleto', 'Cartão', 'Dois Cartões') DEFAULT 'Cartão'
);

-- Table: entregas (Deliveries)
CREATE TABLE entregas (
    idEntrega INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    statusEntrega ENUM('Em andamento', 'Em processamento', 'Enviado', 'Entregue') DEFAULT 'Em processamento',
    codRastreio CHAR(10) NOT NULL,
    CONSTRAINT unique_codRastreio UNIQUE (codRastreio)
);

-- Table: fornecedores (Suppliers)
CREATE TABLE fornecedores (
    idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    cnpj CHAR(15) NOT NULL,
    razaoSocial VARCHAR(50) NOT NULL,
    contato CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_fornecedor UNIQUE (cnpj),
    CONSTRAINT unique_razaoSocial_fornecedor UNIQUE (razaoSocial)
);

-- Table: vendedores (Sellers)
CREATE TABLE vendedores (
    idVendedor INT AUTO_INCREMENT PRIMARY KEY,
    razaoSocial VARCHAR(50) NOT NULL,
    cnpj CHAR(15),
    cpf CHAR(11),
    localidade VARCHAR(45),
    nomeFantasia VARCHAR(45),
    CONSTRAINT unique_razaoSocial_vendedor UNIQUE (razaoSocial),
    CONSTRAINT unique_cnpj_vendedor UNIQUE (cnpj),
    CONSTRAINT unique_cpf_vendedor UNIQUE (cpf)
);

-- Table: produtos (Products)
CREATE TABLE produtos (
    idProduto INT AUTO_INCREMENT PRIMARY KEY,
    nomeProduto VARCHAR(50) NOT NULL,
    classificacaoCrianca BOOL DEFAULT FALSE,
    categoria ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
    descricao VARCHAR(255),
    valor FLOAT NOT NULL,
    avaliacao FLOAT NOT NULL DEFAULT 0,
    dimensoes VARCHAR(10)
);

-- Table: pedidos (Orders)
CREATE TABLE pedidos (
    idPedido INT AUTO_INCREMENT PRIMARY KEY,
    idPedidoPagamento INT NOT NULL,
    idPedidoCliente INT NOT NULL,
    idPedidoEntrega INT NOT NULL,
    descricao VARCHAR(255),
    frete FLOAT DEFAULT 10,
    CONSTRAINT fk_pedido_pagamento FOREIGN KEY (idPedidoPagamento) REFERENCES pagamentos (idPagamento),
    CONSTRAINT fk_pedido_entrega FOREIGN KEY (idPedidoEntrega) REFERENCES entregas (idEntrega),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (idPedidoCliente) REFERENCES clientes (idCliente)
);

-- Table: produtosVendedores (Product / Seller)
CREATE TABLE produtosVendedores (
    idProdutoVendedorVendedor INT,
    idProdutoVendedorProduto INT,
    quantidade INT DEFAULT 1,
    PRIMARY KEY (idProdutoVendedorVendedor, idProdutoVendedorProduto),
    CONSTRAINT fk_produtoVendedor_vendedor FOREIGN KEY (idProdutoVendedorVendedor) REFERENCES vendedores (idVendedor),
    CONSTRAINT fk_produtoVendedor_produto FOREIGN KEY (idProdutoVendedorProduto) REFERENCES produtos (idProduto)
);

-- Table: produtosPedidos (Product / Order)
CREATE TABLE produtosPedidos (
    idProdutoPedidoProduto INT,
    idProdutoPedidoPedido INT,
    quantidade INT DEFAULT 1,
    statusPedido ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idProdutoPedidoProduto, idProdutoPedidoPedido),
    CONSTRAINT fk_produtoPedido_produto FOREIGN KEY (idProdutoPedidoProduto) REFERENCES produtos (idProduto),
    CONSTRAINT fk_produtoPedido_pedido FOREIGN KEY (idProdutoPedidoPedido) REFERENCES pedidos (idPedido)
);

-- Table: estoquesProdutos (Stock)
CREATE TABLE estoquesProdutos (
    idEstoqueProduto INT AUTO_INCREMENT PRIMARY KEY,
    quantidade INT DEFAULT 0,
    localidade VARCHAR(45)
);

-- Table: produtosFornecedores (Product / Supplier)
CREATE TABLE produtosFornecedores (
    idProdutoFornecedorProduto INT,
    idProdutoFornecedorFornecedor INT,
    quantidade INT NOT NULL,
    PRIMARY KEY (idProdutoFornecedorProduto, idProdutoFornecedorFornecedor),
    CONSTRAINT fk_produtoFornecedor_produto FOREIGN KEY (idProdutoFornecedorProduto) REFERENCES produtos (idProduto),
    CONSTRAINT fk_produtoFornecedor_fornecedor FOREIGN KEY (idProdutoFornecedorFornecedor) REFERENCES fornecedores (idFornecedor)
);

-- Table: estoquesLocalidades (Stock / Location)
CREATE TABLE estoquesLocalidades (
    idEstoqueLocalidadeProduto INT,
    idEstoqueLocalidadeEstoque INT,
    localidade VARCHAR(45) NOT NULL,
    PRIMARY KEY (idEstoqueLocalidadeProduto, idEstoqueLocalidadeEstoque),
    CONSTRAINT fk_estoqueLocalidade_produto FOREIGN KEY (idEstoqueLocalidadeProduto) REFERENCES produtos (idProduto),
    CONSTRAINT fk_estoqueLocalidade_estoque FOREIGN KEY (idEstoqueLocalidadeEstoque) REFERENCES estoquesProdutos (idEstoqueProduto)
);

-- Inserindo valores na tabela clientes
INSERT INTO clientes (pNome, nomeMeio, sobrenome, endereco, dataNascimento) 
VALUES 
    ('João', 'S', 'Silva', 'Rua A, 123 - Bairro X - São Paulo/SP', '1995-08-20'),
    ('Ana', 'L', 'Pereira', 'Av. B, 456 - Bairro Y - Rio de Janeiro/RJ', '1980-05-10'),
    ('Pedro', 'M', 'Santos', 'Rua C, 789 - Bairro Z - Belo Horizonte/MG', '2000-11-25'),
    ('Mariana', 'N', 'Oliveira', 'Rua D, 987 - Bairro W - Porto Alegre/RS', '1972-03-15'),
    ('Fernando', 'T', 'Costa', 'Av. E, 654 - Bairro V - Curitiba/PR', '1998-12-08'),
    ('Carla', 'V', 'Rodrigues', 'Rua F, 321 - Bairro U - Brasília/DF', '1985-06-30');

-- Inserindo valores na tabela tipoClientes
INSERT INTO tipoClientes (numero, tipo) 
VALUES 
    (123456789112231, 'CNPJ'),
    (12345678911, 'CPF'),
    (987654321112232, 'CNPJ'),
    (98765432111, 'CPF'),
    (456789123112233, 'CNPJ'),
    (45678912311, 'CPF');

-- Inserindo valores na tabela pagamentos
INSERT INTO pagamentos (tipoPagamento) 
VALUES 
    ('Cartão'),
    ('PIX'),
    ('Dois Cartões'),
    ('Boleto'),
    ('Boleto'),
    ('PIX'),
    ('Cartão'),
    ('Dois Cartões'),
    ('PIX'),
    ('Boleto'),
    ('Dois Cartões'),
    ('PIX'),
    ('PIX');

-- Inserindo valores na tabela produtos
INSERT INTO produtos (nomeProduto, classificacaoCrianca, categoria, descricao, valor, avaliacao, dimensoes)
VALUES 
    ('Notebook', DEFAULT, 'Eletrônico', 'Notebook Intel Core i5', 3499.99, 9, '35x24x2'),
    ('Boneca', TRUE, 'Brinquedos', 'Boneca de pano com cabelo rosa', 59.99, 8, null),
    ('Calça Jeans', DEFAULT, 'Vestimenta', 'Calça jeans feminina', 129.99, 7, null),
    ('Chocolates', DEFAULT, 'Alimentos', 'Caixa com chocolates sortidos', 19.99, 9, null),
    ('Cama Box', DEFAULT, 'Móveis', 'Cama Box casal com colchão de molas', 1899.99, 9.5, '160x200x30'),
    ('Barra de Cereal', DEFAULT, 'Alimentos', 'Barra de cereal com frutas', 3.99, 8, null);

-- Inserindo valores na tabela entregas
INSERT INTO entregas (statusEntrega, codRastreio)
VALUES 
    ('Em andamento', 'ABCDE12345'),
    ('Em processamento', 'FGHIJ67890'),
    ('Enviado', 'KLMNO12345'),
    ('Enviado', 'PQRST67890'),
    ('Entregue', 'UVWXY12345'),
    ('Entregue', 'ZABCD67890');

-- Inserindo valores na tabela pedidos
INSERT INTO pedidos (idPedidoPagamento, idPedidoCliente, descricao, frete)
VALUES 
    (1, 2, 'Compra de notebook', 25),
    (1, 4, 'Compra de chocolates', 15),
    (2, 1, 'Compra de boneca', 12),
    (2, 5, 'Compra de calça jeans', 18),
    (3, 6, 'Compra de cama box', 40),
    (3, 3, 'Compra de barra de cereal', 8),
    (4, 4, 'Compra de notebook', 25),
    (5, 1, 'Compra de chocolates', 15),
    (6, 3, 'Compra de boneca', 12),
    (6, 5, 'Compra de calça jeans', 18),
    (7, 6, 'Compra de cama box', 40),
    (8, 3, 'Compra de notebook', 25);

-- Inserindo valores na tabela estoquesProdutos
INSERT INTO estoquesProdutos (quantidade, localidade)
VALUES 
    (15, 'São Paulo'),
    (8, 'Rio de Janeiro'),
    (12, 'Belo Horizonte'),
    (5, 'Porto Alegre'),
    (10, 'Curitiba');

-- Inserindo valores na tabela fornecedores
INSERT INTO fornecedores (cnpj, razaoSocial, contato)
VALUES 
    ('123456789123456', 'Informática LTDA', '11911110000'),
    ('789456123123456', 'Brinquedos ABC', '11922221111'),
    ('456123789789123', 'Moda & Cia', '11933332222'),
    ('852963741123456', 'Comida Boa', '11944443333'),
    ('159753852456321', 'Móveis Elegantes', '11955554444');

-- Inserindo valores na tabela vendedores
INSERT INTO vendedores (razaoSocial, cnpj, cpf, localidade, nomeFantasia)
VALUES 
    ('Loja de Informática', '123456789987456', NULL, 'São Paulo', 'Tech House'),
    ('Brinquedos Online', '456123789789321', NULL, 'Rio de Janeiro', 'Toy Land'),
    ('Loja de Roupas', '789456123123654', NULL, 'Belo Horizonte', 'Fashion Store'),
    ('Loja de Alimentos', '852963741987654', NULL, 'Porto Alegre', 'Food Market'),
    ('Móveis de Luxo', '159753852654321', NULL, 'Curitiba', 'Elegant Home');

-- Inserindo valores na tabela produtosVendedores
INSERT INTO produtosVendedores (idProdutoVendedorVendedor, idProdutoVendedorProduto, quantidade)
VALUES 
    (1, 1, 10),
    (2, 2, 7),
    (3, 3, 2),
    (4, 4, 6),
    (5, 5, 10),
    (2, 6, 5);

-- Inserindo valores na tabela produtosPedidos
INSERT INTO produtosPedidos (idProdutoPedidoProduto, idProdutoPedidoPedido, quantidade, statusPedido)
VALUES 
    (1, 1, 1, 'Disponível'),
    (2, 2, 1, 'Disponível'),
    (3, 3, 1, 'Sem estoque'),
    (4, 4, 1, 'Sem estoque'),
    (5, 5, 1, 'Disponível'),
    (6, 6, 1, 'Disponível');

-- Inserindo valores na tabela estoquesLocalidades
INSERT INTO estoquesLocalidades (idEstoqueLocalidadeProduto, idEstoqueLocalidadeEstoque, localidade)
VALUES 
    (1, 2, 'São Paulo'),
    (2, 4, 'Rio de Janeiro'),
    (3, 5, 'Belo Horizonte'),
    (4, 1, 'Porto Alegre'),
    (5, 3, 'Curitiba');

-- Inserindo valores na tabela produtosFornecedores
INSERT INTO produtosFornecedores (idProdutoFornecedorProduto, idProdutoFornecedorFornecedor, quantidade)
VALUES 
    (1, 4, 10),
    (2, 1, 7),
    (3, 5, 2),
    (4, 2, 6),
    (5, 3, 10),
    (6, 2, 10);
    
SELECT pag.tipoPagamento, SUM(ped.valor) as Valor_Total_Pedidos
FROM pedidos ped
JOIN pagamentos pag ON ped.idPedidoPagamento = pag.idPagamento
GROUP BY pag.tipoPagamento;

SELECT p.nomeProduto, el.localidade as Localidade, e.quantidade as Quantidade_Estoque
FROM produtos p
JOIN estoquesLocalidades el ON p.idProduto = el.idEstoqueLocalidadeProduto
JOIN estoquesProdutos e ON el.idEstoqueLocalidadeEstoque = e.idEstoqueProduto;

SELECT CONCAT(c.pNome, ' ', COALESCE(c.nomeMeio, ''), ' ', c.sobrenome) as Nome_Completo, COUNT(*) as Quantidade
FROM clientes c
JOIN pedidos p ON c.idCliente = p.idPedidoCliente
JOIN pagamentos pag ON p.idPedidoPagamento = pag.idPagamento
WHERE pag.tipoPagamento = 'PIX'
GROUP BY c.idCliente;


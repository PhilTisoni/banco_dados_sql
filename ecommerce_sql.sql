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
    tipo VARCHAR(4) DEFAULT 'CPF', -- Modified column size to VARCHAR(4)
    numero VARCHAR(20) NOT NULL, -- Increased column size to accommodate CNPJ values
    CONSTRAINT unique_numero_tipoCliente UNIQUE (numero)
);


-- Table: pagamentos (Payments)
CREATE TABLE pagamentos (
    idPagamento INT AUTO_INCREMENT NOT NULL PRIMARY KEY,	
    tipoPagamento ENUM('PIX', 'Boleto', 'Cartão', 'Dois Cartões') DEFAULT 'Cartão'
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

-- Table: entregas (Deliveries)
CREATE TABLE entregas (
    idEntrega INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    statusEntrega ENUM('Em andamento', 'Em processamento', 'Enviado', 'Entregue') DEFAULT 'Em processamento',
    codRastreio CHAR(10) NOT NULL,
    CONSTRAINT unique_codRastreio UNIQUE (codRastreio)
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

-- Table: estoque (Stock)
CREATE TABLE estoquesProdutos (
    idEstoqueProduto INT AUTO_INCREMENT PRIMARY KEY,
    quantidade INT DEFAULT 0,
    localidade VARCHAR(45)
);

-- Table: fornecedores (Suppliers)
CREATE TABLE fornecedores (
    idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    cnpj CHAR(18) NOT NULL, -- Increased column size to accommodate CNPJ values
    razaoSocial VARCHAR(50) NOT NULL,
    contato CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_fornecedor UNIQUE (cnpj),
    CONSTRAINT unique_razaoSocial_fornecedor UNIQUE (razaoSocial)
);

-- Table: vendedores (Sellers)
CREATE TABLE vendedores (
    idVendedor INT AUTO_INCREMENT PRIMARY KEY,
    razaoSocial VARCHAR(50) NOT NULL,
    cnpj CHAR(18),
    cpf CHAR(14), -- Increased column size to accommodate CPF values
    localidade VARCHAR(45),
    nomeFantasia VARCHAR(45),
    CONSTRAINT unique_razaoSocial_vendedor UNIQUE (razaoSocial),
    CONSTRAINT unique_cnpj_vendedor UNIQUE (cnpj),
    CONSTRAINT unique_cpf_vendedor UNIQUE (cpf)
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

-- Table: estoquesLocalidades (Stock / Location)
CREATE TABLE estoquesLocalidades (
    idEstoqueLocalidadeProduto INT,
    idEstoqueLocalidadeEstoque INT,
    localidade VARCHAR(45) NOT NULL,
    PRIMARY KEY (idEstoqueLocalidadeProduto, idEstoqueLocalidadeEstoque),
    CONSTRAINT fk_estoqueLocalidade_produto FOREIGN KEY (idEstoqueLocalidadeProduto) REFERENCES produtos (idProduto),
    CONSTRAINT fk_estoqueLocalidade_estoque FOREIGN KEY (idEstoqueLocalidadeEstoque) REFERENCES estoquesProdutos (idEstoqueProduto)
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

-- Insert random data into clientes (Customers)
INSERT INTO clientes (dataNascimento, primeiroNome, nomeMeio, sobrenome, endereco)
VALUES
    ('1990-03-15', 'João', 'A.', 'Silva', 'Rua dos Flores, 123'),
    ('1985-11-20', 'Maria', NULL, 'Santos', 'Av. das Palmeiras, 456'),
    ('2002-07-03', 'Pedro', 'C.', 'Lima', 'Praça das Águas, 789'),
    ('1978-09-12', 'Ana', 'M.', 'Ferreira', 'Alameda dos Pássaros, 321'),
    ('1995-05-30', 'Lucas', 'B.', 'Souza', 'Travessa das Estrelas, 987');

-- Insert random data into tipoClientes (Customer Types)
INSERT INTO tipoClientes (tipo, numero)
VALUES
    ('CNPJ', '12.345.678/0001-90'),
    ('CPF', '98.765.432-10'),
    ('CNPJ', '11.223.344/0001-55'),
    ('CPF', '99.888.777-20'),
    ('CNPJ', '55.666.777/0001-44');

-- Insert random data into pagamentos (Payments)
INSERT INTO pagamentos (tipoPagamento)
VALUES
    ('PIX'),
    ('Boleto'),
    ('Cartão'),
    ('Dois Cartões'),
    ('Boleto');

-- Insert random data into produtos (Products)
INSERT INTO produtos (nomeProduto, classificacaoCrianca, categoria, descricao, valor, avaliacao, dimensoes)
VALUES
    ('Smartphone XPTO', FALSE, 'Eletrônico', 'Celular smartphone de última geração.', 1999.99, 4.7, '15x7x1.5'),
    ('Camiseta Esportiva', FALSE, 'Vestimenta', 'Camiseta de tecido esportivo.', 49.99, 4.3, '35x25x1'),
    ('Carrinho de Controle Remoto', TRUE, 'Brinquedos', 'Carrinho de controle remoto para crianças.', 89.99, 3.9, '20x10x8'),
    ('Chocolate Amargo', FALSE, 'Alimentos', 'Barra de chocolate amargo 70% cacau.', 7.99, 4.8, '10x5x1'),
    ('Sofá Retrátil', FALSE, 'Móveis', 'Sofá de 3 lugares retrátil com tecido confortável.', 1499.99, 4.5, '200x80x90');

-- Insert random data into entregas (Deliveries)
INSERT INTO entregas (statusEntrega, codRastreio)
VALUES
    ('Em andamento', 'ABCD1234'),
    ('Enviado', 'EFGH5678'),
    ('Entregue', 'WXYZ9876'),
    ('Em processamento', 'JKLM4321'),
    ('Enviado', 'QWERTY1234');

-- Insert random data into pedidos (Orders)
INSERT INTO pedidos (idPedidoPagamento, idPedidoCliente, idPedidoEntrega, descricao, frete)
VALUES
    (1, 2, 3, 'Pedido 001 - Cliente 002', 12.50),
    (3, 1, 4, 'Pedido 002 - Cliente 001', 8.00),
    (2, 5, 2, 'Pedido 003 - Cliente 005', 5.00),
    (4, 3, 1, 'Pedido 004 - Cliente 003', 9.99),
    (5, 4, 5, 'Pedido 005 - Cliente 004', 11.00);

-- Insert random data into estoquesProdutos (Stock)
INSERT INTO estoquesProdutos (quantidade, localidade)
VALUES
    (100, 'São Paulo'),
    (50, 'Rio de Janeiro'),
    (30, 'Belo Horizonte'),
    (80, 'Porto Alegre'),
    (20, 'Recife');

-- Insert random data into fornecedores (Suppliers)
INSERT INTO fornecedores (cnpj, razaoSocial, contato)
VALUES
    ('12.345.678/0001-90', 'Fornecedor A', '11987654321'),
    ('98.765.432/0001-21', 'Fornecedor B', '21987654321'),
    ('11.223.344/0001-55', 'Fornecedor C', '31987654321'),
    ('99.888.777/0001-33', 'Fornecedor D', '41987654321'),
    ('55.666.777/0001-44', 'Fornecedor E', '51987654321');

-- Insert random data into vendedores (Sellers)
INSERT INTO vendedores (razaoSocial, cnpj, cpf, localidade, nomeFantasia)
VALUES
    ('Loja de Eletrônicos', '12.345.678/0001-90', NULL, 'São Paulo', 'Eletrônicos Store'),
    ('Loja de Roupas', '98.765.432/0001-21', NULL, 'Rio de Janeiro', 'Fashion Shop'),
    ('Loja de Brinquedos', NULL, '123.456.789-00', 'Belo Horizonte', 'Kids Toys'),
    ('Supermercado ABC', '99.888.777/0001-33', NULL, 'Porto Alegre', 'Supermercado ABC'),
    ('Móveis & Cia', '55.666.777/0001-44', NULL, 'Recife', 'Móveis & Cia');

-- Insert random data into produtosVendedores (Product / Seller)
INSERT INTO produtosVendedores (idProdutoVendedorVendedor, idProdutoVendedorProduto, quantidade)
VALUES
    (1, 1, 50),
    (1, 5, 30),
    (2, 2, 100),
    (3, 3, 20),
    (4, 4, 80);

-- Insert random data into produtosPedidos (Product / Order)
INSERT INTO produtosPedidos (idProdutoPedidoProduto, idProdutoPedidoPedido, quantidade, statusPedido)
VALUES
    (1, 1, 2, 'Disponível'),
    (3, 2, 1, 'Disponível'),
    (5, 3, 2, 'Sem estoque'),
    (2, 4, 3, 'Disponível'),
    (4, 5, 1, 'Sem estoque');

-- Insert random data into estoquesLocalidades (Stock / Location)
INSERT INTO estoquesLocalidades (idEstoqueLocalidadeProduto, idEstoqueLocalidadeEstoque, localidade)
VALUES
    (1, 1, 'São Paulo'),
    (2, 2, 'Rio de Janeiro'),
    (3, 3, 'Belo Horizonte'),
    (4, 4, 'Porto Alegre'),
    (5, 5, 'Recife');

-- Insert random data into produtosFornecedores (Product / Supplier)
INSERT INTO produtosFornecedores (idProdutoFornecedorProduto, idProdutoFornecedorFornecedor, quantidade)
VALUES
    (1, 1, 100),
    (2, 2, 50),
    (3, 3, 80),
    (4, 4, 30),
    (5, 5, 20);


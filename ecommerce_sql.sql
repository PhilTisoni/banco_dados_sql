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
    PRIMARY KEY (idEstoqueLocalidadeProduto , idEstoqueLocalidadeEstoque),
    CONSTRAINT fk_estoqueLocalidade_produto FOREIGN KEY (idEstoqueLocalidadeProduto)
        REFERENCES produtos (idProduto),
    CONSTRAINT fk_estoqueLocalidade_estoque FOREIGN KEY (idEstoqueLocalidadeEstoque)
        REFERENCES estoquesProdutos (idEstoqueProduto)
);
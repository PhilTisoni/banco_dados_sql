-- Criação do banco de dados para a oficina
CREATE DATABASE oficina_carros;
USE oficina_carros;

-- Tabela clientes
CREATE TABLE clientes (
    idCliente INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200),
    telefone VARCHAR(15)
);

-- Tabela carros
CREATE TABLE carros (
    idCarro INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idCliente INT NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    ano INT NOT NULL,
    cor VARCHAR(20),
    placa VARCHAR(10),
    FOREIGN KEY (idCliente) REFERENCES clientes(idCliente)
);

-- Tabela servicos
CREATE TABLE servicos (
    idServico INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idCarro INT NOT NULL,
    descricao VARCHAR(200) NOT NULL,
    data_servico DATE NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (idCarro) REFERENCES carros(idCarro)
);

-- Tabela pecas
CREATE TABLE pecas (
    idPeca INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(200),
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL
);

-- Tabela servico_pecas
CREATE TABLE servico_pecas (
    idServico INT NOT NULL,
    idPeca INT NOT NULL,
    quantidade_utilizada INT NOT NULL,
    PRIMARY KEY (idServico, idPeca),
    FOREIGN KEY (idServico) REFERENCES servicos(idServico),
    FOREIGN KEY (idPeca) REFERENCES pecas(idPeca)
);

-- Inserindo dados de exemplo na tabela clientes
INSERT INTO clientes (nome, endereco, telefone)
VALUES
    ('João da Silva', 'Rua A, 123 - Bairro X - São Paulo/SP', '(11) 1111-1111'),
    ('Maria Santos', 'Av. B, 456 - Bairro Y - Rio de Janeiro/RJ', '(21) 2222-2222'),
    ('Pedro Oliveira', 'Rua C, 789 - Bairro Z - Belo Horizonte/MG', '(31) 3333-3333');

-- Inserindo dados de exemplo na tabela carros
INSERT INTO carros (idCliente, marca, modelo, ano, cor, placa)
VALUES
    (1, 'Chevrolet', 'Onix', 2021, 'Prata', 'ABC-1234'),
    (1, 'Ford', 'Ka', 2018, 'Branco', 'DEF-5678'),
    (2, 'Volkswagen', 'Gol', 2020, 'Preto', 'GHI-9012');

-- Inserindo dados de exemplo na tabela servicos
INSERT INTO servicos (idCarro, descricao, data_servico, valor)
VALUES
    (1, 'Troca de óleo', '2023-07-20', 150.00),
    (2, 'Revisão completa', '2023-07-21', 300.00),
    (3, 'Troca de pneus', '2023-07-22', 400.00);

-- Inserindo dados de exemplo na tabela pecas
INSERT INTO pecas (nome, descricao, quantidade, preco_unitario)
VALUES
    ('Óleo de motor', 'Óleo sintético 5W30', 50, 30.00),
    ('Filtro de óleo', 'Filtro de óleo do modelo X', 40, 15.00),
    ('Pneu', 'Pneu aro 14, modelo Y', 20, 100.00);

-- Inserindo dados de exemplo na tabela servico_pecas
INSERT INTO servico_pecas (idServico, idPeca, quantidade_utilizada)
VALUES
    (1, 1, 5),
    (1, 2, 1),
    (3, 3, 4);
-- Sintaxe
CREATE TABLE nome_da_tabela (
    nome_coluna1 tipo_dado [restrições],
    nome_coluna2 tipo_dado [restrições],
    ...
);

-- Exemplo
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    data_nascimento DATE,
    ativo BOOLEAN DEFAULT TRUE
);

-- Dica
CREATE TABLE IF NOT EXISTS clientes (
    id INT PRIMARY KEY,
    nome VARCHAR(100)
);

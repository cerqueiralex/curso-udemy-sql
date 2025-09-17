-- Sintaxe
INSERT INTO nome_da_tabela (coluna1, coluna2, coluna3, ...)
VALUES (valor1, valor2, valor3, ...);

INSERT INTO nome_da_tabela (coluna1, coluna2)
VALUES 
  (valor1a, valor2a),
  (valor1b, valor2b);

-- Exemplo
INSERT INTO clientes (nome, email, data_nascimento, ativo)
VALUES ('João Oliveira', 'joao.oliveira@example.com', '1990-01-15', TRUE);

-- Sintaxe
UPDATE nome_da_tabela
SET coluna1 = novo_valor1,
    coluna2 = novo_valor2
WHERE condicao;

-- Exemplo
UPDATE clientes
SET ativo = FALSE
WHERE id = 5;

-- Dica
SELECT * FROM clientes WHERE id = 5;

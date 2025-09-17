-- Sintaxe
-- Adicionar uma nova coluna
ALTER TABLE nome_tabela ADD nome_coluna tipo_dado;

-- Modificar uma coluna existente
ALTER TABLE nome_tabela MODIFY nome_coluna novo_tipo;

-- Renomear uma coluna
ALTER TABLE nome_tabela RENAME COLUMN nome_antigo TO nome_novo;

-- Remover uma coluna
ALTER TABLE nome_tabela DROP COLUMN nome_coluna;

-- Adicionar uma constraint (exemplo: chave estrangeira)
ALTER TABLE nome_tabela ADD CONSTRAINT nome_constraint FOREIGN KEY (coluna) REFERENCES outra_tabela(coluna);


-- Exemplo
ALTER TABLE clientes ADD telefone VARCHAR(15);

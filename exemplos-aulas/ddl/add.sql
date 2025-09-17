-- Sintaxe
-- Para adicionar uma coluna:
ALTER TABLE nome_da_tabela
ADD nome_da_coluna tipo_de_dado;


-- Para adicionar várias colunas de uma vez:
ALTER TABLE nome_da_tabela
ADD (
  coluna1 tipo,
  coluna2 tipo
);

-- Para adicionar uma constraint (ex: chave estrangeira, unique, etc):
ALTER TABLE nome_da_tabela
ADD CONSTRAINT nome_da_constraint
FOREIGN KEY (coluna) REFERENCES outra_tabela(coluna);

-- Exemplo
-- Ou, adicionando uma chave estrangeira chamada fk_cidade_id:
ALTER TABLE clientes
ADD CONSTRAINT fk_cidade_id
FOREIGN KEY (cidade_id) REFERENCES cidades(id);

-- Dica
ALTER TABLE clientes
ADD status VARCHAR(10) NOT NULL DEFAULT 'ativo';

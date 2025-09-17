-- Criar Tabelas
CREATE TABLE departamentos (
    id_departamento INT PRIMARY KEY,
    nome_departamento VARCHAR(100)
);

CREATE TABLE funcionarios (
    id_funcionario INT PRIMARY KEY,
    nome_funcionario VARCHAR(100),
    sobrenome_funcionario VARCHAR(100),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
);

-- Alimentar Tabelas
-- Departamentos (alguns com nome NULL)
INSERT INTO departamentos (id_departamento, nome_departamento) VALUES
(1, 'Financeiro'),
(2, NULL),
(3, 'TI'),
(4, 'Marketing'),
(5, NULL),
(6, 'Jurídico'),
(7, 'Comercial'),
(8, NULL),
(9, 'Administrativo'),
(10, 'Pesquisa');

-- Funcionários (alguns com nome, sobrenome ou id_departamento NULL)
INSERT INTO funcionarios (id_funcionario, nome_funcionario, sobrenome_funcionario, id_departamento) VALUES
(1, 'João', 'Silva', 1),
(2, NULL, 'Souza', 2),
(3, 'Carlos', NULL, 3),
(4, 'Ana', 'Pereira', NULL),
(5, 'Paulo', 'Lima', 4),
(6, 'Fernanda', 'Costa', 5),
(7, 'Ricardo', NULL, NULL),
(8, NULL, 'Alves', 7),
(9, 'Tiago', 'Ramos', 8),
(10, 'Aline', 'Fernandes', 9),
(11, 'Marcos', NULL, 10),
(12, 'Larissa', 'Carvalho', 1),
(13, NULL, NULL, 2),
(14, 'Patrícia', 'Dias', NULL),
(15, 'Bruno', 'Barros', 4),
(16, NULL, NULL, NULL),
(17, 'Lucas', 'Teixeira', 6),
(18, 'Débora', 'Castro', 7),
(19, NULL, 'Araújo', 8),
(20, 'Camila', 'Campos', NULL);


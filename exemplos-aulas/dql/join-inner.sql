-- Sintaxe
SELECT *
FROM tabela1
INNER JOIN tabela2 ON condição;

-- Exemplo
SELECT 
    f.id_funcionario, 
    f.nome_funcionario, 
    d.nome_departamento
FROM 
    funcionarios f
INNER JOIN 
    departamentos d ON f.id_departamento = d.id_departamento;

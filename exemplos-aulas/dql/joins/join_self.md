# **Técnica SQL: SELF JOIN**

#### **Qual é a sua função?**

Um `SELF JOIN` é uma técnica onde uma tabela é **juntada a si mesma**. A sua função é permitir que você compare linhas dentro da mesma tabela, criando um relacionamento entre registros daquela própria tabela.

Isso é extremamente útil quando uma tabela armazena dados hierárquicos ou auto-referenciais. O exemplo mais clássico é uma tabela de funcionários, onde um dos campos (ex: `id_gerente`) aponta de volta para a chave primária de outro registro na mesma tabela (o `id_funcionario` do gerente).

Para que o `SELF JOIN` funcione, é **obrigatório o uso de aliases de tabela** (apelidos). Você trata a mesma tabela como se fossem duas tabelas separadas, dando um alias para cada uma. Por exemplo, `SELECT ... FROM Funcionarios AS F JOIN Funcionarios AS G ON ...`.

* SELF JOIN é uma junção de uma tabela com ela mesma.
* Não existe uma cláusula ou palavra-chave "SELF JOIN" na sintaxe padrão do SQL.
* Um self join é um conceito ou técnica, e não um comando SQL específico. 
* Trata-se simplesmente de unir uma tabela a ela mesma, podendo usar qualquer um dos tipos de junção padrão (INNER JOIN, LEFT JOIN, RIGHT JOIN, etc.) para isso.
* Esse recurso é útil quando se trabalha com dados hierárquicos ou quando se deseja comparar linhas dentro da mesma tabela.


#### **Dicas e Boas Práticas**

1.  **Aliases são a Chave:** O conceito não funciona sem aliases. Use nomes de alias claros e que façam sentido no contexto. Por exemplo, ao consultar funcionários e gerentes, use `F` para funcionário e `G` para gerente.
2.  **A Condição `ON` Define a Relação:** A parte mais importante é a condição de junção (`ON`). É aqui que você define como as linhas de "ambas as tabelas" (que na verdade são a mesma) se relacionam. Ex: `ON F.id_gerente = G.id_funcionario`.
3.  **Pense em Duas Cópias:** A maneira mais fácil de entender a lógica é imaginar que você tem duas cópias idênticas da mesma tabela lado a lado. A primeira cópia representa uma entidade (o "funcionário") e a segunda representa a outra entidade relacionada (o "gerente").
4.  **`INNER JOIN` vs. `LEFT JOIN`:**
      * Um `INNER JOIN` em um `SELF JOIN` mostrará apenas os registros que têm uma correspondência (ex: funcionários que têm um gerente).
      * Um `LEFT JOIN` mostrará todos os registros da "primeira" tabela, mesmo que não tenham uma correspondência na "segunda" (ex: mostrará todos os funcionários, incluindo o CEO, cujo `id_gerente` é `NULL`).

#### **Cenário Prático no Mundo Real**

Imagine a tabela de `Funcionarios` de uma empresa. A estrutura é a seguinte: `id_funcionario`, `nome` e `id_gerente`. A coluna `id_gerente` contém o `id_funcionario` do chefe daquele funcionário.

**O problema:** O RH pede um relatório que mostre o nome de cada funcionário ao lado do nome do seu respectivo gerente. Olhando para a tabela, você só tem o *ID* do gerente, não o nome dele.

**A solução:** Você precisa consultar a mesma tabela `Funcionarios` duas vezes na mesma query. A primeira vez para obter o nome do funcionário, e a segunda vez para usar o `id_gerente` e encontrar o nome do gerente correspondente. Isso é um caso de uso perfeito para o `SELF JOIN`.

-----

### **Trechos de Código**

#### 1\. Sintaxe Pura

Aqui está a sintaxe genérica que demonstra o padrão `SELF JOIN`.

```sql
SELECT
    A.coluna1,
    A.coluna2,
    B.coluna1 AS nome_diferente
FROM
    nome_da_tabela AS A
JOIN
    nome_da_tabela AS B ON A.coluna_referencia = B.coluna_chave;
```

  * `nome_da_tabela AS A`: A primeira "cópia" da tabela, com o alias `A`.
  * `nome_da_tabela AS B`: A segunda "cópia" da tabela, com o alias `B`.
  * `ON A.coluna_referencia = B.coluna_chave`: A condição que cria o vínculo entre as linhas da mesma tabela.

#### 2\. Exemplo Prático Aplicado

Usando nosso cenário da tabela `Funcionarios` para obter o nome do gerente de cada funcionário.

```sql
-- Passo 1: Criar e popular a tabela para o exemplo
CREATE TABLE Funcionarios (
    id_funcionario INT PRIMARY KEY,
    nome VARCHAR(100),
    id_gerente INT
);

INSERT INTO Funcionarios (id_funcionario, nome, id_gerente) VALUES
(1, 'Carlos Silva', NULL),    -- O CEO, não tem gerente
(2, 'Ana Costa', 1),
(3, 'Beatriz Lima', 1),
(4, 'Daniel Martins', 2),
(5, 'Eduarda Souza', 2);

-- Passo 2: A query com SELF JOIN para gerar o relatório
SELECT
    F.nome AS Nome_Funcionario,
    G.nome AS Nome_Gerente
FROM
    Funcionarios AS F
INNER JOIN
    Funcionarios AS G ON F.id_gerente = G.id_funcionario;

-- Resultado da query:
--
-- Nome_Funcionario | Nome_Gerente
-- -----------------|---------------
-- Ana Costa        | Carlos Silva
-- Beatriz Lima     | Carlos Silva
-- Daniel Martins   | Ana Costa
-- Eduarda Souza    | Ana Costa

-- Note que Carlos Silva (o CEO) não aparece na lista de funcionários porque
-- seu id_gerente é NULL e o INNER JOIN exige uma correspondência.
-- Se usássemos LEFT JOIN, ele apareceria com o gerente como NULL.
```

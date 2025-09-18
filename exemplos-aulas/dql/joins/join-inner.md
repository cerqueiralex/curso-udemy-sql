# **Cláusula SQL: INNER JOIN (ou JOIN)**

#### **Qual é a sua função?**

A função do `INNER JOIN` é **combinar e retornar linhas de duas ou mais tabelas com base em uma condição de correspondência entre elas.**

Pense em um Diagrama de Venn. Se cada tabela é um círculo, o `INNER JOIN` retorna apenas a **interseção** entre eles – ou seja, somente os registros que têm um par correspondente em ambas as tabelas, de acordo com a condição que você especificar na cláusula `ON`.

Se um registro na Tabela A não tem um correspondente na Tabela B (e vice-versa), ele é simplesmente ignorado e não aparece no resultado final.

É importante notar: a maioria dos sistemas de banco de dados (como SQL Server, PostgreSQL, MySQL) trata o comando `JOIN` como um sinônimo de `INNER JOIN`. Portanto, escrever `FROM TabelaA JOIN TabelaB` é o mesmo que `FROM TabelaA INNER JOIN TabelaB`.

#### **Dicas e Boas Práticas**

1.  **A Cláusula `ON` é Essencial:** A condição de junção é definida na cláusula `ON`. Geralmente, você vai ligar a chave primária (`PRIMARY KEY`) de uma tabela à chave estrangeira (`FOREIGN KEY`) da outra. Ex: `ON clientes.id = pedidos.id_cliente`.
2.  **Use Aliases (Apelidos):** Ao trabalhar com `JOIN`s, as consultas podem ficar longas e confusas. Usar aliases para os nomes das tabelas torna o código muito mais limpo e legível. Ex: `FROM Clientes AS c JOIN Pedidos AS p ON c.id = p.id_cliente`.
3.  **Seja Específico no `SELECT`:** Evite usar `SELECT *` em consultas com `JOIN`. Se ambas as tabelas tiverem uma coluna com o mesmo nome (como `id`), o resultado será ambíguo. Especifique exatamente quais colunas você quer e de qual tabela, usando o alias: `SELECT c.nome, p.data_pedido`.
4.  **Performance é Chave:** As colunas usadas na cláusula `ON` (as chaves primária e estrangeira) devem ser **indexadas**. Em tabelas grandes, um `JOIN` sem índices pode ser extremamente lento.
5.  **Juntando Múltiplas Tabelas:** Você pode "acorrentar" vários `JOIN`s em uma única consulta para combinar dados de três, quatro ou mais tabelas e responder a perguntas complexas.

#### **Cenário Prático no Mundo Real**

Imagine que você gerencia o banco de dados de um blog. Você tem duas tabelas:

  * **`Autores`**: com as colunas `ID_Autor` e `Nome_Autor`.
  * **`Posts`**: com as colunas `ID_Post`, `Titulo`, e `ID_Autor_Post` (que é a chave estrangeira apontando para a tabela `Autores`).

**O problema:** Você precisa criar uma página que liste o **título de cada post** e, ao lado, o **nome do autor que o escreveu**.

O título está na tabela `Posts`, mas o nome do autor está na tabela `Autores`. Sozinhas, nenhuma das tabelas tem a informação completa.

**A solução:** Você usa um `INNER JOIN` para "cruzar" as duas tabelas usando o campo que elas têm em comum (`ID_Autor` e `ID_Autor_Post`). A consulta vai pegar cada post, olhar o `ID_Autor_Post`, encontrar o autor correspondente na tabela `Autores` e juntar o nome dele ao resultado.

-----

### **Trechos de Código**

#### 1\. Sintaxe Pura

A sintaxe genérica usa aliases para maior clareza.

```sql
SELECT
    t1.coluna1,
    t2.coluna2
FROM
    Tabela1 AS t1
INNER JOIN
    Tabela2 AS t2 ON t1.coluna_em_comum = t2.coluna_em_comum;
```

  * `Tabela1` e `Tabela2`: As tabelas que você quer combinar.
  * `t1` e `t2`: Aliases (apelidos) para as tabelas.
  * `ON t1.coluna_em_comum = t2.coluna_em_comum`: A condição que define como as tabelas se relacionam.

#### 2\. Exemplo Prático Aplicado

Resolvendo nosso cenário do blog para listar posts e seus respectivos autores.

```sql
-- Supondo que temos os seguintes dados:
-- Tabela Autores:
-- ID_Autor | Nome_Autor
-- 1        | Ana Silva
-- 2        | Bruno Costa

-- Tabela Posts:
-- ID_Post | Titulo                   | ID_Autor_Post
-- 101     | Introdução ao SQL        | 1
-- 102     | Avançando com Python     | 2
-- 103     | Dicas de SQL para JOINs  | 1

-- Consulta para buscar o título do post e o nome do autor
SELECT
    p.Titulo,
    a.Nome_Autor
FROM
    Posts AS p
INNER JOIN
    Autores AS a ON p.ID_Autor_Post = a.ID_Autor;

-- O resultado da consulta será:
-- Titulo                   | Nome_Autor
-- -------------------------|-------------
-- Introdução ao SQL        | Ana Silva
-- Avançando com Python     | Bruno Costa
-- Dicas de SQL para JOINs  | Ana Silva
```

Como pode ver, a consulta combinou as informações das duas tabelas em um resultado único e coeso, exatamente como precisávamos.

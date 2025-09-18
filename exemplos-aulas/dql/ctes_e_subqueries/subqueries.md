# **Técnica SQL: Subqueries (Subconsultas)**

Subqueries são consultas SQL aninhadas dentro de outras consultas. Elas são executadas primeiro e seu resultado é usado pela consulta principal (externa).

Vantagens das Subqueries:

* Modularidade e Estruturação:  Quebram problemas complexos em partes menores e mais gerenciáveis
* Flexibilidade de Uso: Podem ser usadas em diferentes cláusulas: 
* SELECT, FROM, WHERE, HAVING
* Dinamismo: Resultados são calculados em tempo de execução
* Expressividade: Permitem expressar consultas que seriam difíceis ou impossíveis apenas com JOINs
* Isolamento e Independência: Cada subquery é uma unidade independente

(Alguns) Tipos de subqueries:

* Subqueries SELECT (Escalares)
* Subqueries FROM (derived tables)
* Subqueries WHERE (Múltiplos níveis)

Com certeza\! Subqueries (ou subconsultas) são uma das ferramentas mais poderosas e flexíveis do SQL. Elas permitem que você construa consultas complexas e dinâmicas, quebrando um problema grande em partes menores.

Assim como `ADD`, uma subquery não é uma *função* única, mas sim uma **técnica de escrita de consultas** onde uma instrução `SELECT` é aninhada dentro de outra instrução SQL.

#### **Qual é a sua função?**

A função de uma subquery é **realizar uma consulta para obter um resultado intermediário que será usado pela consulta principal (externa)**. Pense nela como uma "pergunta dentro de outra pergunta". A consulta interna é executada primeiro, e seu resultado é "entregue" para a consulta externa, que o utiliza para filtrar, selecionar ou calcular seus próprios resultados.

Subqueries podem retornar:

  * **Um único valor (escalar):** Ex: `SELECT MAX(salario) FROM funcionarios`.
  * **Uma única coluna com várias linhas (lista):** Ex: `SELECT id FROM clientes WHERE estado = 'SP'`.
  * **Múltiplas colunas e múltiplas linhas (uma tabela):** Ex: `SELECT id, nome FROM produtos_ativos`.

Elas podem ser usadas em várias partes de uma consulta principal, como nas cláusulas `SELECT`, `FROM`, `WHERE` e `HAVING`.

#### **Dicas e Boas Práticas**

1.  **Clareza e Legibilidade:** Embora poderosas, subqueries complexas podem dificultar a leitura do código. Sempre indente e comente suas subconsultas para que você (ou outra pessoa) entenda a lógica no futuro.
2.  **Performance:** Subqueries nem sempre são a opção mais performática. Em muitos casos, especialmente em subconsultas na cláusula `WHERE` (usando `IN` ou `NOT IN`), um `JOIN` pode ser mais rápido. Analise o plano de execução da sua consulta (`EXPLAIN PLAN`) para ver qual abordagem é melhor.
3.  **Subconsultas Correlacionadas:** Existem subconsultas que dependem da consulta externa para cada linha que ela processa. Elas podem ser muito lentas, pois a subconsulta é executada repetidamente. Use-as com cuidado e apenas quando necessário.
4.  **CTE (Common Table Expressions):** Para consultas muito complexas com múltiplos níveis de subqueries, considere usar CTEs (com a cláusula `WITH`). Elas tornam o código muito mais organizado e legível, permitindo que você nomeie seus resultados intermediários.

#### **Cenário Prático no Mundo Real**

Imagine que você gerencia o banco de dados de uma universidade. Você tem as tabelas `Alunos` e `Matriculas`.

**O problema:** O reitor pede uma lista com o nome de **todos os alunos que estão matriculados no curso de 'Engenharia de Software'**.

Como você resolve isso em uma única consulta?

1.  Primeiro, você precisa descobrir o `ID` do curso 'Engenharia de Software' na tabela `Cursos`.
2.  Depois, você precisa encontrar todos os `ID_Aluno` na tabela `Matriculas` que correspondem a esse `ID_Curso`.
3.  Finalmente, você pega essa lista de `ID_Aluno` e busca os nomes correspondentes na tabela `Alunos`.

Uma subquery permite que você faça tudo isso de uma vez. A "pergunta interna" descobre os IDs dos alunos matriculados, e a "pergunta externa" usa essa lista para encontrar os nomes.

-----

### **Trechos de Código**

#### 1\. Sintaxe Pura

A subquery é simplesmente uma instrução `SELECT` colocada dentro de parênteses. Abaixo estão as sintaxes mais comuns.

**Na cláusula `WHERE` (o uso mais comum):**

```sql
SELECT coluna1, coluna2
FROM tabela_principal
WHERE coluna_chave IN (SELECT coluna_da_subquery FROM outra_tabela WHERE condicao);
```

**Na cláusula `FROM` (tratando a subquery como uma tabela temporária):**

```sql
SELECT T.coluna_a, T.coluna_b
FROM (SELECT coluna1 AS coluna_a, coluna2 AS coluna_b FROM tabela_origem) AS T
WHERE T.coluna_a > 100;
```

**Na cláusula `SELECT` (para retornar um único valor):**

```sql
SELECT nome, (SELECT COUNT(*) FROM pedidos WHERE pedidos.cliente_id = clientes.id) AS total_de_pedidos
FROM clientes;
```

#### 2\. Exemplo Prático Aplicado

Usando nosso cenário da universidade para encontrar os alunos de 'Engenharia de Software'. Vamos supor que temos as tabelas `Alunos`, `Matriculas` e `Cursos`.

```sql
-- Tabelas de exemplo:
-- Alunos (ID_Aluno, Nome)
-- Cursos (ID_Curso, Nome_Curso)
-- Matriculas (ID_Matricula, ID_Aluno_FK, ID_Curso_FK)

-- A consulta com a subquery:
SELECT Nome
FROM Alunos
WHERE ID_Aluno IN (
    -- Início da Subquery: esta parte é executada primeiro.
    -- Ela retorna uma lista de IDs de todos os alunos
    -- matriculados no curso de Engenharia de Software.
    SELECT ID_Aluno_FK
    FROM Matriculas
    WHERE ID_Curso_FK = (
        -- Outra subquery, ainda mais interna!
        -- Retorna um único valor: o ID do curso desejado.
        SELECT ID_Curso FROM Cursos WHERE Nome_Curso = 'Engenharia de Software'
    )
    -- Fim da Subquery
);

-- Resultado: A consulta principal pega a lista de IDs retornada pela subquery
-- e filtra a tabela 'Alunos' para mostrar apenas os nomes correspondentes.
```

# Exemplos e Tipos

Vamos usar um cenário com duas tabelas simples para todos os exemplos: `Funcionarios` e `Departamentos`.

  * **`Departamentos`**:
      * `ID_Departamento` (Chave Primária)
      * `Nome_Departamento`
  * **`Funcionarios`**:
      * `ID_Funcionario` (Chave Primária)
      * `Nome`
      * `Salario`
      * `ID_Departamento_FK` (Chave Estrangeira para `Departamentos`)

-----

### **1. Subqueries `SELECT` (Escalares)**

Este tipo de subquery retorna **exatamente um valor único (uma coluna e uma linha)**. Ela é usada na lista de colunas da consulta principal, geralmente para calcular um valor relacionado a cada linha do resultado.

**Explicação:**
No exemplo abaixo, queremos listar cada funcionário, seu salário, e também exibir o salário médio de **toda** a empresa na mesma linha. A subquery `(SELECT AVG(Salario) FROM Funcionarios)` é escalar porque calcula um único valor (a média de todos os salários), que é então exibido como uma nova coluna chamada `Media_Geral_Salarios` para cada funcionário.

**Código Exemplo:**

```sql
SELECT
    Nome,
    Salario,
    -- Início da Subquery Escalar
    (SELECT AVG(Salario) FROM Funcionarios) AS Media_Geral_Salarios,
    -- Também podemos usá-la para fazer um cálculo em tempo real
    Salario - (SELECT AVG(Salario) FROM Funcionarios) AS Diferenca_Para_Media
FROM
    Funcionarios;
```

**Resultado esperado:**
| Nome | Salario | Media\_Geral\_Salarios | Diferenca\_Para\_Media |
| :--- | :--- | :--- | :--- |
| Ana | 6000 | 5500 | 500 |
| Bruno | 5000 | 5500 | -500 |
| Carlos | 5500 | 5500 | 0 |

-----

### **2. Subqueries `FROM` (Derived Tables / Tabelas Derivadas)**

Este tipo de subquery é usado na cláusula `FROM`. A consulta interna é executada primeiro, e seu resultado é tratado como uma **tabela temporária (ou virtual)**, da qual a consulta externa pode selecionar dados. É obrigatório dar um `ALIAS` (um apelido) para essa tabela derivada.

**Explicação:**
No exemplo abaixo, o objetivo é primeiro calcular a soma e a média de salários **por departamento** e, a partir desse resultado agrupado, selecionar apenas os departamentos cuja média salarial seja superior a R$ 5.000.

A subquery cria uma tabela virtual chamada `ResumoDepartamentos` com os cálculos. A consulta principal então filtra essa tabela virtual.

**Código Exemplo:**

```sql
SELECT
    Nome_Departamento,
    Media_Salarial_Por_Depto
FROM
    -- Início da Subquery (Tabela Derivada)
    (
        SELECT
            d.Nome_Departamento,
            COUNT(f.ID_Funcionario) AS Numero_Funcionarios,
            AVG(f.Salario) AS Media_Salarial_Por_Depto
        FROM
            Funcionarios AS f
        JOIN
            Departamentos AS d ON f.ID_Departamento_FK = d.ID_Departamento
        GROUP BY
            d.Nome_Departamento
    ) AS ResumoDepartamentos -- Alias obrigatório para a tabela derivada
    -- Fim da Subquery
WHERE
    ResumoDepartamentos.Media_Salarial_Por_Depto > 5000;
```

-----

### **3. Subqueries `WHERE` (Múltiplos Níveis)**

Este é o uso mais comum. A subquery é usada na cláusula `WHERE` para filtrar os resultados da consulta principal. Ela pode retornar uma lista de valores (para ser usada com `IN` ou `NOT IN`) ou um valor único (para ser usada com `=`, `>`, `<`, etc.).

**Explicação:**
No exemplo abaixo, queremos encontrar o nome de todos os funcionários que trabalham no departamento de 'Tecnologia'.

A consulta interna (a subquery) é executada primeiro para descobrir qual é o `ID_Departamento` correspondente ao nome 'Tecnologia'. A consulta externa então usa esse ID para filtrar a tabela `Funcionarios` e retornar apenas os funcionários que pertencem àquele departamento.

**Código Exemplo:**

```sql
SELECT
    Nome,
    Salario
FROM
    Funcionarios
WHERE
    ID_Departamento_FK IN (
        -- Início da Subquery. Ela retorna uma lista de IDs de departamento.
        -- Neste caso, retornará apenas um ID, mas o IN funciona para múltiplos também.
        SELECT ID_Departamento FROM Departamentos WHERE Nome_Departamento = 'Tecnologia'
        -- Fim da Subquery
    );
```

Excelente pergunta\! Além da classificação pelo local onde a subquery é usada (`SELECT`, `FROM`, `WHERE`), existem outras formas importantes de classificar as subqueries, principalmente pelo seu **comportamento** e pelos **operadores** com os quais elas trabalham.

As duas categorias conceituais mais importantes são: **Subqueries Correlacionadas** e **Não Correlacionadas**.

-----

### **4. Subquery Não Correlacionada (Self-Contained)**

É o tipo que vimos na maioria dos exemplos anteriores.

  * **Característica:** A subquery interna pode ser executada de forma completamente independente da consulta externa. Ela é executada **uma única vez**, e seu resultado é "entregue" para a consulta externa usar.
  * **Exemplo (Relembrando):**
    ```sql
    -- Encontrar funcionários que trabalham no departamento de 'Tecnologia'
    SELECT Nome FROM Funcionarios
    WHERE ID_Departamento_FK = (SELECT ID_Departamento FROM Departamentos WHERE Nome_Departamento = 'Tecnologia');
    ```
    Aqui, `(SELECT ID_Departamento FROM Departamentos ...)` é executada primeiro para encontrar o ID (ex: 5). Depois, a consulta principal efetivamente se torna `SELECT Nome FROM Funcionarios WHERE ID_Departamento_FK = 5;`.

-----

### **5. Subquery Correlacionada (Correlated Subquery)**

Este é um conceito mais avançado e muito poderoso.

  * **Característica:** A subquery interna **depende de dados da consulta externa**. Ela não pode ser executada de forma independente. O banco de dados a executa repetidamente, **uma vez para cada linha** que está sendo processada pela consulta externa.
  * **Cenário:** "Encontrar todos os funcionários que ganham mais do que a média salarial do **seu próprio departamento**."
  * **Explicação:** Para cada funcionário na consulta externa, a subquery interna precisa calcular a média salarial apenas para o departamento *daquele funcionário específico*. A subquery precisa do `ID_Departamento` da linha atual da consulta externa.
  * **Código Exemplo:**
    ```sql
    SELECT
        f1.Nome,
        f1.Salario,
        d.Nome_Departamento
    FROM
        Funcionarios AS f1
    JOIN
        Departamentos AS d ON f1.ID_Departamento_FK = d.ID_Departamento
    WHERE
        f1.Salario > (
            -- Início da Subquery Correlacionada
            -- Esta subquery calcula a média salarial apenas para o departamento do funcionário f1
            SELECT AVG(f2.Salario)
            FROM Funcionarios AS f2
            WHERE f2.ID_Departamento_FK = f1.ID_Departamento_FK -- A "correlação" acontece aqui!
            -- Fim da Subquery
        );
    ```
    **Atenção:** Subqueries correlacionadas podem ser lentas em tabelas muito grandes, pois a consulta interna é executada várias vezes.

-----

### **6. Subqueries com Operadores Específicos**

Além do `IN` e de operadores de comparação (`=`, `>`), existem outros operadores lógicos que são projetados para trabalhar com subqueries.

#### **A. `EXISTS` e `NOT EXISTS`**

  * **Função:** Verifica se a subquery retorna **qualquer linha**. `EXISTS` é verdadeiro se a subquery retornar uma ou mais linhas; `NOT EXISTS` é verdadeiro se ela não retornar nenhuma. É usado para checar a existência de uma relação. Muitas vezes é mais performático que `IN`.
  * **Cenário:** "Listar todos os departamentos que **têm** pelo menos um funcionário associado."
  * **Código Exemplo:**
    ```sql
    SELECT
        Nome_Departamento
    FROM
        Departamentos d
    WHERE EXISTS (
        -- A subquery verifica se existe algum funcionário para o departamento 'd' atual
        SELECT 1 -- Usamos 'SELECT 1' por convenção, é o mais rápido
        FROM Funcionarios f
        WHERE f.ID_Departamento_FK = d.ID_Departamento
    );
    ```

#### **B. `ANY` e `ALL`**

  * **Função:** São usados com operadores de comparação (`=`, `>`, `<`, `<>`) para comparar um valor com uma lista de valores retornada pela subquery.
      * `> ANY`: Maior que pelo menos um dos valores (ou seja, maior que o valor mínimo da lista).
      * `> ALL`: Maior que todos os valores (ou seja, maior que o valor máximo da lista).
  * **Cenário:** "Encontrar funcionários cujo salário é maior que o salário de **todos** os funcionários do departamento de 'RH' (cujo ID é 3)."
  * **Código Exemplo:**
    ```sql
    SELECT
        Nome,
        Salario
    FROM
        Funcionarios
    WHERE
        Salario > ALL (
            -- A subquery retorna uma lista de salários do pessoal de RH
            SELECT Salario
            FROM Funcionarios
            WHERE ID_Departamento_FK = 3
        );
    ```

### **Resumo dos Tipos**

| Tipo de Subquery | Principal Característica | Exemplo de Uso Comum |
| :--- | :--- | :--- |
| **Não Correlacionada** | Executada 1 vez, independente da consulta externa. | Filtrar com base em um resultado fixo (`WHERE ... IN (...)`). |
| **Correlacionada** | Executada 1 vez por linha da consulta externa, depende dela. | Comparar um valor da linha com um resultado agregado do seu próprio grupo. |
| **Com `EXISTS`** | Verifica a existência de linhas, retorna `TRUE` ou `FALSE`. | Encontrar registros em uma tabela que têm correspondência em outra. |
| **Com `ANY` / `ALL`** | Compara um valor com uma lista de valores da subquery. | Encontrar valores que são maiores/menores que o mínimo/máximo de um conjunto. |

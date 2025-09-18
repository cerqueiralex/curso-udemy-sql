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

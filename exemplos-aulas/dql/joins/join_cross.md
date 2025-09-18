# **Cláusula SQL: CROSS JOIN**

#### **Qual é a sua função?**

A função do `CROSS JOIN` é criar o que é conhecido como **Produto Cartesiano** entre duas tabelas. Em termos simples, ele combina **cada linha** da primeira tabela com **cada linha** da segunda tabela.

Se a Tabela A tem `m` linhas e a Tabela B tem `n` linhas, o resultado de um `CROSS JOIN` entre elas será uma nova tabela com `m * n` linhas.

Diferente dos outros `JOINs`, o `CROSS JOIN` **não precisa de uma cláusula `ON`** para especificar uma condição de junção, pois sua única regra é "combine tudo com tudo".

#### **Dicas e Boas Práticas**

1.  **Cuidado com a "Explosão Cartesiana":** Este é o ponto mais crítico. Se você usar `CROSS JOIN` em tabelas grandes, o resultado pode ser gigantesco e consumir todos os recursos do seu servidor. Um `CROSS JOIN` entre uma tabela de 1.000 clientes e outra de 1.000 produtos resultará em **1 milhão de linhas**. Use-o apenas quando tiver certeza de que precisa de todas as combinações e, de preferência, com tabelas pequenas.
2.  **Sintaxe Implícita vs. Explícita:** Existe uma sintaxe mais antiga para o `CROSS JOIN` que é simplesmente listar as tabelas separadas por vírgula: `FROM Tabela_A, Tabela_B`. Embora funcione, a sintaxe explícita `FROM Tabela_A CROSS JOIN Tabela_B` é preferível, pois deixa a sua intenção clara e evita `CROSS JOINs` acidentais (um erro comum quando se esquece a cláusula `WHERE` na sintaxe antiga).
3.  **Uso Principal - Geração de Dados:** O `CROSS JOIN` brilha quando você precisa gerar um conjunto de dados base para relatórios, testes ou templates. Por exemplo, criar todas as combinações possíveis de um produto, ou gerar uma grade de horários para todos os dias do mês.

#### **Cenário Prático no Mundo Real**

Imagine que você gerencia o estoque de uma loja de roupas. A loja vende um modelo de camiseta que está disponível em 4 tamanhos (`P`, `M`, `G`, `GG`) e em 3 cores (`Branca`, `Preta`, `Azul`).

**O problema:** Você precisa criar uma entrada no sistema de inventário para **cada variação possível** do produto (P-Branca, P-Preta, P-Azul, M-Branca, etc.) para que o estoque de cada uma possa ser controlado.

**A solução:** Em vez de cadastrar manualmente todas as 12 combinações, você pode usar um `CROSS JOIN` em duas tabelas pequenas: uma de `Tamanhos` e outra de `Cores`. O resultado será a lista completa de todas as variações que você precisa cadastrar.

-----

### **Trechos de Código**

#### 1\. Sintaxe Pura

A sintaxe explícita e recomendada é:

```sql
SELECT
    Tabela_A.coluna1,
    Tabela_B.coluna2
FROM
    Tabela_A
CROSS JOIN
    Tabela_B;
```

Não há cláusula `ON` ou `USING`.

#### 2\. Exemplo Prático Aplicado

Usando nosso cenário da loja de roupas para gerar todas as variações de camisetas.

```sql
-- Primeiro, criamos e populamos nossas tabelas de atributos
CREATE TABLE Tamanhos (
    tamanho VARCHAR(5)
);
INSERT INTO Tamanhos (tamanho) VALUES ('P'), ('M'), ('G'), ('GG');

CREATE TABLE Cores (
    cor VARCHAR(20)
);
INSERT INTO Cores (cor) VALUES ('Branca'), ('Preta'), ('Azul');

-- Agora, usamos o CROSS JOIN para gerar todas as combinações possíveis
SELECT
    t.tamanho,
    c.cor
FROM
    Tamanhos AS t
CROSS JOIN
    Cores AS c
ORDER BY
    t.tamanho, c.cor;

-- O resultado será uma lista com 12 linhas (4 tamanhos * 3 cores),
-- pronta para ser inserida na sua tabela de produtos:
--
-- tamanho | cor
-- --------|--------
-- G       | Azul
-- G       | Branca
-- G       | Preta
-- GG      | Azul
-- GG      | Branca
-- GG      | Preta
-- M       | Azul
-- M       | Branca
-- M       | Preta
-- P       | Azul
-- P       | Branca
-- P       | Preta
```

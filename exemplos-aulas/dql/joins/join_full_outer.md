# **Junção SQL: FULL JOIN (ou FULL OUTER JOIN)**

#### **Qual é a sua função?**

A função do `FULL JOIN` é **retornar todos os registros de ambas as tabelas (esquerda e direita) que estão sendo unidas**.

Ele funciona da seguinte maneira:

1.  Ele tenta combinar as linhas de ambas as tabelas com base na condição de junção (a cláusula `ON`).
2.  Se houver uma correspondência, ele retorna uma única linha com os dados combinados das duas tabelas (como um `INNER JOIN`).
3.  Se uma linha da tabela da esquerda **não tiver** uma correspondência na tabela da direita, ele ainda assim retorna essa linha, preenchendo as colunas da tabela da direita com `NULL`.
4.  Da mesma forma, se uma linha da tabela da direita **não tiver** uma correspondência na tabela da esquerda, ele também retorna essa linha, preenchendo as colunas da tabela da esquerda com `NULL`.

Em resumo, ele é a combinação de um `LEFT JOIN` e um `RIGHT JOIN`. Ele garante que nenhuma informação de nenhuma das tabelas seja perdida na junção.

#### **Dicas e Boas Práticas**

1.  **Cuidado com `NULL`s:** O resultado de um `FULL JOIN` frequentemente contém valores `NULL`. É crucial tratar esses nulos em sua lógica, seja no `SELECT` (usando funções como `COALESCE` para substituir o `NULL` por um valor padrão) ou no `WHERE` para filtrar os resultados.
2.  **Encontrando Inconsistências:** A principal utilidade do `FULL JOIN` é para análise e auditoria de dados. Ao filtrar por `WHERE Tabela1.ID IS NULL` ou `WHERE Tabela2.ID IS NULL`, você consegue encontrar registros que existem em uma tabela mas não têm correspondência na outra, o que pode indicar órfãos ou inconsistências nos dados.
3.  **Performance:** `FULL JOIN`s podem ser computacionalmente caros e gerar conjuntos de resultados muito grandes, especialmente em tabelas com muitos registros sem correspondência. Use-os com critério e sempre que possível com cláusulas `WHERE` para filtrar os dados.
4.  **Sintaxe:** Os termos `FULL JOIN` e `FULL OUTER JOIN` são sinônimos e intercambiáveis na maioria dos sistemas de banco de dados (como SQL Server, PostgreSQL e Oracle).

#### **Cenário Prático no Mundo Real**

Imagine que uma empresa tem dois sistemas diferentes:

1.  Um sistema de RH com uma tabela `Funcionarios`, que contém `ID_Funcionario` e `Nome_Funcionario`.
2.  Um sistema de segurança com uma tabela `Crachas_Acesso`, que contém `ID_Cracha`, `Numero_Cracha` e o `ID_Funcionario_Associado`.

O gerente de TI precisa fazer uma auditoria para responder a três perguntas:

  * Quais funcionários têm um crachá associado?
  * Quais funcionários **não têm** um crachá? (Talvez sejam novos contratados esperando o crachá).
  * Quais crachás estão cadastrados mas **não estão associados** a nenhum funcionário válido? (Pode ser um crachá de um ex-funcionário que precisa ser desativado).

Um `INNER JOIN` mostraria apenas a primeira resposta. Um `LEFT JOIN` mostraria a primeira e a segunda. Somente um `FULL JOIN` pode responder a todas as três perguntas de uma só vez, mostrando a relação completa (e a falta dela) entre funcionários e crachás.

-----

### **Trechos de Código**

#### 1\. Sintaxe Pura

A sintaxe genérica é a seguinte:

```sql
SELECT
    TabelaA.coluna1,
    TabelaA.coluna2,
    TabelaB.coluna3,
    TabelaB.coluna4
FROM
    TabelaA
FULL OUTER JOIN
    TabelaB ON TabelaA.chave_comum = TabelaB.chave_comum;
```

  * `TabelaA`: A primeira tabela (ou a da esquerda).
  * `TabelaB`: A segunda tabela (ou a da direita).
  * `chave_comum`: A coluna que relaciona as duas tabelas.

#### 2\. Exemplo Prático Aplicado

Usando nosso cenário de auditoria de funcionários e crachás:

```sql
-- Criando tabelas de exemplo
CREATE TABLE Funcionarios (
    ID_Funcionario INT PRIMARY KEY,
    Nome_Funcionario VARCHAR(100)
);

CREATE TABLE Crachas_Acesso (
    ID_Cracha INT PRIMARY KEY,
    Numero_Cracha VARCHAR(50),
    ID_Funcionario_Associado INT
);

-- Inserindo dados de exemplo
INSERT INTO Funcionarios VALUES (10, 'Ana Silva');     -- Tem crachá
INSERT INTO Funcionarios VALUES (20, 'Bruno Costa');    -- Tem crachá
INSERT INTO Funcionarios VALUES (30, 'Carlos Dias');  -- NÃO tem crachá

INSERT INTO Crachas_Acesso VALUES (101, 'CRACHA-01', 10); -- Crachá da Ana
INSERT INTO Crachas_Acesso VALUES (102, 'CRACHA-02', 20); -- Crachá do Bruno
INSERT INTO Crachas_Acesso VALUES (103, 'CRACHA-03', 99); -- Crachá associado a um funcionário que NÃO EXISTE

-- Agora, a consulta de auditoria usando FULL JOIN
SELECT
    f.ID_Funcionario,
    f.Nome_Funcionario,
    c.Numero_Cracha
FROM
    Funcionarios f
FULL OUTER JOIN
    Crachas_Acesso c ON f.ID_Funcionario = c.ID_Funcionario_Associado;
```

**Resultado da Consulta:**

| ID\_Funcionario | Nome\_Funcionario | Numero\_Cracha |
| :--- | :--- | :--- |
| 10 | Ana Silva | CRACHA-01 |
| 20 | Bruno Costa | CRACHA-02 |
| 30 | Carlos Dias | `NULL` |
| `NULL` | `NULL` | CRACHA-03 |

**Análise do Resultado:**

  * **Linhas 1 e 2:** Funcionários com crachás correspondentes (resultado de um `INNER JOIN`).
  * **Linha 3:** O funcionário 'Carlos Dias' existe, mas não tem crachá (`Numero_Cracha` é `NULL`).
  * **Linha 4:** O 'CRACHA-03' existe, mas não está associado a nenhum funcionário válido (`ID_Funcionario` e `Nome_Funcionario` são `NULL`).

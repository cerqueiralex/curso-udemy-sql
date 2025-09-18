# **Cláusula SQL: RIGHT JOIN (ou RIGHT OUTER JOIN)**

É importante notar que `RIGHT JOIN` e `RIGHT OUTER JOIN` são funcionalmente idênticos. O uso de `RIGHT JOIN` é apenas uma forma mais curta e comum de escrever o mesmo comando.

#### **Qual é a sua função?**

A função do `RIGHT JOIN` é retornar **todos os registros da tabela à direita** (a segunda tabela mencionada na consulta) e os registros correspondentes da tabela à esquerda.

O resultado é:

1.  Se houver uma correspondência entre a tabela da direita e a da esquerda (baseado na condição `ON`), a linha conterá os dados de ambas as tabelas.
2.  Se um registro da tabela da direita **não tiver** uma correspondência na tabela da esquerda, a linha ainda assim será retornada, mas as colunas da tabela da esquerda conterão o valor `NULL`.

Pense assim: a tabela da direita é a "principal" na consulta; todos os seus registros são garantidos no resultado.

#### **Dicas e Boas Práticas**

1.  **LEFT JOIN é mais comum:** Na prática, a maioria dos desenvolvedores prefere usar `LEFT JOIN`. Um `RIGHT JOIN` pode ser sempre reescrito como um `LEFT JOIN` simplesmente invertendo a ordem das tabelas. Muitos acham que ler as consultas da esquerda para a direita (começando com a tabela principal) é mais intuitivo.
      * `TabelaA RIGHT JOIN TabelaB` é o mesmo que `TabelaB LEFT JOIN TabelaA`.
2.  **Encontrando Dados "Órfãos":** O uso mais poderoso do `RIGHT JOIN` (e do `LEFT JOIN`) é encontrar registros em uma tabela que não têm correspondência na outra. Você faz isso filtrando por `NULL` na chave da tabela da esquerda. Por exemplo: `WHERE TabelaEsquerda.ID IS NULL`.
3.  **Visualização:** Imagine dois círculos de um Diagrama de Venn. O `RIGHT JOIN` retorna todo o círculo da direita, mais a interseção entre os dois.

#### **Cenário Prático no Mundo Real**

Imagine que uma empresa tem uma tabela de `Departamentos` e uma tabela de `Funcionarios`. A empresa quer fazer um relatório para descobrir **quais departamentos ainda não têm funcionários alocados**.

  * **Tabela `Departamentos`:** Contém `ID_Departamento` e `Nome_Departamento`.
  * **Tabela `Funcionarios`:** Contém `ID_Funcionario`, `Nome_Funcionario` e `ID_Departamento_FK` (a chave estrangeira que liga ao departamento).

Se fizermos um `INNER JOIN`, só veremos os departamentos que *têm* funcionários. Mas com um `RIGHT JOIN`, podemos listar todos os departamentos e ver quais deles não têm nenhum funcionário associado.

**O problema:** Como identificar os departamentos vazios?

**A solução:** Usar um `RIGHT JOIN` partindo da tabela `Funcionarios` para a tabela `Departamentos`. Isso garante que todos os departamentos apareçam na lista. Onde não houver um funcionário correspondente, as colunas de `Funcionarios` serão `NULL`.

-----

### **Trechos de Código**

#### 1\. Sintaxe Pura

A sintaxe genérica para um `RIGHT JOIN` é:

```sql
SELECT
    TabelaEsquerda.coluna1,
    TabelaDireita.coluna2
FROM
    TabelaEsquerda
RIGHT JOIN TabelaDireita
    ON TabelaEsquerda.coluna_chave = TabelaDireita.coluna_chave;
```

  * `TabelaEsquerda`: A primeira tabela mencionada.
  * `TabelaDireita`: A segunda tabela. O `RIGHT JOIN` garante que todos os registros desta tabela estarão no resultado.
  * `ON ...`: A condição que conecta as duas tabelas.

#### 2\. Exemplo Prático Aplicado

Usando nosso cenário de `Funcionarios` e `Departamentos`.

```sql
-- 1. Vamos criar e popular as tabelas
CREATE TABLE Departamentos (
    ID_Departamento INT PRIMARY KEY,
    Nome_Departamento VARCHAR(100)
);

CREATE TABLE Funcionarios (
    ID_Funcionario INT PRIMARY KEY,
    Nome_Funcionario VARCHAR(100),
    ID_Departamento_FK INT
);

INSERT INTO Departamentos (ID_Departamento, Nome_Departamento) VALUES
(1, 'Vendas'),
(2, 'RH'),
(3, 'TI'),
(4, 'Marketing'); -- Departamento sem funcionários

INSERT INTO Funcionarios (ID_Funcionario, Nome_Funcionario, ID_Departamento_FK) VALUES
(101, 'Ana', 1),
(102, 'Bruno', 1),
(103, 'Carlos', 2),
(104, 'Daniela', 3);

-- 2. Agora, a consulta com RIGHT JOIN para listar todos os departamentos
-- e os funcionários correspondentes.
SELECT
    f.Nome_Funcionario,
    d.Nome_Departamento
FROM
    Funcionarios AS f
RIGHT JOIN Departamentos AS d
    ON f.ID_Departamento_FK = d.ID_Departamento;
```

**Resultado da consulta:**

| Nome\_Funcionario | Nome\_Departamento |
| :--------------- | :---------------- |
| Ana              | Vendas            |
| Bruno            | Vendas            |
| Carlos           | RH                |
| Daniela          | TI                |
| **NULL** | **Marketing** |

A linha com `NULL` e `Marketing` nos mostra exatamente o que queríamos: o departamento de Marketing existe, mas não tem nenhum funcionário alocado a ele.

# **Cláusula SQL: LEFT JOIN (LEFT OUTER JOIN)**

O nome completo da cláusula é `LEFT OUTER JOIN`, mas na prática, a palavra `OUTER` é quase sempre omitida, e a maioria das pessoas usa apenas `LEFT JOIN`. Ambas as formas são funcionalmente idênticas na maioria dos sistemas de banco de dados.

#### **Qual é a sua função?**

A função do `LEFT JOIN` é retornar **todos os registros da tabela da esquerda (a primeira tabela mencionada) e os registros correspondentes da tabela da direita (a segunda tabela)**.

O ponto-chave é: se não houver uma correspondência na tabela da direita para um registro da tabela da esquerda, o resultado ainda assim mostrará o registro da tabela da esquerda, e as colunas da tabela da direita serão preenchidas com o valor `NULL`.

Em resumo: ele prioriza a tabela da esquerda, garantindo que todos os seus dados apareçam no resultado final.

#### **Dicas e Boas Práticas**

1.  **Diferença Crucial para o `INNER JOIN`:** Um `INNER JOIN` só retorna os registros que têm correspondência em **ambas** as tabelas. O `LEFT JOIN` retorna **todos** da esquerda, independentemente de terem ou não uma correspondência na direita.
2.  **A Ordem das Tabelas Importa:** Ao contrário do `INNER JOIN`, no `LEFT JOIN` a ordem em que você escreve as tabelas muda completamente o resultado. `FROM TabelaA LEFT JOIN TabelaB` é diferente de `FROM TabelaB LEFT JOIN TabelaA`.
3.  **Encontrando o que "Falta":** A dica mais poderosa sobre `LEFT JOIN` é usá-lo para encontrar registros que existem em uma tabela mas não têm correspondência em outra. Você faz isso adicionando uma cláusula `WHERE` para filtrar onde a chave da tabela da direita é `NULL`. (Ex: `WHERE TabelaDireita.ID IS NULL`).
4.  **Use Aliases:** Ao trabalhar com `JOINs`, é uma excelente prática usar aliases (apelidos) para os nomes das tabelas (ex: `FROM Clientes c LEFT JOIN Pedidos p`). Isso torna o código mais curto, legível e evita ambiguidades quando as tabelas têm colunas com o mesmo nome.

#### **Cenário Prático no Mundo Real**

Imagine que você gerencia a base de dados de uma plataforma de cursos online. Você tem duas tabelas principais:

  * **`Alunos`**: Contém `ID_Aluno`, `Nome` e `Email` de todos os alunos cadastrados.
  * **`Inscricoes`**: Contém `ID_Inscricao`, `ID_Aluno` e `ID_Curso`, registrando qual aluno se inscreveu em qual curso.

**O problema:** O time de marketing quer lançar uma campanha para reengajar alunos que se cadastraram na plataforma, mas que **nunca se inscreveram em nenhum curso**. Como você obtém essa lista?

**A solução:** Um `LEFT JOIN` da tabela `Alunos` para a tabela `Inscricoes` é a ferramenta perfeita. Você pega todos os alunos (`tabela da esquerda`) e tenta juntar com suas inscrições (`tabela da direita`). Os alunos que tiverem `NULL` nos dados da inscrição são exatamente aqueles que nunca se inscreveram em nada.

-----

### **Trechos de Código**

#### 1\. Sintaxe Pura

Aqui está a estrutura genérica de um `LEFT JOIN`.

```sql
SELECT
    tabela1.coluna1,
    tabela1.coluna2,
    tabela2.coluna1
FROM
    tabela1 -- Tabela da Esquerda (SEMPRE retorna todos os seus registros)
LEFT JOIN
    tabela2 -- Tabela da Direita
ON
    tabela1.coluna_chave = tabela2.coluna_chave; -- Condição de junção
```

  * `tabela1`: A tabela principal, da qual você quer todos os resultados.
  * `tabela2`: A tabela secundária, que pode ou não ter correspondências.
  * `ON ...`: A regra que diz como os registros das duas tabelas se relacionam.

#### 2\. Exemplo Prático Aplicado

Usando nosso cenário da plataforma de cursos para encontrar alunos sem nenhuma inscrição.

```sql
-- Passo 1: Criar e popular as tabelas de exemplo
CREATE TABLE Alunos (
    ID_Aluno INT PRIMARY KEY,
    Nome VARCHAR(100)
);

CREATE TABLE Inscricoes (
    ID_Inscricao INT PRIMARY KEY,
    ID_Aluno INT,
    ID_Curso INT
);

INSERT INTO Alunos (ID_Aluno, Nome) VALUES
(1, 'Ana Silva'),
(2, 'Bruno Costa'),
(3, 'Carla Dias'),  -- Carla nunca se inscreveu em um curso
(4, 'Daniel Souza');

INSERT INTO Inscricoes (ID_Inscricao, ID_Aluno, ID_Curso) VALUES
(101, 1, 50),  -- Ana
(102, 2, 51),  -- Bruno
(103, 4, 50),  -- Daniel
(104, 1, 52);  -- Ana fez outro curso

-- Passo 2: A consulta com LEFT JOIN para encontrar alunos sem inscrição
SELECT
    a.Nome,
    i.ID_Inscricao
FROM
    Alunos a
LEFT JOIN
    Inscricoes i ON a.ID_Aluno = i.ID_Aluno
WHERE
    i.ID_Inscricao IS NULL;

-- RESULTADO DA CONSULTA:
--
-- Nome        | ID_Inscricao
-- ------------|---------------
-- Carla Dias  | NULL
--
-- A consulta retorna exatamente a aluna que está na tabela Alunos,
-- mas não possui nenhuma correspondência na tabela Inscricoes.
```

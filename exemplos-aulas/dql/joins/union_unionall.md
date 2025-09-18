# **Operadores SQL: UNION vs. UNION ALL**

#### **Qual é a sua função?**

Ambos os operadores têm a função de **empilhar verticalmente** os resultados de múltiplas consultas `SELECT`. Imagine que você tem o resultado da primeira consulta em uma folha de papel e o resultado da segunda consulta em outra. `UNION` e `UNION ALL` colam uma folha abaixo da outra para criar uma lista unificada.

Para que isso funcione, as consultas `SELECT` envolvidas devem seguir duas regras obrigatórias:

1.  Elas devem ter o **mesmo número de colunas**.
2.  As colunas correspondentes devem ter **tipos de dados compatíveis** (ex: uma coluna de texto com outra de texto, uma de número com outra de número).

A grande diferença está em como eles tratam linhas duplicadas:

  * **`UNION`**: Combina os resultados e **remove todas as linhas duplicadas**. Ele efetivamente executa uma operação `DISTINCT` no conjunto de resultados final.
  * **`UNION ALL`**: Combina os resultados e **mantém todas as linhas** de todas as consultas, incluindo as duplicadas.

#### **Dicas e Boas Práticas**

1.  **Performance é a Chave:** **Sempre prefira `UNION ALL`** a menos que você tenha uma razão específica para remover duplicatas. Como `UNION` precisa verificar cada linha para encontrar e remover duplicatas, ele é significativamente mais lento e consome mais recursos do que `UNION ALL`, que simplesmente junta os resultados sem nenhuma verificação.
2.  **Nomes das Colunas:** O nome das colunas no resultado final é determinado pela **primeira consulta `SELECT`**. É uma boa prática usar aliases (`AS`) na primeira consulta para deixar o resultado mais claro.
3.  **Ordenação (`ORDER BY`):** Se você precisar ordenar o resultado final, a cláusula `ORDER BY` deve ser colocada apenas no final da última consulta `SELECT`. Ela será aplicada ao conjunto de dados unificado.

#### **Cenário Prático no Mundo Real**

Imagine uma empresa que possui duas tabelas:

  * `Funcionarios_Atuais`: Contém informações sobre todos os funcionários que trabalham na empresa atualmente.
  * `Funcionarios_Demitidos`: Um arquivo histórico com informações de ex-funcionários.

O departamento de RH precisa gerar um relatório para o final do ano contendo o **nome e o email de todas as pessoas que já passaram pela empresa** (atuais e demitidos) para enviar uma mensagem de felicitações.

**O problema:** Os dados estão em duas tabelas separadas. Como criar uma lista de emails unificada?

**A solução:** Você usará um operador de união para combinar os resultados das duas tabelas.

  * Se o objetivo é garantir que cada pessoa receba apenas **um email** (caso alguém tenha sido demitido e recontratado, por exemplo), você usaria `UNION` para remover os emails duplicados.
  * Se o objetivo fosse apenas fazer uma contagem bruta de quantos registros de funcionários existem no total (incluindo duplicatas), você usaria `UNION ALL`.

Para o envio do email, `UNION` é a escolha correta e mais segura.

## UNION

O UNION serve para juntar resultados de duas ou mais consultas SQL, eliminando duplicatas automaticamente.

* Remove duplicatas
* Mais lento (Não usa DISTINCT)
* Volume de dados reduzido

Se ambas as tabelas tiverem "São Paulo", ele só vai trazer uma vez.

Resultado final será sem duplicatas.

Use UNION quando:

* Você quer dados únicos e não se importa com performance.
Ex: Gerar uma lista única de cidades de duas fontes.

## UNION ALL

O UNION ALL também junta os resultados de duas ou mais queries, mas mantém os duplicados.

* Não Remove duplicatas
* Mais rápido (Não deduplica)
* Volume de dados igual / total

Se "São Paulo" aparecer 3 vezes, ele trará as 3 vezes.

Use UNION ALL quando:

* Precisa manter todos os registros, mesmo os repetidos.
* Quer melhor performance, pois ele não faz verificação e duplicatas.

Ex: Juntar logs, eventos, faturas repetidas por cliente, etc.

-----

### **Trechos de Código**

#### 1\. Sintaxe Pura

A sintaxe genérica é a mesma para ambos, você apenas escolhe qual operador usar.

```sql
SELECT coluna1, coluna2 FROM tabela_A
WHERE condicao

UNION -- ou UNION ALL

SELECT coluna_x, coluna_y FROM tabela_B
WHERE outra_condicao;
```

*Note que `coluna1` e `coluna_x` devem ser de tipos compatíveis, assim como `coluna2` e `coluna_y`.*

#### 2\. Exemplo Prático Aplicado

Usando o cenário dos funcionários, vamos criar a lista de emails.

```sql
-- Supondo a existência das tabelas:
-- Funcionarios_Atuais (ID, Nome, Email)
-- Funcionarios_Demitidos (ID, Nome, Email)

-- Vamos popular com alguns dados, incluindo um funcionário que foi demitido e recontratado
-- INSERT INTO Funcionarios_Atuais VALUES (1, 'Ana Silva', 'ana.silva@email.com');
-- INSERT INTO Funcionarios_Atuais VALUES (2, 'Carlos Souza', 'carlos.souza@email.com');
-- INSERT INTO Funcionarios_Demitidos VALUES (3, 'Jorge Lima', 'jorge.lima@email.com');
-- INSERT INTO Funcionarios_Demitidos VALUES (1, 'Ana Silva', 'ana.silva@email.com'); -- Ana foi demitida antes


-- Exemplo 1: Usando UNION para obter uma lista de emails única (ideal para o newsletter)
-- O email de 'Ana Silva' aparecerá apenas uma vez.
SELECT Nome, Email FROM Funcionarios_Atuais

UNION

SELECT Nome, Email FROM Funcionarios_Demitidos;

-- Resultado do UNION:
-- Nome         | Email
-- ------------------------------------
-- Ana Silva    | ana.silva@email.com
-- Carlos Souza | carlos.souza@email.com
-- Jorge Lima   | jorge.lima@email.com


-- Exemplo 2: Usando UNION ALL para obter todos os registros
-- O email de 'Ana Silva' aparecerá duas vezes.
SELECT Nome, Email FROM Funcionarios_Atuais

UNION ALL

SELECT Nome, Email FROM Funcionarios_Demitidos;

-- Resultado do UNION ALL:
-- Nome         | Email
-- ------------------------------------
-- Ana Silva    | ana.silva@email.com
-- Carlos Souza | carlos.souza@email.com
-- Jorge Lima   | jorge.lima@email.com
-- Ana Silva    | ana.silva@email.com
```

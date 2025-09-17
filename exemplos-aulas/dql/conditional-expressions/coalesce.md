# A Função SQL: COALESCE()

## O que é a função `COALESCE()`?

A função `COALESCE()` é uma das funções mais úteis e versáteis do SQL. Ela aceita uma lista de dois ou mais argumentos e retorna o **primeiro argumento da lista que não seja NULO (NULL)**.

Pense nela como uma cascata de tentativas: ela verifica o primeiro valor; se for nulo, passa para o segundo; se o segundo for nulo, passa para o terceiro, e assim por diante, até encontrar um valor válido ou esgotar a lista. Se todos os argumentos fornecidos forem `NULL`, a função retornará `NULL`.

## Dicas e Pontos de Atenção

  * **Padrão ANSI SQL**: Uma grande vantagem da `COALESCE()` é que ela faz parte do padrão ANSI SQL, o que significa que funciona na grande maioria dos sistemas de banco de dados (SQL Server, PostgreSQL, MySQL, Oracle, etc.). Isso a torna mais portável do que funções específicas como `ISNULL()` (SQL Server) ou `NVL()` (Oracle).
  * **Múltiplos Argumentos**: Diferente de `ISNULL()` e `NVL()`, que só aceitam dois argumentos, `COALESCE()` pode receber uma lista longa de valores, permitindo criar uma cadeia de "fallbacks" (alternativas).
  * **Compatibilidade de Tipos de Dados**: Todos os argumentos na lista devem ser de tipos de dados compatíveis. Se você misturar texto com números (ex: `COALESCE(coluna_numerica, 'Não disponível')`), o banco de dados tentará uma conversão implícita. Para evitar erros, garanta que todos os valores possam ser convertidos para um tipo de dado em comum (geralmente o tipo com maior precedência).
  * **Evitar NULOs em Cálculos**: Use `COALESCE()` para substituir `NULL` por um valor padrão (como `0` ou `1`) antes de realizar operações matemáticas. Qualquer cálculo envolvendo `NULL` (ex: `5 * NULL`) sempre resulta em `NULL`. `COALESCE()` previne isso.

## Cenário de Aplicação Prática no Mundo Real

O cenário mais comum para `COALESCE()` é **fornecer valores padrão (defaults) para dados ausentes** em relatórios e exibições.

**Exemplo prático:**
Imagine um sistema de e-commerce com uma tabela de `produtos`. Essa tabela tem as colunas `nome_produto` e `apelido_produto`. A coluna `apelido_produto` é opcional e muitas vezes está nula. Ao gerar uma lista de produtos para o site, você não quer mostrar um espaço em branco. A regra de negócio é: "Mostrar o `apelido_produto` se ele existir; caso contrário, mostrar o `nome_produto` oficial".

A função `COALESCE()` é perfeita para isso. Com `COALESCE(apelido_produto, nome_produto)`, você garante que sempre um nome válido será exibido, priorizando o apelido quando ele estiver disponível.

Outro cenário clássico é consolidar informações de contato, como no exemplo de código abaixo.

## Exemplos de Código

### 1\. Sintaxe Pura

A sintaxe aceita uma lista de valores separados por vírgula. Ela retornará o primeiro valor que não for `NULL`.

```sql
SELECT COALESCE(valor1, valor2, valor3, ..., valor_padrao)
FROM sua_tabela;
```

### 2\. Exemplo Aplicado (Cenário Real)

Vamos usar um cenário de uma tabela de `contatos`. Queremos criar uma coluna que mostre o melhor telefone disponível para contato, seguindo uma ordem de preferência: Celular \> Comercial \> Residencial. Se nenhum existir, exibimos uma mensagem padrão.

```sql
-- Cenário: Em uma lista de contatos, queremos exibir o melhor telefone disponível.
-- A ordem de preferência é: Celular, depois Telefone Comercial, depois Telefone Residencial.
-- Se nenhum existir, mostrar uma mensagem padrão.

SELECT
    nome_contato,
    COALESCE(
        telefone_celular,
        telefone_comercial,
        telefone_residencial,
        'Não possui telefone cadastrado'
    ) AS melhor_telefone_disponivel
FROM
    contatos;

/*
Vamos imaginar a seguinte tabela 'contatos':
+--------------+------------------+----------------------+------------------------+
| nome_contato | telefone_celular | telefone_comercial   | telefone_residencial   |
+--------------+------------------+----------------------+------------------------+
| Ana Silva    | (11) 98888-8888  | (11) 5555-5555       | (11) 2222-2222         |
| Beto Costa   | NULL             | (11) 6666-6666       | NULL                   |
| Carla Dias   | NULL             | NULL                 | (11) 3333-3333         |
| Daniel Souza | NULL             | NULL                 | NULL                   |
+--------------+------------------+----------------------+------------------------+

Resultado da consulta acima:
+--------------+---------------------------------+
| nome_contato | melhor_telefone_disponivel      |
+--------------+---------------------------------+
| Ana Silva    | (11) 98888-8888                 | -- Retornou o primeiro valor não nulo (celular)
| Beto Costa   | (11) 6666-6666                  | -- Pulou o celular (nulo) e retornou o comercial
| Carla Dias   | (11) 3333-3333                  | -- Pulou os dois primeiros e retornou o residencial
| Daniel Souza | Não possui telefone cadastrado  | -- Retornou o valor padrão, pois todos eram nulos
+--------------+---------------------------------+
*/
```

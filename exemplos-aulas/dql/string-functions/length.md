# A Função SQL: LENGTH()

## O que é a função `LENGTH()`?

A função `LENGTH()` (e suas variantes como `LEN()` e `CHAR_LENGTH()`) em SQL é uma função de texto que retorna o comprimento de uma string. O resultado é um número inteiro que representa quantos caracteres (ou, em alguns casos específicos, quantos bytes) a string contém.

Por exemplo, `LENGTH('Olá Mundo')` retornaria `9`, pois a string "Olá Mundo" possui 9 caracteres, incluindo o espaço.

## Dicas e Pontos de Atenção

  * **Variações de Nomes e Comportamentos (MUITO IMPORTANTE\!)**: Diferente de outras funções, o nome e o comportamento de `LENGTH()` variam significativamente entre os sistemas de banco de dados.

      * **MySQL / PostgreSQL**: Usam `LENGTH()` para medir o tamanho em **bytes** e `CHAR_LENGTH()` (ou `CHARACTER_LENGTH()`) para medir em **caracteres**. Para textos que podem conter acentos ou caracteres especiais (UTF-8), `CHAR_LENGTH()` é a opção mais segura e precisa para contar os caracteres. Por exemplo, em UTF-8, `LENGTH('ç')` pode retornar `2` (bytes), enquanto `CHAR_LENGTH('ç')` sempre retornará `1` (caractere).
      * **SQL Server**: Usa a função `LEN()`. Uma grande e importante diferença é que `LEN()` **ignora os espaços em branco no final da string**. Por exemplo, `LEN('sql   ')` retornará `3`.
      * **Oracle**: Usa `LENGTH()` que, dependendo da configuração do banco de dados, pode medir em bytes ou caracteres. `LENGTHC()` é usado para garantir a contagem em caracteres.

  * **Valores `NULL`**: Se a string de entrada for `NULL`, o resultado da função também será `NULL`, e não `0`.

  * **Encontrando Strings Vazias**: A função é muito útil para encontrar campos que não foram preenchidos. É uma boa prática combiná-la com `TRIM()` para desconsiderar espaços em branco, por exemplo: `WHERE LENGTH(TRIM(coluna)) = 0`.

## Cenário de Aplicação Prática no Mundo Real

O cenário mais comum e crítico para a função `LENGTH()` é na **validação e limpeza de dados (Data Cleansing)**.

As regras de negócio de um sistema frequentemente definem requisitos de tamanho para campos de texto. Por exemplo, em um sistema de cadastro de clientes no Brasil:

  * Um **CPF** deve ter exatamente 11 caracteres (se armazenado sem pontos ou traços).
  * O campo **UF** (Unidade Federativa / Estado) deve ter exatamente 2 caracteres (ex: 'SP', 'RJ', 'MG').
  * Uma **senha** de usuário deve ter no mínimo 8 caracteres.
  * Um **CEP** deve ter 8 caracteres (sem o traço).

Você pode usar `LENGTH()` em uma cláusula `WHERE` para auditar a base de dados e encontrar todos os registros que não estão em conformidade com essas regras, permitindo a correção dos dados e garantindo a integridade do sistema.

## Exemplos de Código

### 1\. Sintaxe Pura

Devido às variações, a sintaxe pura pode ser representada das seguintes formas:

```sql
-- Sintaxe para contar caracteres (mais segura e recomendada em MySQL, PostgreSQL)
SELECT CHAR_LENGTH(sua_coluna_de_texto) FROM sua_tabela;

-- Sintaxe para SQL Server (lembre-se que ignora espaços finais)
SELECT LEN(sua_coluna_de_texto) FROM sua_tabela;

-- Sintaxe genérica (pode contar bytes em alguns sistemas)
SELECT LENGTH(sua_coluna_de_texto) FROM sua_tabela;
```

### 2\. Exemplo Aplicado (Cenário Real)

Vamos usar o cenário de validação de dados para encontrar clientes em uma tabela cujo campo `uf` (estado) não possui exatamente 2 caracteres, indicando um erro de digitação ou importação.

```sql
-- Cenário: Encontrar registros de clientes onde o campo 'uf' é inválido.
-- Usaremos CHAR_LENGTH() por ser mais robusto para contar caracteres.

SELECT
    cliente_id,
    nome_cliente,
    uf,
    CHAR_LENGTH(uf) AS tamanho_do_campo_uf
FROM
    clientes
WHERE
    -- A condição busca por qualquer registro onde o tamanho seja diferente de 2
    CHAR_LENGTH(uf) <> 2
    -- Também podemos incluir casos onde o campo é NULL, embora a condição acima já os ignore
    OR uf IS NULL;

/*
Resultado Esperado (mostraria apenas os registros com problema):
+------------+------------------+-------+-----------------------+
| cliente_id | nome_cliente     | uf    | tamanho_do_campo_uf   |
+------------+------------------+-------+-----------------------+
| 103        | Carla Dias       | 'SP ' | 3                     | -- Problema: Espaço extra no final
| 205        | Eduardo Lima     | 'Minas' | 5                   | -- Problema: Nome do estado em vez da sigla
| 410        | Fernanda Andrade | NULL  | NULL                  | -- Problema: Campo não preenchido
+------------+------------------+-------+-----------------------+
*/
```

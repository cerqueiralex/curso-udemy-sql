# A Função SQL: SUBSTRING()

## O que é a função `SUBSTRING()`?

A função `SUBSTRING()` (e sua variante comum `SUBSTR()`) é uma das funções de manipulação de texto mais importantes e utilizadas em SQL. Sua finalidade é **extrair e retornar uma parte de uma string** (um "pedaço" do texto).

Para usá-la, você especifica a string original, uma posição inicial para o corte e, na maioria dos casos, a quantidade de caracteres que deseja extrair a partir daquele ponto.

## Dicas e Pontos de Atenção

  * **Indexação Começa em 1**: Diferente de muitas linguagens de programação (como Python ou JavaScript) onde a contagem de posições começa em 0, em SQL a contagem de caracteres na `SUBSTRING()` **começa na posição 1**. Portanto, `SUBSTRING('Brasil', 1, 1)` retorna 'B'. Este é um ponto de atenção crucial para desenvolvedores.
  * **Variações de Sintaxe**: A nomenclatura pode variar. `SUBSTRING` é o padrão ANSI (usado por SQL Server, MySQL, PostgreSQL), enquanto `SUBSTR` é um sinônimo muito comum (usado em Oracle, SQLite e também suportado por PostgreSQL e MySQL). A funcionalidade é essencialmente a mesma.
  * **Parâmetro de Comprimento Opcional**: Em muitos sistemas, o terceiro parâmetro (o comprimento) é opcional. Se você o omitir, a função retornará todo o resto da string a partir da posição inicial. Exemplo: `SUBSTRING('Boa Noite', 5)` retornaria 'Noite'.
  * **Combinação Poderosa com `CHARINDEX()`/`POSITION()`**: O verdadeiro poder da `SUBSTRING()` aparece quando combinada com funções que localizam caracteres, como `CHARINDEX()` (SQL Server) ou `POSITION()` (PostgreSQL/Padrão SQL). Você pode usar `CHARINDEX()` para encontrar a posição de um hífen, arroba ou espaço e usar esse resultado dinamicamente como o ponto de partida ou de corte para a `SUBSTRING()`, permitindo extrair dados de strings com comprimentos variáveis.

## Cenário de Aplicação Prática no Mundo Real

O cenário mais comum para a `SUBSTRING()` é o **parsing de dados**, ou seja, a extração de informações úteis de colunas que armazenam dados compostos em um formato padronizado.

**Exemplo:** Imagine uma tabela de `produtos` onde a coluna `codigo_produto` armazena um código padronizado, como por exemplo `'CAT-PROD12345-BR'`, que contém informações embutidas:

  * `CAT`: A categoria do produto (3 primeiros caracteres).
  * `PROD12345`: O ID único do produto (a partir do 5º caractere).
  * `BR`: O país de origem (os 2 últimos caracteres).

Para relatórios gerenciais, pode ser necessário analisar as vendas por categoria ou por país. No entanto, esses dados estão "presos" dentro de uma única coluna. A função `SUBSTRING()` é a ferramenta ideal para **desmembrar essa string em colunas virtuais** durante uma consulta, permitindo agrupar (`GROUP BY`) e analisar os dados de forma eficaz sem precisar alterar a estrutura da tabela.

## Exemplos de Código

### 1\. Sintaxe Pura

Esta é a estrutura básica da função, mostrando seus três parâmetros principais.

```sql
-- Sintaxe: A string, a posição inicial, o número de caracteres a extrair
SELECT SUBSTRING(sua_coluna_de_texto, posicao_inicial, comprimento)
FROM sua_tabela;
```

### 2\. Exemplo Aplicado (Cenário Real)

Vamos aplicar a função ao nosso cenário de código de produto para extrair a categoria, o ID e o país de origem.

```sql
-- Cenário: Extrair informações de um código de produto padronizado.
-- Padrão do código: CAT-IDPRODUTO-PAIS (ex: ELE-A235B-US)

SELECT
    codigo_produto,
    -- Extrai os 3 primeiros caracteres para a Categoria
    SUBSTRING(codigo_produto, 1, 3) AS categoria,

    -- Extrai 5 caracteres para o ID, começando da 5ª posição (após o hífen)
    SUBSTRING(codigo_produto, 5, 5) AS id_produto,

    -- Extrai os 2 últimos caracteres para o País, começando da 11ª posição
    SUBSTRING(codigo_produto, 11, 2) AS pais_origem
FROM
    produtos;

/*
Resultado Esperado:
+----------------+-----------+------------+-------------+
| codigo_produto | categoria | id_produto | pais_origem |
+----------------+-----------+------------+-------------+
| ELE-A235B-US   | ELE       | A235B      | US          |
| LIV-C987D-BR   | LIV       | C987D      | BR          |
| ROUPA-P012M-PT | ROUPA     | P012M      | PT          |
+----------------+-----------+------------+-------------+
*/
```

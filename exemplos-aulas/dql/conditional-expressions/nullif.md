# A Função SQL: NULLIF()

## O que é a função `NULLIF()`?

A função `NULLIF()` é uma função de controle de fluxo que aceita dois argumentos. Ela retorna `NULL` se os dois argumentos forem **iguais**. Caso contrário, ela retorna o valor do **primeiro** argumento.

Sua lógica é muito simples:

  * `NULLIF(valor_A, valor_B)`
  * **SE** `valor_A` for igual a `valor_B`, o resultado é `NULL`.
  * **SE** `valor_A` for diferente de `valor_B`, o resultado é `valor_A`.

Pense nela como um atalho para uma expressão `CASE` específica: `CASE WHEN expressao1 = expressao2 THEN NULL ELSE expressao1 END`.

## Dicas e Pontos de Atenção

  * **Equivalente a `CASE`**: A maneira mais fácil de entender e memorizar `NULLIF(a, b)` é saber que ela é 100% equivalente à expressão: `CASE WHEN a = b THEN NULL ELSE a END`. Isso remove qualquer mistério sobre seu funcionamento.
  * **O Objetivo é Ignorar Valores**: O principal propósito de usar `NULLIF()` é "remover" um valor específico de um conjunto de dados para que ele seja ignorado por funções de agregação como `AVG()`, `SUM()`, `COUNT(coluna)`, etc. Essas funções geralmente ignoram valores `NULL`, mas não valores como `0` ou `''` (string vazia), que poderiam distorcer os resultados.
  * **Evitar Divisão por Zero**: Este é o uso mais famoso e crucial da função. Em vez de fazer uma divisão como `numerador / denominador`, você usa `numerador / NULLIF(denominador, 0)`. Se o `denominador` for `0`, a expressão se torna `numerador / NULL`, o que resulta em `NULL` em vez de um erro que travaria toda a sua consulta.
  * **Funciona com Qualquer Tipo de Dado**: A função não se limita a números. É muito útil com strings para substituir valores padrão que deveriam ser tratados como nulos. Por exemplo: `NULLIF(status_pedido, 'N/A')` ou `NULLIF(campo_texto, '')`.

## Cenário de Aplicação Prática no Mundo Real

O cenário mais comum e crítico onde `NULLIF()` é aplicado é para **prevenir erros de divisão por zero** em relatórios e cálculos de métricas.

**Exemplo do cenário:** Imagine que você gerencia um site de e-commerce e precisa criar um relatório com a **taxa de conversão de cliques por produto**. A fórmula é `(Total de Vendas / Total de Cliques)`.

O problema é que alguns produtos recém-lançados podem ter `0` cliques. Se você tentar executar a consulta com `total_vendas / total_cliques`, no momento em que o SQL encontrar um produto com zero cliques, a consulta inteira irá falhar com um erro de "divisão por zero".

`NULLIF()` resolve isso de forma elegante. Ao reescrever a fórmula como `total_vendas / NULLIF(total_cliques, 0)`, o cálculo para produtos com zero cliques se torna `total_vendas / NULL`, o que resulta em `NULL` (indicando que a taxa não é aplicável). Isso permite que a consulta continue executando e processe todos os outros produtos sem interrupção.

## Exemplos de Código

### 1\. Sintaxe Pura

Este é o formato básico da função, que recebe duas expressões para comparar.

```sql
SELECT NULLIF(expressao_1, expressao_2)
FROM sua_tabela;
```

### 2\. Exemplo Aplicado (Cenário Real)

Vamos usar o cenário de taxa de conversão para calcular a performance de produtos de forma segura, evitando o erro de divisão por zero.

```sql
-- Cenário: Calcular a taxa de conversão de vendas por clique para produtos,
-- evitando o erro de 'divisão por zero' para produtos que não tiveram cliques.

SELECT
    id_produto,
    nome_produto,
    total_vendas,
    total_cliques,
    -- Cálculo seguro da taxa de conversão (multiplicado por 100.0 para obter percentual)
    (total_vendas * 100.0) / NULLIF(total_cliques, 0) AS taxa_conversao_percentual
FROM
    metricas_produtos;

/*
Resultado Esperado:
+------------+---------------------+--------------+---------------+----------------------------+
| id_produto | nome_produto        | total_vendas | total_cliques | taxa_conversao_percentual  |
+------------+---------------------+--------------+---------------+----------------------------+
| 101        | 'Monitor Gamer'     | 50           | 1000          | 5.000000                   |
| 102        | 'Teclado Mecânico'  | 120          | 2500          | 4.800000                   |
| 103        | 'Mouse Vertical'    | 0            | 300           | 0.000000                   |
| 104        | 'Webcam 4K'         | 5            | 0             | NULL                       |
+------------+---------------------+--------------+---------------+----------------------------+
-- Note como o produto 104, com 0 cliques, resultou em NULL na taxa de conversão, em vez de quebrar a consulta.
*/
```

# A Função SQL: FLOOR()

## O que é a função `FLOOR()`?

A função `FLOOR()` em SQL é uma função matemática que retorna o maior número inteiro que é menor ou igual a um número ou expressão numérica especificada.

De forma mais simples, ela **arredonda um número para baixo**, sempre para o número inteiro mais próximo. O nome "floor" (piso, em inglês) é uma analogia a empurrar o valor para o "piso" ou o valor inteiro mais baixo.

## Dicas e Pontos de Atenção

  * **Com Números Positivos:** É bastante intuitivo. `FLOOR(15.7)` se torna `15`. `FLOOR(15.2)` também se torna `15`.
  * **Com Números Negativos:** Aqui é onde muitos se confundem. A função arredonda "para baixo" na reta numérica (em direção ao infinito negativo). Portanto, `FLOOR(-15.7)` se torna `-16`, e não `-15` (porque -16 é o inteiro imediatamente *abaixo* de -15.7).
  * **Diferença para `CEILING()` e `ROUND()`:**
      * `FLOOR()`: Arredonda para baixo.
      * `CEILING()`: É o oposto, arredonda para cima (ex: `CEILING(15.2)` se torna `16`).
      * `ROUND()`: Arredonda para o inteiro mais próximo (ex: `ROUND(15.7)` se torna `16`, mas `ROUND(15.2)` se torna `15`).
  * **Tipos de Dados:** A função aceita qualquer tipo de dado numérico exato ou aproximado como entrada (exceto o tipo `bit`). O tipo de dado retornado é o mesmo do valor de entrada, mas ajustado para um inteiro.

## Cenário de Aplicação Prática no Mundo Real

Um dos cenários mais comuns e perfeitos para o uso da função `FLOOR()` é o **cálculo de idade**.

Imagine que você tem uma tabela de `clientes` com uma coluna `data_nascimento`. Para calcular a idade exata de uma pessoa, você pode subtrair a data de nascimento da data atual e dividir o resultado por 365.25 (para levar em conta os anos bissextos). O resultado quase sempre será um número decimal (ex: `30.75` anos).

Ninguém diz que tem "30.75 anos". A idade correta é `30` até o dia do próximo aniversário. Usar a função `ROUND()` seria incorreto, pois ela arredondaria `30.75` para `31`, o que está errado.

A função `FLOOR()` é a ferramenta perfeita para isso, pois ela sempre irá "cortar" a parte decimal, retornando o número de anos completos que a pessoa viveu.

## Exemplos de Código

### 1\. Sintaxe Pura

Este é o esqueleto básico da função, mostrando como aplicá-la a uma coluna de uma tabela.

```sql
SELECT FLOOR(sua_coluna_numerica)
FROM sua_tabela;
```

### 2\. Exemplo Aplicado (Cenário Real)

Vamos usar um cenário de controle de estoque para calcular quantas caixas **completas** de um produto podem ser montadas. Se temos 125 itens no estoque e cada caixa comporta 10 itens, não podemos montar 12.5 caixas. Na prática, podemos montar apenas 12 caixas completas.

```sql
-- Cenário: Calcular quantas caixas COMPLETAS podem ser montadas com o estoque atual.
-- Tabela hipotética: 'estoque' com nome do produto, quantidade e itens por caixa.

SELECT
    produto_nome,
    quantidade_em_estoque,
    itens_por_caixa,
    FLOOR(quantidade_em_estoque / itens_por_caixa) AS caixas_completas_possiveis
FROM
    estoque;

/*
Resultado Esperado para uma linha de dados:
+--------------+-----------------------+-----------------+-------------------------------+
| produto_nome | quantidade_em_estoque | itens_por_caixa | caixas_completas_possiveis    |
+--------------+-----------------------+-----------------+-------------------------------+
| Parafuso 3mm | 125                   | 10              | 12                            |
| Arruela      | 58                    | 15              | 3                             |
+--------------+-----------------------+-----------------+-------------------------------+
*/
```

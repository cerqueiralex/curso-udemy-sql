# A Função SQL: ROUND()

## O que é a função `ROUND()`?

A função `ROUND()` em SQL é uma função numérica que **arredonda um número** para um número específico de casas decimais. Se o número de casas decimais não for especificado, ela arredonda para o inteiro mais próximo.

É uma das funções mais essenciais e frequentemente utilizadas em SQL, especialmente para formatação de dados, relatórios e em qualquer cálculo que envolva valores monetários.

A regra de arredondamento padrão geralmente segue o método matemático comum: se a casa decimal seguinte for 5 ou maior, arredonda-se para cima; caso contrário, arredonda-se para baixo.

## Dicas e Pontos de Atenção

  * **O Segundo Parâmetro é a Chave**: A flexibilidade da função `ROUND()` vem de seu segundo parâmetro opcional (o número de casas decimais).
      * `ROUND(numero)` ou `ROUND(numero, 0)`: Arredonda para o **inteiro mais próximo**. Ex: `ROUND(15.7)` vira `16`; `ROUND(15.2)` vira `15`.
      * `ROUND(numero, D)` (com D \> 0): Arredonda para **`D` casas decimais**. Ex: `ROUND(123.456, 2)` vira `123.46`.
      * `ROUND(numero, D)` (com D \< 0): Este é um truque poderoso. Arredonda **à esquerda do ponto decimal**. Ex: `ROUND(123.45, -1)` vira `120` (arredonda para a dezena mais próxima); `ROUND(123.45, -2)` vira `100` (arredonda para a centena mais próxima).
  * **Comparação com `FLOOR()` e `CEILING()`**: É crucial não confundir.
      * `ROUND()`: Arredonda para o valor **mais próximo**.
      * `FLOOR()`: **Sempre** arredonda para baixo.
      * `CEILING()`: **Sempre** arredonda para cima.
  * **Comportamento do `x.5`**: A grande maioria dos bancos de dados (como MySQL e PostgreSQL) arredonda `x.5` para cima (longe do zero). Por exemplo, `ROUND(15.5)` se torna `16`. No entanto, alguns sistemas (como o SQL Server) podem, em certas condições, usar uma regra chamada "arredondamento bancário" (arredondar para o par mais próximo). Verifique a documentação do seu SGBD se a precisão em casos de `x.5` for absolutamente crítica.

## Cenário de Aplicação Prática no Mundo Real

O cenário mais comum e indispensável para a função `ROUND()` é em qualquer aplicação que lide com **dinheiro**, como sistemas de e-commerce, bancos, ou softwares de faturamento.

**Exemplo:**
Imagine uma loja online. O preço de um produto é `R$ 29,90` e um imposto de `17.5%` é aplicado. O cálculo do valor do imposto seria `29.90 * 0.175`, o que resulta em `5.2325`.

É impossível cobrar ou registrar um valor com mais de duas casas decimais em um sistema financeiro. O valor do imposto precisa ser arredondado para o centavo mais próximo.

A função `ROUND(valor, 2)` é a ferramenta perfeita para garantir que todos os cálculos monetários sejam ajustados para duas casas decimais, mantendo a integridade, a precisão e o formato correto dos dados financeiros.

## Exemplos de Código

### 1\. Sintaxe Pura

A sintaxe pode ser usada de duas formas principais: com um ou dois argumentos.

```sql
-- Sintaxe para arredondar para o inteiro mais próximo (0 casas decimais)
SELECT ROUND(sua_coluna_numerica)
FROM sua_tabela;

-- Sintaxe para arredondar para um número específico de casas decimais
SELECT ROUND(sua_coluna_numerica, casas_decimais)
FROM sua_tabela;

-- Exemplo com valores diretos:
-- SELECT ROUND(25.8);       -- Retorna 26
-- SELECT ROUND(25.847, 2);  -- Retorna 25.85
-- SELECT ROUND(258, -1);    -- Retorna 260
```

### 2\. Exemplo Aplicado (Cenário Real)

Vamos usar o cenário de e-commerce para calcular o valor de itens em um pedido, incluindo impostos, e garantir que todos os resultados estejam formatados corretamente com duas casas decimais.

```sql
-- Cenário: Calcular o valor total de itens de um pedido, incluindo impostos,
-- arredondando os valores monetários para 2 casas decimais.

SELECT
    id_item_pedido,
    preco_unitario,
    quantidade,
    taxa_imposto,

    -- Calcula o subtotal sem imposto e arredonda
    ROUND(preco_unitario * quantidade, 2) AS subtotal,

    -- Calcula apenas o valor do imposto e arredonda
    ROUND((preco_unitario * quantidade) * taxa_imposto, 2) AS valor_imposto,

    -- Calcula o total final (subtotal + imposto) e arredonda para o valor final de cobrança
    ROUND((preco_unitario * quantidade) * (1 + taxa_imposto), 2) AS total_com_imposto
FROM
    pedidos_itens;

/*
Resultado Esperado para um item com cálculo que gera muitas casas decimais:
+----------------+----------------+------------+--------------+----------+---------------+-------------------+
| id_item_pedido | preco_unitario | quantidade | taxa_imposto | subtotal | valor_imposto | total_com_imposto |
+----------------+----------------+------------+--------------+----------+---------------+-------------------+
| 237            | 19.99          | 3          | 0.075        | 59.97    | 4.50          | 64.47             |
+----------------+----------------+------------+--------------+----------+---------------+-------------------+
-- Cálculo original do imposto: 59.97 * 0.075 = 4.49775, que foi arredondado para 4.50
-- Cálculo original total: 59.97 * 1.075 = 64.46775, que foi arredondado para 64.47
*/
```

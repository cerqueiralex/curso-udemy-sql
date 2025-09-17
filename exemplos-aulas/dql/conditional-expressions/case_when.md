# A Expressão SQL: CASE WHEN

## O que é a expressão `CASE WHEN`?

Diferente das funções anteriores, `CASE WHEN` não é uma função, mas sim uma **expressão de controle de fluxo**. É a forma como o SQL implementa a lógica **"se-então-senão"** (`if-then-else`) que é comum em outras linguagens de programação.

Sua principal função é permitir que você retorne valores diferentes com base em uma ou mais condições, criando colunas derivadas, filtros complexos ou ordens personalizadas diretamente dentro de sua consulta.

Em resumo, `CASE WHEN` avalia uma lista de condições e retorna o primeiro resultado correspondente à primeira condição que for verdadeira.

## Dicas e Pontos de Atenção

  * **A Ordem é Importante**: As condições `WHEN` são avaliadas na ordem em que são escritas. Assim que uma condição é satisfeita, a expressão retorna o valor correspondente e ignora todas as condições seguintes. Por isso, ao trabalhar com intervalos (como faixas de preço ou idade), comece sempre pela condição mais restritiva.
  * **Use Sempre o `ELSE`**: É uma excelente prática sempre incluir a cláusula `ELSE`. Se nenhuma das condições `WHEN` for satisfeita e a cláusula `ELSE` for omitida, a expressão retornará `NULL`. Isso pode gerar valores nulos inesperados em seus relatórios e cálculos.
  * **Versatilidade de Uso**: A expressão `CASE` é extremamente flexível e pode ser usada em diferentes partes de uma consulta SQL:
      * No `SELECT` para criar novas colunas com base em regras de negócio.
      * No `WHERE` para criar filtros condicionais complexos.
      * No `ORDER BY` para definir uma lógica de ordenação personalizada (ex: "sempre mostrar o status 'Pendente' primeiro").
      * No `GROUP BY` para agrupar por uma categoria que você acabou de criar com a própria expressão `CASE`.
  * **Tipos de Dados Consistentes**: Garanta que todos os valores de retorno (nos `THEN` e no `ELSE`) sejam do mesmo tipo de dado ou, pelo menos, de tipos compatíveis entre si. Misturar textos com números, por exemplo, pode causar erros.

## Cenário de Aplicação Prática no Mundo Real

O cenário de uso mais comum e poderoso para o `CASE WHEN` é a **categorização ou segmentação de dados**.

Imagine que você trabalha em uma empresa de e-commerce e precisa criar um relatório que classifica o status de um pedido de forma mais amigável para o usuário. No banco de dados, a coluna `status_pedido` pode conter códigos numéricos ou textuais pouco claros, como `1` (Aprovado), `2` (Enviado), `3` (Entregue), `9` (Cancelado).

Em vez de exibir esses códigos no relatório, você pode usar `CASE WHEN` para "traduzir" esses valores em textos claros e significativos que qualquer pessoa possa entender, criando uma nova coluna "Status" no resultado da sua consulta.

## Exemplos de Código

### 1\. Sintaxe Pura

Esta é a estrutura geral da expressão `CASE WHEN`, que deve ser finalizada com a palavra-chave `END` e, idealmente, apelidada com `AS`.

```sql
SELECT
    coluna1,
    coluna2,
    CASE
        WHEN condicao1 THEN resultado1
        WHEN condicao2 THEN resultado2
        -- Você pode ter quantas cláusulas WHEN precisar
        ELSE resultado_padrao
    END AS nome_da_sua_nova_coluna
FROM
    sua_tabela;
```

### 2\. Exemplo Aplicado (Cenário Real)

Vamos aplicar o cenário de "tradução" do status de pedidos para um relatório gerencial.

```sql
-- Cenário: Criar um relatório de pedidos com um status claro e legível para o usuário.
-- Tabela hipotética: 'pedidos' com uma coluna 'status_code'.

SELECT
    id_pedido,
    data_pedido,
    valor_pedido,
    CASE status_code
        WHEN 1 THEN 'Pagamento Aprovado'
        WHEN 2 THEN 'Em Separação'
        WHEN 3 THEN 'Enviado'
        WHEN 4 THEN 'Entregue'
        WHEN 9 THEN 'Cancelado'
        ELSE 'Status Desconhecido'
    END AS status_descritivo
FROM
    pedidos
ORDER BY
    data_pedido DESC;

/*
Resultado Esperado:
+-----------+-------------+--------------+-----------------------+
| id_pedido | data_pedido | valor_pedido | status_descritivo     |
+-----------+-------------+--------------+-----------------------+
| 1005      | 2025-09-17  | 250.00       | Enviado               |
| 1004      | 2025-09-16  | 120.50       | Entregue              |
| 1003      | 2025-09-16  | 75.25        | Entregue              |
| 1002      | 2025-09-15  | 500.00       | Cancelado             |
| 1001      | 2025-09-14  | 315.80       | Entregue              |
+-----------+-------------+--------------+-----------------------+
*/
```

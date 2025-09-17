# A Função SQL: ABS()

## O que é a função `ABS()`?

A função `ABS()` em SQL é uma função matemática que retorna o **valor absoluto** (ou módulo) de uma expressão numérica. O valor absoluto de um número é a sua magnitude, ou seja, a sua distância de zero na reta numérica, sempre como um valor não negativo (positivo ou zero).

De forma simples:

  * Se o número for positivo ou zero, `ABS()` retorna o próprio número (ex: `ABS(7)` retorna `7`).
  * Se o número for negativo, `ABS()` retorna o número sem o sinal de negativo (ex: `ABS(-7)` também retorna `7`).

## Dicas e Pontos de Atenção

  * **Universalidade**: É uma das funções mais básicas e está disponível em praticamente todos os sistemas de banco de dados SQL com a mesma sintaxe (`ABS(numero)`), tornando seu uso muito seguro e portável entre diferentes tecnologias.
  * **Cálculo de Diferença**: Sua principal utilidade é calcular a **diferença ou magnitude** entre dois números, independentemente de qual é maior. A expressão `ABS(A - B)` sempre retornará a mesma distância que `ABS(B - A)`.
  * **Uso em Cláusulas `WHERE`**: É extremamente poderosa em cláusulas `WHERE` para encontrar registros que estão dentro de uma certa "tolerância" ou "margem" de um valor-alvo, ignorando se a diferença é positiva ou negativa.
  * **Tipo de Dado**: O tipo de dado retornado pela função `ABS()` é o mesmo do tipo de dado de entrada. Se você passar um valor `DECIMAL` (ex: `ABS(-15.75)`), ela retornará um `DECIMAL` (`15.75`). Se passar um `INTEGER`, retornará um `INTEGER`.

## Cenário de Aplicação Prática no Mundo Real

Um cenário de uso diário para a função `ABS()` é na **reconciliação financeira e de estoque**, especificamente para encontrar discrepâncias entre valores esperados e valores reais.

**Exemplo do cenário:**
Imagine uma tabela de `estoque_produtos` que contém as colunas `quantidade_sistema` e `quantidade_fisica` (contada manualmente). A diferença (`quantidade_sistema - quantidade_fisica`) pode ser:

  * Positiva (há menos itens na prateleira do que o sistema indica).
  * Negativa (há mais itens na prateleira do que o sistema indica).

Um gerente de estoque pode não se importar com a direção da diferença, mas sim com a **magnitude** dela. Ele pode querer um relatório de todos os produtos cuja contagem física diverge da do sistema em mais de 5 unidades, para qualquer lado.

A função `ABS()` resolve isso perfeitamente. Ao usar `WHERE ABS(quantidade_sistema - quantidade_fisica) > 5`, a consulta captura todos os produtos com uma divergência significativa, seja ela positiva ou negativa, permitindo focar nos problemas mais importantes.

## Exemplos de Código

### 1\. Sintaxe Pura

Este é o formato básico da função, que recebe um único argumento numérico.

```sql
SELECT ABS(sua_coluna_numerica_ou_expressao)
FROM sua_tabela;

-- Exemplo com valores diretos:
-- SELECT ABS(-250.75); -- Retorna 250.75
```

### 2\. Exemplo Aplicado (Cenário Real)

Vamos usar o cenário de reconciliação financeira para encontrar todas as faturas com uma discrepância (para mais ou para menos) superior a R$ 1,00 entre o valor cobrado e o valor pago.

```sql
-- Cenário: Encontrar todas as faturas com uma discrepância significativa
-- entre o valor cobrado e o valor pago.

SELECT
    id_fatura,
    cliente_nome,
    valor_cobrado,
    valor_pago,
    (valor_cobrado - valor_pago) AS diferenca
FROM
    faturas
WHERE
    -- Usamos ABS() para encontrar qualquer diferença maior que 1.00,
    -- seja ela positiva (pagamento a menos) ou negativa (pagamento a mais).
    ABS(valor_cobrado - valor_pago) > 1.00;

/*
Resultado Esperado (considerando uma tabela com os seguintes dados):
- Fatura 101: cobrado 100.00, pago 100.00 (diferença 0)    -> NÃO SELECIONADA
- Fatura 102: cobrado 150.00, pago 148.50 (diferença 1.50)  -> SELECIONADA
- Fatura 103: cobrado 200.00, pago 201.25 (diferença -1.25) -> SELECIONADA
- Fatura 104: cobrado 50.00,  pago 50.50  (diferença -0.50) -> NÃO SELECIONADA

+-----------+--------------+---------------+------------+-----------+
| id_fatura | cliente_nome | valor_cobrado | valor_pago | diferenca |
+-----------+--------------+---------------+------------+-----------+
| 102       | Beto Costa   | 150.00        | 148.50     | 1.50      |
| 103       | Carla Dias   | 200.00        | 201.25     | -1.25     |
+-----------+--------------+---------------+------------+-----------+
*/
```

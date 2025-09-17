# A Função SQL: CEIL() / CEILING()

## O que é a função `CEIL()` / `CEILING()`?

A função `CEILING()` (ou `CEIL()` em alguns bancos de dados) é uma função matemática em SQL que retorna o menor número inteiro que é maior ou equal a um número ou expressão numérica especificada.

De forma mais simples, ela **arredonda um número para cima**, sempre para o próximo número inteiro, não importa qual seja a casa decimal. O nome "ceiling" (teto, em inglês) é uma analogia a empurrar o valor para o "teto" ou o valor inteiro mais alto.

## Dicas e Pontos de Atenção

  * **`CEIL` vs. `CEILING`**: O nome padrão da função no SQL ANSI é `CEILING`. Bancos de dados como Oracle e MySQL também aceitam `CEIL` como um sinônimo. Para garantir maior compatibilidade entre diferentes sistemas (como SQL Server, PostgreSQL, etc.), é recomendado usar `CEILING`.
  * **O Oposto de `FLOOR()`**: É a função exatamente oposta de `FLOOR()`. Enquanto `FLOOR(15.2)` resulta em `15` (arredonda para baixo), `CEILING(15.2)` resulta em `16` (arredonda para cima).
  * **Números Negativos**: A lógica de "arredondar para cima" continua na reta numérica (em direção a zero/infinito positivo). Portanto, `CEILING(-15.7)` se torna `-15`, pois `-15` é o inteiro imediatamente *acima* de `-15.7`.
  * **Nenhum Efeito em Inteiros**: Se o número fornecido já for um inteiro, a função não tem efeito. `CEILING(20)` simplesmente retorna `20`.

## Cenário de Aplicação Prática no Mundo Real

Um cenário de uso extremamente comum para `CEILING()` é no **cálculo do número total de páginas** necessárias para exibir resultados em um sistema (paginação).

**Exemplo do cenário:**
Imagine que você tem um site de e-commerce com **250** produtos e quer exibir **12** produtos por página.

Se você simplesmente dividir `250 / 12`, obterá `20.833...`. Não existem "20.8 páginas". Você precisa de 20 páginas completas para exibir os primeiros 240 produtos (`20 * 12`), e uma página adicional, a 21ª, para exibir os 10 produtos restantes.

A função `CEILING()` resolve isso perfeitamente. `CEILING(250 / 12.0)` resulta em `21`, que é o número exato de páginas que você precisa para garantir que todos os produtos sejam exibidos. Outro exemplo seria calcular quantos veículos são necessários para transportar uma carga ou um número de pessoas.

## Exemplos de Código

### 1\. Sintaxe Pura

Como a sintaxe pode variar, aqui estão as duas formas. A primeira (`CEILING`) é a mais recomendada.

```sql
-- Sintaxe padrão (mais compatível entre bancos de dados)
SELECT CEILING(sua_coluna_numerica)
FROM sua_tabela;

-- Sintaxe alternativa (comum em Oracle e MySQL)
SELECT CEIL(sua_coluna_numerica)
FROM sua_tabela;
```

### 2\. Exemplo Aplicado (Cenário Real)

Vamos usar o cenário de paginação de um site de e-commerce para calcular o número total de páginas necessárias.

```sql
-- Cenário: Calcular o número total de páginas necessárias para exibir todos os produtos de um e-commerce,
-- sabendo que cada página exibe 12 produtos.

-- Em uma aplicação real, o '250' viria de uma subconsulta, como (SELECT COUNT(*) FROM produtos).
-- Usamos '12.0' para garantir que a divisão seja de ponto flutuante, não inteira.

SELECT
    250 AS total_de_produtos,
    12 AS produtos_por_pagina,
    CEILING(250 / 12.0) AS total_de_paginas_necessarias;

/*
Explicação do cálculo: 250 dividido por 12 é 20.833...
Como não podemos ter uma fração de página e nenhum produto pode ficar de fora,
precisamos arredondar o resultado para cima, para o próximo inteiro.
CEILING(20.833...) resulta em 21.

Resultado Esperado:
+-------------------+---------------------+-------------------------------+
| total_de_produtos | produtos_por_pagina | total_de_paginas_necessarias  |
+-------------------+---------------------+-------------------------------+
| 250               | 12                  | 21                            |
+-------------------+---------------------+-------------------------------+
*/
```

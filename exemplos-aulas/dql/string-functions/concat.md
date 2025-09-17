# A Função SQL: CONCAT()

## O que é a função `CONCAT()`?

A função `CONCAT()` em SQL é uma função de texto (string) que serve para unir (concatenar) duas ou mais strings em uma única string resultante. É uma das funções mais utilizadas para formatação de dados para exibição.

Por exemplo, se você tem as strings 'Olá' e 'Mundo', `CONCAT('Olá', ' ', 'Mundo')` retornará a string única 'Olá Mundo'.

## Dicas e Pontos de Atenção

  * **Alternativas: Operadores `+` e `||`**: A sintaxe para concatenar strings não é universal. Fique atento ao sistema de banco de dados que você está usando:
      * **SQL Server**: Usa o operador `+` (ex: `'string1' + ' ' + 'string2'`).
      * **Oracle, PostgreSQL**: Usam o operador `||` (ex: `'string1' || ' ' || 'string2'`).
      * **MySQL, MariaDB**: `CONCAT()` é a forma padrão, embora também suportem `||` em modos específicos.
  * **Cuidado com Valores `NULL`**: Este é um ponto de atenção crucial. O comportamento da função `CONCAT()` com valores `NULL` pode ser uma armadilha. Em **MySQL**, por exemplo, se qualquer um dos argumentos for `NULL`, o resultado inteiro da função será `NULL`.
      * **Solução**: Para evitar isso, use funções como `COALESCE()` ou `IFNULL()` para substituir o `NULL` por uma string vazia. Ex: `CONCAT(primeiro_nome, ' ', COALESCE(nome_do_meio, ''))`.
  * **Conversão Implícita de Tipos**: A função `CONCAT()` geralmente converte valores não-textuais (como números, datas) em texto automaticamente antes de uni-los. Embora isso seja conveniente, para formatações complexas (como um padrão de data específico), é mais seguro usar uma função de conversão explícita, como `CAST()` ou `FORMAT()`.
  * **Conheça a `CONCAT_WS()`**: Muitos sistemas (como MySQL e PostgreSQL) oferecem a função `CONCAT_WS()` (Concatenate With Separator). A sintaxe é `CONCAT_WS(separador, string1, string2, ...)`. Ela é extremamente útil porque:
    1.  Adiciona o separador automaticamente entre os itens.
    2.  **Ignora valores `NULL`**, tornando-a a opção mais segura e limpa para unir campos que podem ser nulos (como um nome do meio).

## Cenário de Aplicação Prática no Mundo Real

O cenário mais comum e universal para `CONCAT()` é a **criação de um nome completo** a partir de colunas separadas em uma tabela de `usuarios` ou `clientes`.

Normalmente, em um banco de dados, os nomes são armazenados de forma granular (`primeiro_nome`, `nome_do_meio`, `sobrenome`) para facilitar buscas, ordenação e indexação. No entanto, para exibição em relatórios, e-mails personalizados ("Olá, João Silva") ou interfaces de usuário, você precisa apresentar o nome completo de forma legível.

A função `CONCAT()` (ou suas variantes) permite que você combine essas colunas, adicionando os espaços necessários entre elas, para criar um campo de exibição amigável diretamente na sua consulta SQL, sem a necessidade de processamento adicional na aplicação.

## Exemplos de Código

### 1\. Sintaxe Pura

Este é o formato básico da função, que pode receber múltiplos argumentos de texto.

```sql
-- Concatena o conteúdo de duas colunas, separados por um espaço literal
SELECT CONCAT(coluna_texto1, ' ', coluna_texto2) AS texto_combinado
FROM sua_tabela;
```

### 2\. Exemplo Aplicado (Cenário Real)

Vamos usar o cenário de criar um nome completo, mas utilizando `CONCAT_WS()` por ser a solução mais robusta e elegante para lidar com nomes do meio que podem ser `NULL`.

```sql
-- Cenário: Criar o nome completo de clientes, tratando de forma segura os nomes do meio que podem ser nulos.

SELECT
    id_cliente,
    primeiro_nome,
    nome_do_meio,
    ultimo_nome,
    -- CONCAT_WS usa o primeiro argumento (' ') como separador
    -- e ignora automaticamente os valores NULL, como o nome_do_meio do cliente 2.
    CONCAT_WS(' ', primeiro_nome, nome_do_meio, ultimo_nome) AS nome_completo
FROM
    clientes;

/*
Resultado Esperado:
+------------+---------------+--------------+-------------+--------------------------+
| id_cliente | primeiro_nome | nome_do_meio | ultimo_nome | nome_completo            |
+------------+---------------+--------------+-------------+--------------------------+
| 1          | Maria         | Aparecida    | Silva       | Maria Aparecida Silva    |
| 2          | João          | NULL         | Souza       | João Souza               |
| 3          | Pedro         | de Almeida   | Costa       | Pedro de Almeida Costa   |
+------------+---------------+--------------+-------------+--------------------------+
*/
```

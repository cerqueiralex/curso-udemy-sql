# A Função SQL: UPPER()

## O que é a função `UPPER()`?

A função `UPPER()` em SQL é uma função de manipulação de strings que converte todos os caracteres alfabéticos de uma string para sua forma **maiúscula**.

É uma função fundamental para padronização e comparação de textos. Números, símbolos (`@`, `!`, `#`) e outros caracteres que não possuem uma distinção entre maiúsculas e minúsculas permanecem inalterados.

Por exemplo, `UPPER('Alexandre Cerqueira')` resulta na string `'ALEXANDRE CERQUEIRA'`.

## Dicas e Pontos de Atenção

  * **Função Oposta `LOWER()`**: O oposto direto de `UPPER()` é a função `LOWER()`, que converte uma string para minúsculas. Ambas são frequentemente usadas para os mesmos fins, e a escolha entre uma e outra é geralmente uma questão de preferência ou padrão de equipe.
  * **Sinônimo `UCASE()`**: Em alguns sistemas de banco de dados, como o MySQL, a função `UCASE()` é um sinônimo para `UPPER()` e pode ser usada da mesma forma.
  * **Impacto no Desempenho (Índices)**: Este é o ponto mais crítico. Usar `UPPER()` em uma coluna dentro da cláusula `WHERE` (ex: `WHERE UPPER(email) = '...'`) geralmente impede que o banco de dados utilize um índice padrão criado para essa coluna. Isso pode forçar uma varredura completa da tabela (*full table scan*), tornando a consulta muito lenta em tabelas grandes. Para contornar isso, a melhor solução é usar **índices baseados em função** (*Function-Based Indexes*), se o seu sistema de banco de dados suportar.
  * **Collation (Agrupamento)**: O comportamento da função com caracteres especiais e acentuados (como `ç`, `ã`, `é`) depende da configuração de *collation* do seu banco de dados. Em geral, a maioria das configurações padrão lida com isso corretamente (ex: `UPPER('josé')` se tornará `'JOSÉ'`), mas é um ponto de atenção em ambientes multilíngues.

## Cenário de Aplicação Prática no Mundo Real

O cenário mais comum e essencial para a `UPPER()` é a realização de **buscas que não diferenciam maiúsculas de minúsculas (*case-insensitive search*)**.

Imagine uma tabela de `produtos` em um site de e-commerce. Um usuário pode buscar por 'notebook dell', 'Notebook Dell' ou 'NOTEBOOK DELL'. Se a sua consulta for rígida (ex: `WHERE nome_produto = 'notebook dell'`), ela só encontrará a primeira variação e falhará nas outras. Isso leva a uma péssima experiência do usuário, que pode achar que o produto não existe.

A solução é padronizar ambos os lados da comparação para a mesma caixa (alta ou baixa). Ao converter tanto o valor da coluna quanto o termo de busca para maiúsculas, a comparação se torna eficaz e robusta, independentemente de como os dados foram inseridos ou de como o usuário digitou a busca.

**Exemplo da lógica:** `WHERE UPPER(nome_produto) = UPPER('notebook dell')`.

## Exemplos de Código

### 1\. Sintaxe Pura

Este é o formato básico da função, que recebe uma string ou uma coluna de texto como argumento.

```sql
SELECT UPPER(sua_coluna_de_texto)
FROM sua_tabela;

-- Exemplo com um valor literal:
-- SELECT UPPER('teste@email.com'); -- Retorna 'TESTE@EMAIL.COM'
```

### 2\. Exemplo Aplicado (Cenário Real)

Vamos usar o cenário de busca de usuário por e-mail, onde não queremos que a busca diferencie maiúsculas de minúsculas.

```sql
-- Cenário: Encontrar um usuário pelo seu e-mail, sem se preocupar
-- se o e-mail foi salvo como 'user@email.com' ou 'User@Email.com'.

-- Suponha que o usuário digitou 'JOAO.SOUZA@email.com' na interface de busca.
-- Em uma aplicação real, esse valor viria de uma variável.
DECLARE @EmailBuscado VARCHAR(100) = 'JOAO.SOUZA@email.com';

SELECT
    id_usuario,
    nome_completo,
    email
FROM
    usuarios
WHERE
    -- Comparamos ambas as strings em maiúsculo para garantir a correspondência.
    UPPER(email) = UPPER(@EmailBuscado);

/*
Esta consulta encontrará o usuário com sucesso, mesmo que o e-mail
esteja salvo no banco de dados de qualquer uma das seguintes formas:
- 'joao.souza@email.com'
- 'Joao.Souza@email.com'
- 'JOAO.SOUZA@EMAIL.COM'
*/
```

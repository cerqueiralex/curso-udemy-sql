# A Função SQL: `CREATE TABLE`

#### Qual é a sua função?

O comando `CREATE TABLE` é uma instrução da **DDL (Data Definition Language)**, ou Linguagem de Definição de Dados. Sua função principal é **criar uma nova tabela** dentro de um banco de dados.

Uma tabela é a estrutura fundamental onde os dados são armazenados de forma organizada, em um formato de linhas e colunas, semelhante a uma planilha. Ao usar o `CREATE TABLE`, você define:

1.  **O nome da tabela**: O identificador único para essa estrutura.
2.  **As colunas**: Os "campos" que cada registro (linha) da tabela terá.
3.  **O tipo de dado de cada coluna**: Se a coluna armazenará texto (`VARCHAR`), números inteiros (`INT`), datas (`DATE`), valores monetários (`DECIMAL`), etc.
4.  **As restrições (Constraints)**: Regras que garantem a integridade e a qualidade dos dados, como definir uma coluna que não pode ser nula (`NOT NULL`) ou que deve ter um valor único (`UNIQUE`).

-----

#### Dicas e Boas Práticas ao usar `CREATE TABLE`

  * **Nomenclatura Consistente**: Adote um padrão para nomear suas tabelas e colunas. Uma prática comum é usar nomes de tabelas no plural (ex: `clientes`, `produtos`) e nomes de colunas no singular (ex: `nome_cliente`, `preco_produto`), tudo em minúsculas e separado por underline (`snake_case`).
  * **Escolha o Tipo de Dado Certo**: Seja específico ao escolher o tipo de dado. Se uma coluna vai armazenar a sigla de um estado (ex: 'SP'), use `VARCHAR(2)` em vez de `VARCHAR(255)`. Isso economiza espaço e melhora o desempenho.
  * **Toda Tabela Precisa de uma Chave Primária**: Praticamente toda tabela deve ter uma `PRIMARY KEY`. Ela é um identificador único para cada linha, garantindo que não haja registros duplicados e permitindo criar relacionamentos com outras tabelas. Geralmente, é uma coluna numérica de autoincremento.
  * **Use `NOT NULL` Generosamente**: Se um campo é obrigatório (como o e-mail de um usuário), declare-o como `NOT NULL`. Isso força a inserção de um valor e evita dados inconsistentes no futuro.
  * **Defina Valores Padrão (`DEFAULT`)**: Para colunas que devem ter um valor inicial caso nenhum seja fornecido, use a restrição `DEFAULT`. Por exemplo, uma coluna `status_pedido` pode ter o valor padrão 'Pendente'.

-----

#### Cenário de Aplicação no Mundo Real

Imagine que você está desenvolvendo o sistema de um **e-commerce**. Uma das primeiras necessidades é armazenar as informações dos produtos que serão vendidos. Para isso, você precisa criar uma estrutura para guardar o nome, a descrição, o preço e a quantidade em estoque de cada item.

Nesse cenário, o `CREATE TABLE` é a ferramenta perfeita. Você o utilizaria para criar uma tabela chamada `produtos`, definindo colunas como:

  * `id`: Um número único para identificar cada produto (a Chave Primária).
  * `nome`: O nome do produto (texto).
  * `descricao`: Um texto mais longo detalhando o produto.
  * `preco`: O valor de venda (um número decimal).
  * `quantidade_estoque`: A quantidade disponível (um número inteiro).
  * `data_criacao`: A data em que o produto foi cadastrado.

Essa tabela se tornaria a fonte central de informações para exibir os produtos no site, controlar o estoque e processar as vendas.

-----

### Exemplos de Código

#### 1\. Sintaxe Básica

Este é o esqueleto genérico do comando, mostrando a estrutura fundamental.

```sql
CREATE TABLE nome_da_tabela (
    coluna1 tipo_de_dado RESTRICAO_DA_COLUNA,
    coluna2 tipo_de_dado,
    coluna3 tipo_de_dado,
    ...
    CONSTRAINT nome_da_restricao TIPO_DE_RESTRICAO (coluna_afetada)
);
```

#### 2\. Exemplo Prático Aplicado

Usando nosso cenário do e-commerce, o código para criar a tabela `produtos` seria assim:

```sql
/*
  Cria a tabela 'produtos' para armazenar os itens de um e-commerce.
  Esta tabela contém informações essenciais como nome, preço e estoque.
*/
CREATE TABLE produtos (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único e automático para cada produto (Chave Primária)
    nome VARCHAR(200) NOT NULL,         -- Nome do produto, campo obrigatório
    descricao TEXT,                     -- Descrição detalhada, pode ser um texto longo e não é obrigatório
    preco DECIMAL(10, 2) NOT NULL,      -- Preço com 10 dígitos no total e 2 casas decimais, obrigatório
    quantidade_estoque INT NOT NULL DEFAULT 0, -- Quantidade em estoque, obrigatório, com valor padrão 0
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Data e hora do cadastro, com valor padrão sendo o momento da criação
);
```

# ALTER TABLE

O comando `ALTER` é um comando de **DDL (Data Definition Language)**, ou seja, ele é usado para modificar a **estrutura** de objetos existentes no banco de dados. Sua função principal não é manipular os dados em si (como `SELECT` ou `INSERT`), mas sim alterar a definição, as características e a estrutura de tabelas, colunas, índices, etc.

O uso mais comum do `ALTER` é com o subcomando `ALTER TABLE`, que permite:

  * **Adicionar, remover ou modificar colunas** em uma tabela existente.
  * **Adicionar ou remover restrições (constraints)**, como `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL` e `CHECK`.
  * **Renomear tabelas ou colunas**.
  * **Alterar características da tabela**, como o seu motor de armazenamento (em alguns sistemas de banco de dados).

Em resumo, se você já criou uma tabela e precisa mudar o "esqueleto" dela sem ter que apagá-la e recriá-la, o `ALTER` é o comando que você usará.

### Dicas sobre a função `ALTER`

1.  **Cuidado com Dados Existentes:** Modificar uma tabela que já contém dados é uma operação delicada. Por exemplo, se você tentar adicionar uma coluna com a restrição `NOT NULL` em uma tabela com milhões de registros, a operação pode falhar ou demorar muito, pois o banco de dados precisará de um valor padrão para todas as linhas existentes.
2.  **Perda de Dados:** Alterar o tipo de dado de uma coluna (ex: de `VARCHAR(100)` para `VARCHAR(50)`) pode causar truncamento e perda de dados se os valores existentes forem maiores que o novo limite. **Sempre faça backup antes de operações de `ALTER` em produção.**
3.  **Travamento de Tabela (Locking):** Em tabelas grandes, uma operação `ALTER` pode "travar" a tabela, impedindo que outras consultas de leitura ou escrita ocorram até que a alteração seja concluída. Isso pode impactar a performance da sua aplicação. Planeje executar essas mudanças em janelas de baixa utilização do sistema.
4.  **Variações de Sintaxe:** A sintaxe do `ALTER` pode variar um pouco entre diferentes sistemas de banco de dados (MySQL, PostgreSQL, SQL Server, Oracle). Por exemplo, para modificar uma coluna, alguns usam `MODIFY COLUMN` (MySQL) enquanto outros usam `ALTER COLUMN` (PostgreSQL, SQL Server).
5.  **Múltiplas Alterações:** Alguns sistemas de banco de dados permitem que você execute múltiplas alterações em um único comando `ALTER TABLE`, o que pode ser mais eficiente do que executar vários comandos separados.

### Cenário prático no mundo real

Imagine que você trabalha em uma empresa de e-commerce e é responsável pelo banco de dados. A tabela de `Clientes` foi criada há um ano com os seguintes campos: `ID`, `Nome`, `Email` e `DataCadastro`.

Com o tempo, a empresa evolui e novas necessidades surgem:

1.  **Necessidade de Marketing:** A equipe de marketing decide iniciar campanhas por SMS e precisa do número de telefone dos clientes. A tabela `Clientes` não tem esse campo.

      * **Solução:** Usar `ALTER TABLE` para adicionar uma nova coluna chamada `Telefone`.

2.  **Integração com Sistema de Logística:** O novo sistema de logística requer um código de cliente único (diferente do `ID` numérico) para rastreamento. Esse código não pode se repetir.

      * **Solução:** Usar `ALTER TABLE` para adicionar a coluna `CodigoCliente` com uma restrição `UNIQUE`.

3.  **Privacidade de Dados (LGPD/GDPR):** A empresa decide que não precisa mais armazenar a data de nascimento dos clientes, que existia em uma coluna `DataNascimento`. Para se adequar às leis de privacidade, esse dado deve ser removido.

      * **Solução:** Usar `ALTER TABLE` para remover a coluna `DataNascimento`.

Nesse cenário, o `ALTER` é fundamental para adaptar o banco de dados às novas regras de negócio sem perder todos os dados de clientes já cadastrados.

-----

### 1\. Trecho de Código (Sintaxe)

```sql
-- Sintaxe genérica para as operações mais comuns com ALTER TABLE

-- Adicionar uma nova coluna
ALTER TABLE nome_da_tabela
ADD nome_da_nova_coluna tipo_de_dado [restrições];

-- Remover uma coluna existente
ALTER TABLE nome_da_tabela
DROP COLUMN nome_da_coluna;

-- Modificar o tipo de dado de uma coluna (a sintaxe pode variar)
-- Exemplo para PostgreSQL / SQL Server
ALTER TABLE nome_da_tabela
ALTER COLUMN nome_da_coluna TYPE novo_tipo_de_dado;

-- Exemplo para MySQL / Oracle
ALTER TABLE nome_da_tabela
MODIFY COLUMN nome_da_coluna novo_tipo_de_dado;

-- Adicionar uma restrição (constraint), como uma chave estrangeira
ALTER TABLE nome_da_tabela
ADD CONSTRAINT nome_da_constraint FOREIGN KEY (coluna_local) REFERENCES outra_tabela (coluna_referenciada);

-- Renomear uma tabela
ALTER TABLE nome_da_tabela_antiga
RENAME TO novo_nome_da_tabela;
```

### 2\. Trecho de Código (Exemplo Aplicado)

Vamos usar o cenário prático do e-commerce. Suponha que temos a seguinte tabela `Clientes`:

```sql
CREATE TABLE Clientes (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    DataCadastro DATE
);
```

Agora, vamos aplicar as alterações necessárias:

```sql
-- Cenário: A empresa precisa evoluir a tabela de Clientes.

-- 1. Adicionar uma coluna para armazenar o telefone do cliente.
-- A coluna pode ser nula, pois nem todos os clientes fornecerão o telefone.
ALTER TABLE Clientes
ADD COLUMN Telefone VARCHAR(20) NULL;


-- 2. Adicionar um código de cliente único para o sistema de logística.
-- O código deve ser único e não pode ser nulo.
-- NOTA: Em uma tabela com dados, isso falharia. Seria preciso primeiro adicionar a coluna permitindo nulos,
-- preencher os dados e depois adicionar a restrição NOT NULL. Mas para o exemplo, faremos direto.
ALTER TABLE Clientes
ADD COLUMN CodigoCliente VARCHAR(36) NOT NULL UNIQUE;


-- 3. O campo 'Nome' de 100 caracteres se mostrou pequeno para nomes completos. Vamos aumentá-lo.
-- Usando a sintaxe do PostgreSQL/SQL Server como exemplo.
ALTER TABLE Clientes
ALTER COLUMN Nome TYPE VARCHAR(255);

-- Se fosse em MySQL, o comando seria:
-- ALTER TABLE Clientes
-- MODIFY COLUMN Nome VARCHAR(255);
```

# **Cláusula SQL: ADD**

O comando ADD é usado dentro da instrução ALTER TABLE para adicionar uma nova coluna ou nova constraint (restrição) a uma tabela existente no banco de dados. 

Ele não recria a tabela, apenas modifica sua estrutura.

✅ Dica: Sempre que for adicionar colunas com restrições como NOT NULL, certifique-se de fornecer um valor padrão com DEFAULT, ou a operação falhará se a tabela já tiver registros existentes.

Com certeza\! É importante esclarecer um ponto inicial: `ADD` em SQL não é uma *função* como `SUM()` ou `COUNT()`, mas sim uma **cláusula** ou um **comando** utilizado principalmente dentro da instrução `ALTER TABLE`.

Sua finalidade é modificar a estrutura de uma tabela já existente, adicionando algo novo a ela.

-----

#### **Qual é a sua função?**

A função principal da cláusula `ADD` é **adicionar uma nova coluna a uma tabela existente**. Quando você cria uma tabela, define suas colunas iniciais. No entanto, com o tempo, as necessidades do sistema podem mudar, e pode ser necessário armazenar novas informações. Em vez de apagar e recriar a tabela (o que causaria a perda de todos os dados), você usa `ALTER TABLE` com a cláusula `ADD` para evoluir a estrutura da tabela dinamicamente.

Além de colunas, `ADD` também pode ser usado para adicionar novas **restrições** (constraints) a uma tabela, como `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, etc.

#### **Dicas e Boas Práticas**

1.  **Valores Nulos:** Ao adicionar uma nova coluna a uma tabela que já contém dados, todas as linhas existentes receberão o valor `NULL` para essa nova coluna, a menos que você especifique um valor padrão.
2.  **Use `DEFAULT`:** Para evitar `NULL`s em linhas existentes e garantir que novos registros tenham um valor inicial, é uma ótima prática usar a cláusula `DEFAULT`. Por exemplo, `ADD COLUMN data_cadastro DATE DEFAULT GETDATE()`.
3.  **Cuidado com Tabelas Grandes:** Executar um `ALTER TABLE ... ADD` em uma tabela com milhões ou bilhões de linhas pode ser uma operação lenta e que consome muitos recursos. Em alguns sistemas de banco de dados, isso pode "travar" a tabela, impedindo leituras e escritas enquanto a operação é concluída. Planeje essas alterações para janelas de baixa utilização.
4.  **Posicionamento da Coluna (MySQL):** Em MySQL, você pode especificar a posição da nova coluna usando `AFTER nome_de_outra_coluna`. Ex: `ADD COLUMN cidade VARCHAR(100) AFTER nome`. Em outros sistemas como SQL Server ou PostgreSQL, a nova coluna é sempre adicionada no final.

#### **Cenário Prático no Mundo Real**

Imagine que você trabalha em uma empresa de e-commerce. A empresa possui uma tabela `Pedidos` com as colunas `id`, `cliente_id`, `valor_total` e `data_pedido`.

O time de logística decide que, para otimizar as entregas, precisa de um **código de rastreamento** para cada pedido. Essa informação não existia quando a tabela foi criada.

**O problema:** Como adicionar um campo para o código de rastreamento em todos os pedidos, sem perder os dados já existentes?

**A solução:** Você, como desenvolvedor ou analista de dados, executa um comando `ALTER TABLE` para adicionar a nova coluna `codigo_rastreamento` à tabela `Pedidos`.

-----

### **Trechos de Código**

#### 1\. Sintaxe Pura

Aqui está a sintaxe genérica para adicionar uma nova coluna a uma tabela.

```sql
ALTER TABLE nome_da_tabela
ADD nome_da_nova_coluna tipo_de_dado [restrições];
```

  * `nome_da_tabela`: A tabela que você quer modificar.
  * `nome_da_nova_coluna`: O nome da coluna que você quer criar.
  * `tipo_de_dado`: O tipo de dado da nova coluna (ex: `VARCHAR(255)`, `INT`, `DATE`).
  * `[restrições]`: Opcional. Você pode adicionar restrições como `NOT NULL` ou um valor `DEFAULT`.

#### 2\. Exemplo Prático Aplicado

Usando nosso cenário do e-commerce, vamos adicionar a coluna `codigo_rastreamento` à tabela `Pedidos`.

```sql
-- Supondo que a tabela Pedidos já existe e tem dados:
-- id | cliente_id | valor_total | data_pedido
-- 1  | 101        | 199.90      | 2025-09-16
-- 2  | 102        | 89.50       | 2025-09-17

-- Comando para adicionar a nova coluna para o código de rastreamento
ALTER TABLE Pedidos
ADD codigo_rastreamento VARCHAR(50) NULL;

-- Após executar o comando, a tabela ficará assim:
-- id | cliente_id | valor_total | data_pedido | codigo_rastreamento
-- 1  | 101        | 199.90      | 2025-09-16  | NULL
-- 2  | 102        | 89.50       | 2025-09-17  | NULL

-- Agora, o sistema pode atualizar essa coluna quando o pedido for despachado.
-- UPDATE Pedidos SET codigo_rastreamento = 'BR123456789XX' WHERE id = 1;
```

Neste exemplo, adicionamos a coluna `codigo_rastreamento` do tipo `VARCHAR(50)` e permitimos que ela seja nula (`NULL`), pois um pedido recém-criado ainda não terá um código de rastreio.

Excelente pergunta\! `ADD CONSTRAINT` é um comando complementar ao `ADD` que vimos antes. Enquanto `ADD COLUMN` adiciona *dados*, `ADD CONSTRAINT` adiciona **regras e integridade** a esses dados.

É uma parte fundamental do `ALTER TABLE` que garante que seus dados sejam confiáveis, consistentes e livres de erros.

-----

# **Comando SQL: ALTER TABLE ... ADD CONSTRAINT**

#### **Qual é a sua função?**

A função principal do `ADD CONSTRAINT` é **adicionar uma regra de integridade (uma "restrição") a uma ou mais colunas de uma tabela já existente.** Essas regras são essenciais para manter a qualidade e a lógica dos dados armazenados.

Constraints são regras que o sistema de banco de dados impõe automaticamente. Se uma operação (como `INSERT` ou `UPDATE`) violar essa regra, o banco de dados rejeitará a operação e retornará um erro. Isso impede que dados inválidos ou "sujos" entrem no seu sistema.

#### **Tipos de Constraints (Regras) que Você Pode Adicionar:**

1.  **`PRIMARY KEY` (Chave Primária):**

      * **Função:** Garante que cada linha na tabela seja única e não nula. É o identificador principal do registro.
      * **Exemplo:** O `CPF` de um cliente ou o `ID` de um produto.

2.  **`FOREIGN KEY` (Chave Estrangeira):**

      * **Função:** Cria um vínculo entre duas tabelas. Garante que o valor em uma coluna de uma tabela corresponda a um valor na coluna de outra tabela (geralmente a chave primária da outra tabela). É a base dos bancos de dados relacionais.
      * **Exemplo:** O `ID_Cliente` na tabela `Pedidos` deve corresponder a um `ID_Cliente` que realmente existe na tabela `Clientes`.

3.  **`UNIQUE` (Única):**

      * **Função:** Garante que todos os valores em uma coluna (ou conjunto de colunas) sejam diferentes uns dos outros. É semelhante a uma chave primária, mas permite valores nulos (geralmente apenas um).
      * **Exemplo:** O `Email` em uma tabela de `Usuarios` deve ser único para cada usuário.

4.  **`CHECK` (Verificação):**

      * **Função:** Garante que o valor em uma coluna satisfaça uma condição específica.
      * **Exemplo:** O `Salario` de um funcionário deve ser maior que zero (`Salario > 0`) ou o campo `Status` de um pedido só pode aceitar os valores 'Pendente', 'Enviado' ou 'Entregue'.

#### **Cenário Prático no Mundo Real**

Vamos continuar com o exemplo do e-commerce. Você tem duas tabelas: `Clientes` e `Pedidos`.

  * **`Clientes`**: com as colunas `ID_Cliente` (chave primária) e `Email`.
  * **`Pedidos`**: com as colunas `ID_Pedido`, `ID_Cliente_Pedido` e `Valor_Total`.

Inicialmente, as tabelas foram criadas sem todas as regras. Agora, a empresa precisa garantir a integridade dos dados:

1.  **Problema 1:** As pessoas estão cadastrando clientes com o mesmo email. Isso está causando confusão.
2.  **Problema 2:** Um funcionário, por engano, cadastrou um pedido para um `ID_Cliente_Pedido` que não existe na tabela `Clientes`. Agora há um pedido "órfão", sem um cliente associado.

**A solução:** Você usará `ADD CONSTRAINT` para resolver ambos os problemas.

  * Para o Problema 1, você adicionará uma constraint `UNIQUE` na coluna `Email` da tabela `Clientes`.
  * Para o Problema 2, você adicionará uma constraint `FOREIGN KEY` na coluna `ID_Cliente_Pedido` da tabela `Pedidos`, fazendo-a referenciar a coluna `ID_Cliente` da tabela `Clientes`.

-----

### **Trechos de Código**

#### 1\. Sintaxe Pura

A sintaxe genérica para adicionar uma constraint é:

```sql
ALTER TABLE nome_da_tabela
ADD CONSTRAINT nome_da_constraint TIPO_DA_CONSTRAINT (coluna(s));
```

  * `nome_da_tabela`: A tabela que receberá a regra.
  * `nome_da_constraint`: Um nome que você dá para a regra. É uma boa prática nomeá-las de forma clara (ex: `FK_Pedidos_Clientes`).
  * `TIPO_DA_CONSTRAINT`: O tipo de regra (`PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK`).
  * `(coluna(s))`: A(s) coluna(s) onde a regra será aplicada.

#### 2\. Exemplo Prático Aplicado

Resolvendo os problemas do nosso cenário de e-commerce:

```sql
-- Supondo que as tabelas Clientes e Pedidos já existem

-- Problema 1: Garantir que o email de cada cliente seja único
ALTER TABLE Clientes
ADD CONSTRAINT UQ_Clientes_Email UNIQUE (Email);

-- A partir de agora, qualquer tentativa de inserir um email que já existe
-- na tabela Clientes resultará em um erro.


-- Problema 2: Garantir que todo pedido tenha um cliente válido
ALTER TABLE Pedidos
ADD CONSTRAINT FK_Pedidos_Clientes FOREIGN KEY (ID_Cliente_Pedido)
REFERENCES Clientes (ID_Cliente);

-- A partir de agora, o banco de dados só permitirá a inserção de um pedido
-- se o valor na coluna ID_Cliente_Pedido já existir na coluna ID_Cliente
-- da tabela Clientes.
```

# **Comando SQL: INSERT INTO**

#### **Qual é a sua função?**

A função do `INSERT INTO` é **adicionar uma ou mais linhas (registros) novas a uma tabela**. Toda vez que você precisa salvar uma nova informação no banco de dados — seja um novo usuário, um novo produto, um novo pedido ou qualquer outro dado — você utiliza o comando `INSERT`.

Ele faz parte do DML (Data Manipulation Language - Linguagem de Manipulação de Dados), o conjunto de comandos SQL para gerenciar os dados em si.

#### **Dicas e Boas Práticas**

1.  **Sempre Especifique as Colunas:** A melhor prática é sempre listar explicitamente as colunas nas quais você está inserindo os dados (ex: `INSERT INTO Clientes (Nome, Email)`). Isso torna seu código mais claro, legível e seguro contra futuras alterações na tabela. Se uma nova coluna for adicionada à tabela, seu código não quebrará.
2.  **Ordem e Quantidade de Valores:** A ordem dos valores na cláusula `VALUES` deve corresponder exatamente à ordem das colunas que você especificou. A quantidade de valores também deve ser a mesma.
3.  **Respeite os Tipos de Dados e Constraints:** O `INSERT` falhará se você tentar inserir um dado incompatível com o tipo da coluna (ex: um texto em uma coluna de número) ou se violar alguma `CONSTRAINT` (ex: tentar inserir um email que já existe em uma coluna `UNIQUE`).
4.  **Inserção de Múltiplas Linhas:** Para inserir vários registros de uma vez, você pode listar múltiplos conjuntos de valores separados por vírgula. Isso é muito mais eficiente do que executar um comando `INSERT` para cada linha.
5.  **Copiar Dados com `INSERT INTO ... SELECT`:** Uma técnica poderosa é usar `INSERT` em conjunto com `SELECT` para copiar dados de uma tabela para outra. Por exemplo, para mover clientes inativos de uma tabela `ClientesAtivos` para uma tabela `ClientesInativos`.

#### **Cenário Prático no Mundo Real**

Imagine o fluxo de cadastro de um novo usuário em qualquer site ou aplicativo, como uma rede social, um e-commerce ou um serviço de streaming.

**O cenário:** Uma nova usuária, chamada "Maria Souza", preenche o formulário de cadastro com seu nome, email e cria uma senha. Ao clicar no botão "Cadastrar", essas informações são enviadas do aplicativo para o servidor.

**A aplicação:** O servidor recebe os dados da Maria. Para que ela possa fazer login mais tarde e para que suas informações fiquem salvas permanentemente, o sistema precisa armazenar esses dados no banco de dados.

**A solução:** O sistema executa um comando `INSERT INTO` para adicionar uma nova linha na tabela `Usuarios`, contendo o nome "Maria Souza", seu email "maria.s@exemplo.com" e a senha (geralmente criptografada).

-----

### **Trechos de Código**

#### 1\. Sintaxe Pura

Existem duas formas principais de sintaxe.

**Forma 1: Especificando as colunas (Recomendado)**

```sql
INSERT INTO nome_da_tabela (coluna1, coluna2, coluna3)
VALUES (valor1, valor2, valor3);
```

**Forma 2: Inserindo múltiplas linhas de uma vez**

```sql
INSERT INTO nome_da_tabela (coluna1, coluna2, coluna3)
VALUES
  (valor1A, valor2A, valor3A),
  (valor1B, valor2B, valor3B),
  (valor1C, valor2C, valor3C);
```

#### 2\. Exemplo Prático Aplicado

Usando nosso cenário de cadastro da nova usuária "Maria Souza" na tabela `Usuarios`.

```sql
-- Supondo que a tabela Usuarios tenha a seguinte estrutura:
-- ID_Usuario (INT, auto-incremento, chave primária)
-- Nome (VARCHAR)
-- Email (VARCHAR, unique)
-- DataCadastro (DATE)

-- Comando para inserir a nova usuária Maria Souza na tabela
INSERT INTO Usuarios (Nome, Email, DataCadastro)
VALUES ('Maria Souza', 'maria.s@exemplo.com', '2025-09-17');

-- Após a execução, a tabela Usuarios terá uma nova linha.
-- Se executarmos um SELECT para ver os dados:
-- SELECT * FROM Usuarios WHERE Email = 'maria.s@exemplo.com';

-- O resultado seria:
-- ID_Usuario | Nome        | Email                 | DataCadastro
-- 123        | Maria Souza | maria.s@exemplo.com   | 2025-09-17
-- (O ID_Usuario seria gerado automaticamente pelo banco de dados)
```

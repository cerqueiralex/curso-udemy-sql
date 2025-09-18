# **Comando SQL: UPDATE**

#### **Qual é a sua função?**

O comando `UPDATE` é usado para **modificar registros (linhas) que já existem em uma tabela**. Diferente do `INSERT` que adiciona novas linhas e do `DELETE` que remove linhas, o `UPDATE` altera os dados dentro das linhas existentes.

Você pode usar o `UPDATE` para alterar o valor de uma única coluna em uma única linha, ou de várias colunas em múltiplas linhas de uma vez, dependendo da sua necessidade e da condição que você especificar.

#### **Dicas e Boas Práticas**

1.  **A REGRA DE OURO: SEMPRE USE `WHERE`\!** Esta é a dica mais importante. Se você executar um comando `UPDATE` sem uma cláusula `WHERE`, **TODAS as linhas da tabela serão atualizadas**. Isso pode ser catastrófico e causar perda de dados irrecuperável.

      * `UPDATE Clientes SET status = 'Inativo';` \<-- **PERIGOSO\!** Torna todos os clientes inativos.
      * `UPDATE Clientes SET status = 'Inativo' WHERE ultimo_login < '2023-01-01';` \<-- **SEGURO\!** Atualiza apenas o grupo desejado.

2.  **Verifique com `SELECT` Primeiro:** Antes de executar um `UPDATE`, é uma excelente prática rodar um `SELECT` com a mesma cláusula `WHERE`. Isso mostrará exatamente quais linhas serão afetadas, permitindo que você confirme se a sua condição está correta.

      * Primeiro, rode: `SELECT * FROM Clientes WHERE ID_Cliente = 105;`
      * Se o resultado for o esperado, rode: `UPDATE Clientes SET Endereco = 'Nova Rua, 123' WHERE ID_Cliente = 105;`

3.  **Use Transações para Segurança:** Para atualizações críticas, especialmente em ambientes de produção, envolva seu comando `UPDATE` em uma transação (`BEGIN TRANSACTION`... `COMMIT`/`ROLLBACK`). Se algo der errado ou o resultado não for o esperado, você pode usar `ROLLBACK` para desfazer a alteração completamente.

4.  **Atualizando Múltiplas Colunas:** Você pode atualizar vários campos de uma vez, separando as atribuições por vírgula na cláusula `SET`. Isso é mais eficiente do que rodar vários `UPDATE`s para a mesma linha.

      * `UPDATE Clientes SET Endereco = 'Rua Nova, 50', Cidade = 'São Paulo' WHERE ID_Cliente = 200;`

#### **Cenário Prático no Mundo Real**

Imagine que você trabalha no sistema de uma empresa e um funcionário, "Carlos Souza", foi promovido. O cargo dele precisa ser atualizado de "Analista" para "Gerente" e seu salário precisa ser ajustado.

**O problema:** Como alterar os dados de Carlos na tabela `Funcionarios` sem afetar os dados de outros funcionários?

**A solução:** Você usará o comando `UPDATE` com uma cláusula `WHERE` que identifique unicamente o Carlos (pelo seu `ID_Funcionario`, por exemplo) para alterar os campos `Cargo` e `Salario` apenas no registro dele.

-----

### **Trechos de Código**

#### 1\. Sintaxe Pura

A sintaxe genérica para o comando `UPDATE`.

```sql
UPDATE nome_da_tabela
SET coluna1 = novo_valor1,
    coluna2 = novo_valor2
WHERE condicao;
```

  * `nome_da_tabela`: A tabela que contém os dados a serem modificados.
  * `SET`: A cláusula que especifica qual(is) coluna(s) serão alteradas e seus novos valores.
  * `WHERE`: A cláusula **essencial** que filtra quais linhas devem ser atualizadas. Se omitida, todas as linhas são afetadas.

#### 2\. Exemplo Prático Aplicado

Usando nosso cenário da promoção do funcionário Carlos Souza.

```sql
-- Supondo que a tabela Funcionarios exista com os seguintes dados:
-- ID_Funcionario | Nome_Completo  | Cargo     | Salario
-- 10             | Ana Silva      | Vendedora | 3500.00
-- 15             | Carlos Souza   | Analista  | 5000.00
-- 22             | Maria Oliveira | Analista  | 5200.00

-- Comando para atualizar o cargo e o salário do Carlos (ID 15)
UPDATE Funcionarios
SET
    Cargo = 'Gerente',
    Salario = 7500.00
WHERE
    ID_Funcionario = 15;

-- Após a execução do comando, a tabela ficará assim:
-- ID_Funcionario | Nome_Completo  | Cargo     | Salario
-- 10             | Ana Silva      | Vendedora | 3500.00
-- 15             | Carlos Souza   | Gerente   | 7500.00
-- 22             | Maria Oliveira | Analista  | 5200.00

-- Apenas a linha do Carlos foi modificada, garantindo a integridade dos outros registros.
```

# **Comando SQL: DELETE**

#### **Qual é a sua função?**

A função do comando `DELETE` é **remover uma ou mais linhas (registros) de uma tabela**. Ele é utilizado para apagar dados que não são mais necessários, como um usuário que excluiu sua conta, um produto que foi descontinuado ou um log de sistema antigo.

A parte mais crucial do comando `DELETE` é a cláusula `WHERE`, que especifica *quais* linhas devem ser removidas. Se você esquecer a cláusula `WHERE`, o comando removerá **TODAS as linhas da tabela**, o que pode ser desastroso.

#### **Dicas e Boas Práticas**

1.  **A REGRA DE OURO: SEMPRE USE `WHERE`\!** A menos que sua intenção seja realmente limpar a tabela inteira, nunca execute um `DELETE` sem uma cláusula `WHERE`. A ausência dela significa "apague tudo".
2.  **Teste com `SELECT` primeiro:** Antes de executar um `DELETE`, uma prática de segurança altamente recomendada é rodar um `SELECT *` com a mesma cláusula `WHERE`. Isso mostrará exatamente quais linhas serão afetadas. Se o resultado do `SELECT` for o que você espera apagar, então você pode prosseguir com o `DELETE`.
      * *Exemplo:* Antes de `DELETE FROM Usuarios WHERE status = 'inativo';`, rode `SELECT * FROM Usuarios WHERE status = 'inativo';` para ter certeza.
3.  **Use Transações (`TRANSACTION`):** Para deleções críticas, envolva seu comando `DELETE` em uma transação (`BEGIN TRANSACTION` ou `START TRANSACTION`). Isso permite que você desfaça a operação com um `ROLLBACK` caso perceba que cometeu um erro, antes de confirmar as mudanças com `COMMIT`.
4.  **Cuidado com `DELETE` vs. `TRUNCATE`:**
      * `DELETE` é uma operação DML (Data Manipulation Language) que remove linha por linha e registra cada remoção. Por isso, pode ser mais lenta em tabelas grandes. Pode ser desfeita com `ROLLBACK` (dentro de uma transação).
      * `TRUNCATE` é uma operação DDL (Data Definition Language) que remove todas as linhas de uma vez, de forma muito mais rápida, desalocando as páginas de dados. Geralmente não pode ser desfeita e não aciona gatilhos (`triggers`) de `DELETE`. Use `TRUNCATE` quando tiver certeza de que quer esvaziar a tabela completamente.
5.  **Chaves Estrangeiras (`Foreign Keys`):** Esteja ciente de que, se a linha que você está tentando apagar for referenciada por outra tabela através de uma chave estrangeira, o banco de dados poderá impedir a exclusão para manter a integridade referencial, a menos que a regra `ON DELETE CASCADE` esteja definida (o que apagaria os registros relacionados em cascata).

#### **Cenário Prático no Mundo Real**

Imagine que você administra um blog. O blog tem um sistema de comentários e, infelizmente, começou a receber muitos comentários de spam. A tabela de comentários se chama `Comentarios` e tem as colunas `id`, `autor`, `texto_comentario` e `status`.

**O problema:** A seção de comentários está poluída com dezenas de mensagens de spam, que foram automaticamente marcadas com o `status = 'spam'`. É preciso limpar o banco de dados removendo todos esses comentários indesejados.

**A solução:** Você usará o comando `DELETE` com uma cláusula `WHERE` para mirar e apagar apenas os comentários marcados como spam, sem tocar nos comentários legítimos.

-----

### **Trechos de Código**

#### 1\. Sintaxe Pura

A sintaxe genérica para apagar linhas que correspondem a uma condição.

```sql
DELETE FROM nome_da_tabela
WHERE condição;
```

  * `nome_da_tabela`: A tabela da qual você quer remover os dados.
  * `condição`: A expressão que define quais linhas serão apagadas (ex: `id = 10`, `preco < 50.00`, `data_cadastro < '2020-01-01'`).

**AVISO:** A sintaxe abaixo apaga **TODAS AS LINHAS** da tabela. Use com extremo cuidado.

```sql
-- CUIDADO: ESTE COMANDO APAGA TUDO!
DELETE FROM nome_da_tabela;
```

#### 2\. Exemplo Prático Aplicado

Usando nosso cenário do blog para remover os comentários de spam.

```sql
-- Tabela 'Comentarios' antes da operação:
-- id | autor       | texto_comentario             | status
-- 1  | 'Maria'     | 'Adorei o artigo!'           | 'aprovado'
-- 2  | 'spam_bot'  | 'Compre Cripto AGORA!!!'     | 'spam'
-- 3  | 'João'      | 'Muito informativo, obrigado.' | 'aprovado'
-- 4  | 'outro_bot' | 'Clique aqui para ganhar!'   | 'spam'

-- PASSO 1: (Recomendado) Verificar o que será apagado com um SELECT
SELECT * FROM Comentarios WHERE status = 'spam';
-- O resultado mostraria as linhas com id 2 e 4.

-- PASSO 2: Executar o comando DELETE com a mesma condição
DELETE FROM Comentarios
WHERE status = 'spam';

-- Após a execução, a tabela 'Comentarios' ficará assim:
-- id | autor   | texto_comentario             | status
-- 1  | 'Maria' | 'Adorei o artigo!'           | 'aprovado'
-- 3  | 'João'  | 'Muito informativo, obrigado.' | 'aprovado'
```

Como pode ver, apenas os registros que satisfizeram a condição `status = 'spam'` foram removidos, deixando os dados legítimos intactos.

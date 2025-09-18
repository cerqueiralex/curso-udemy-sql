# **SQL: CTE (Common Table Expression)**

CTEs são conjuntos de resultados temporários nomeados que existem apenas durante a execução de uma única instrução SQL. 

Eles são definidos usando a cláusula WITH.

Vantagens das CTEs:
* Legibilidade: Quebram consultas complexas em partes menores e mais compreensíveis
* Reutilização: Uma CTE pode ser referenciada múltiplas vezes na mesma consulta
* Organização: Permitem estruturar a lógica da consulta de forma mais clara
* Recursividade: CTEs recursivas permitem trabalhar com dados hierárquicos
* Manutenibilidade: Mais fácil de modificar e debugar do que subconsultas aninhadas

#### **Qual é a sua função?**

A função principal de uma CTE é **simplificar consultas complexas**. Ela permite que você quebre uma lógica de negócio complicada em blocos de construção lógicos e sequenciais. Em vez de aninhar várias subconsultas (subqueries), o que torna o código difícil de ler e depurar, você pode definir cada passo lógico como uma CTE nomeada.

**As principais vantagens são:**

1.  **Legibilidade:** Transforma uma consulta "monstro" em uma série de passos lógicos e nomeados, quase como se fosse uma receita.
2.  **Reutilização dentro da mesma query:** Uma vez que você define uma CTE, pode referenciá-la várias vezes na consulta principal que a segue. Com uma subquery, você teria que reescrevê-la toda vez que precisasse dela.
3.  **Recursividade:** Este é o superpoder das CTEs. Elas podem referenciar a si mesmas, permitindo que você resolva problemas complexos de hierarquia ou grafos, como organogramas de empresas, listas de materiais de um produto, etc.
4.  **Manutenção Simplificada:** É muito mais fácil depurar ou modificar uma query estruturada com CTEs. Você pode testar cada CTE individualmente para ver se o resultado intermediário está correto.

#### **Dicas e Boas Práticas**

1.  **Sempre comece com `WITH`:** Uma CTE sempre é introduzida pela palavra-chave `WITH`.
2.  **Nomeie bem suas CTEs:** Dê nomes descritivos que expliquem o que aquele bloco de dados representa. Em vez de `cte1`, use `TotalVendasPorCliente` ou `FuncionariosAtivos2025`.
3.  **Encadeamento Lógico:** Você pode definir múltiplas CTEs em sequência (separadas por vírgula). Uma CTE posterior pode fazer referência a uma CTE definida anteriormente, criando um fluxo de transformação de dados.
4.  **Não é um ganho de performance (geralmente):** Uma CTE é principalmente "açúcar sintático". Na maioria dos casos, o otimizador do banco de dados a transforma internamente em algo similar a uma subquery. O principal ganho é para o desenvolvedor, em termos de clareza, não para o banco de dados em termos de velocidade.
5.  **Cuidado com a Recursão:** Ao usar CTEs recursivas, sempre inclua uma condição de parada (um `WHERE` na parte recursiva) para evitar loops infinitos, que podem consumir todos os recursos do servidor.

#### **Cenário Prático no Mundo Real**

Imagine que você trabalha em um RH e precisa gerar um relatório que mostre o nome de cada funcionário e o nome do seu gestor direto. A tabela de funcionários (`Funcionarios`) é uma só e tem as colunas `ID_Funcionario`, `Nome` e `ID_Gestor`. A coluna `ID_Gestor` aponta para o `ID_Funcionario` de outro registro na mesma tabela.

**O problema:** Para obter o nome do gestor, você precisaria fazer um `JOIN` da tabela `Funcionarios` com ela mesma (`SELF JOIN`). Isso já pode começar a confundir. Agora, imagine se pedissem o organograma completo, mostrando quem se reporta a quem em todos os níveis? Seria um pesadelo de `JOIN`s aninhados.

**A solução com CTE:** Você pode criar uma CTE que "aplana" essa relação. Primeiro, você cria um conjunto de dados temporário que já combina o funcionário com o nome do seu gestor, e depois faz uma simples consulta nessa CTE. Para o organograma completo, uma CTE recursiva seria a solução perfeita.

-----

### **Trechos de Código**

#### 1\. Sintaxe Pura

A sintaxe genérica para uma ou mais CTEs.

```sql
-- Sintaxe para uma única CTE
WITH NomeDaCTE (coluna1, coluna2) AS (
    -- SELECT que define a sua tabela temporária
    SELECT f.Nome, f.Salario
    FROM Funcionarios f
    WHERE f.Departamento = 'Vendas'
)
-- Query principal que utiliza a CTE
SELECT
    coluna1 AS NomeDoFuncionario,
    coluna2 AS Salario
FROM NomeDaCTE
WHERE coluna2 > 5000;


-- Sintaxe para CTEs encadeadas
WITH
Vendas2024 AS (
    SELECT ID_Produto, SUM(Quantidade) AS TotalVendido
    FROM Pedidos
    WHERE YEAR(DataPedido) = 2024
    GROUP BY ID_Produto
),
ProdutosPopulares AS (
    -- Esta CTE usa a CTE anterior (Vendas2024)
    SELECT ID_Produto
    FROM Vendas2024
    WHERE TotalVendido > 1000
)
SELECT
    p.NomeProduto,
    p.Preco
FROM Produtos p
INNER JOIN ProdutosPopulares pp ON p.ID_Produto = pp.ID_Produto;
```

#### 2\. Exemplo Prático Aplicado

Vamos resolver o cenário do RH: encontrar o nome de cada funcionário e de seu respectivo gestor.

```sql
-- Supondo que temos uma tabela 'Funcionarios' assim:
-- ID_Funcionario | Nome         | ID_Gestor
-- 1              | Carlos Silva | NULL
-- 2              | Ana Souza    | 1
-- 3              | Bia Martins  | 1
-- 4              | Pedro Lima   | 2

-- Usamos uma CTE para organizar a consulta
WITH HierarquiaFuncionarios (ID_Func, Nome_Func, Nome_Gestor) AS (
    -- O SELECT abaixo junta a tabela com ela mesma (self join)
    -- para encontrar o nome do gestor de cada funcionário.
    SELECT
        func.ID_Funcionario,
        func.Nome,
        gest.Nome
    FROM
        Funcionarios AS func
    LEFT JOIN
        -- O LEFT JOIN garante que até o "chefe principal" (com ID_Gestor NULL) apareça
        Funcionarios AS gest ON func.ID_Gestor = gest.ID_Funcionario
)
-- Agora a query principal fica muito simples e legível.
-- Nós simplesmente selecionamos da nossa "tabela virtual" já pronta.
SELECT
    Nome_Func AS 'Funcionário',
    ISNULL(Nome_Gestor, 'Sem Gestor (CEO)') AS 'Gestor Direto'
FROM
    HierarquiaFuncionarios;

-- Resultado esperado:
-- Funcionário   | Gestor Direto
-- Carlos Silva  | Sem Gestor (CEO)
-- Ana Souza     | Carlos Silva
-- Bia Martins   | Carlos Silva
-- Pedro Lima    | Ana Souza
```

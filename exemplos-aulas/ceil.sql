-- 1. Sintaxe Pura
-- Este é o formato básico da função, onde você a aplica a uma coluna numérica de uma tabela.
SELECT CEIL(nome_da_coluna_numerica)
FROM nome_da_tabela;

-- 2. Exemplo Aplicado (usando o cenário de logística)
-- Vamos supor que temos uma tabela chamada Pedidos com a quantidade de itens solicitados para envio. A capacidade de cada caixa é de 8 unidades.

-- Supondo que temos uma tabela 'Pedidos' com os seguintes dados:
-- ID_Pedido | Produto       | Quantidade
-- ----------------------------------------
-- 101       | Caneca        | 15
-- 102       | Camiseta      | 8
-- 103       | Mousepad      | 17
-- 104       | Teclado       | 32

-- A capacidade de cada caixa de envio é 8.

SELECT
    ID_Pedido,
    Produto,
    Quantidade,
    -- Usamos CEIL na divisão para garantir que sempre arredondemos para cima.
    -- Dividimos por 8.0 (ponto flutuante) para garantir que a divisão não seja inteira.
    CEIL(Quantidade / 8.0) AS Caixas_Necessarias
FROM
    Pedidos;

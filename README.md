# Curso Udemy - SQL para Análise de Dados

## 📖 Sobre o Repositório

Este repositório armazena todos os scripts, datasets e materiais de apoio utilizados no curso "SQL para Análise de Dados: Do básico ao avançado" da Udemy, ministrado por mim. O objetivo é fornecer aos alunos um local centralizado para acessar todos os recursos necessários para acompanhar as aulas, praticar os exercícios e desenvolver os projetos propostos.

Este repositório contém todo o material de apoio, scripts SQL, bases de dados (datasets) e exercícios usados no curso **“SQL para Análise de Dados: Do básico ao avançado”** da Udemy, ministrado pelo autor. O objetivo é fornecer aos alunos um local centralizado com tudo que precisam para acompanhar as aulas, praticar e desenvolver os projetos propostos.

[![GitHub issues](https://img.shields.io/github/issues/cerqueiralex/curso-udemy-sql)](https://github.com/cerqueiralex/curso-udemy-sql/issues)
[![GitHub forks](https://img.shields.io/github/forks/cerqueiralex/curso-udemy-sql)](https://github.com/cerqueiralex/curso-udemy-sql/network)
[![GitHub stars](https://img.shields.io/github/stars/cerqueiralex/curso-udemy-sql)](https://github.com/cerqueiralex/curso-udemy-sql/stargazers)
[![GitHub license](https://img.shields.io/github/license/cerqueiralex/curso-udemy-sql)](LICENSE)


## 📋 Links úteis e documentação

  * [Acesso ao Curso](https://www.udemy.com/course/domine-os-fundamentos-da-analise-de-dados-e-data-science/)

---

## Índice

1. [Funcionalidades](#funcionalidades)
2. [Público-alvo](#público-alvo)
3. [Pré-requisitos](#pré-requisitos)
4. [Como usar](#como-usar)
5. [Estrutura do repositório](#estrutura-do-repositório)
6. [Exemplos de uso](#exemplos-de-uso)
7. [Contribuições](#como-contribuir)

---

## Funcionalidades

* Scripts SQL correspondentes às aulas do curso, organizados por módulo.
* Exercícios práticos para reforçar o aprendizado.
* Bases de dados (datasets) para usar nos estudos ou laboratórios.
* Instruções para configurar o ambiente local (restauração de bancos, seleção de cliente SQL, etc.).

---

## Público-alvo

* Iniciantes em SQL que querem aprender do zero até níveis intermediários/avançados.
* Analistas de dados ou profissionais que precisam usar SQL como ferramenta de consulta, análise e manipulação de dados.
* Estudantes ou autodidatas que preferem estudar com exemplos práticos e bases reais.

---

## Pré-requisitos

Antes de começar, você vai precisar de:

* Um Sistema de Gerenciamento de Banco de Dados (SGBD), por exemplo:

  * **PostgreSQL** (recomendado)
  * **SQL Server**
* Um cliente SQL para executar os scripts, por exemplo:

  * DBeaver
  * pgAdmin (para PostgreSQL)
  * SQL Server Management Studio (SSMS), para SQL Server
* Git, para clonar o repositório localmente

---

## Como usar

1. Clone este repositório:

   ```bash
   git clone https://github.com/cerqueiralex/curso-udemy-sql.git
   cd curso-udemy-sql
   ```

2. Restaure / configure o banco de dados de exemplo:

   * Na pasta `datasets/` há os arquivos necessários de backup e instruções (`README.md`) para restaurar.
   * Dependendo do SGBD escolhido (PostgreSQL ou SQL Server), siga o guia específico.

3. Abra os arquivos `.sql` do módulo correspondente no seu cliente SQL preferido.

4. Conecte-se ao banco de dados preparado no passo 2.

5. Execute os scripts um a um para acompanhar as aulas ou os exercícios.

---

## Estrutura do repositório

Segue a hierarquia de pastas e arquivos e o que cada um representa:

```
/
├── datasets/
│   └── README.md                   # Instruções gerais
│
├── Módulo 01 - Introdução a SQL/
│   ├── 01_primeiras_consultas.sql   # Script da primeira aula
│   └── 02_exercicios.sql            # Exercícios do módulo
│
├── Módulo 02 - Consultas Básicas/
│   ├── 01_filtros_com_where.sql      # Aula com filtros WHERE
│   └── 02_exercicios.sql             # Exercícios do módulo
│
├── exemplos-aulas/                  # (Se existir) Exemplo prático de cada aula
│   └── ...                          # scripts ou material adicional
│
├── prompt_engineering/              # (Se existir) Materiais relacionados ao uso de prompts (OpenAI etc.)
│   └── ...
│
└── README.md                        # Este arquivo de documentação principal
```

### Detalhes

* **datasets/**: Contém os arquivos de banco de dados (como backups) e instruções para restaurar/usar esse banco no ambiente local.
* **Módulo XX - Nome do módulo/**: Cada módulo do curso corresponde a uma pasta, com os arquivos de aula e exercícios.
* **exemplos-aulas/**: Possíveis arquivos de exemplo adicional que complementam as aulas (ex: consultas feitas em aula, modelos).
* **prompt\_engineering/**: Material extra que não necessariamente é parte central do curso, se aplicável.

---

## Exemplos de uso

* Se estiver aprendendo **Filtros com WHERE**, entre na pasta `Módulo 02 - Consultas Básicas/` e abra `01_filtros_com_where.sql`.
* Rode os comandos no seu SGBD para ver os resultados e entender o funcionamento.
* Depois, tente fazer os exercícios do arquivo `02_exercicios.sql` para fixar.

---

## Como-contribuir

Contribuições são muito bem-vindas! Se você quiser ajudar com correções, melhorias ou sugestões:

1. Faça um Fork deste repositório.
2. Crie uma branch com sua feature ou correção:

   ```bash
   git checkout -b feature/minha-melhoria
   ```
3. Faça os commits referente às suas mudanças.
4. Faça push para sua branch no seu fork.
5. Abra um Pull Request explicando o que fez.

Se encontrar bugs ou tiver sugestões, pode abrir diretamente uma *Issue*.

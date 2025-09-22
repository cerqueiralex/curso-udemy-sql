# Curso Udemy - SQL para Análise de Dados

## 📖 Sobre o Repositório

Este repositório armazena todos os scripts, datasets e materiais de apoio utilizados no curso "SQL para Análise de Dados: Do básico ao avançado" da Udemy, ministrado por mim. O objetivo é fornecer aos alunos um local centralizado para acessar todos os recursos necessários para acompanhar as aulas, praticar os exercícios e desenvolver os projetos propostos.


## 📋 Links úteis e documentação

  * [Acesso ao Curso](https://www.udemy.com/course/domine-os-fundamentos-da-analise-de-dados-e-data-science/)

-----

## 🚀 Começando

Siga estas instruções para configurar o ambiente e começar a usar os materiais do curso.

### Pré-requisitos

Antes de começar, você precisará ter os seguintes softwares instalados:

  * **Sistema de Gerenciamento de Banco de Dados (SGBD):**
      * [PostgreSQL](https://www.postgresql.org/download/) (Recomendado)
      * ou [link suspeito removido]
      * ou [SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
  * **Cliente SQL:**
      * [DBeaver](https://dbeaver.io/download/) (Multiplataforma)
      * ou [pgAdmin](https://www.pgadmin.org/download/) (para PostgreSQL)
      * ou [SQL Server Management Studio (SSMS)](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms) (para SQL Server)
  * [Git](https://git-scm.com/downloads) para clonar o repositório.

### Instalação do Ambiente

1.  **Clone o repositório:**

    ```bash
    git clone https://github.com/cerqueiralex/curso-udemy-sql.git
    cd curso-udemy-sql
    ```

2.  **Restaure o Banco de Dados:**

      * As instruções para restaurar o banco de dados de exemplo (ex: AdventureWorks, Northwind) podem ser encontradas na pasta `datasets/`. Siga o `README.md` específico daquela pasta.

-----

## 📂 Estrutura do Repositório

O repositório está organizado da seguinte forma:

```
/
├── datasets/
│   ├── AdventureWorks.bak        # Arquivo de backup do banco de dados
│   └── README.md                 # Instruções para restaurar o banco de dados
│
├── Módulo 01 - Introdução a SQL/
│   ├── 01_primeiras_consultas.sql
│   └── 02_exercicios.sql
│
├── Módulo 02 - Consultas Básicas/
│   ├── 01_filtros_com_where.sql
│   └── 02_exercicios.sql
│
├── ... (outras pastas de módulos)
│
└── README.md                     # Este arquivo
```

  * **`/datasets`**: Contém os arquivos de banco de dados e as instruções para configuração do ambiente.
  * **`/Módulo XX - ...`**: Cada módulo do curso tem sua própria pasta, contendo os scripts SQL apresentados nas aulas e os exercícios propostos.

-----

## 💻 Como Usar

1.  Navegue até a pasta do módulo que você está estudando.
2.  Abra o arquivo `.sql` correspondente à aula no seu cliente SQL de preferência (DBeaver, pgAdmin, etc.).
3.  Conecte-se ao banco de dados que você restaurou na etapa de instalação.
4.  Execute as consultas para ver os resultados e praticar os conceitos.

-----

## 🤝 Como Contribuir

Contribuições são o que tornam a comunidade de código aberto um lugar incrível para aprender, inspirar e criar. Qualquer contribuição que você fizer será **muito apreciada**.

Se você encontrar um erro ou tiver uma sugestão de melhoria, por favor, abra uma "Issue" neste repositório.

1.  Faça um "Fork" do projeto
2.  Crie uma "Branch" para sua feature (`git checkout -b feature/AmazingFeature`)
3.  Faça o "Commit" de suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4.  Faça o "Push" para a Branch (`git push origin feature/AmazingFeature`)
5.  Abra um "Pull Request"

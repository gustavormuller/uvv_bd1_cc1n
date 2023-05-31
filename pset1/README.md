# PSET1   

## Sobre o PSET1
O Problem Set 1 é um trabalho proposto pelo professor Abrantes Araújo Silva Filho, da disciplina Design e Desenvolvimento de Banco de Dados. O trabalho foi realizado na seguinte ordem:   

- Criação do projeto lógico no SQL Power Architect
- Exportar o projeto do Power Architect em SQL para o PostgreSQL
- Editar o script gerado para consertar possíveis erros do Power Architect, além de adicionar os comandos de criação do banco de dados, usuário e esquema, comentando todos os comandos do script de forma detalhada
- Responder as questões discursivas e entregar ao professor

## Estrutura dos arquivos   

- cc1n_202309287_postgresql.sql : script sql que gera todo o banco de dados, o usuário, esquema e as tabelas, sem pedir senha.
- cc1n_202309287_postgresql.architect : arquivo gerado no SQL Power Architect contendo as tabelas e suas relações.
- cc1n_202309287_postgresql.pdf : contém a imagem das tabelas e relações que foram geradas no SQL Power Architect.

## Utilização

Para facilitar a execução do script, é recomendado rodá-lo na máquina virtual DBServer2

1. Instale a máquina virtual [DBSERVER 2.0](https://www.computacaoraiz.com.br/2023/01/02/dbserver-2/) 
2. Clone este repositório utilizando o comando git clone, ou simplesmente baixe os arquivos e arraste para sua máquina virtual.
3. Abra o terminal Linux presente na máquina virtual
4. Entre na pasta onde está os arquivos deste repositório
5. Execute o seguinte comando para rodar o script: `psql -U postgres <cc1n_202309287_postgresql.sql`
6. Digite a senha: computacao@raiz
7. Pronto, o banco de dados está criado!

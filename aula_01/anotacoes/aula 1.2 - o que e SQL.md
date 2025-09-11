Linguagem de pesquisa declarativa de padrão para banco de dados relacional

# elementos

**Comandos** -  SELECT, INSERT, UPDATE, DELETE, CREATE TABLE, GRANT

**Clausulas** - FROM, WHERE, GROUP BY

**Expressões** - A+B, A* ABS(B-20) 
transformações nos dados através de expressões

**Predicados** - A>B, C BETWEEN 20 AND 200
Comparações lógicas

**Queries** - SELECT COLUNA FROM TABELA
Quando as coisas são juntadas

## Estruturas importantes

**Chaves primária e referências** - 
PK (primary key) e FK (foreign Key) garantem a integridade e relacionamento consistente entre as tabelas
Servem como uma documentação também

PK são identificadores únicos de uma entidade, ou seja, aquilo que uma entidade possui e nenhuma outra tem igual. Exemplo: CPF, CNPJ, ID de cliente

FK seria colocar esse identificador único de uma entidade de uma determinada tabela, como uma referência em outra tabela
Exemplo:
uma tabela de cliente que tem id como PK
E uma tabela de vendas também é necessário guardar uma informação de qual o cliente fez a compra, nesse caso, o id do cliente é salvado como FK

"O FK de uma tabela é o PK de outra tabela"

**Constraints**

Restrições dentro de alguns campos
Exemplos: Esse campo tem que ser positivo, esse campo tem que ser único, não pode ser maior do que 20 letras

"Não são muito usados por podem onerar o SGBD"

<mark style="background: #ADCCFFA6;">O mais comum é o NOT NULL</mark>

"Condição tem um efeito de comparação, restrição tem a ver com regras daquela propriedade"

**Sequências**
<mark style="background: #ADCCFFA6;">Enum</mark>
São campos que não são livres para ser inseridos qualquer tipo de dado

Por exemplo: Um campo de Estado já tem valores pré-determinados que o usuário pode escolher um, mas não pode digitar seu próprio estado 
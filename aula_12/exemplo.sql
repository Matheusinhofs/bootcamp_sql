-- criação das tabelas
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- toda vez que cria uma estrutura com primary key e foreign key já utiliza index de forma natural
CREATE TABLE pessoas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(3),
    last_name VARCHAR(3)
);

-- verificação dos índices
SELECT 
    tablename AS "Tabela",
    indexname AS "Índice",
    indexdef AS "Definição do Índice"
FROM 
    pg_indexes 
WHERE 
    tablename = 'pessoas'; -- Substitua 'pessoas' pelo nome da sua tabela

-- recriar a tabela de pessoas para usar id serial, uma vez que o serial para inserção é bem mais rápido que UUID
CREATE TABLE pessoas (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(3),
    last_name VARCHAR(3)
);

-- inserir 1 milhão de registros
INSERT INTO pessoas (first_name, last_name)
SELECT 
    substring(md5(random()::text), 0, 3),
    substring(md5(random()::text), 0, 3)
FROM 
    generate_series(1, 1000000);


select * from pessoas p 
where p.id = 26

-- busca o índice como index only scan
EXPLAIN select p.id from pessoas p 
where p.id = 26

-- busca a informação da tabela usando o index scan
EXPLAIN SELECT first_name FROM pessoas WHERE id = 100000;

-- busca a informação através do parallel seq scan, percorrendo na tabela
EXPLAIN SELECT first_name FROM pessoas WHERE first_name = 'aa'

-- busca a informação através do seq scan, sendo este o menos performático que ele vai na coluna para percorrer onde esta o caracter
EXPLAIN SELECT first_name FROM pessoas WHERE first_name LIKE '%a%';

-- forma de criar o index 
CREATE INDEX first_name_index ON pessoas(first_name);

-- Após a criação do index a query ela passa a buscar como index only scan
EXPLAIN SELECT first_name FROM pessoas WHERE first_name = 'aa';

-- Quando ele precisa buscar um valor usando o like com o %, ele continua precisando percorrer a coluna de forma que o índice da tabela não vai ser utilizado
EXPLAIN SELECT first_name FROM pessoas WHERE first_name LIKE '%aa%';

-- Este exemplo abaixo ele utiliza o Bitmap Index Scan para combinar múltiplos índices em uma única operação
SELECT id, first_name FROM pessoas WHERE id = 100 OR first_name = 'aa';

-- Como verificar qual o custo do índice, tamanho do espaço em disco ocupado pelo índice
SELECT pg_size_pretty(pg_relation_size('first_name_index'));

-- Abaixo traz o tamanho total da coluna em todas as linhas da tabela
SELECT pg_size_pretty(pg_column_size(first_name)::bigint) AS tamanho_total
FROM pessoas;

-- Calcula o tamanho total de todas as colunas e todas as linhas na tabela 
SELECT pg_size_pretty(SUM(pg_column_size(first_name)::bigint)) AS tamanho_total
FROM pessoas;
-- Tabela criada
CREATE TABLE pessoas (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(3),
    last_name VARCHAR(3),
    estado VARCHAR(3)
);

-- Inserindo dados aleatórios
CREATE OR REPLACE FUNCTION random_estado()
RETURNS VARCHAR(3) AS $$
BEGIN
   RETURN CASE floor(random() * 5)
         WHEN 0 THEN 'SP'
         WHEN 1 THEN 'RJ'
         WHEN 2 THEN 'MG'
         WHEN 3 THEN 'ES'
         ELSE 'DF'
         END;
END;
$$ LANGUAGE plpgsql;

-- Inserir dados na tabela pessoas com estados aleatórios
INSERT INTO pessoas (first_name, last_name, estado)
SELECT 
   substring(md5(random()::text), 0, 3),
   substring(md5(random()::text), 0, 3),
   random_estado()
FROM 
   generate_series(1, 10000000);

-- Criando o index 
create index first_name_index on pessoas(first_name)

-- contagem com o index 
select count(first_name) from pessoas where first_name = 'aa'

-- contagem sem o index
-- com o explain é possível verificar que a query abaixo utilizou o seq scan para realizá-la
select count(last_name) from pessoas where last_name = 'aa'

-- No postgres a primary key é criada composta com a pk serial e a que particiona
CREATE TABLE pessoas2 (
    id SERIAL,
    first_name VARCHAR(3),
    last_name VARCHAR(3),
    estado VARCHAR(3),
    PRIMARY KEY (id, estado)
) PARTITION BY LIST (estado);


-- patições
CREATE TABLE pessoas2_sp PARTITION OF pessoas FOR VALUES IN ('SP');
CREATE TABLE pessoas2_rj PARTITION OF pessoas FOR VALUES IN ('RJ');
CREATE TABLE pessoas2_mg PARTITION OF pessoas FOR VALUES IN ('MG');
CREATE TABLE pessoas2_es PARTITION OF pessoas FOR VALUES IN ('ES');
CREATE TABLE pessoas2_df PARTITION OF pessoas FOR VALUES IN ('DF');

-- pela partição ele busca como index only scan
explain select count(*) from pessoas2 p where p.estado = 'RJ'

-- exemplo de partição por range de id
-- menos usado na prática
CREATE TABLE pessoas3 (
        id SERIAL PRIMARY KEY,
        first_name VARCHAR(3),
        last_name VARCHAR(3),
        estado VARCHAR(3)
    ) PARTITION BY RANGE (id);

CREATE TABLE pessoas3_part1 PARTITION OF pessoas3 FOR VALUES FROM (MINVALUE) TO (2000001);
CREATE TABLE pessoas3_part2 PARTITION OF pessoas3 FOR VALUES FROM (2000001) TO (4000001);
CREATE TABLE pessoas3_part3 PARTITION OF pessoas3 FOR VALUES FROM (4000001) TO (6000001);
CREATE TABLE pessoas3_part4 PARTITION OF pessoas3 FOR VALUES FROM (6000001) TO (8000001);
CREATE TABLE pessoas3_part5 PARTITION OF pessoas3 FOR VALUES FROM (8000001) TO (MAXVALUE);


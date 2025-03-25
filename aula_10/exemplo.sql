
BEGIN;
-- Criar tabela
CREATE TABLE exemplo (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50)
);

-- Inserir dados
INSERT INTO exemplo (nome) VALUES ('A'), ('B'), ('C');

SELECT * FROM exemplo
COMMIT;


BEGIN;
INSERT INTO exemplo (nome) VALUES ('A');
COMMIT;

-- isolamento para leitura
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN;
SELECT nome, count(nome) FROM exemplo
GROUP by nome;
SELECT * FROM exemplo;
COMMIT;



-- Serializable
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN;
SELECT * FROM exemplo;

-- Configuração para Serializable
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN;
SELECT * FROM exemplo;

-- Voltar pro T1
INSERT INTO exemplo (nome) VALUES ('A');
COMMIT;

-- Voltar pro T2
INSERT INTO exemplo (nome) VALUES ('A');
COMMIT;
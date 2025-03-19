CREATE TABLE IF NOT EXISTS clients (
    id SERIAL PRIMARY KEY NOT NULL,
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL
);


CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS clients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL
);



-- Criação de Procedure
CREATE OR REPLACE PROCEDURE realizar_transacao(
    IN p_tipo CHAR(1),
    IN p_descricao VARCHAR(10),
    IN p_valor INTEGER,
    IN p_cliente_id INTEGER
)

LANGUAGE plpgsql
-- Sobre a languages na documentação do postgresql tem 4 linguagens padrões disponíveis: PL/pgSQL (Chapter 43), PL/Tcl (Chapter 44), PL/Perl (Chapter 45), and PL/Python



AS $$
DECLARE
    saldo_atual INTEGER;
    limite_cliente INTEGER;
BEGIN
    -- Corpo da procedure...
END;
$$;

-- O corpo da stored procedure é definido entre AS $$ e $$;.
-- Dentro do corpo, declaramos variáveis locais usando DECLARE.
-- A execução da procedure ocorre entre BEGIN e END;

-- Obtém o saldo atual e o limite do cliente
SELECT saldo, limite INTO saldo_atual, limite_cliente
FROM clients
WHERE id = p_cliente_id;

-- Verifica se a transação é válida com base no saldo e no limite
IF p_tipo = 'd' AND saldo_atual - p_valor < -limite_cliente THEN
    RAISE EXCEPTION 'Saldo insuficiente para realizar a transação';
END IF;

-- Atualiza o saldo do cliente
UPDATE clients
SET saldo = saldo + CASE WHEN p_tipo = 'd' THEN -p_valor ELSE p_valor END
WHERE id = p_cliente_id;

-- Insere uma nova transação
INSERT INTO transactions (tipo, descricao, valor, cliente_id)
VALUES (p_tipo, p_descricao, p_valor, p_cliente_id);


--Para chamar a stored procedure realizar_transacao com os parâmetros fornecidos, você pode executar o seguinte comando SQL no PostgreSQL:
CALL realizar_transacao('d', 'carro', 80000, 1);


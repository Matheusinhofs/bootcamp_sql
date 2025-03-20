-- Criação da tabela Funcionario
CREATE TABLE Funcionario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    salario DECIMAL(10, 2),
    dtcontratacao DATE
);

-- Criação da tabela Funcionario_Auditoria
CREATE TABLE Funcionario_Auditoria (
    id INT,
    salario_antigo DECIMAL(10, 2),
    novo_salario DECIMAL(10, 2),
    data_de_modificacao_do_salario TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id) REFERENCES Funcionario(id)
);

-- Inserção de dados na tabela Funcionario
INSERT INTO Funcionario (nome, salario, dtcontratacao) VALUES ('Maria', 5000.00, '2021-06-01');
INSERT INTO Funcionario (nome, salario, dtcontratacao) VALUES ('João', 4500.00, '2021-07-15');
INSERT INTO Funcionario (nome, salario, dtcontratacao) VALUES ('Ana', 4000.00, '2022-01-10');
INSERT INTO Funcionario (nome, salario, dtcontratacao) VALUES ('Pedro', 5500.00, '2022-03-20');
INSERT INTO Funcionario (nome, salario, dtcontratacao) VALUES ('Lucas', 4700.00, '2022-05-25');




create function registrar_auditoria_salario()
returns trigger as $$
begin

	insert into funcionario_auditoria(id, salario_antigo, salario_novo)
	values (old.id, old.salario, new.salario);
	return new;
end;
$$ language plpgsql;

-- o old consegue trazer os valores antigos antes do update
-- new traz os valores novos após o update


create trigger trg_salario_modificado
-- after / before
after update of salario on funcionario
-- insert, delete, update
-- tem que especificar o que vai ser alterado
for each row
--row -> se coloca as linhas de uma vez/statement -> se faz o refresh depois, muita movimentação melhor usar o statement
execute function
registrar_auditoria_salario():


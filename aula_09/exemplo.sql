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

	insert into funcionario_auditoria(id, salario_antigo, novo_salario)
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
registrar_auditoria_salario();



-- Criação da tabela Produto
CREATE TABLE Produto (
    cod_prod INT PRIMARY KEY,
    descricao VARCHAR(50) UNIQUE,
    qtde_disponivel INT NOT NULL DEFAULT 0
);

-- Inserção de produtos
INSERT INTO Produto VALUES (1, 'Basica', 10);
INSERT INTO Produto VALUES (2, 'Dados', 5);
INSERT INTO Produto VALUES (3, 'Verao', 15);

-- Criação da tabela RegistroVendas
CREATE TABLE RegistroVendas (
    cod_venda SERIAL PRIMARY KEY,
    cod_prod INT,
    qtde_vendida INT,
    FOREIGN KEY (cod_prod) REFERENCES Produto(cod_prod) ON DELETE CASCADE
);

-- Delete cascade deleta o que vem de uma deleção de uma tabela com a chave primária


create or replace function func_verifica_estoque() returns trigger as $$
declare 
	qtde_atual integer;
begin 
	select qtde_disponivel into qtde_atual
	from produto where cod_prod = new.cod_prod;
	if qtde_atual < new.qtde_vendida then
		raise exception 'Quantidade indisponivel no estoque';
	else
		update produto set qtde_disponivel = qtde_disponivel - new.qtde_vendida
		where cod_prod = new.cod_prod;
	end if;
	return new;		
end;
$$ language plpgsql;

create trigger trg_verifica_estoque
before insert on registrovendas
for each row
execute function func_verifica_estoque();


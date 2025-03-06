-- 1. Obter todas as colunas das tabelas Clientes, Pedidos e Fornecedores

select * from customers c 
select * from orders 
select * from suppliers 

-- 2. Obter todos os Clientes em ordem alfabética por país e nome

select * from customers c order by c.country, c.contact_name  

-- 3. Obter os 5 pedidos mais antigos

select * from orders o 
order by o.order_date asc
limit 5

-- 4. Obter a contagem de todos os Pedidos feitos durante 1997

-- 5. Obter os nomes de todas as pessoas de contato onde a pessoa é um gerente, em ordem alfabética

-- 6. Obter todos os pedidos feitos em 19 de maio de 1997
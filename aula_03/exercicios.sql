-- 1. Cria um relatório para todos os pedidos de 1996 e seus clientes (152 linhas)
select * from orders o 
inner join customers c on o.customer_id = c.customer_id   
where extract(year from o.order_date) = 1996

-- 2. Cria um relatório que mostra o número de funcionários e clientes de cada cidade que tem funcionários (5 linhas)
select 
	count(distinct e.employee_id),
	count(distinct c.customer_id),
	e.city 
from employees e 
left join customers c on e.city = c.city
where e.employee_id is not null 
group by e.city

-- 3. Cria um relatório que mostra o número de funcionários e clientes de cada cidade que tem clientes (69 linhas)

-- 4.Cria um relatório que mostra o número de funcionários e clientes de cada cidade (71 linhas)

-- 5. Cria um relatório que mostra a quantidade total de produtos encomendados.
-- Mostra apenas registros para produtos para os quais a quantidade encomendada é menor que 200 (5 linhas)

-- 6. Cria um relatório que mostra o total de pedidos por cliente desde 31 de dezembro de 1996.
-- O relatório deve retornar apenas linhas para as quais o total de pedidos é maior que 15 (5 linhas)
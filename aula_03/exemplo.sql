-- INNER JOIN ou só JOIN, traz tudo de ambas as tabelas, mas que são em comum
-- sempre trazer o nome da tabela antes do campo
select * 
from orders o  
inner join customers c on o.customer_id = c.customer_id

-- extract traz tudo do ano escolhido
select * 
from orders o  
join customers c on o.customer_id  = c.customer_id
where extract(year from o.order_date) = 1996

-- Left Join, traz tudo de uma tabela a esquerda e traz tudo da direita que corresponde na esquerda
-- Right Join faz o contrário entre as tabelas
select e.employee_id, e.last_name, c.contact_name 
from employees e  
left join customers c on e.city = c.city 
order by e.employee_id

-- Full Join, ele traz tudo de ambas as tabelas 
select 
	 coalesce(c.city, e.city),
	 count(distinct e.employee_id) as qtd_funcionarios,
	 count(distinct c.customer_id ) as qtd_funcionarios
from employees e
full join customers c on e.city = c.city
group by c.city, e.city

-- cross join, ele faz semelhante a um produto cartesiano, aumentando o resultado em relação às tabelas
select 
	 coalesce(c.city, e.city),
	 count(distinct e.employee_id) as qtd_funcionarios,
	 count(distinct c.customer_id ) as qtd_funcionarios
from employees e
cross join customers c 
group by c.city, e.city



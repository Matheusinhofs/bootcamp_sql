--Qual foi o total de receitas no ano de 1997?
select 
	sum(od.unit_price * od.quantity) as receita
from order_details od 
inner join orders o on od.order_id = o.order_id  
where extract(year from o.order_date) = 1997


--Faça uma análise de crescimento mensal e o cálculo de YTD
--Qual é o valor total que cada cliente já pagou até agora?

-- Utilizando group by
select 
	sum(od.unit_price * od.quantity) as gasto,
	c.contact_name
from order_details od 
inner join orders o on od.order_id = o.order_id  
left join customers c on c.customer_id = o.customer_id
group by c.contact_name
order by c.contact_name

-- Utilizando over e partition by
select
	distinct 
	sum(od.unit_price * od.quantity) over (partition by c.contact_name) as gasto,
	c.contact_name
from order_details od 
inner join orders o on od.order_id = o.order_id  
left join customers c on c.customer_id = o.customer_id
order by c.contact_name


--Separe os clientes em 5 grupos de acordo com o valor pago por cliente

select
	distinct 
	sum(od.unit_price * od.quantity) as gasto,
	c.contact_name,
	ntile(5) over (order by sum(od.unit_price * od.quantity)) as grupo
from order_details od 
inner join orders o on od.order_id = o.order_id  
left join customers c on c.customer_id = o.customer_id
group by c.contact_name
order by grupo

--Agora somente os clientes que estão nos grupos 3, 4 e 5 para que seja feita uma análise de Marketing especial com eles



--Identificar os 10 produtos mais vendidos.
select 
	p.product_name,
	od.quantity,
	rank() over (order by quantity desc) as rank
from order_details od 
inner join products p on od.product_id = p.product_id 
order by od.quantity desc
limit 10


--Quais clientes do Reino Unido pagaram mais de 1000 dólares?
select
	distinct 
	sum(od.unit_price * od.quantity) as gasto,
	c.contact_name
from order_details od 
inner join orders o on od.order_id = o.order_id  
left join customers c on c.customer_id = o.customer_id 
where c.country = 'UK'
group by c.contact_name
having sum(od.unit_price * od.quantity) > 1000 
order by c.contact_name
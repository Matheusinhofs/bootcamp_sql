--Qual foi o total de receitas no ano de 1997?
select 
	sum((od.unit_price * od.quantity) * (1-od.discount)) as receita
from order_details od 
inner join orders o on od.order_id = o.order_id  
where extract(year from o.order_date) = 1997


--Faça uma análise de crescimento mensal e o cálculo de YTD
with ReceitasMensais as (
	select 
		extract(year from o.order_date) as Ano,
		extract(month from o.order_date) as Mes, 
		sum((od.unit_price * od.quantity) * (1-od.discount)) as receita
	from order_details od 
	inner join orders o on od.order_id = o.order_id  
	group by Ano, Mes
),
	ReceitasMensaisYTD as (
	select 
		Ano,
		Mes,
		receita,
		SUM(receita) over (partition by Ano order by Mes) as Receita_YTD
	from ReceitasMensais
	)
	
select 
	Ano, 
	Mes, 
	receita, 
	receita - lag(receita) over (partition by Ano order by Mes) as Diferenca_Mensal,
	Receita_YTD,
	((receita - lag(receita) over (partition by Ano order by Mes))/lag(receita) OVER (PARTITION BY Ano ORDER BY Mes)) * 100 as percent
from ReceitasMensaisYTD
ORDER BY
    Ano, Mes;

--Qual é o valor total que cada cliente já pagou até agora?

-- Utilizando group by
select 
	sum((od.unit_price * od.quantity) * (1-od.discount)) as gasto,
	c.contact_name
from order_details od 
inner join orders o on od.order_id = o.order_id  
left join customers c on c.customer_id = o.customer_id
group by c.contact_name
order by c.contact_name

-- Utilizando over e partition by
select
	distinct 
	sum((od.unit_price * od.quantity) * (1-od.discount)) over (partition by c.contact_name) as gasto,
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
	ntile(5) over (order by sum((od.unit_price * od.quantity) * (1-od.discount))) as grupo
from order_details od 
inner join orders o on od.order_id = o.order_id  
left join customers c on c.customer_id = o.customer_id
group by c.contact_name
order by grupo

--Agora somente os clientes que estão nos grupos 3, 4 e 5 para que seja feita uma análise de Marketing especial com eles
with Grupos as (
	select distinct 
		sum(od.unit_price * od.quantity) as gasto,
		c.contact_name,
		ntile(5) over (order by sum((od.unit_price * od.quantity) * (1-od.discount))) as grupo
	from order_details od 
	inner join orders o on od.order_id = o.order_id  
	left join customers c on c.customer_id = o.customer_id
	group by c.contact_name
	order by grupo
)

select * from Grupos
where grupo >= 3


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
	sum((od.unit_price * od.quantity) * (1-od.discount)) as gasto,
	c.contact_name
from order_details od 
inner join orders o on od.order_id = o.order_id  
inner join customers c on c.customer_id = o.customer_id 
where c.country = 'UK'
group by c.contact_name
having sum((od.unit_price * od.quantity) * (1-od.discount)) > 1000 
order by c.contact_name


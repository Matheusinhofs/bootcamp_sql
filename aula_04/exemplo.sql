select 
	od.order_id,
	count(distinct od.product_id) as valor_unique_product,
	sum(od.quantity) as total_products_sales,
	sum(od.unit_price * od.quantity) as total_sales
from order_details od 
group by od.order_id 
order by od.order_id 

-- É possível resolver a mesma solução usando o OVER, em que ele particiona, sendo cada linha uma agregação
-- Ele repete as linhas várias vezes
-- Ao invés de agrupar toda a tabela, consegue agrupar a nível de linha
select 
	distinct od.order_id,
	count(od.product_id) over (partition by od.order_id) as valor_unique_product,
	sum(od.quantity) over (partition by od.order_id) as total_products_sales,
	sum(od.unit_price * od.quantity) over (partition by od.order_id) as total_sales
from order_details od 
order by od.order_id 

-- Com isso é possível manter as informações das linhas e adicionar novas colunas 
select 
	distinct od.order_id,
	count(od.product_id) over (partition by od.order_id) as valor_unique_product,
	sum(od.quantity) over (partition by od.order_id) as total_products_sales,
	sum(od.unit_price * od.quantity) over (partition by od.order_id) as total_sales
from order_details od 
order by od.order_id 


select 
	o.customer_id,
	MIN(o.freight),
	MAX(o.freight),
	AVG(o.freight)
from orders o 
group by o.customer_id

-- Power BI pode consumir essas tabelas já com o KPI
-- explain analyse
select 
	distinct o.customer_id,
	MIN(o.freight) over (partition by o.customer_id) as minimo,
	MAX(o.freight) over (partition by o.customer_id) as maximo,
	AVG(o.freight) over (partition by o.customer_id) as media
from orders o 
order by o.customer_id


-- Rank(): Atribui um rank único a cada linha, deixando lacunas em caso de empates.
-- Dense_rank(): Atribui um rank único a cada linha, com ranks contínuos para linhas empatadas. 
-- Row_number(): Atribui um número inteiro sequencial único a cada linha, independentemente de empates, sem lacunas.

select  
	distinct p.product_id,
	p.product_name,
	(od.unit_price * od.quantity) as total_vendas,
	row_number() over (order by (od.unit_price * od.quantity) desc) as row_numb,
	rank() over (order by (od.unit_price * od.quantity) desc) as rankk,
	dense_rank() over (order by (od.unit_price * od.quantity) desc) as dense_rankk
from order_details od 
join products p on p.product_id = od.product_id
order by rankk


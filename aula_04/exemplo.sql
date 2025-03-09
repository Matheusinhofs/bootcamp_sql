-- 6. Obter todos os pedidos feitos em 19 de maio de 1997
select * from orders o 
where o.order_date = '19/05/1997'


select * from order_details od limit 10

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



-- Percent_rank(): Calcula o rank relativo de uma linha específica dentro do conjunto de resultados como uma porcentagem.
-- Fórmula: PERCENT_RANK = (RANK - 1) / (N - 1)

-- Cume_dist(): Calcula a distribuição acumulada de um valor no conjunto de resultados. Representa a proporção de linhas que são menores ou iguais à linha atual.
-- Fórmula: CUME_DIST = (Número de linhas com valores <= linha atual) / (Número total de linhas)

-- ambos retornam valores entre 0 e 1

SELECT  
  order_id, 
  unit_price * quantity AS total_sale,
  ROUND(CAST(PERCENT_RANK() OVER (PARTITION BY order_id 
    ORDER BY (unit_price * quantity) DESC) AS numeric), 2) AS order_percent_rank,
  ROUND(CAST(CUME_DIST() OVER (PARTITION BY order_id 
    ORDER BY (unit_price * quantity) DESC) AS numeric), 2) AS order_cume_dist
FROM  
  order_details;


-- NTILE(n): fala como vai particionar os grupos, divide em partes iguais ou aproximadamente iguais
-- NTILE(n) OVER (ORDER BY coluna)
-- n: O número de faixas ou grupos que você deseja criar.
-- ORDER BY coluna: A coluna pela qual você deseja ordenar o conjunto de resultados antes de aplicar a função NTILE()
-- todos esses grupos são de rankings

SELECT first_name, last_name, title,
   NTILE(3) OVER (ORDER BY first_name) AS group_number
FROM employees;



-- LAG(), LEAD()
-- LAG(): Permite acessar o valor da linha anterior dentro de um conjunto de resultados. Isso é particularmente útil para fazer comparações com a linha atual ou identificar tendências ao longo do tempo.
-- LEAD(): Permite acessar o valor da próxima linha dentro de um conjunto de resultados, possibilitando comparações com a linha subsequente.

-- comparação de resultados normalmente vai usar o lag ou o lead
-- o lag vai traz quanto vendeu no dia anterior e o lead traz o do próximo dia 

SELECT 
  customer_id, 
  TO_CHAR(order_date, 'YYYY-MM-DD') AS order_date, 
  shippers.company_name AS shipper_name, 
  LAG(freight) OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS previous_order_freight, 
  freight AS order_freight, 
  LEAD(freight) OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS next_order_freight
FROM 
  orders
JOIN 
  shippers ON shippers.shipper_id = orders.ship_via;


-- Having: filtra os dados através de uma conta matemática, como por exemplo soma, medidas e etc
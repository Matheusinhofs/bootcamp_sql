-- consulta de seleção de todas as linhas e colunas
select 
	* 
from customers

-- consulta de seleção de colunas específicas
select distinct country from customers c 

-- o where faz o filtro a nível de linha
-- diminui o número de linhas
select 
	*
from customers c 
where c.country = 'Mexico'

-- o where pode ser usado com vários tipos de operadores como and, or
-- pode ser usado o operador and da seguinte maneira
select 
	*
from customers c 
where c.country = 'UK' and c.city = 'Cowes'

-- pode ser usado o operador or da seguinte maneira
select 
	*
from customers c 
where c.country = 'UK' or c.country = 'Germany'

-- uso de dois operadores
select 
	*
from customers c 
where c.country = 'Spain' and (c.city  = 'Barcelona' or c.city = 'Sevilla')

-- consulta retirando países com diferente <>
select 
	*
from customers c 
where c.country <> 'Spain' and c.country <> 'UK'

-- operadores de comparação com sinais de maior, menor, diferente
select 
	*
from products p 
where unit_price < 20

select 
	*
from products p 
where unit_price < 20 and unit_price > 5

-- operador para retirar o que é nulo ou não nulo
select 
	*
from customers c 
where c.region is not null

-- operador like verifica se em uma string tem nela um pedaço de texto
-- sempre lembrar que o like tem um peso na consulta
select 
	c.contact_name 
from customers c 
where UPPER(c.contact_name) like 'A%'

-- O _ ele substitui uma posição do like, dessa forma o like busca algo na primeira posição, depois o que tiver 'a' e alguma coisa depois
-- E o ilike ele já ignora o case sensitive do like 
select 
	c.contact_name 
from customers c 
where c.contact_name ilike '_a%'

-- Operador not com o like
select 
	c.contact_name 
from customers c 
where c.contact_name not ilike 'a%'

-- Comando similar to ele busca o que começa com os caracteres indicados
select 
	* 
from customers c 
where c.city similar to '(B|S|P)%'

-- Operador IN ele avalia semelhante a uma lista do python
select 
	* 
from customers c 
where c.country IN ('Germany', 'UK', 'France')

-- O Between traz o resultado da query com os valores entre intervalos
select 
	* 
from products p  
where p.unit_price between 10 and 30

-- Agregadores geralmente utilizam o group by se vier com outros campos
-- No exemplo abaixo ele só faz a agregação do max sem outro campo, sem necessidade de group by
select 
	MAX(p.unit_price)
from products p  

-- Agregador com group by
select 
	p.product_name,
	MAX(p.unit_price)
from products p  
group by p.product_name 



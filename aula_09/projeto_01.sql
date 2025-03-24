-- Foi criada uma view materializada com os dados acumulados de receitas no ano e a receita do mes consolidada

CREATE MATERIALIZED VIEW MaterializedReceitasMensais as 
	select 
		Ano,
		Mes,
		receita,
		SUM(receita) over (partition by Ano order by Mes) as Receita_YTD
	from (select 
		extract(year from o.order_date) as Ano,
		extract(month from o.order_date) as Mes, 
		sum((od.unit_price * od.quantity) * (1-od.discount)) as receita
	from order_details od 
	inner join orders o on od.order_id = o.order_id  
	group by Ano, Mes)

-- Criação da função de atualização da view materializada
create or replace function atualizar_orders() returns trigger as $$
	begin
		REFRESH MATERIALIZED VIEW MaterializedReceitasMensais;
	end;
$$ language plpgsql;

-- duas triggers foram criadas para atualizar a materialized view em alterações das tabelas orders e order_details
create trigger trg_alterar_orders
after update or delete or insert on orders
for each row
execute function
atualizar_orders();

create trigger trg_alterar_order_details
after update or delete or insert on order_details
for each row
execute function
atualizar_orders();

-- exemplo de atualização dos dados em que a trigger irá rodar após o update 
-- valor anterior era 14 e a data do pedido era em 07/1996
update order_details
set unit_price = 100000000
where order_id = 10248 and product_id = 11 

select * from materializedreceitasmensais m     
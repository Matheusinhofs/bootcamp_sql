-- Faça a classificação dos produtos mais venvidos usando usando RANK(), DENSE_RANK() e ROW_NUMBER()
-- Essa questão tem 2 implementações, veja uma que utiliza subquery e uma que não utiliza.
-- Tabelas utilizadas FROM order_details o JOIN products p ON p.product_id = o.product_id;
-- Listar funcionários dividindo-os em 3 grupos usando NTILE
-- FROM employees;



-- Ordenando os custos de envio pagos pelos clientes de acordo 
-- com suas datas de pedido, mostrando o custo anterior e o custo posterior usando LAG e LEAD:
-- FROM orders JOIN shippers ON shippers.shipper_id = orders.ship_via;
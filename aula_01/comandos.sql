-- Alguns comandos para testar o exemplo do Northwind
-- Consultas muito complexas podem onerar o banco de dados
-- 
SELECT * FROM categories;

SELECT DISTINCT country FROM customers

SELECT COUNT(DISTINCT country) FROM customers

SELECT * FROM customers WHERE country='Mexico';

SELECT * FROM customers ORDER BY country;


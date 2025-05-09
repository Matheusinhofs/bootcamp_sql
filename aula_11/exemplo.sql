DROP TABLE IF EXISTS cars, engines;
CREATE TABLE cars (
 manufacturer VARCHAR(64),
 model VARCHAR(64),
 country VARCHAR(64),
 engine_name VARCHAR(64),
 year INT
);
CREATE TABLE engines (
 name VARCHAR(64),
 horse_power INT
);

INSERT INTO cars
VALUES 
 ('BMW', 'M4', 'Germany', 'S58B30T0-353', 2021),
 ('BMW', 'M4', 'Germany', 'S58B30T0-375', 2021),
 ('Chevrolet', 'Corvette', 'USA', 'LT6', 2023),
 ('Chevrolet', 'Corvette', 'USA', 'LT2', 2023),
 ('Audi', 'R8', 'Germany', 'DOHC FSI V10-5.2-456', 2019),
 ('McLaren', 'GT', 'UK', 'M840TE', 2019),
 ('Mercedes', 'AMG C 63 S E', 'Germany', 'M139L', 2023);
 
INSERT INTO engines
VALUES 
 ('S58B30T0-353', 473),
 ('S58B30T0-375', 510),
 ('LT6', 670),
 ('LT2', 495),
 ('DOHC FSI V10-5.2-456', 612),
 ('M840TE', 612),
 ('M139L', 469);


 -- script de exemplo e nele é possível verificar as etapas que ele priorizou para otimizar 
SELECT
  cars.manufacturer,
  cars.model,
  cars.country,
  cars.year,
  MAX(engines.horse_power) as maximum_horse_power
FROM cars
JOIN engines ON cars.engine_name = engines.name
WHERE cars.year > 2015 AND cars.country = 'Germany'
GROUP BY cars.manufacturer, cars.model, cars.country, cars.year
HAVING MAX(engines.horse_power)> 200
ORDER BY maximum_horse_power DESC
LIMIT 2
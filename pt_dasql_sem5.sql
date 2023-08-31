-- Создаем БД
DROP DATABASE IF EXISTS pt_dasql_sem5; 
CREATE DATABASE IF NOT EXISTS pt_dasql_sem5;
USE pt_dasql_sem5;

CREATE TABLE AUTO_price
(
	id INT NOT NULL PRIMARY KEY,
    Сar_brand VARCHAR(80),
    Сost INT
);

INSERT AUTO_price
  VALUES
	(1, "Audi", 52642),
    (2, "Mercedes", 57127 ),
    (3, "Skoda", 9000 ),
    (4, "Volvo", 29000),
	(5, "Bentley", 350000),
    (6, "Citroen ", 21000 ), 
    (7, "Hummer", 41400), 
    (8, "Volkswagen ", 21600);
    
SELECT * FROM AUTO_price;


-- 1. Создайте представление, в которое попадут автомобили стоимостью до 25 000 долларов
DROP VIEW IF EXISTS Auto_under_25000;
CREATE VIEW Auto_under_25000 
  AS  SELECT id, Сar_brand, Сost
    FROM AUTO_price
  WHERE Сost < 25000;

SELECT * FROM Auto_under_25000;


-- 2. Изменить в существующем представлении порог для стоимости: пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW)
ALTER VIEW Auto_under_25000 
  AS SELECT id, Сar_brand, Сost
    FROM AUTO_price
  WHERE Сost < 30000;

SELECT * FROM Auto_under_25000;


-- 3. Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди”
DROP VIEW IF EXISTS Skoda_and_Audi;
CREATE VIEW Skoda_and_Audi 
  AS SELECT id, Сar_brand, Сost
    FROM AUTO_price
  WHERE Сar_brand IN ("Skoda", "Audi");

SELECT * FROM Skoda_and_Audi;


-- 4. Что-нибудь придумать с этими двумя представлениями
-- Объединим два представления "Auto_under_25000" и "Skoda_and_Audi", возвращая все строки из обоих представлений без повторов.
SELECT * FROM Auto_under_25000
  UNION
SELECT * FROM Skoda_and_Audi;

  
-- 5. Вывести название и цену для всех анализов, которые продавались 5 февраля 2020 и всю следующую неделю.
/*
  Есть таблица анализов Analysis:
an_id — ID анализа;
an_name — название анализа;
an_cost — себестоимость анализа;
an_price — розничная цена анализа;
an_group — группа анализов.
  Есть таблица групп анализов Groups:
gr_id — ID группы;
gr_name — название группы;
gr_temp — температурный режим хранения.
  Есть таблица заказов Orders:
ord_id — ID заказа;
ord_datetime — дата и время заказа;
ord_an — ID анализа.
*/
SELECT an_name, an_price
  FROM Analysis
  INNER JOIN Orders ON Analysis.an_id = Orders.ord_an
WHERE ord_datetime BETWEEN '2020-02-05' AND DATEADD(day, 7, '2020-02-05');


-- 6. Добавьте новый столбец под названием «время до следующей станции». 
/*
Чтобы получить это значение, мы вычитаем время станций для пар смежных станций. 
Мы можем вычислить это значение без использования оконной функции SQL, но это может быть очень сложно. Проще это сделать с помощью оконной функции LEAD . 
Эта функция сравнивает значения из одной строки со следующей строкой, чтобы получить результат. 
В этом случае функция сравнивает значения в столбце «время» для станции со станцией сразу после нее.
*/
DROP TABLE IF EXISTS train;
CREATE TABLE train 
(
  id INT NOT NULL, 
  station VARCHAR(20) NOT NULL,
  station_time TIME NOT NULL
  );
 
INSERT train
  VALUES
	(110, "San Francisco", '10:00:00'),
    (110, "Redwood City", '10:54:00'),
    (110, "Palo Alto", '11:02:00'),
    (110, "San Jose", '12:35:00'),
	(120, "San Francisco", '11:00:00'),
    (120, "Palo Alto", '12:49:00'), 
    (120, "San Jose", '13:30:00');

SELECT * FROM train;

SELECT 
  id AS `train_id  integer`,
  station AS `station character varying(20)`,
  station_time AS `station_time time without time zone`,
  TIMEDIFF(LEAD(station_time) OVER (PARTITION BY id ORDER BY station_time), station_time) AS `time_to_next_station interval`
FROM train;
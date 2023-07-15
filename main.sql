drop table if exists `salesperson`;

-- Salesperson Table
create table `salesperson` (
   `id` int(5) not null auto_increment,
   `name` varchar(255) unique not null,
   primary key (`id`)
);

insert into `salesperson` values 
(1, 'Jim'),
(2, 'Sally'),
(3, 'Jenny');

drop table if exists `vehicle`;

-- Vehicle Table
create table `vehicle` (
   `vin` varchar(17) not null,
   `make` varchar(255) not null,
   `model` varchar(255) not null,
   primary key (`vin`)
);

insert into `vehicle` values
   ('69727AB2697722419', 'Toyota', 'Tercel'),
   ('418557625X042Y034', 'Kia', 'Sedona'),
   ('6267Z2E49D2502855', 'Thunder Cougar', 'Falcon Bird'),
   ('2376511239L29M386', 'Ford', 'F150'),
   ('Z097313925971579A', 'GM', 'Saturn'),
   ('3492677929DM3505C', 'Pontiac', 'Moon'),
   ('65BC51791T4840858', 'Red Rider', 'BB'),
   ('94253753X44C14690', 'Audi', 'Titi'),
   ('105196194194AC8CL', 'Ford', 'Mustang'),
   ('105196194694AC8CX', 'Ford', 'Cayonero');

drop table if exists `vehicle_sale`;

-- Vehicle Sale Table
create table `vehicle_sale` (
   sale_id int(10) primary key not null auto_increment,
   salesperson_id int(5) not null,
   vin_sold varchar(17) not null,
   sale_date timestamp default current_timestamp,
   sale_price decimal(10, 2) not null,
   foreign key (`vin_sold`) references `vehicle` (`vin`)
);

insert into `vehicle_sale` values
   (1, 1, '69727AB2697722419', now(), 3000.00),
   (2, 1, '418557625X042Y034', now(), 16000.00),
   (3, 1, '6267Z2E49D2502855', now(), 2000.00),
   (4, 2, '2376511239L29M386', now(), 4100.00),
   (5, 2, 'Z097313925971579A', now(), 900.00),
   (6, 2, '3492677929DM3505C', now(), 450.00),
   (7, 3, '65BC51791T4840858', now(), 999.99),
   (8, 3, '94253753X44C14690', now(), 100000.00),
   (9, 3, '105196194194AC8CL', now(), 20000.00),
   (10, 3,'105196194694AC8CX', now(), 500.00);

--select the sale_id from vehicle sale where the sales price = top three
--select the salesperson_id from vehicle sale where the sale_id = top three
SELECT sper.name, veh.make, sa.sale_price FROM salesperson sper
INNER JOIN vehicle_sale sa ON sa.salesperson_id = sper.id
INNER JOIN vehicle veh ON veh.vin = sa.vin_sold
WHERE sa.sale_id IN (SELECT sale_id FROM (SELECT sale_id FROM vehicle_sale AS VS 
INNER JOIN (SELECT max(S.sale_price) AS salePrice, SP.id FROM salesperson SP
INNER JOIN vehicle_sale S on S.salesperson_id = SP.id
INNER JOIN vehicle V on V.vin = S.vin_sold 
GROUP BY SP.id) AS topThree ON sale_price = topThree.salePrice
AND salesperson_id = topThree.id) AS topSaleIDs); 

show databases;
create database airport;
show databases;
use airport;
select * from airportprojectsql;
create database titanic;
use titanic;
select * from titanic_data;
select sum(survived),sum(name) from titanic_data
group by
sex;
select sum(sex) from titanic_data group by sex;
create database amazon;
create database world;
use world;
select * from city;
select user();
create database car_dekho;
use car_dekho;
select * from cardekho;
select count(*) as count  from cardekho;
select distinct(brand) as unique_brand from cardekho;
select brand,count(*) as count from cardekho group by brand;
select * from cardekho where brand='hyundai';
select * from cardekho where vehicle_age<5;
select * from cardekho where selling_price between 100000 and 500000;
select * from	 cardekho order by selling_price asc;
select avg(mileage) as avg_mileage from cardekho;
select fuel_type,count(*) as total_count
from cardekho group by fuel_type;
select * from cardekho where mileage >30;
select sum(km_driven) as total_km from cardekho;
select * from cardekho where seats >8;
select seller_type,avg(selling_price) as avg_sell_price from cardekho group by seller_type;
select * from cardekho where engine >2000;
select * from cardekho order by vehicle_age desc limit 5;
select * from cardekho where max_power >150;
select brand,avg(selling_price) as avg_selling_price from cardekho group by 
brand order by avg_selling_price desc;
-- find the most popular brand in the car dekho table 
select brand, count(*) as count from cardekho group by brand order by count desc limit 5;
select fuel_type,transmission_type,avg(selling_price) as avg_sell_price from cardekho group by fuel_type,transmission_type
order by avg_sell_price desc;
select car_name,brand,seats,selling_price,mileage/selling_price as ratio_mileage_selling_price
from cardekho ;
-- identify the car with low mileage and high 	selling price
select * from cardekho where mileage<(select avg(mileage) from cardekho)
and selling_price> (select avg(selling_price) from cardekho)
order by selling_price desc limit 10;
-- retrieve the top 3 expessive car of each brand
select brand,car_name,selling_price from (select *,row_number() over 
(partition by brand order by selling_price desc) as ranks from cardekho)
cardekho where ranks<=3  order by brand,selling_price desc ;
SELECT brand, car_name, selling_price
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY brand ORDER BY selling_price DESC) AS ranks
    FROM cardekho
) ranked_cars
WHERE ranks <= 3
ORDER BY brand, selling_price DESC;
-- find the most common combination  fuel type and transmission type
select fuel_type,transmission_type,count(*) as total_cars
from cardekho 
group by fuel_type,transmission_type
order by total_cars desc limit 10;
use car_dekho;
select * from cardekho;
SELECT 
    brand, COUNT(*) AS total_car
FROM
    cardekho
GROUP BY brand
ORDER BY total_car DESC
LIMIT 10;
-- calculate the average selling price by fuel type and transmission type
select brand,transmission_type,avg(selling_price) as selling_prices from cardekho 
group by brand,transmission_type order by selling_prices desc;
-- find car with the best  mileage with car ratio
SELECT car_name, brand, mileage, selling_price, round((mileage / selling_price),5) AS mileage_to_price_ratio
FROM cardekho
ORDER BY mileage_to_price_ratio DESC
LIMIT 10;
-- identify the car with low mileage and high selling price 
select * from cardekho where mileage<(select avg(mileage) from cardekho)
and selling_price > (select avg(selling_price) from cardekho)
order by selling_price desc;
-- Retrieve the top 3 most expensive by each brand
SELECT brand, car_name, selling_price
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY brand ORDER BY selling_price DESC) AS ranks
    FROM cardekho
) ranked_cars
WHERE ranks <= 3
ORDER BY brand, selling_price DESC;
-- find the common combination of fuel and transmission type
select fuel_type,transmission_type,count(*) as total_car from cardekho
group by fuel_type,transmission_type order by total_car desc;
-- calculate the depreciation percentage of each car
-- rank car based on mileage ,price,and power (multi factor rank)
select car_name,brand,mileage,max_power,selling_price ,rank() over (order by
mileage desc,selling_price desc,max_power desc) as ranks from cardekho order by ranks;
-- identify the brand with highest average mileage
select brand,avg(mileage) as avg_mileage from cardekho group by brand
order by avg_mileage desc;
-- Analysis the selling price trend by vehicle age 
select vehicle_age,avg(selling_price) as avg_sel_price from cardekho
group by vehicle_age order by avg_sel_price desc limit  10;
-- find car with unsual engine size for their brand
SELECT *
FROM cardekho c1
WHERE engine > (
    SELECT AVG(engine) +(select * from hello)
    FROM cardekho c2
    WHERE c1.brand = c2.brand
)
ORDER BY engine DESC;
create view hello as
select 2*stddev(engine) from cardekho;
select * from hello;
use car_dekho;
-- determine the revenue contribution of each seller type
select seller_type,sum(selling_price) as total_selling_price,
(sum(selling_price) * 100 / (select sum(selling_price) from cardekho )) as revenue_percentage
from cardekho group by seller_type order by total_selling_price desc;
-- identify the most frequent car sold
select model,count(*) as total_car from cardekho group by
model order by total_car desc limit 10;
-- predict selling price based on mileage and the vehicle age
select mileage,vehicle_age,selling_price,round(selling_price/ (selling_price* mileage),2)*100
as price_per_mileage_age from cardekho
where mileage>0 and vehicle_age>0  order by
price_per_mileage_age;
-- detect car with very high kilometer driven relative to age
select car_name,brand,vehicle_age,km_driven,(km_driven/vehicle_age) as km_per_year
from cardekho
where 
vehicle_age>0
order by
km_per_year
desc limit 10;
-- identify the brand with highest reveneu contribute in the table
select brand,sum(selling_price) as total_selling_price
from cardekho group by brand
order by total_selling_price desc limit 10;
-- compare avearge selling price between automatic and mannual car
-- transimission  by fuel
select fuel_type,transmission_type,avg(selling_price)as total_price
from cardekho group by fuel_type,transmission_type order by total_price desc;
-- Find the Cars That Deviate Significantly in Selling Price for Their Brand

SELECT car_name, brand, selling_price, 
       AVG(selling_price) OVER (PARTITION BY brand) AS avg_brand_price,
       ABS(selling_price - AVG(selling_price) OVER (PARTITION BY brand)) AS price_deviation
FROM cardekho
ORDER BY price_deviation DESC
LIMIT 10;
-- find the that are both old and highly driven 
select car_name,brand,vehicle_age,km_driven
from cardekho
where vehicle_age>(select avg(vehicle_age) from cardekho) and
km_driven> (select avg(km_driven) from cardekho)
order by km_driven desc,vehicle_age desc limit 5;
select 
case
when vehicle_age<=2 then '0-2 years'
when vehicle_age between 3 and 5 then '3-5 years'
when vehicle_age between 6 and 10 then '6-10 year'
else '10+ year'
end as age_group,
count(*) as total_cars
from cardekho 
group by age_group
order by total_cars desc;
-- find the most ecomical car by fuel  	type ( mileage and price combining)
-- identify the car with rare features (low count by modal)
select model,count(*) as model_count from cardekho 
group by model 
having model_count=1
order by model_count desc;
-- calculate the percentage of automatic vs mannual car
select transmission_type,count(*) as total_count,count(*) * 100/ (select  count(*) from cardekho)
as percentage from cardekho group by transmission_type ;
-- analysis the car that are overpriced based on age and mileage
select car_name,brand,selling_price,vehicle_age,mileage,
(selling_price/mileage*vehicle_age ) as price_factor
from cardekho
where vehicle_age>0 and mileage>0
order by price_factor desc limit 5;
use car_dekho;
select * from cardekho;










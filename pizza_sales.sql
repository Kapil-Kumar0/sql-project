select * from pizza_sales

select * from pizza_sales where pizza_name_id is null

select * from pizza_sales where pizza_id is null
or order_id is null
or pizza_name_id is null
or quantity is null
or order_date is null
or unit_price is null
or total_price is null
or pizza_size is null
or pizza_category is null
or pizza_ingredients is null
or pizza_name is null;

select count(distinct order_id ) as total_order from pizza_sales;

select sum(quantity) as total_pizza_sold from pizza_sales;

select distinct pizza_category from pizza_sales;

select distinct pizza_size from pizza_sales;

select round(sum(total_price),2) as total_revenue_generate from pizza_sales;

select pizza_size,sum(total_price) as size_wise_total_revenue from 
pizza_sales group by pizza_size order by size_wise_total_revenue desc;

select pizza_name,sum(quantity) as pizza_wise_quantity from pizza_sales group by 
pizza_name order by pizza_wise_quantity desc ;

select pizza_name,sum(total_price) as total_price from pizza_sales 
group by pizza_name order by total_price desc;

select * from pizza_sales;

SELECT order_date, SUM(total_price) AS daily_revenue
FROM pizza_sales
GROUP BY order_date
ORDER BY daily_revenue desc;


SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_price) AS monthly_revenue
FROM pizza_sales
GROUP BY month
ORDER BY month;

SELECT DAYNAME(order_date) AS day_of_week, COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY day_of_week
ORDER BY total_orders DESC;

SELECT AVG(quantity) AS avg_pizzas_per_order
FROM pizza_sales;

SELECT pizza_category, SUM(quantity) AS total_quantity_sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_quantity_sold DESC
;

SELECT pizza_size, SUM(quantity) AS total_quantity_sold
FROM pizza_sales
GROUP BY pizza_size
ORDER BY total_quantity_sold DESC
;

SELECT DISTINCT pizza_ingredients
FROM pizza_sales;

SELECT pizza_ingredients, COUNT(*) AS usage_count
FROM pizza_sales
GROUP BY pizza_ingredients
ORDER BY usage_count DESC
;

SELECT pizza_name
FROM pizza_sales
WHERE pizza_ingredients LIKE '%Pepperoni%';


SELECT pizza_category, pizza_size, SUM(total_price) AS total_revenue
FROM pizza_sales
GROUP BY pizza_category, pizza_size
ORDER BY pizza_category, pizza_size;


SELECT pizza_name, SUM(total_price) AS total_revenue
FROM pizza_sales
GROUP BY pizza_name
HAVING total_price > (SELECT AVG(total_price) FROM pizza_sales);

SELECT order_id, SUM(quantity) AS total_pizzas
FROM pizza_sales
where total_pizzas > 5
GROUP BY order_id

select order_id,sum(quantity) as total_quantity
from pizza_sales  
group by order_id 

SELECT *
FROM pizza_sales
WHERE pizza_id IS NULL
   OR order_id IS NULL
   OR pizza_name_id IS NULL
   OR quantity IS NULL
   OR order_date IS NULL
   OR order_time IS NULL
   OR unit_price IS NULL
   OR total_price IS NULL
   OR pizza_size IS NULL
   OR pizza_category IS NULL
   OR pizza_ingredients IS NULL
   OR pizza_name IS NULL;


   SELECT
    COUNT(CASE WHEN pizza_id IS NULL THEN 1 END) AS null_pizza_id,
    COUNT(CASE WHEN order_id IS NULL THEN 1 END) AS null_order_id,
    COUNT(CASE WHEN pizza_name_id IS NULL THEN 1 END) AS null_pizza_name_id,
    COUNT(CASE WHEN quantity IS NULL THEN 1 END) AS null_quantity,
    COUNT(CASE WHEN order_date IS NULL THEN 1 END) AS null_order_date,
    COUNT(CASE WHEN order_time IS NULL THEN 1 END) AS null_order_time,
    COUNT(CASE WHEN unit_price IS NULL THEN 1 END) AS null_unit_price,
    COUNT(CASE WHEN total_price IS NULL THEN 1 END) AS null_total_price,
    COUNT(CASE WHEN pizza_size IS NULL THEN 1 END) AS null_pizza_size,
    COUNT(CASE WHEN pizza_category IS NULL THEN 1 END) AS null_pizza_category,
    COUNT(CASE WHEN pizza_ingredients IS NULL THEN 1 END) AS null_pizza_ingredients,
    COUNT(CASE WHEN pizza_name IS NULL THEN 1 END) AS null_pizza_name
FROM pizza_sales;

SELECT
    order_date,
    SUM(total_price) OVER (ORDER BY order_date) AS cumulative_revenue
FROM pizza_sales
GROUP BY order_date
ORDER BY order_date;

SELECT
    order_date,
    AVG(SUM(total_price)) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg_revenue
FROM pizza_sales
GROUP BY order_date
ORDER BY order_date;

SELECT
    pizza_category,
    SUM(total_price) AS category_revenue,
    ROUND(SUM(total_price) / (SELECT SUM(total_price) FROM pizza_sales) * 100, 2) AS revenue_percentage
FROM pizza_sales
GROUP BY pizza_category
ORDER BY revenue_percentage DESC;


WITH ranked_pizzas AS (
    SELECT
        pizza_category,
        pizza_name,
        SUM(quantity) AS total_quantity,
        RANK() OVER (PARTITION BY pizza_category ORDER BY SUM(quantity) DESC) AS rank
    FROM pizza_sales
    GROUP BY pizza_category, pizza_name
)
SELECT pizza_category, pizza_name, total_quantity
FROM ranked_pizzas
WHERE rank = 1;

SELECT
    order_id,
    COUNT(*) AS order_count
FROM pizza_sales
GROUP BY order_id
HAVING order_count > 5
ORDER BY order_count DESC;

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(total_price) AS revenue
    FROM pizza_sales
    GROUP BY month
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month) * 100, 2) AS growth_rate
FROM monthly_revenue
ORDER BY month;



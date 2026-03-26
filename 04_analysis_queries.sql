-- Analytic Queries

-- what was the total sales revenue in january,2020
select *
  from sales_fact;
desc sales_fact;
desc time_dim;
select t.month,
       t.year,
       sum(f.total_sales) as total_sales
  from sales_fact f,
       time_dim t
 where t.time_id = f.time_id
   and trim(t.month) = 'January'
   and trim(t.year) = '2020'
 group by t.month,
          t.year;

-- how many pieces of equipment were sold in Winter, 2018
select se.season_name,
       t.year,
       sum(f.num_of_equipment) as number_of_equipments
  from sales_fact f
  join time_dim t
on t.time_id = f.time_id
  join season_dim se
on t.season_id = se.season_id
   and trim(se.season_name) = 'Winter'
   and trim(t.year) = '2018'
 group by se.season_name,
          t.year;

-- how many equipment was hired by business customers
select cus.description,
       sum(f.num_of_equipment) as number_of_equipments
  from sales_fact f,
       customer_type_dim cus
 where cus.customer_type_id = f.customer_type_id
   and cus.description = 'Business'
 group by cus.description;

-- what was the total hire revenue in clayton branch
select *
  from hire_fact;
select company_branch,
       sum(total_hire) as total_hire_revenue
  from hire_fact
 where company_branch = 'Clayton'
 group by company_branch;

-- How many trailers were hired by individual customers in Summer?
select c.category_description,
       cus.description,
       se.season_name,
       sum(h.num_of_equipment) as number_of_equipments
  from hire_fact h
  join category_dim c
on h.category_id = c.category_id
  join customer_type_dim cus
on h.customer_type_id = cus.customer_type_id
  join time_dim t
on t.time_id = h.time_id
  join season_dim se
on t.season_id = se.season_id
 where c.category_description = 'Trailers'
   and cus.description = 'Individual'
   and se.season_name = 'Summer'
 group by c.category_description,
          cus.description,
          se.season_name;

-- What is the average sale revenue for Lighting equipment in 2019?
select c.category_description,
       t.year,
       round(
          (sum(s.total_sales) / sum(s.num_of_equipment)),
          2
       ) as average_sales_revenue_per_equipment,
       round(
          (sum(s.total_sales) / sum(s.num_of_transaction)),
          2
       ) as average_sales_revenue_per_transaction
  from sales_fact s
  join category_dim c
on c.category_id = s.category_id
  join time_dim t
on s.time_id = t.time_id
 where c.category_description = 'Lighting'
   and t.year = '2019'
 group by c.category_description,
          t.year;

select *
  from sales_fact;


-- What is the average hire revenue for Vehicles by individual customers?
select c.category_description,
       cus.description,
       round(
          (sum(h.total_hire) / sum(h.num_of_equipment)),
          2
       ) as average_hire_revenue_per_equipment,
       round(
          (sum(h.total_hire) / sum(h.num_of_transaction)),
          2
       ) as average_hire_revenue_per_transaction
  from hire_fact h
  join category_dim c
on c.category_id = h.category_id
  join customer_type_dim cus
on h.customer_type_id = cus.customer_type_id
 where c.category_description = 'Vehicles'
   and cus.description = 'Individual'
 group by c.category_description,
          cus.description;


-- How much sales revenue was generated from a high sale in Summer?
select s.price_tag,
       se.season_name,
       sum(s.total_sales) as total_sales_revenue
  from sales_fact s
  join time_dim t
on s.time_id = t.time_id
  join season_dim se
on t.season_id = se.season_id
 where s.price_tag = 'High'
   and se.season_name = 'Summer'
 group by s.price_tag,
          se.season_name;

-- Data Analytics Stage 
select company_branch,
       sum(f.total_sales) as total_sales,
       sum(f.num_of_equipment) as number_of_equipments
  from sales_fact f
 group by company_branch
 order by total_sales;

select c.category_description,
       sum(f.total_hire) as total_hire,
       sum(f.num_of_equipment) as number_of_equipments
  from hire_fact f
  join time_dim t
on t.time_id = f.time_id
  join category_dim c
on c.category_id = f.category_id
 group by c.category_description
 order by number_of_equipments;
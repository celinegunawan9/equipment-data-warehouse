-- A. Data Exploration for MonEquip Database

-- Address -> customer address information
drop table monequip_address;
create table monequip_address
   as
      select *
        from monequip.address;

-- Category -> category information
drop table monequip_category;
create table monequip_category
   as
      select *
        from monequip.category;

-- Customer -> customer information
drop table monequip_customer;
create table monequip_customer
   as
      select *
        from monequip.customer;

-- customer_type -> customer type information
drop table monequip_customer_type;
create table monequip_customer_type
   as
      select *
        from monequip.customer_type;

-- equipment -> equipment information
drop table monequip_equipment;
create table monequip_equipment
   as
      select *
        from monequip.equipment;

-- hire -> hire information
-- unit_hire_price : hiring rate per day
drop table monequip_hire;
create table monequip_hire
   as
      select *
        from monequip.hire;

-- sales -> sales information
drop table monequip_sales;
create table monequip_sales
   as
      select *
        from monequip.sales;

-- staff -> information of staff
drop table monequip_staff;
create table monequip_staff
   as
      select *
        from monequip.staff;

-- B. Data Cleaning 
-- handling incomplete/missing data 
select distinct customer_type_id
  from monequip_customer;
select *
  from monequip_customer_type;

-- handling duplicate values
select customer_id,
       customer_type_id,
       name,
       gender,
       address_id,
       phone,
       email,
       count(*)
  from monequip_customer
 group by customer_id,
          customer_type_id,
          name,
          gender,
          address_id,
          phone,
          email
having count(*) > 1;

drop table monequip_customer;
create table monequip_customer
   as
      select distinct *
        from monequip.customer;

-- handling duplicate and inconsistent values
select distinct *
  from monequip_customer_type;

update monequip_customer_type
   set
   description = 'Business'
 where lower(description) in ( 'business' );

create table monequip_customer_type_2 as 
 select distinct *
  from monequip_customer_type;

-- handling inconsistent values
select distinct street_name,
                street_number,
                suburb,
                state,
                postcode
  from monequip_address
 order by suburb;

select *
  from monequip_address
 where street_name like 'Oakdean%';

update monequip_address
   set
   street_name = 'Oakdean Boulevard'
 where lower(street_name) in ( 'oakdean blvd' );

select distinct ( gender )
  from monequip_customer;

update monequip_customer
   set
   gender = 'Male'
 where gender = 'M';

update monequip_customer
   set
   gender = 'Female'
 where gender = 'F'; 

select distinct ( manufacturer )
  from monequip_equipment;
update monequip_equipment
   set
   manufacturer = 'Hitachi'
 where upper(manufacturer) in ( 'HITACHI' );

-- handling invalid values 
select *
  from monequip_hire
 where start_date > end_date;
delete from monequip_hire
 where start_date > end_date;

select distinct equipment_id
  from monequip_equipment
 order by equipment_id;
select *
  from monequip_hire
 where equipment_id > 158
    or equipment_id < 1;
delete from monequip_hire
 where equipment_id > 158
    or equipment_id < 1;

select customer_id
  from monequip_customer
 order by customer_id;
select *
  from monequip_hire
 where customer_id > 150
    or customer_id < 1;
delete from monequip_hire
 where customer_id > 150
    or customer_id < 1;

select *
  from monequip_hire
 where staff_id > 50;

delete from monequip_hire
 where staff_id > 50;

select * from monequip_sales;
delete from monequip_sales
 where quantity < 0
    or unit_sales_price < 0
    or total_sales_price < 0;

-- MonEquip only records transaction from April 2018 to December 2020
select *
  from monequip_hire
 where start_date < to_date('01/04/2018','DD/MM/YYYY')
    or end_date > to_date('31/12/2020','DD/MM/YYYY');
delete from monequip_hire
 where start_date < to_date('01/04/2018','DD/MM/YYYY')
    or end_date > to_date('31/12/2020','DD/MM/YYYY');

-- if customer returns equipment the same day, they only need to pay 50% of unit_hire_price
-- otherwise, total_hire_price is (End_Date - Start_Date) * Unit_Hire_Price * Quantity.
select * from monequip_hire;
update monequip_hire
   set total_hire_price = CASE
   when (end_date-start_date)=0 then (unit_hire_price/2)
   else 
   ( end_date - start_date ) * unit_hire_price * quantity
   end;

-- string 'null' to Unknown (not recorded in report)
select * from monequip_category;
update monequip_category
   set
   category_description = 'Unknown'
 where lower(category_description) in ( 'null' );
   

        
          



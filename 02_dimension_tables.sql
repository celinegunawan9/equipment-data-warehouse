-- Dimension tables

-- season_dim
create table season_dim (
   season_id   number primary key,
   season_name varchar2(10)
);

insert into season_dim values ( 1,
                                'Summer' );
insert into season_dim values ( 2,
                                'Autumn' );
insert into season_dim values ( 3,
                                'Winter' );
insert into season_dim values ( 4,
                                'Spring' );

-- time_dim
drop table time_dim;

create table time_dim
   as
      select distinct to_char(
         sales_date,
         'yyyy/mm'
      ) as time_id,
                      to_char(
                         sales_date,
                         'Month'
                      ) as month,
                      to_char(
                         sales_date,
                         'yyyy'
                      ) as year
        from monequip_sales
      union
      select distinct to_char(
         start_date,
         'yyyy/mm'
      ) as time_id,
                      to_char(
                         start_date,
                         'Month'
                      ) as month,
                      to_char(
                         start_date,
                         'yyyy'
                      ) as year
        from monequip_hire;

alter table time_dim add season_id number;
update time_dim
   set
   season_id =
      case
         when trim(month) in ( 'December',
                               'January',
                               'February' ) then
            1
         when trim(month) in ( 'March',
                               'April',
                               'May' ) then
            2
         when trim(month) in ( 'June',
                               'July',
                               'August' ) then
            3
         when trim(month) in ( 'September',
                               'October',
                               'November' ) then
            4
      end;

-- customer_type_dim
drop table customer_type_dim;

create table customer_type_dim
   as
      select *
        from monequip_customer_type_2;

select *
  from customer_type_dim;

-- branch_dim
select *
  from monequip_staff;

drop table branch_dim;

create table branch_dim
   as
      select distinct company_branch
        from monequip_staff;
select *
  from branch_dim;

-- category_dim
drop table category_dim;

create table category_dim
   as
      select *
        from monequip_category;
select *
  from category_dim;

-- sales_price_scale_dim
drop table sales_price_scale_dim;

create table sales_price_scale_dim (
   price_tag   varchar2(10),
   description varchar2(50)
);

insert into sales_price_scale_dim values ( 'Low',
                                           'Sales < $5,000' );
insert into sales_price_scale_dim values ( 'Medium',
                                           '$5,000 < Sales < $10,000' );
insert into sales_price_scale_dim values ( 'High',
                                           'Sales > $5,000' );
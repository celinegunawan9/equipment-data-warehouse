-- Fact tables

-- Sales Fact
drop table sales_fact;

create table sales_fact
   as
      select cus.customer_type_id,
             to_char(
                s.sales_date,
                'YYYY/MM'
             ) as time_id,
             e.category_id,
             st.company_branch,
             count(*) as num_of_transaction,
             sum(s.quantity) as num_of_equipment,
             sum(s.total_sales_price) as total_sales
        from monequip_customer cus,
             monequip_sales s,
             monequip_equipment e,
             monequip_staff st
       where cus.customer_id = s.customer_id
         and e.equipment_id = s.equipment_id
         and st.staff_id = s.staff_id
       group by cus.customer_type_id,
                to_char(
                   s.sales_date,
                   'YYYY/MM'
                ),
                e.category_id,
                st.company_branch;

alter table sales_fact add (
   price_tag varchar2(10)
);
update sales_fact
   set
   price_tag =
      case
         when total_sales < 5000                 then
            'Low'
         when total_sales between 5000 and 10000 then
            'Medium'
         when total_sales > 10000                then
            'High'
      end;


-- Hire fact
drop table hire_fact;

create table hire_fact
   as
      select cus.customer_type_id,
             to_char(
                h.start_date,
                'YYYY/MM'
             ) as time_id,
             e.category_id,
             st.company_branch,
             count(*) as num_of_transaction,
             sum(h.quantity) as num_of_equipment,
             sum(h.total_hire_price) as total_hire
        from monequip_hire h
        left join monequip_customer c
      on c.customer_id = h.customer_id
        left join monequip_customer_type_2 cus
      on cus.customer_type_id = c.customer_type_id
        join monequip_equipment e
      on e.equipment_id = h.equipment_id
        join monequip_staff st
      on st.staff_id = h.staff_id
       group by cus.customer_type_id,
                to_char(
                   h.start_date,
                   'YYYY/MM'
                ),
                e.category_id,
                st.company_branch;

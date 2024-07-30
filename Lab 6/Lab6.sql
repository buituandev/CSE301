use salemanagement;
set sql_safe_updates = 0;

-- 1. How to check constraint in a table?
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'salesman';

-- 2. Create a separate table name as “ProductCost” from “Product” table
-- which contains the information about product name and its buying price.
create table if not exists ProductCost(
    productName varchar(255) not null,
    buyingPrice decimal(10,2) not null
);

insert into ProductCost(productName,buyingPrice)
select product_name, cost_price
from product;

-- 3. Compute the profit percentage for all products. Note: profit = (sell-cost)/cost*100
alter table product add column profit float;
-- select *, (Sell_Price - Cost_Price)/Cost_Price * 100
-- from product;
update product set profit = (Sell_Price - Cost_Price)/Cost_Price * 100;

-- 4. If a salesman exceeded his sales target by more than equal to 75%, his remarks should be ‘Good’.
alter table salesman add column remark varchar(250);
update salesman set remark = 'Good' where Target_Achieved >= Sales_Target*0.75;
select * from salesman;

-- 5. If a salesman does not reach more than 75% of his sales objective, he is labeled as 'Average'.
update salesman set remark = 'Average' where Target_Achieved < Sales_Target*0.75;
select * from salesman;

-- 6. If a salesman does not meet more than half of his sales objective, he is considered 'Poor'.
update salesman set remark = 'Poor' where Target_Achieved <= Sales_Target*0.5;
select * from salesman;

-- 7. Find the total quantity for each product.
select Product_Name, (Quantity_On_Hand+Quantity_Sell) as Total_quantity from product;

-- 8. Add a new column and find the total quantity for each product
alter table product add column totalQuantity int;
update product set totalQuantity = Quantity_On_Hand+Quantity_Sell;
select * from product;

-- 9. If the Quantity on hand for each product is more than 10, change the discount rate to 10 otherwise set to 5
-- select *, case when product.Quantity_On_Hand >10 then 10 else 5 end as discountRate from product;
select *, IF(product.Quantity_On_Hand > 10, 10, 5) as discountRate from product;

-- 10. If the Quantity on hand for each product is more than equal to 20, change the discount rate to 10, if it is between 10 and 20 then change to 5, if it is more than 5 then change to 3 otherwise set to 0.
select *, case when Quantity_On_Hand>=20 then 10
               when Quantity_On_Hand between 10 and 20 then 5
               when Quantity_On_Hand > 5 then 3 else 0 end as discountRate
from product;

-- 11. The first number of pin code in the client table should be start with 7.
alter table Clients
add CONSTRAINT chk_pin_code check (Pincode like '7%');


-- 12. Creates a view name as clients_view that shows all customers information from Thu Dau Mot.
create view clients_view as select * from clients where City = 'Thu Dau Mot';

-- 13. Drop the “client_view”.
drop view if exists clients_view;

-- 14. Creates a view name as clients_order that shows all clients and their order details from Thu Dau Mot.
create view clients_order as
select clients.*, so.* from clients
join salesorder on clients.Client_Number = salesorder.Client_Number
join salesorderdetails so on salesorder.Order_Number = so.Order_Number
where clients.City = 'Thu Dau Mot';

-- 15. Creates a view that selects every product in the "Products" table with a sell price higher than the average
-- sell price.
create view products_above_avg_price as
select * from product
where Sell_Price > (select avg(Sell_Price) from product);

-- 16. Creates a view name as salesman_view that show all salesman information and products (product names,
-- product price, quantity order) were sold by them.
create view salesman_view as
select salesman.*, product.Product_Name, product.Sell_Price, salesorderdetails.Order_Quantity
from salesman
join salesorder s on salesman.Salesman_Number = s.Salesman_Number
join salesorderdetails on s.Order_Number = salesorderdetails.Order_Number
join product on salesorderdetails.Product_Number = product.Product_Number;

-- 17. Creates a view name as sale_view that show all salesman information and product (product names,
-- product price, quantity order) were sold by them with order_status = 'Successful'.
create view sale_view as
select salesman.*, product.Product_Name, product.Sell_Price, salesorderdetails.Order_Quantity
from salesman
         join salesorder s on salesman.Salesman_Number = s.Salesman_Number
         join salesorderdetails on s.Order_Number = salesorderdetails.Order_Number
         join product on salesorderdetails.Product_Number = product.Product_Number
where Order_Status = 'Successful';

-- 18. Creates a view name as sale_amount_view that show all salesman information and sum order quantity
-- of product greater than and equal 20 pieces were sold by them with order_status = 'Successful'.
create view sale_amount_view as
select salesman.*, sum(Salesorderdetails.Order_Quantity) AS Total_Quantity
from salesman
         join salesorder s on salesman.Salesman_Number = s.Salesman_Number
         join salesorderdetails on s.Order_Number = salesorderdetails.Order_Number
         join product on salesorderdetails.Product_Number = product.Product_Number
where Order_Status = 'Successful'
group by Salesman.Salesman_Number
having Total_Quantity >= 20;

-- 19. Amount paid and amounted due should not be negative when you are inserting the data.
alter table Clients
add CONSTRAINT chk_amount_paid check (Amount_Paid>=0);
alter table Clients
add CONSTRAINT chk_amount_due check (Amount_Due>=0);

-- 20. Remove the constraint from pincode;
alter table clients
drop CONSTRAINT chk_pin_code;

-- 21. The sell price and cost price should be unique
alter table product
add constraint unique_sell_cost UNIQUE (Sell_Price, Cost_Price);

-- 22. The sell price and cost price should not be unique.
alter table product
drop constraint unique_sell_cost;

-- 23. Remove unique constraint from product name.
alter table product
drop constraint product_name;

-- 24. Update the delivery status to “Delivered” for the product number P1007.
update salesorder
join salesorderdetails on salesorder.Order_Number = salesorderdetails.Order_Number
set salesorder.Delivery_Status = 'Delivered'
where salesorderdetails.Product_Number = 'P1007';

-- 25. Change address and city to ‘Phu Hoa’ and ‘Thu Dau Mot’ where client number is C104.
update clients
set City = 'Thu Dau Mot', Address = 'Phu Hoa'
where Client_Number = 'C104';

-- 26. Add a new column to “Product” table named as “Exp_Date”, data type is Date
alter table product
add column Exp_Date Date;

-- 27. Add a new column to “Clients” table named as “Phone”, data type is varchar and size is 15.
alter table clients
add column phone varchar(15);

-- 28. Update remarks as “Good” for all salesman.
update salesman
set remark = 'Good';

-- 29. Change remarks to "bad" whose salesman number is "S004".
update salesman
set remark = 'Bad'
where salesman_number = 'S004';

-- 30. Modify the data type of “Phone” in “Clients” table with varchar from size 15 to size is 10.
alter table clients
modify column phone varchar(10);

-- 31. Delete the “Phone” column from “Clients” table.
alter table clients
drop column phone;

-- 33. Change the sell price of Mouse to 120
update product
set Sell_Price = 120
where Product_Name  = 'Mouse';

-- 34. Change the city of client number C104 to “Ben Cat”.
update clients
set city = 'Ben Cat'
where client_number = 'C104';

-- 35. If On_Hand_Quantity greater than 5, then 10% discount. 
-- If On_Hand_Quantity greater than 10, then 15% discount. Othrwise, no discount
select *,
case when Quantity_On_Hand > 10 then 15
when Quantity_On_Hand > 5 then 10 else 0
end as discountRate from product;

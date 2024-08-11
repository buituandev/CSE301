use salemanagement;
-- 1. Create a trigger before_total_quantity_update to update total quantity of product when
-- Quantity_On_Hand and Quantity_sell change values. Then Update total quantity when Product P1004
-- have Quantity_On_Hand = 30, quantity_sell =35.
delimiter $$
create trigger before_total_quantity_update
    before update
    on product
    for each row
begin
    set NEW.totalQuantity = NEW.Quantity_On_Hand + NEW.Quantity_Sell;
end$$
delimiter ;

update product
set Quantity_On_Hand = 30,
    Quantity_Sell    = 35
where Product_Number = 'P1004';

-- 2. Create a trigger before_remark_salesman_update to update Percentage of per_remarks in a salesman
-- table (will be stored in PER_MARKS column) : per_remarks = target_achieved*100/sales_target.
alter table salesman
    add per_remark decimal(15, 2);

delimiter $$
create TRIGGER before_remark_salesman_update
    BEFORE UPDATE
    on salesman
    for EACH ROW
BEGIN
    set NEW.per_remark = NEW.Target_Achieved * 100 / NEW.Sales_Target;
end;
$$

update salesman
set Sales_Target = 50
where salesman_number = 'S001';

select *
from salesman;

-- 3. Create a trigger before_product_insert to insert a product in product table.
delimiter $$
create trigger before_product_insert
    before insert
    on product
    for EACH ROW
begin
    if NEW.Product_Number is null then
        set new.Product_Name = now();
    end if;
end;
$$

-- 4. Create a trigger to before update the delivery status to "Delivered" when an order is marked as
-- "Successful".
delimiter $$
create TRIGGER before_update_delivery_status
    BEFORE update
    on salesorder
    for each row
begin
    if new.order_status = 'Successful' then
        set new.Delivery_Status = 'Delivered';
    end if;
end;
$$

update salesorder
set Order_Status = 'Successful'
where Order_Number = 'O20013';

-- 5. Create a trigger to update the remarks "Good" when a new salesman is inserted
delimiter $$
create trigger before_insert_remark
    before insert
    on salesman
    for each row
begin
    set new.remark = 'Good';
end;
$$

insert into salesman (Salesman_Number, Salesman_Name, Address, City, Pincode, Province, Salary, Sales_Target,
                      Target_Achieved, Phone)
values ('S009', 'Hue', 'Hoa Phu', 'Thu Dau Mot', 700051, 'Binh Duong', 13500.0000, 50, 75, 0995213659);

select *
from salesman;

-- 6. Create a trigger to enforce that the first digit of the pin code in the "Clients" table must be 7
delimiter $$
create trigger check_pin_code
    before insert
    on Clients
    for each row
begin
    if new.Pincode not like '7%' then
        set new.Pincode = concat('7', substring(new.pincode, 2));
    end if;
end $$
insert into clients (Client_Number, Client_Name, Pincode, Amount_Paid, Amount_Due)
values ('C011', 'Hue', 850721, 13500.0000, 145);

-- 7. Create a trigger to update the city for a specific client to "Unknown" when the client is deleted
create table client_deleted
(
    client_number varchar(255),
    city          varchar(255)
);

delimiter $$
create trigger update_city_to_unknown
    after delete
    on clients
    for each row
begin
    insert into clients_deleted (Client_Number, city)
    values (old.Client_Number, 'Unknown');
end;
$$

delete
from clients
where Client_Number = 'C011';

select *
from clients_deleted;

-- 8. Create a trigger after_product_insert to insert a product and update profit and total_quantity in product
-- table.
create table product_after
(
    Product_Number   varchar(15),
    Product_Name     varchar(25)    not null unique,
    Quantity_On_Hand int            not null,
    Quantity_Sell    int            not null,
    Sell_Price       decimal(15, 4) not null,
    Cost_Price       decimal(15, 4) not null,
    profit           int,
    total_quantity   float
);

delimiter $$
create trigger after_product_insert
    after insert
    on product
    for EACH ROW
begin
    set @profit = ((new.Sell_Price / new.Cost_Price) - 1) * 100, @total_quantity = new.Quantity_On_Hand + new.Quantity_Sell;
    insert into product_after(product_number, product_name, quantity_on_hand, quantity_sell, sell_price, cost_price,
                              profit, total_quantity) value (new.Product_Number, new.Product_Name, new.Quantity_On_Hand,
                                                             new.Quantity_Sell, new.Sell_Price, new.Cost_Price, @profit,
                                                             @total_quantity);
end;
$$
drop trigger after_product_insert;
insert into product(Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, Sell_Price, Cost_Price, Exp_Date)
values ('P1010', 'RAM64', 200, 500, 9000.0000, 1900.0000, null);


-- 9. Create a trigger to update the delivery status to "On Way" for a specific order when an order is inserted.
delimiter $$
create trigger update_delivery_status
    before insert
    on salesorder
    for each row
begin
    if new.Delivery_Status is null then
        set new.Delivery_Status = 'On Way';
    end if;
end;
$$

insert into salesorder
values ('O20017', '2022-05-18', 'C109', 'S008', 'Delivered', null, 'In Process');

-- 10. Create a trigger before_remark_salesman_update to update Percentage of per_remarks in a salesman
-- table (will be stored in PER_MARKS column) If per_remarks >= 75%, his remarks should be ‘Good’.
-- If 50% <= per_remarks < 75%, he is labeled as 'Average'. If per_remarks <50%, he is considered
-- 'Poor'.
drop trigger before_remark_salesman_update;

delimiter $$
create trigger before_remark_salesman_update
    before update
    on salesman
    for EACH ROW
BEGIN
    set new.per_remark = new.Target_Achieved * 100 / new.Sales_Target;
    if new.per_remark >= 75 then
        set new.remark = 'Good';
    elseif new.per_remark >= 50 then
        set new.remark = 'Average';
    else
        set new.remark = 'Poor';
    end if;
end;
$$

update salesman
set Sales_Target = 50
where salesman_number = 'S001';

select *
from salesman;

-- 11. Create a trigger to check if the delivery date is greater than the order date, if not, do not insert it.
delimiter $$
create trigger check_delivery_date
    before insert
    on salesorder
    for each row
begin
    if new.Delivery_Date <= new.Order_Date then
        SIGNAL SQLSTATE '45000'
            set MESSAGE_TEXT = 'Delivery date must be greater than order date';
    end if;
end;
$$
insert into salesorder
values ('O20018', '2022-05-18', 'C108', 'S007', 'Delivered', '2022-05-15', 'Successful');

-- 12. Create a trigger to update Quantity_On_Hand when ordering a product (Order_Quantity)
delimiter $$
create trigger update_quantity_on_hand
    after insert
    ON salesorderdetails
    for EACH ROW
begin
    update product
    set Quantity_On_Hand = Quantity_On_Hand - new.Order_Quantity
    WHERE Product_Number = new.Product_Number;
end;
$$
insert into salesorderdetails
values ('O20017', 'P1001', 5);

use salemanagement;

-- Functions
-- 1. Find the average salesman’s salary.
delimiter $$
create function avg_salesman_salary()
    returns decimal(10, 2)
    deterministic
begin
    declare avg_salary decimal(10, 2);
    select avg(salary) into avg_salary from salesman;
    return avg_salary;
end;
$$

select avg_salesman_salary();

-- 2. Find the name of the highest paid salesman.
delimiter $$
create function highest_paid_salesman()
    returns varchar(50)
    deterministic
begin
    declare name varchar(50);

    select Salesman_Name
    into name
    from salesman
    order by Salary desc
    limit 1;
    return name;
end;
$$

select highest_paid_salesman();

-- 3. Find the name of the salesman who is paid the lowest salary.
delimiter $$
create function lowest_paid_salesman()
    returns varchar(50)
    deterministic
begin
    declare name varchar(50);

    select Salesman_Name
    into name
    from salesman
    order by Salary
    limit 1;
    return name;
end;
$$

select lowest_paid_salesman();

-- 4. Determine the total number of salespeople employed by the company.
delimiter $$
create function total_salespeople()
    returns int
    deterministic
begin
    declare total int;
    select count(*)
    into total
    from salesman;
    return total;
end;
$$

select total_salespeople();

-- 5. Compute the total salary paid to the company's salesman.
delimiter $$
create function total_salary()
    returns decimal(10, 2)
    deterministic
begin
    declare total_salary decimal(10, 2);
    select sum(Salary) into total_salary from salesman;

    return total_salary;
end;
$$

select total_salary();

-- 6. Find Clients in a Province
delimiter $$
create function find_clients_in_province(provinceInput varchar(50))
    returns varchar(1000)
    deterministic
begin
    declare name varchar(50);
    select group_concat(Client_Name separator ', ')
    into name
    from clients
    where province = provinceInput;
    return name;
end;
$$

select find_clients_in_province('Binh Duong');

-- 7. Calculate Total Sales
delimiter $$
create function total_sales()
    returns decimal(10, 2)
    deterministic
begin
    declare total_sales decimal(10, 2);
    select sum(Quantity_Sell) into total_sales from product;
    return total_sales;
end;
$$

select total_sales();

-- 8. Calculate Total Order Amount
delimiter $$
create function total_order_amount()
    returns decimal(10, 2)
    deterministic
begin
    declare total_order_amount decimal(10, 2);
    select sum(Order_Quantity) into total_order_amount from salesorderdetails;
    return total_order_amount;
end;
$$

select total_order_amount();
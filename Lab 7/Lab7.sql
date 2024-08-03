use salemanagement;
set sql_safe_updates = 0;
-- 1 SQL statement returns the cities (only distinct values) from both the "Clients" and the "salesman"
-- table.
SELECT city from clients
UNION
SELECT city from salesman;

-- 2 SQL statement returns the cities (duplicate values also) both the "Clients" and the "salesman" table.
SELECT city from clients
UNION ALL
SELECT city from salesman;

-- 3 SQL statement returns the Ho Chi Minh cities (only distinct values) from the "Clients" and the
-- "salesman" table.
SELECT Client_Name,city FROM clients
WHERE city = 'Ho Chi Minh'
UNION
SELECT salesman_name,city from salesman
WHERE city = 'Ho Chi Minh';

-- 4 SQL statement returns the Ho Chi Minh cities (duplicate values also) from the "Clients" and the
-- "salesman" table.
SELECT Client_Name, City FROM clients
WHERE city = 'Ho Chi Minh'
UNION ALL
SELECT Salesman_Name, city from salesman
WHERE city = 'Ho Chi Minh';

-- 5 SQL statement lists all Clients and salesman.
SELECT client_name from clients
UNION ALL
SELECT salesman_name from salesman;

-- 6 Write a SQL query to find all salesman and clients located in the city of Ha Noi on a table with
-- information: ID, Name, City and Type.
SELECT client_number id, client_name `name`, 'client' `type` from clients
WHERE city = 'Hanoi'
UNION
SELECT salesman_number id, salesman_name `name`, 'salesman' `type` from salesman
WHERE city = 'Hanoi';

-- 7 Write a SQL query to find those salesman and clients who have placed more than one order. Return
-- ID, name and order by ID.
SELECT clients.client_number id, client_name `name` FROM clients
join salesorder on salesorder.client_number = clients.Client_Number
GROUP by id
HAVING count(salesorder.order_number) > 1
UNION
SELECT salesman.salesman_number id, salesman_name `name` FROM salesman
join salesorder on salesorder.salesman_number = salesman.Salesman_Number
GROUP by id
HAVING count(salesorder.order_number) > 1
ORDER BY id;

-- 8 Retrieve Name, Order Number (order by order number) and Type of client or salesman with the client
-- names who placed orders and the salesman names who processed those orders.
SELECT clients.client_name `name`, salesorder.order_number order_number, 'client' `type` FROM clients
join salesorder on salesorder.client_number = clients.client_number
UNION ALL
SELECT salesman.salesman_name `name`, salesorder.order_number order_number, 'salesman' `type` FROM salesman
join salesorder on salesorder.salesman_number = salesman.salesman_number
ORDER BY order_number;

-- 9 Write a SQL query to create a union of two queries that shows the salesman, cities, and
-- target_Achieved of all salesmen. Those with a target of 60 or greater will have the words 'High
-- Achieved', while the others will have the words 'Low Achieved'.
SELECT s.salesman_name `name`, s.city city, s.target_achieved target_achieved, 'High Achieved' as achievement from salesman s
where target_achieved >= 60
UNION
SELECT s.salesman_name `name`, s.city city, s.target_achieved target_achieved, 'Low Achieved' as achievement from salesman s
where target_achieved < 60;

-- 10 Write query to creates lists all products (Product_Number AS ID, Product_Name AS Name,
-- Quantity_On_Hand AS Quantity) and their stock status. Products with a positive quantity in stock are
-- labeled as 'More 5 pieces in Stock'. Products with zero quantity are labeled as ‘Less 5 pieces in Stock'.
SELECT product_number id, product_name name, quantity_on_hand, 'More 5 pieces in Stock' stock_status
FROM product
WHERE quantity_on_hand > 0
UNION
SELECT product_number id, product_name name, quantity_on_hand, 'Less 5 pieces in Stock' stock_status
FROM product
WHERE quantity_on_hand = 0;

-- 11 Create a procedure stores get_clients _by_city () saves the all Clients in table. Then Call procedure
-- stores.
Delimiter $$
CREATE PROCEDURE get_clients_by_city()
BEGIN
SELECT * FROM clients;
END$$
Delimiter ;
CALL get_clients_by_city();

-- 12 Drop get_clients _by_city () procedure stores.
DROP PROCEDURE get_clients_by_city;

-- 13 Create a stored procedure to update the delivery status for a given order number. Change value
-- delivery status of order number “O20006” and “O20008” to “On Way”
Delimiter $$
CREATE PROCEDURE update_order()
BEGIN
UPDATE salesorder 
SET delivery_status = 'On Way'
WHERE order_number = 'O20006' or order_number = 'O20008';
END$$
Delimiter ;
CALL update_order();

-- 14 Create a stored procedure to retrieve the total quantity for each product.
Delimiter $$
CREATE PROCEDURE quantity_product()
BEGIN
SELECT product_number, product_name, SUM(quantity_on_hand+quantity_sell)
from product
GROUP by product_number;
END$$
Delimiter ;
CALL quantity_product();

-- 15 Create a stored procedure to update the remarks for a specific salesman.
Delimiter $$
CREATE PROCEDURE update_remark(in salesman_id VARCHAR(15),in new_remark varchar(255))
BEGIN
UPDATE salesman
SET remark = new_remark
WHERE salesman_number = salesman_id;
END$$
Delimiter ;
call update_remark('S004','Good');
-- 16 Create a procedure stores find_clients() saves all of clients and can call each client by client_number.
Delimiter $$
CREATE PROCEDURE find_clients(in client_id varchar(10))
BEGIN
SELECT *
from clients
WHERE client_number = client_id;
END$$
Delimiter ;
call find_clients('C102');
-- 17 Create a procedure stores find_clients() saves all of clients and can call each client by client_number.
Delimiter $$
CREATE PROCEDURE salary_salesman(in limit_execute int)
BEGIN
SELECT salesman_number, salesman_name, salary
from salesman
WHERE salary > 15000
LIMIT limit_execute;
END$$
Delimiter ;
CALL salary_salesman(2);
call salary_salesman(4);

-- 18 Procedure MySQL MAX() function retrieves maximum salary from MAX_SALARY of salary table.
Delimiter $$
CREATE PROCEDURE max_salary()
BEGIN
SELECT MAX(salary) max_salary
from salesman;
END$$
Delimiter ;
CALL max_salary();

-- 19 Create a procedure stores execute finding amount of order_status by values order status of salesorder
-- table.
Delimiter $$
CREATE PROCEDURE amount_order_status(in orderValue varchar(15))
BEGIN
SELECT order_status, count(order_status) as amount
from salesorder
Where order_status = orderValue
GROUP by order_status;
END$$
Delimiter ;
CALL amount_order_status("Cancelled");
CALL amount_order_status("Successful");
CALL amount_order_status("In Process");

-- 20 Create a stored procedure to calculate and update the discount rate for orders.
-- 21 Count the number of salesman with following conditions : SALARY < 20000; SALARY > 20000;
-- SALARY = 20000.
Delimiter $$
CREATE PROCEDURE count_salesman_condition()
BEGIN
SELECT
sum(case when salary < 20000 then 1 else 0 end) as less_20000,
sum(case when salary = 20000 then 1 else 0 end) as equal_20000,
sum(case when salary > 20000 then 1 else 0 end) as more_20000
from salesman;
END$$
Delimiter ;
CALL count_salesman_condition();

-- 22 Create a stored procedure to retrieve the total sales for a specific salesman
Delimiter $$
CREATE PROCEDURE total_sale(in salesman_id varchar(15))
BEGIN
SELECT salesman.salesman_number, salesman.salesman_name, sum(so.Order_Quantity) as total_sales
from salesman
join salesorder on salesorder.salesman_number = salesman.salesman_number
join salesorderdetails so on so.order_number = salesorder.order_number
join product p on p.product_number = so.product_number
WHERE salesman.salesman_number=salesman_id 
GROUP by salesman.salesman_number, salesman.salesman_name;
END$$
Delimiter ;

CALL total_sale('S003');
-- 23 Create a stored procedure to add a new product:
-- Input variables: Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, Sell_Price,
-- Cost_Price.
Delimiter $$
CREATE PROCEDURE add_product(
    in product_number varchar(15),
    in product_name VARCHAR(25),
    in quantity_on_hand int,
    in quantity_sell int,
    in sell_price DECIMAL(15,4),
    in cost_price DECIMAL(15,4),
    in profit FLOAT,
    in totalQuantity int,
    in exp_Date date
)
BEGIN
INSERT INTO product
VALUES(product_number, product_name, quantity_on_hand, quantity_sell, sell_price, cost_price, profit,totalQuantity,exp_date);
END$$
Delimiter ;

call add_product('P1009','Ram',100,300,1000.0000,900.0000,25,40,null);

-- 24 Create a stored procedure for calculating the total order value and classification:
-- - This stored procedure receives the order code (p_Order_Number) và return the total value
-- (p_TotalValue) and order classification (p_OrderStatus).
-- - Using the cursor (CURSOR) to browse all the products in the order (SalesOrderDetails ).
-- - LOOP/While: Browse each product and calculate the total order value.
-- - CASE WHEN: Classify orders based on total value:
-- Greater than or equal to 10000: "Large"
-- Greater than or equal to 5000: "Midium"
-- Less than 5000: "Small"
DELIMITER $$

CREATE PROCEDURE calculate_order_value(IN p_Order_Number VARCHAR(10), OUT p_TotalValue DECIMAL(10, 2), OUT p_OrderStatus VARCHAR(10))
BEGIN
    DECLARE total DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE product_price DECIMAL(10, 2);
    DECLARE order_qty INT;
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR
        SELECT Product.Sell_Price, Salesorderdetails.Order_Quantity
        FROM Salesorderdetails
                 JOIN Product ON Salesorderdetails.Product_Number = Product.Product_Number
        WHERE Salesorderdetails.Order_Number = p_Order_Number;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO product_price, order_qty;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SET total = total + (product_price * order_qty);
    END LOOP;
    CLOSE cur;

    SET p_TotalValue = total;

    CASE
        WHEN total >= 10000 THEN SET p_OrderStatus = 'Large';
        WHEN total >= 5000 THEN SET p_OrderStatus = 'Medium';
        ELSE SET p_OrderStatus = 'Small';
        END CASE;
END$$

DELIMITER ;

CALL calculate_order_value('O20006', @total_value, @order_status);
SELECT @total_value AS TotalValue, @order_status AS OrderStatus;

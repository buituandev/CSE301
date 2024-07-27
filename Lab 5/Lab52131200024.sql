use salemanagement;

insert into salesman
values ('S007', 'Quang', 'Chanh My', 'Da Lat', 700032, 'Lam Dong', 25000, 90, 95, '0900853487'),
       ('S008', 'Hoa', 'Hoa Phu', 'Thu Dau Mot', 700051, 'Binh Duong', 13500, 50, 75, '0998213659');
       
insert into salesorder
values ('O20015', '2022-05-12', 'C108', 'S007', 'On Way', '2022-05-15', 'Successful'),
       ('O20016', '2022-05-16', 'C109', 'S008', 'Ready to Ship', null, 'In Process');

insert into salesorderdetails
values ('O20015', 'P1008', 15),
       ('O20015', 'P1007', 10),
       ('O20016', 'P1007', 20),
       ('O20016', 'P1003', 5);

-- 1. Display the clients (name) who live in the same city.
SELECT 
    c1.client_name, c2.Client_Name, c2.City
FROM
    clients c1
        JOIN
    clients c2
WHERE
    c1.City = c2.City
        AND c1.Client_Number <> c2.Client_Number;

-- 2. Display city, the client names, and salesman names who live in “Thu Dau Mot” city.
SELECT 
    c.City, c.Client_Name, s.Salesman_Name
FROM
    clients c
        JOIN
    salesman s ON c.City = s.City
WHERE
    c.City = 'Thu Dau Mot';

-- 3. Display client name, client number, order number, salesman number, and product number for each order.
SELECT 
    c.Client_Name,
    c.Client_Number,
    s.Order_Number,
    s.Salesman_Number,
    so.Product_Number
FROM
    clients c
        JOIN
    salesorder s ON c.Client_Number = s.Client_Number
        JOIN
    salesorderdetails so ON s.Order_Number = so.Order_Number;

-- 4. Find each order (client_number, client_name, order_number) placed by each client.
SELECT 
    clients.Client_Number,
    clients.Client_Name,
    salesorder.Order_Number
FROM
    clients
        LEFT JOIN
    salesorder ON clients.Client_Number = salesorder.Client_Number;

-- 5. Display the details of clients (client_number, client_name) and the number of orders which are paid by them.
select clients.Client_Number, clients.Client_Name, COUNT(salesorder.Order_Number) as no_order
from clients
left join salesorder on clients.Client_Number = salesorder.Client_Number
group by clients.Client_Number, clients.Client_Name;


-- 6. Display the details of clients (client_number, client_name) who have paid for more than 2 orders. 
SELECT 
    c.client_number, c.client_name
FROM
    clients c
        JOIN
    salesorder s ON s.client_number = c.Client_Number
GROUP BY c.Client_Number
HAVING COUNT(s.Order_Number) > 2;

-- 7. Display details of clients who have paid for more than 1 order in descending order of client_number.
SELECT 
    c.*
FROM
    clients c
        JOIN
    salesorder s ON c.Client_Number = s.Client_Number
GROUP BY c.Client_Number
HAVING COUNT(s.Order_Number) > 1
ORDER BY s.Client_Number DESC;

-- 8. Find the salesman names who sells more than 20 products.
SELECT 
    sm.Salesman_Name
FROM
    salesman sm
        JOIN
    salesorder s ON sm.Salesman_Number = s.Salesman_Number
        JOIN
    salesorderdetails sd ON s.Order_Number = sd.Order_Number
GROUP BY sm.Salesman_Name
HAVING SUM(sd.Order_Quantity) > 20;

-- 9. Display the client information (client_number, client_name) and order number of those clients who have order status is 'Cancelled'.
SELECT 
    clients.Client_Number, clients.Client_Name, s.Order_Number
FROM
    clients
        JOIN
    salesorder s ON clients.Client_Number = s.Client_Number
WHERE
    s.Order_Status = 'Cancelled';
    
-- 10. Display client name, client number of clients 'C101' and count the number of orders which were received “successful”.
SELECT 
    clients.Client_Name,
    clients.Client_Number,
    COUNT(s.Order_Number) no_order
FROM
    clients
        JOIN
    salesorder s ON clients.Client_Number = s.Client_Number
WHERE
    s.Client_Number = 'C101'
        AND s.Order_Status = 'Successful';

-- 11. Count the number of clients orders placed for each product.
select sd.Product_Number, count(c.Client_Number) no_clients
from clients c
join salesorder s on c.Client_Number = s.Client_Number
join salesorderdetails sd on s.Order_Number = sd.Order_Number
group by sd.Product_Number;

-- 12. Find product numbers that were ordered by more than two clients then order in descending by product number.
SELECT 
    sd.Product_Number, COUNT(c.Client_Number) no_clients
FROM
    clients c
        JOIN
    salesorder s ON c.Client_Number = s.Client_Number
        JOIN
    salesorderdetails sd ON s.Order_Number = sd.Order_Number
GROUP BY sd.Product_Number
HAVING COUNT(c.Client_Number) > 2
ORDER BY sd.Product_Number DESC;

-- 13. Find the salesman’s names who are getting the second highest salary.
SELECT 
    salesman.Salesman_Name
FROM
    salesman
WHERE
    Salary = (SELECT 
            MAX(Salary)
        FROM
            salesman
        WHERE
            Salary < (SELECT 
                    MAX(Salary)
                FROM
                    salesman));

-- 14. Find the salesman’s names who are getting the second lowest salary.
SELECT 
    salesman.Salesman_Name
FROM
    salesman
WHERE
    Salary = (SELECT 
            MIN(Salary)
        FROM
            salesman
        WHERE
            Salary > (SELECT 
                    MIN(Salary)
                FROM
                    salesman));
                    
-- 15. Write a query to find the name and salary of the salesman who has a higher salary than the salesman whose salesman number is S001.
SELECT 
    salesman.Salesman_Name, salesman.Salary
FROM
    salesman
WHERE
    Salary > (SELECT 
            Salary
        FROM
            salesman
        WHERE
            Salesman_Number = 'S001');
            
-- 16. Write a query to find the name of all salesman who sold the product has number: P1002.
SELECT 
    salesman.Salesman_Name
FROM
    salesman
WHERE
    Salesman_Number IN (SELECT 
            Salesman_Number
        FROM
            salesorder
        WHERE
            Order_Number IN (SELECT 
                    Order_Number
                FROM
                    salesorderdetails
                WHERE
                    Product_Number = 'P1002'));
                    
-- 17. Find the name of the salesman who sold the product to client C108 with delivery status is “delivered”.
SELECT 
    salesman.Salesman_Name
FROM
    salesman
WHERE
    Salesman_Number IN (SELECT 
            Salesman_Number
        FROM
            salesorder
        WHERE
            Client_Number = 'C108'
                AND Delivery_Status = 'Delivered');
                
-- 18. Display lists the ProductName in ANY records in the Salesorderdetails table have Order Quantity equal to 5.
SELECT 
    product.Product_Name
FROM
    product
WHERE
    Product_Number = ANY (SELECT 
            Product_Number
        FROM
            salesorderdetails
        WHERE
            Order_Quantity = 5);
            
-- 19. Write a query to find the name and number of the salesman who sold 'pen' or 'TV' or 'laptop'.
SELECT 
    salesman_name, salesman_number, COUNT(*) no_salesman
FROM
    salesman
WHERE
    Salesman_Number IN (SELECT 
            Salesman_Number
        FROM
            salesorder
        WHERE
            Order_Number IN (SELECT 
                    Order_Number
                FROM
                    salesorderdetails
                WHERE
                    Product_Number IN (SELECT 
                            product_number
                        FROM
                            product
                        WHERE
                            Product_Name IN ('pen' , 'TV', 'laptop'))))
GROUP BY Salesman_Name , Salesman_Number;

-- 20. List the salesman’s name who sold a product with a product price less than 800 and Quantity_On_Hand more than 50.
SELECT 
    salesman.Salesman_Name
FROM
    salesman
WHERE
    Salesman_Number IN (SELECT 
            Salesman_Number
        FROM
            salesorder
        WHERE
            Order_Number IN (SELECT 
                    Order_Number
                FROM
                    salesorderdetails
                WHERE
                    Product_Number IN (SELECT 
                            Product_Number
                        FROM
                            product
                        WHERE
                            Cost_Price < 800
                                AND Quantity_On_Hand > 50)));
                                

-- 21. Write a query to find the name and salary of the salesman whose salary is greater than the average salary.
SELECT 
    salesman_name, salary
FROM
    salesman
WHERE
    salary > (SELECT 
            AVG(Salary)
        FROM
            salesman);

-- 22. Write a query to find the name and Amount Paid of the clients whose amount paid is greater than the average amount paid.
SELECT 
    Client_Name, Amount_Paid
FROM
    Clients
WHERE
    Amount_Paid > (SELECT 
            AVG(Amount_Paid)
        FROM
            Clients);
            
-- 23. Find the product price that was sold to 'Le Xuan'.
SELECT 
    sell_price
FROM
    product
        JOIN
    salesorderdetails ON product.Product_Number = salesorderdetails.Product_Number
        JOIN
    salesorder ON salesorderdetails.Order_Number = salesorder.Order_Number
        JOIN
    clients ON salesorder.Client_Number = clients.Client_Number
WHERE
    Client_Name = 'Le Xuan';

-- 24. Determine the product name, client name, and amount due that was delivered.
SELECT 
    product.Product_Name,
    clients.Client_Name,
    clients.Amount_Due
FROM
    product
        JOIN
    salesorderdetails ON product.Product_Number = salesorderdetails.Product_Number
        JOIN
    salesorder ON salesorderdetails.Order_Number = salesorder.Order_Number
        JOIN
    clients ON salesorder.Client_Number = clients.Client_Number
WHERE
    Delivery_Status = 'Delivered';
    

-- 25. Find the salesman’s name and their product name which is cancelled.
select salesman.Salesman_Name, product.Product_Name
from salesman
join salesorder on salesman.Salesman_Number = salesorder.Salesman_Number
join salesorderdetails on salesorder.Order_Number = salesorderdetails.Order_Number
join product on salesorderdetails.Product_Number = product.Product_Number
where Order_Status = 'Cancelled';

-- 26. Find product names, prices, and delivery status for products purchased by 'Nguyen Thanh'.
select product.Product_Name, product.Sell_Price, salesorder.Delivery_Status
from product
join salesorderdetails on product.Product_Number = salesorderdetails.Product_Number
join salesorder on salesorderdetails.Order_Number = salesorder.Order_Number
join clients on salesorder.Client_Number = clients.Client_Number
where Client_Name = 'Nguyen Thanh';

-- 27. Display product name, sell price, salesperson name, delivery status, 
-- and order quantity information for each customer.
SELECT 
    product.Product_Name,
    product.Sell_Price,
    salesman.Salesman_Name,
    salesorder.Delivery_Status,
    salesorderdetails.Order_Quantity
FROM
    clients
        JOIN
    salesorder ON clients.Client_Number = salesorder.Client_Number
        JOIN
    salesorderdetails ON salesorder.Order_Number = salesorderdetails.Order_Number
        JOIN
    product ON salesorderdetails.Product_Number = product.Product_Number
        JOIN
    salesman ON salesorder.Salesman_Number = salesman.Salesman_Number;

-- 28. Find the names, product names, and order dates of all sales 
-- staff whose product order status has been "successful" 
-- but the items have not yet been delivered to the client.
SELECT 
    salesman.Salesman_Name,
    product.Product_Name,
    salesorder.Order_Date
FROM
    salesman
        JOIN
    salesorder ON salesman.Salesman_Number = salesorder.Salesman_Number
        JOIN
    salesorderdetails ON salesorder.Order_Number = salesorderdetails.Order_Number
        JOIN
    product ON salesorderdetails.Product_Number = product.Product_Number
WHERE
    Order_Status = 'Successful'
        AND Delivery_Status <> 'Delivered';
        
-- 29. Find each client's product that is "on the way."
SELECT 
    Client_Name, Product_Name
FROM
    product
        JOIN
    salesorderdetails ON product.Product_Number = salesorderdetails.Product_Number
        JOIN
    salesorder ON salesorderdetails.Order_Number = salesorder.Order_Number
        JOIN
    clients ON salesorder.Client_Number = clients.Client_Number
WHERE
    Delivery_Status = 'On Way';
    
-- 30. Find the salary and names of the salesman who is getting the highest salary.
SELECT 
    Salesman_Name, Salary
FROM
    Salesman
WHERE
    Salary = (SELECT 
            MAX(Salary)
        FROM
            Salesman);
            
-- 31. Find the salary and names of the salesman who is getting the second lowest salary.
SELECT 
    Salesman_Name, Salary
FROM
    Salesman
WHERE
    Salary = (SELECT 
            MIN(Salary)
        FROM
            Salesman
        WHERE
            Salary > (SELECT 
                    MIN(Salary)
                FROM
                    salesman));

-- 32. Display the ProductName in ANY records 
-- in the Salesorderdetails table that have an Order Quantity more than 9.
SELECT 
    product.Product_Name
FROM
    product
WHERE
    Product_Number = ANY (SELECT 
            Product_Number
        FROM
            salesorderdetails
        WHERE
            Order_Quantity > 9);
            
-- 33. Find the name of the customer who ordered the same item multiple times.
SELECT 
    clients.Client_Name, salesorderdetails.Product_Number
FROM
    clients
        JOIN
    salesorder ON clients.Client_Number = salesorder.Client_Number
        JOIN
    salesorderdetails ON salesorder.Order_Number = salesorderdetails.Order_Number
GROUP BY Product_Number , Client_Name
HAVING COUNT(Product_Number) > 1;


-- 34. Write a query to find the name, number, and salary of the salesmen who earn less than the average salary  and works in any of Thu Dau Mot city. 
select salesman.Salesman_Name, salesman.Salesman_Number,salesman.Salary
from salesman
where Salary < (select avg(Salary) from salesman) and City = 'Thu Dau Mot';

-- 35. Write a query to find the name, number, and salary of the salesmen who earn a salary higher than 
-- the salary of all salesmen who have Order_status = 'Cancelled'. 
-- Sort the results by salary from lowest to highest.
SELECT 
    salesman.Salesman_Name,
    salesman.Salesman_Number,
    salesman.Salary
FROM
    salesman
WHERE
    Salary > (SELECT 
            MAX(Salary)
        FROM
            salesman
                JOIN
            salesorder ON salesman.Salesman_Number = salesorder.Salesman_Number
        WHERE
            Order_Status = 'Cancelled')
ORDER BY Salary;

-- 36. Write a query to find the 4th maximum salary in the salesman’s table.
SELECT Salary
FROM Salesman
ORDER BY Salary DESC
LIMIT 3, 1; 

-- 37. Write a query to find the 3th minimum salary in the salesman’s table
SELECT 
    salary
FROM
    salesman
ORDER BY salary
LIMIT 2 , 1;
USE SALEMANAGEMENT;

-- Practice in Class
-- 1. Show the all-clients details who lives in “Binh Duong”
SELECT *
FROM clients
WHERE province = 'Binh Duong';

-- 2.Find the client’s number and client’s name who do not live in “Hanoi”.
SELECT client_number
	,client_name
FROM clients
WHERE province != 'Hanoi';

-- 3.Identify the names of all products with less than 25 in stock.
SELECT product_name
FROM product
WHERE quantity_on_hand < 25;

-- 4.Find the product names where company making losses.  
SELECT product_name
FROM product
WHERE sell_price < cost_price;

-- 5.Find the salesman’s details who are able achieved their target
SELECT *
FROM salesman
WHERE target_achieved >= sales_target;

-- 6.Select the names and city of salesman who are not received salary between 10000 and 17000.
SELECT salesman_name
	,city
FROM salesman
WHERE salary NOT BETWEEN 10000
		AND 17000;

-- 7. Show order date and the clients_number of who bought the product between '2022-01-01' and '2022-02-15'.
SELECT order_date
	,client_number
FROM salesorder
WHERE order_date BETWEEN '2022-01-01'
		AND '2022-02-15';

-- 8. Find the names of cities in clients table where city name starts with "N"
SELECT city
FROM clients
WHERE city LIKE 'N%';

-- 9.Display clients’ information whose names have "u" in third position.
SELECT *
FROM clients
WHERE Client_Name LIKE '__u%';

-- 10. Find the details of clients whose names have "u" in second last position.
SELECT *
FROM clients
WHERE Client_Name LIKE '%u_';

-- 11. Find the names of cities in clients table where city name starts with "D" and ends with “n”
SELECT city
FROM clients
WHERE city LIKE 'D%n';

-- 12. Select all clients details who belongs from Ho Chi Minh, Hanoi and Da Lat.
SELECT *
FROM clients
WHERE city IN (
		'Ho Chi Minh'
		,'Hanoi'
		,'Da Lat'
		);

-- 13. Choose all clients data who do not reside in Ho Chi Minh, Hanoi and Da Lat
SELECT *
FROM clients
WHERE city NOT IN (
		'Ho Chi Minh'
		,'Hanoi'
		,'Da Lat'
		);

-- 14. Find the average salesman’s salary.
SELECT avg(s.salary)
FROM salesman s;

-- 15. Find the name of the highest paid salesman.
SELECT salesman_name
FROM salesman
WHERE salary = (
		SELECT MAX(salary)
		FROM salesman
		);

-- 16. Find the name of the salesman who is paid the lowest salary.
SELECT salesman_name
FROM salesman
WHERE salary = (
		SELECT MIN(salary)
		FROM salesman
		);

-- 17. Determine the total number of salespeople employed by the company.
SELECT COUNT(*)
FROM salesman;

-- 18. Compute the total salary paid to the company's salesman.
SELECT SUM(salary)
FROM salesman;

-- 19. Select the salesman’s details sorted by their salary
SELECT *
FROM salesman
ORDER BY salary;

-- 20. Display salesman names and phone numbers based on their target achieved (in ascending order) and their city (in descending order).
SELECT salesman_name
	,phone
FROM salesman
ORDER BY target_achieved ASC
	,city DESC;

-- 21. Display 3 first names of the salesman table and the salesman’s names in descending order.
SELECT salesman_name
FROM salesman
ORDER BY salesman_name DESC LIMIT 3;

-- 22. Find salary and the salesman’s names who is getting the highest salary
SELECT salary
	,salesman_name
FROM salesman
ORDER BY salary DESC LIMIT 1;

-- 23. Find salary and the salesman’s names who is getting second lowest salary.
SELECT salary
	,salesman_name
FROM salesman
ORDER BY salary LIMIT 1 OFFSET 1;

-- 24. Display the first five sales orders information from the sales order table.
SELECT *
FROM salesorder LIMIT 5;

-- 25. Display next ten sales order information from sales order table except first five sales order
SELECT *
FROM salesorder LIMIT 10 OFFSET 5;

-- 26. If there are more than one client, find the name of the province and the number of clients in each 
-- province, ordered high to low.
SELECT province
	,COUNT(client_number) AS number_of_clients
FROM clients
GROUP BY province
HAVING COUNT(*) > 1
ORDER BY number_of_clients DESC;

-- 27. Display information clients have number of sales order more than 1.
SELECT 
    *
FROM
    clients
WHERE
    client_number IN (SELECT 
            client_number
        FROM
            salesorder
        GROUP BY client_number
        HAVING COUNT(order_number) > 1);

-- Practice to grade
-- 28. Display the name and due amount of those clients who lives in “Hanoi”.
SELECT client_name, amount_due FROM clients
WHERE city = 'Hanoi';

-- 29. Find the clients details who has due more than 3000.
SELECT * FROM clients
WHERE amount_due > 3000;

-- 30. Find the clients name and their province who has no due
SELECT client_name, province FROM clients
WHERE amount_due = 0;

-- 31. Show details of all clients paying between 10,000 and 13,000.
SELECT * FROM clients
WHERE amount_paid BETWEEN 10000 AND 13000;

-- 32. Find the details of clients whose name is “Dat”.
SELECT * FROM clients
WHERE client_name LIKE '%Dat';

-- 33. Display all product name and their corresponding selling price.
SELECT product_name, sell_price FROM product;

-- 34. How many TVs are in stock?
SELECT quantity_on_hand FROM product
WHERE product_name = 'TV';

-- 35. Find the salesman’s details who are not able achieved their target
SELECT * FROM salesman
WHERE target_achieved < sales_target;

-- 36. Show all the product details of product number ‘P1005’.
SELECT * FROM product
WHERE product_number = 'P1005';

-- 37. Find the buying price and sell price of a Mouse.
SELECT cost_price, sell_price FROM product
WHERE product_name = 'Mouse';

-- 38. Find the salesman names and phone numbers who lives in Thu Dau Mot.
SELECT salesman_name, phone FROM salesman
WHERE city = 'Thu Dau Mot';

-- 39. Find all the salesman’s name and salary
SELECT salesman_name, salary FROM salesman;

-- 40. Select the names and salary of salesman who are received between 10000 and 17000.
SELECT salesman_name, salary FROM salesman
WHERE salary BETWEEN 10000 AND 17000;

-- 41. Display all salesman details who are received salary between 10000 and 20000 and achieved their target.
SELECT * FROM salesman
WHERE (salary BETWEEN 10000 AND 20000) AND (target_achieved > sales_target);

-- 42. Display all salesman details who are received salary between 20000 and 30000 and not achieved their target
SELECT * FROM salesman
WHERE (salary BETWEEN 20000 AND 30000) AND (target_achieved < sales_target);

-- 43. Find information about all clients whose names do not end with "h"
SELECT * FROM clients
WHERE NOT client_name LIKE '%h';

-- 44. Find client names whose second letter is 'r' or second last letter 'a'.
SELECT client_name FROM clients
WHERE client_name LIKE '_r%' OR '%a_';

-- 45. Select all clients where the city name starts with "D" and at least 3 characters in length.
SELECT * FROM clients 
WHERE city LIKE 'D%' AND LENGTH(city) >= 3;

-- 46. Select the salesman name, salaries and target achieved sorted by their target_achieved in descending order.
SELECT salesman_name, salary, target_achieved FROM salesman
ORDER BY target_achieved DESC;

-- 47. Select the salesman’s details sorted by their sales_target and target_achieved in ascending order.
SELECT * FROM salesman
ORDER BY sales_target, target_achieved; 

-- 48. Select the salesman’s details sorted ascending by their salary and descending by achieved target.
SELECT * FROM salesman
ORDER BY salary, target_achieved DESC; 

-- 49. Display salesman names and phone numbers in descending order based on their sales target.
SELECT salesman_name, phone FROM salesman
ORDER BY sales_target DESC;

-- 50. Display the product name, cost price, and sell price sorted by quantity in hand
SELECT product_name, cost_price, sell_price FROM product
ORDER BY quantity_on_hand;

-- 51. Retrieve the clients’ names in ascending order
SELECT client_name FROM clients
ORDER BY client_name;

-- 52. Display client information based on order by their city.
SELECT * FROM clients
ORDER BY city;

-- 53. Display client information based on order by their address and city.
SELECT * FROM clients
ORDER BY address, city;

-- 54. Display client information based on their city, sorted high to low based on amount due.
SELECT * FROM clients
ORDER BY city, amount_due DESC;

-- 55. Display the data of sales orders depending on their delivery status from the current date to the old date
SELECT * FROM salesorder
ORDER BY delivery_status, delivery_date DESC;

-- 56. Display last five sales order in formation from sales order table.
SELECT * FROM salesorder
ORDER BY order_number DESC LIMIT 5;

-- 57. Count the pincode in client table.
SELECT COUNT(pincode) FROM clients;

-- 58. How many clients are living in Binh Duong?
SELECT COUNT(*) FROM clients
WHERE province = 'Binh Duong';

-- 59. Count the clients for each province
SELECT province, COUNT(*) FROM clients
GROUP BY province;

-- 60. If there are more than three clients, find the name of the province and the number of clients in each province.
SELECT province, COUNT(*) FROM clients
GROUP BY province
HAVING COUNT(*) > 3;

-- 61. Display product number and product name and count number orders of each product more than 1 (in ascending order).
SELECT 
    p.product_number,
    p.product_name,
    COUNT(so.product_number) AS cp
FROM
    salesorderdetails AS so,
    product AS p
WHERE
    so.product_number = p.product_number
GROUP BY so.product_number
HAVING cp > 1
ORDER BY cp;

-- 62. Find products which have more quantity on hand than 20 and less than the sum of average
SELECT * FROM product
WHERE quantity_on_hand > 20 AND quantity_on_hand< (SELECT AVG(quantity_on_hand) FROM product);
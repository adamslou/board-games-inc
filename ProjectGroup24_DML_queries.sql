-- Name: Louis Adams and Gregory Noetzel
-- Date: February 24, 2020
-- Class: CS340-401
-- Assignment: Step 4 Draft DML Queries

-- Variables are denoted by : or %s
-- Input from a textbox is denoted by In
-- Input from a dropdown menu is denoted by INPUT_FROM_DROPDOWN
-- Input from clicking a button is denoted by INPUT_FROM_CLICK
-- Input from clicking checkboxes is denoted by INPUT_FROM_CHECKBOXES

/* Item Page Queries*/
SELECT * FROM Items

INSERT INTO Items (price, item_name, description, quantity_available) 
	VALUES (:priceIn, :item_nameIn, :descriptionIn, :quantity_availableIn)

UPDATE Items SET price=:priceIn, item_name=:item_nameIn, description=:descriptionIn, quantity_avaliable=:quantity_availableIn
WHERE item_id=:item_idINPUT_FROM_CLICK

DELETE FROM Items WHERE item_id=:item_idINPUT_FROM_CHECKBOXES	/*loop this query for each id selected



/* Customer Page Queries*/
SELECT * FROM Customers

INSERT INTO Customers (email, first_name, last_name, phone_number) 
	VALUES (:emailInput, :first_nameIn, :last_nameIn, :phone_numberIn)

UPDATE Customers SET email=:emailIn, first_name=:first_nameIn, last_name=:last_nameIn, phone_number=:phone_numberIn WHERE cust_id=:cust_idINPUT_FROM_CLICK

DELETE FROM Customers WHERE cust_id=:cust_idINPUT_FROM_CHECKBOXES	/*loop this query for each id selected



/* Employee Page Queries*/
SELECT * FROM Employees

INSERT INTO Employees (first_name, last_name) 
	VALUES (:first_nameIn, :last_nameIn,)

UPDATE Employees SET first_name=:first_nameIn, last_name=:last_nameIn WHERE emp_id=:emp_idINPUT_FROM_CLICK

DELETE FROM Employees WHERE emp_id=:emp_idINPUT_FROM_CHECKBOXES	/*loop this query for each id selected



/* Order Page Queries*/
-- queries for displaying the Orders table
SELECT order_id, CONCAT(Customers.first_name,' ',Customers.last_name) AS cust_name, CONCAT(Employees.first_name,' ',Employees.last_name) AS emp_name,
date, total, credit_card_num, exp_date, credit_card_code
FROM Orders
LEFT JOIN Customers ON Orders.cust_id = Customers.cust_id
LEFT JOIN Employees ON Orders.emp_id = Employees.emp_id

-- queries for displaying Customers, Employees, and Items dropdown menus
SELECT CONCAT(Customers.first_name,' ',Customers.last_name) FROM Customers
SELECT CONCAT(Employees.first_name,' ',Employees.last_name) FROM Employees
SELECT Items.item_name, Items.price Items.quantity_available FROM Items

-- queries for displaying Order_Items under each order in the Orders table
SELECT Orders.order_id, Items.item_id, Items.item_name, Order_Items.quantity, Items.price * Order_Items.quantity AS item_total
FROM Orders
LEFT JOIN Order_Items ON Orders.order_id = Order_Items.order_id
LEFT JOIN Items ON Order_Items.item_id = Items.item_id
WHERE Orders.order_id = :order_id

-- query for getting the quantity_available of an item for checking whether enough items are available for an order
SELECT quantity_available FROM Items WHERE item_id = %s;

-- query for adding a new order
INSERT INTO Orders (cust_id, emp_id, date, total, credit_card_num, exp_date, credit_card_code)
	VALUES (:cust_idINPUT_FROM_DROPDOWN, :emp_idINPUT_FROM_DROPDOWN, :dateIn, NULL, :credit_card_numIn, :exp_dateIn, :credit_card_codeIn)

-- query for adding order items
INSERT INTO Order_Items (order_id, item_id, quantity)
	VALUES ((SELECT Orders.order_id FROM Orders ORDER BY Orders.order_id DESC LIMIT 1), :item_idINPUT_FROM_DROPDOWN, :quantityIn)

-- query for updating the quantity_available for Items related to the Order_Items just added
UPDATE Items SET quantity_available = ((SELECT quantity_available FROM Items WHERE item_id = %s) - %s) WHERE item_id = %s;

-- query for getting the total of an order
UPDATE Orders SET total = (SELECT SUM(Items.price * Order_Items.quantity) FROM Order_Items INNER JOIN Items ON Order_Items.item_id = Items.item_id WHERE Order_Items.order_id = (SELECT Orders.order_id FROM Orders ORDER BY Orders.order_id DESC LIMIT 1)) WHERE Orders.order_id = (SELECT Orders.order_id FROM Orders ORDER BY Orders.order_id DESC LIMIT 1)

-- query for deleting an order
DELETE FROM Orders WHERE order_id=:order_idINPUT_FROM_CHECKBOXES



/* Edit Order Page Queries*/
-- query for displaying the Edit Order page
SELECT order_id, Customers.cust_id, Employees.emp_id, date, total, credit_card_num, exp_date, credit_card_code FROM Orders LEFT JOIN Customers ON Orders.cust_id = Customers.cust_id LEFT JOIN Employees ON Orders.emp_id = Employees.emp_id WHERE Orders.order_id = %s;

-- query for displaying the order items in the Edit Orders page
SELECT Orders.order_id, Order_Items.item_id, Order_Items.quantity, ((ROW_NUMBER() OVER(ORDER BY Order_Items.item_id)) - 1) AS rowNum FROM Orders LEFT JOIN Order_Items ON Orders.order_id = Order_Items.order_id LEFT JOIN Items ON Order_Items.item_id = Items.item_id WHERE Orders.order_id = %s;

-- query for getting the number of order items to be displayed in the Edit Orders page
SELECT COUNT(Order_Items.item_id) FROM Order_Items WHERE Order_Items.order_id = %s;

-- query for editing an order
UPDATE Orders SET cust_id=:cust_idINPUT_FROM_DROPDOWN, emp_id=:emp_idINPUT_FROM_DROPDOWN, date=:dateIn, credit_card_num=:credit_card_numIn,
	exp_date=:exp_dateIn, credit_card_code=:credit_card_codeIn
WHERE order_id=:order_idINPUT_FROM_CLICK


-- queries for editing order items
-- gets the item_ids from an order
SELECT item_id FROM Order_Items WHERE Order_Items.order_id = %s;
-- gets the quantities from an order
SELECT quantity FROM Order_Items WHERE Order_Items.order_id = %s;
-- query for getting the quantity_available of an item for checking whether enough items are available for an order
SELECT quantity_available FROM Items WHERE item_id = %s;
-- sets quantity_available back to its orginal value for an item
UPDATE Items SET quantity_available = ((SELECT quantity_available FROM Items WHERE item_id = %s) + (SELECT quantity FROM Order_Items WHERE Order_Items.order_id = %s AND Order_Items.item_id = %s)) WHERE item_id = %s;
-- deletes original Order_Items
DELETE FROM Order_Items WHERE order_id = %s;
-- insert rows for new Order_Items
INSERT INTO Order_Items (order_id, item_id, quantity) VALUES (%s, %s, %s);
-- update quantity_available for Items related to the Order_Items newly added
UPDATE Items SET quantity_available = ((SELECT quantity_available FROM Items WHERE item_id = %s) - %s) WHERE item_id = %s;

-- queries for getting the total of an order after updating the order
UPDATE Orders SET total = (SELECT SUM(Items.price * Order_Items.quantity) FROM Order_Items INNER JOIN Items ON Order_Items.item_id = Items.item_id WHERE Order_Items.order_id = %s) WHERE Orders.order_id = %s;

-- query for deleting order items
DELETE FROM Order_Items WHERE order_id=:order_idINPUT_FROM_CLICK AND item_id=:item_idINPUT_FROM_CHECKBOXES

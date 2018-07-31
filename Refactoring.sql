SELECT * FROM v_employee_orders

go;

CREATE VIEW v_employee_orders AS
SELECT 
  Employees.ID, LastName, 
  all_orders.order_count AS total_order_count,
  late_orders.order_count AS late_order_count
FROM Employees
JOIN v_all_orders 
     ON Employees.ID = all_orders.EmployeeID 
JOIN v_late_orders 
     ON Employees.ID = late_orders.EmployeeID


go;
--

CREATE VIEW v_all_orders AS
SELECT EmployeeID, COUNT(*) AS order_count
FROM Orders
GROUP BY EmployeeID
GO
;
--

SELECT EmployeeID, COUNT(*) AS order_count
INTO #all_orders
FROM Orders
GROUP BY EmployeeID

SELECT EmployeeID, COUNT(*) AS order_count
INTO #late_orders
FROM Orders
WHERE RequiredDate <= ShippedDate
GROUP BY EmployeeID 

SELECT 
  Employees.ID, LastName, 
  all_orders.order_count AS total_order_count,
  late_orders.order_count AS late_order_count
FROM Employees
JOIN #all_orders 
     ON Employees.ID = all_orders.EmployeeID 
JOIN #late_orders 
     ON Employees.ID = late_orders.EmployeeID

-- Can reference #all_orders and #late_orders in additional queries



----
;
WITH
all_orders AS (
    SELECT EmployeeID, COUNT(*) AS order_count
    FROM Orders
    GROUP BY EmployeeID
),
late_orders AS (
    SELECT EmployeeID, COUNT(*) AS order_count
    FROM Orders
    WHERE RequiredDate <= ShippedDate
    GROUP BY EmployeeID 
)
SELECT 
  Employees.ID, LastName, 
  all_orders.order_count AS total_order_count,
  late_orders.order_count AS late_order_count
FROM Employees
JOIN all_orders 
     ON Employees.ID = all_orders.EmployeeID 
JOIN late_orders 
     ON Employees.ID = late_orders.EmployeeID

----

SELECT all_orders.EmployeeID, 
       Employees.LastName,
       all_orders.order_count AS total_order_count, 
       late_orders.order_count AS late_order_count
  FROM (
       SELECT EmployeeID, COUNT(*) AS order_count
         FROM Orders
        GROUP BY EmployeeID
  ) all_orders
  JOIN (
       SELECT EmployeeID, COUNT(*) AS order_count
         FROM Orders
        WHERE RequiredDate <= ShippedDate
     GROUP BY EmployeeID 
  ) late_orders
    ON all_orders.EmployeeID = late_orders.employeeID
  JOIN Employees
    ON all_orders.EmployeeId = Employees.Id

----



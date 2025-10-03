
-- 1. Drop old tables if exist (optional)

DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;

-- =========================================
-- 2. Create base tables
-- =========================================
CREATE TABLE Customers (
  customer_id INT PRIMARY KEY,
  name VARCHAR(100),
  city VARCHAR(100)
);

CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  product VARCHAR(100),
  amount DECIMAL(10,2),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- =========================================
-- 3. Insert sample data
-- =========================================
INSERT INTO Customers VALUES 
(1, 'Alice', 'Hyderabad'),
(2, 'Bob', 'Delhi'),
(3, 'Charlie', 'Mumbai');

INSERT INTO Orders VALUES
(101, 1, 'Laptop', 50000),
(102, 2, 'Mobile', 15000),
(103, 1, 'Headphones', 2000),
(104, 3, 'Tablet', 12000);

-- =========================================
-- 4. Stored Procedure
-- =========================================
-- Procedure: Get orders for a given customer
DELIMITER $$

CREATE PROCEDURE GetCustomerOrders (IN cust_id INT)
BEGIN
    SELECT o.order_id, o.product, o.amount
    FROM Orders o
    WHERE o.customer_id = cust_id;
END $$

DELIMITER ;

-- Usage
CALL GetCustomerOrders(1);

-- =========================================
-- 5. Function
-- =========================================
-- Function: Calculate discount based on amount
DELIMITER $$

CREATE FUNCTION GetDiscount(amount DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE discount DECIMAL(10,2);

    IF amount > 30000 THEN
        SET discount = amount * 0.10; -- 10% discount
    ELSE
        SET discount = amount * 0.05; -- 5% discount
    END IF;

    RETURN discount;
END $$

DELIMITER ;

-- Usage
SELECT order_id, product, amount, GetDiscount(amount) AS discount
FROM Orders;

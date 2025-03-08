create database casestudy3
use  casestudy3
select * from [dbo].[Continent]
select * from [dbo].[Customers]
select * from [dbo].[Transaction]





--1. Display the count of customers in each region who have done the
--transaction in the year 2020.

SELECT C.region_id, COUNT(*) as customer_count
FROM Customers C
JOIN [Transaction] T ON C.customer_id = T.customer_id
WHERE YEAR(T.txn_date) = 2020
GROUP BY C.region_id;



--2. Display the maximum and minimum transaction amount of each
--transaction type.
SELECT txn_type, MAX(txn_amount) as max_amount, MIN(txn_amount) as min_amount
FROM [Transaction]
GROUP BY txn_type;

--3. Display the customer id, region name and transaction amount where
--transaction type is deposit and transaction amount > 2000.
SELECT C.customer_id, Co.region_name, T.txn_amount
FROM Customers C
JOIN [Transaction] T ON C.customer_id = T.customer_id
JOIN Continent Co ON C.region_id = Co.region_id
WHERE T.txn_type = 'deposit' AND T.txn_amount > 2000;


--4. Find duplicate records in the Customer table.

SELECT customer_id, COUNT(*) as duplicate_count
FROM Customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

--5. Display the customer id, region name, transaction type and transaction
--amount for the minimum transaction amount in deposit.

SELECT C.customer_id, Co.region_name, T.txn_type, T.txn_amount
FROM Customers C
JOIN [Transaction] T ON C.customer_id = T.customer_id
JOIN Continent Co ON C.region_id = Co.region_id
WHERE T.txn_type = 'deposit'
  AND T.txn_amount = (
    SELECT MIN(txn_amount)
    FROM [Transaction]
    WHERE txn_type = 'deposit'
  );

--6. Create a stored procedure to display details of customers in the
--Transaction table where the transaction date is greater than Jun 2020.
CREATE PROCEDURE GetCustomersAfterJune2020 AS
BEGIN
    SELECT C.customer_id, C.region_id, T.txn_date, T.txn_type, T.txn_amount
    FROM Customers C
    JOIN [Transaction] T ON C.customer_id = T.customer_id
    WHERE T.txn_date > '2020-06-30';
END;


--7. Create a stored procedure to insert a record in the Continent table.

CREATE PROCEDURE InsertContinent
    @region_id tinyint,
    @region_name nvarchar(50)
AS
BEGIN
    INSERT INTO Continent (region_id, region_name)
    VALUES (@region_id, @region_name);
END;

--8. Create a stored procedure to display the details of transactions that
--happened on a specific day.

CREATE PROCEDURE GetTransactionsOnDate
    @txn_date date
AS
BEGIN
    SELECT *
    FROM [Transaction]
    WHERE txn_date = @txn_date;
END;

--9. Create a user defined function to add 10% of the transaction amount in a
--table.
CREATE FUNCTION AddTenPercent
(
    @amount smallint
)
RETURNS smallint
AS
BEGIN
    RETURN @amount + (@amount * 0.1);
END;


--10. Create a user defined function to find the total transaction amount for a
--given transaction type.
CREATE FUNCTION GetTotalAmountForTxnType
(
    @txn_type nvarchar(50)
)
RETURNS smallint
AS
BEGIN
    DECLARE @total_amount smallint;
    SELECT @total_amount = SUM(txn_amount)
    FROM [Transaction]
    WHERE txn_type = @txn_type;
    RETURN @total_amount;
END;



--11. Create a table value function which comprises the columns customer_id,
--region_id ,txn_date , txn_type , txn_amount which will retrieve data from
--the above table.
CREATE FUNCTION GetTransactionData()
RETURNS TABLE
AS
RETURN
    SELECT C.customer_id, C.region_id, T.txn_date, T.txn_type, T.txn_amount
    FROM Customers C
    JOIN [Transaction] T ON C.customer_id = T.customer_id;



--12. Create a TRY...CATCH block to print a region id and region name in a
--single column.
BEGIN TRY
    SELECT region_id + ' - ' + region_name AS Combined
    FROM Continent;
END TRY
BEGIN CATCH
    PRINT 'An error occurred: ' + ERROR_MESSAGE();
END CATCH



--13. Create a TRY...CATCH block to insert a value in the Continent table.
BEGIN TRY
    INSERT INTO Continent (region_id, region_name)
    VALUES (10, 'Test Region');
END TRY
BEGIN CATCH
    PRINT 'An error occurred: ' + ERROR_MESSAGE();
END CATCH



--14. Create a trigger to prevent deleting a table in a database.
 

CREATE TRIGGER nDEL
ON customers
INSTEAD OF DELETE
AS
BEGIN
    RAISEERROR('Records cannot be deleted', 16, 1);
END;


--15. Create a trigger to audit the data in a table.
 
CREATE TABLE AuditTrail (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(100),
    Action NVARCHAR(10), -- Insert, Update, Delete
    AuditDate DATETIME,
    OldValue NVARCHAR(MAX),
    NewValue NVARCHAR(MAX)
);

 
CREATE TRIGGER AuditTrigger
ON transaction
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

 
    DECLARE @TableName NVARCHAR(100) = 'YourTable';
    DECLARE @Action NVARCHAR(10);

 
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        IF EXISTS (SELECT * FROM deleted)
            SET @Action = 'Update'
        ELSE
            SET @Action = 'Insert'
    END
    ELSE
        SET @Action = 'Delete';

     
    INSERT INTO AuditTrail (TableName, Action, AuditDate, OldValue, NewValue)
    SELECT 
        @TableName,
        @Action,
        GETDATE(),
        (SELECT * FROM deleted FOR XML AUTO, ELEMENTS),
        (SELECT * FROM inserted FOR XML AUTO, ELEMENTS);
END;

 

--16. Create a trigger to prevent login of the same user id in multiple pages.
 
  
CREATE TABLE Se  (
    SessionID uniqueidentifier PRIMARY KEY,
    UserID int,
    LoginTime datetime
);


CREATE TRIGGER PreventMultipleLogin
ON customers
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM  se
        WHERE UserID IN (SELECT user_id FROM inserted)
    )
    BEGIN
        RAISEERROR('User is already logged in on another page.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;



--17. Display top n customers on the basis of transaction type.
DECLARE @n int = 5;  

SELECT TOP (@n) C.customer_id, Co.region_name, T.txn_type, T.txn_amount
FROM Customers C
JOIN [Transaction] T ON C.customer_id = T.customer_id
JOIN Continent Co ON C.region_id = Co.region_id
ORDER BY T.txn_amount DESC;


--18. Create a pivot table to display the total purchase, withdrawal and
--deposit for all the customers.SELECT customer_id, region_name, 
    ISNULL([purchase], 0) as purchase, 
    ISNULL([withdrawal], 0) as withdrawal, 
    ISNULL([deposit], 0) as deposit
FROM (
    SELECT C.customer_id, Co.region_name, T.txn_type, T.txn_amount
    FROM Customers C
    JOIN [Transaction] T ON C.customer_id = T.customer_id
    JOIN Continent Co ON C.region_id = Co.region_id
) src
PIVOT
(
    SUM(txn_amount)
    FOR txn_type IN ([purchase], [withdrawal], [deposit])
) piv;

CREATE DATABASE penguin_bookstore;
USE penguin_bookstore;

-- EventType 1:N --> Event (Include)
CREATE TABLE EventType
(
    EventTypeID INT PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT
);

-- Event 1:N --> EventReservation (Reserves)
-- Event N:1 --> EventType (Include)
CREATE TABLE Event
(
    EventID     INT PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(255) NOT NULL,
    StartDate   DATETIME     NOT NULL,
    EndDate     DATETIME,
    Location    VARCHAR(255),
    EventTypeID INT          NOT NULL,
    FOREIGN KEY (EventTypeID) REFERENCES EventType (EventTypeID) ON DELETE RESTRICT,
    CHECK (EndDate IS NULL OR EndDate >= StartDate)
);

-- Customer 1:N --> Order (Places)
-- Customer 1:N --> GiftCard (Uses)
-- Customer 1:N --> EventReservation (Reserves)
-- Customer 1:N --> CustomerReviews (Writes)
-- Customer 1:1 --> WebUser (Belongs To)
CREATE TABLE Customer
(
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name       VARCHAR(100) NOT NULL,
    Surname    VARCHAR(100),
    Email      VARCHAR(255) UNIQUE,
    Phone      VARCHAR(20),
    Status     VARCHAR(50) DEFAULT 'Regular'
);

-- GiftCard N:1 --> Customer (Uses)
CREATE TABLE GiftCard
(
    GiftCardID     INT PRIMARY KEY AUTO_INCREMENT,
    Code           VARCHAR(50)    NOT NULL UNIQUE,
    Amount         DECIMAL(10, 2) NOT NULL CHECK (Amount >= 0),
    ExpirationDate DATE,
    CustomerID     INT NULL,
    IsActive       BIT DEFAULT 1,
    FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID) ON DELETE SET NULL
);

-- Employee 1:N --> Order (Taken By)
-- Employee 1:N --> EmployeeShift (Works In)
CREATE TABLE Employee
(
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    Name       VARCHAR(100) NOT NULL,
    Surname    VARCHAR(100) NOT NULL,
    Position   VARCHAR(100),
    Salary     DECIMAL(10, 2) CHECK (Salary >= 0) NOT NULL
);

-- EmployeeShift N:1 --> Employee (Works In)
CREATE TABLE EmployeeShift
(
    ShiftID    INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT  NOT NULL,
    ShiftDate  DATE NOT NULL,
    StartTime  TIME NOT NULL,
    EndTime    TIME NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employee (EmployeeID) ON DELETE CASCADE,
    CHECK (EndTime > StartTime)
);

-- Publisher 1:N --> Book (Publishes)
CREATE TABLE Publisher
(
    PublisherID INT PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(255) NOT NULL,
    Address     VARCHAR(500)
);

-- Category M:N --> Book (Belongs To)
CREATE TABLE Category
(
    CategoryID  INT PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT
);

-- Author M:N --> Book (Writes)
CREATE TABLE Author
(
    AuthorID  INT PRIMARY KEY AUTO_INCREMENT,
    Name      VARCHAR(200) NOT NULL,
    Biography TEXT
);

-- WebUser 1:1 --> Customer (Belongs To)
CREATE TABLE WebUser
(
    WebUserID    INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID   INT          NOT NULL UNIQUE,
    Username     VARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    Email        VARCHAR(255) NOT NULL UNIQUE,
    FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID) ON DELETE CASCADE
);

-- Order 1:N --> OrderDetail (Contains)
-- Order 1:1 --> Return (Related Order)
-- Order N:1 --> Customer (Places)
-- Order N:1 --> Employee (Taken By)
CREATE TABLE `Order`
(
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    OrderDate   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Status      VARCHAR(50) DEFAULT 'Pending',
    TotalAmount DECIMAL(12, 2) CHECK (TotalAmount >= 0),
    SalesChannel VARCHAR(50) NOT NULL CHECK (SalesChannel IN ('Online', 'Store')),
    ShippingAddress VARCHAR(500) NULL,
    CustomerID  INT NOT NULL,
    EmployeeID  INT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID) ON DELETE RESTRICT,
    FOREIGN KEY (EmployeeID) REFERENCES Employee (EmployeeID) ON DELETE SET NULL
);

-- DiscountCampaign M:N --> Product (Applied To)
CREATE TABLE DiscountCampaign
(
    CampaignID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(150) NOT NULL,
    DiscountRate DECIMAL(5, 2) CHECK (DiscountRate >= 0 AND DiscountRate <= 100),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    CHECK (EndDate >= StartDate)
);

-- Supplier 1:N --> SupplyOrder (Places)
CREATE TABLE Supplier
(
    SupplierID INT PRIMARY KEY AUTO_INCREMENT,
    Name       VARCHAR(255) NOT NULL,
    Phone      VARCHAR(20),
    Address    VARCHAR(500)
);

-- SupplyOrder N:1 --> Supplier (Places)
CREATE TABLE SupplyOrder
(
    SupplyOrderID INT PRIMARY KEY AUTO_INCREMENT,
    SupplierID    INT  NOT NULL,
    OrderDate     DATE NOT NULL,
    Status        VARCHAR(50),
    FOREIGN KEY (SupplierID) REFERENCES Supplier (SupplierID) ON DELETE RESTRICT
);

-- Return 1:1 --> Order (Related To)
CREATE TABLE `Return`
(
    ReturnID    INT PRIMARY KEY AUTO_INCREMENT,
    ReturnDate  DATE NOT NULL,
    Reason     TEXT,
    TotalRefundAmount DECIMAL(10, 2),
    OrderID     INT NULL,
    CustomerID  INT NOT NULL,
    ProcessedByEmployeeID INT NULL,
    FOREIGN KEY (OrderID) REFERENCES `Order` (OrderID) ON DELETE SET NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID) ON DELETE RESTRICT,
    FOREIGN KEY (ProcessedByEmployeeID) REFERENCES Employee (EmployeeID) ON DELETE SET NULL);

-- Menu M:N --> CafeProduct (Contains)
CREATE TABLE Menu
(
    MenuID INT PRIMARY KEY AUTO_INCREMENT,
    Name         VARCHAR(100) NOT NULL,
    CreationDate DATE
);

-- ISA Relationship: Product (supertype) --> Book
-- CafeProduct (subtypes)
CREATE TABLE Product
(
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    Name      VARCHAR(255)   NOT NULL,
    Price     DECIMAL(10, 2) NOT NULL CHECK (Price >= 0),
    Description TEXT
);

-- Book ISA Subtype of Product
-- Book N:1 --> Publisher (Publishes)
CREATE TABLE Book
(
    ProductID     INT PRIMARY KEY,
    ISBN          VARCHAR(20) NOT NULL UNIQUE,
    NumberOfPages INT CHECK (NumberOfPages > 0),
    PublisherID   INT,
    FOREIGN KEY (ProductID) REFERENCES Product (ProductID) ON DELETE CASCADE,
    FOREIGN KEY (PublisherID) REFERENCES Publisher (PublisherID) ON DELETE SET NULL
);

-- CafeProduct ISA Subtype of Product
-- CafeProduct M:N --> Menu (Contains)
CREATE TABLE CafeProduct
(
    ProductID  INT PRIMARY KEY,
    GramWeight VARCHAR(50),
    Category   VARCHAR(50),
    FOREIGN KEY (ProductID) REFERENCES Product (ProductID) ON DELETE CASCADE
);

-- M:N --> Book & Author (Writes)
CREATE TABLE BookAuthor
(
    BookProductID INT,
    AuthorID      INT,
    PRIMARY KEY (BookProductID, AuthorID),
    FOREIGN KEY (BookProductID) REFERENCES Book (ProductID) ON DELETE CASCADE,
    FOREIGN KEY (AuthorID) REFERENCES Author (AuthorID) ON DELETE CASCADE
);

-- M:N --> Book & Category (Belongs To)
CREATE TABLE BookCategory
(
    BookProductID INT,
    CategoryID    INT,
    PRIMARY KEY (BookProductID, CategoryID),
    FOREIGN KEY (BookProductID) REFERENCES Book (ProductID) ON DELETE CASCADE,
    FOREIGN KEY (CategoryID) REFERENCES Category (CategoryID) ON DELETE CASCADE
);

-- Customer 1:N --> CustomerReviews (Writes), Product 1:N --> CustomerReviews (Comments On)
CREATE TABLE CustomerReviews
(
    ReviewID    INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID  INT NOT NULL,
    ProductID   INT NOT NULL,
    Rating      INT NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
    CommentText TEXT,
    ReviewDate  DATETIME DEFAULT CURRENT_TIMESTAMP,
    IsApproved  BIT DEFAULT 0,
    FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product (ProductID) ON DELETE CASCADE
);

-- Weak Entity: EventReservation N:1 --> Event, N:1 --> Customer
CREATE TABLE EventReservation
(
    EventID     INT,
    CustomerID  INT,
    BookingDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    NumberOfGuests INT DEFAULT 1 CHECK (NumberOfGuests > 0),
    Status      VARCHAR(50) DEFAULT 'Confirmed',
    PRIMARY KEY (EventID, CustomerID),
    FOREIGN KEY (EventID) REFERENCES Event (EventID) ON DELETE CASCADE,
    FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID) ON DELETE CASCADE
);

-- Weak Entity: OrderDetail N:1 --> Order, N:1 --> Product
CREATE TABLE OrderDetail
(
    OrderID   INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity  INT            NOT NULL CHECK (Quantity > 0),
    Price     DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES `Order` (OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product (ProductID) ON DELETE RESTRICT
);

-- M:N --> DiscountCampaign & Product (Applied To)
CREATE TABLE Discount_Product_AppliedTo
(
    CampaignID INT,
    ProductID  INT,
    PRIMARY KEY (CampaignID, ProductID),
    FOREIGN KEY (CampaignID) REFERENCES DiscountCampaign (CampaignID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product (ProductID) ON DELETE CASCADE
);

-- Weak Entity: ProductSupplyDetail N:1 --> SupplyOrder, N:1 --> Product
CREATE TABLE ProductSupplyDetail
(
    SupplyOrderID INT,
    ProductID     INT,
    Quantity      INT NOT NULL CHECK (Quantity > 0),
    UnitPrice     DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (SupplyOrderID, ProductID),
    FOREIGN KEY (SupplyOrderID) REFERENCES SupplyOrder (SupplyOrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product (ProductID) ON DELETE RESTRICT
);

-- Weak Entity: ProductReturnDetail N:1 --> Return, N:1 --> Product
CREATE TABLE ProductReturnDetail
(
    ReturnID  INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity  INT NOT NULL CHECK (Quantity > 0),
    PRIMARY KEY (ReturnID, ProductID),
    FOREIGN KEY (ReturnID) REFERENCES `Return` (ReturnID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product (ProductID) ON DELETE RESTRICT
);

-- M:N --> Menu & CafeProduct (Contains)
CREATE TABLE Menu_CafeProduct_Contains
(
    MenuID        INT,
    CafeProductID INT,
    PRIMARY KEY (MenuID, CafeProductID),
    FOREIGN KEY (MenuID) REFERENCES Menu (MenuID) ON DELETE CASCADE,
    FOREIGN KEY (CafeProductID) REFERENCES CafeProduct (ProductID) ON DELETE CASCADE
);

-- Exmaples

INSERT INTO EventType (Name, Description)
VALUES ('Book Signing', 'The author signs books.'),
       ('Talk', 'Conversation between author and readers.'),
       ('Book Reading', 'Author reads selected chapters.'),
       ('Workshop', 'Interactive book discussion.'),
       ('Launch Event', 'Book launch celebration.');

INSERT INTO Event (Name, StartDate, EndDate, Location, EventTypeID)
VALUES ('Ahmet Ümit Book Signing', '2025-03-01 14:00:00', '2025-03-01 16:00:00', 'Erenkoy Street Branch', 1),
       ('Sci-Fi Talks', '2025-03-15 18:00:00', NULL, 'Online Platform', 2),
       ('Poetry Workshop', '2025-04-10 15:00:00', NULL, 'Cihangir Branch', 4),
       ('Harari Book Talk', '2025-04-12 17:00:00', NULL, 'Online Platform', 2),
       ('Book Launch - New Author', '2025-04-15 18:00:00', '2025-04-15 20:00:00', 'Moda Branch', 5);

INSERT INTO Customer (Name, Surname, Email, Phone)
VALUES ('Hatice', 'Özateş', 'haticeozates@gmail.com', '5414478299'),
       ('Sude', 'Günal', 'sudegunal@gmail.com', '5323712219'),
       ('Sara', 'Kaya', 'sarakaya@gmail.com', '5321234567'),
       ('Alperen', 'Daşoğlu', 'alperendasoglu@gmail.com', '5309876543'),
       ('Yusuf', 'Şen', 'yusufsen@gmail.com', '5398765432'),
       ('Zikra', 'Osman', 'zikosman@gmail.com', '5414413475');

INSERT INTO GiftCard (Code, Amount, ExpirationDate, CustomerID)
VALUES ('GCXMAS2024', 1000.00, '2025-12-31', 1),
       ('GCSPRING2025', 500.00, '2025-06-30', 2),
       ('GCSUMMER25', 750.00, '2025-09-01', 3),
       ('GCBOOKLOVER', 300.00, '2025-07-31', 4),
       ('GC2025DISC', 200.00, '2025-08-31', 5);

INSERT INTO Employee (Name, Surname, Position, Salary)
VALUES ('Gökhan', 'Karanfil', 'Sales Consultant', 30000.00),
       ('Yusuf', 'Doğan', 'Barista', 26000.00),
       ('Zeynep', 'Aslan', 'Cashier', 28000.00),
       ('Bora', 'Aydın', 'Store Manager', 35000.00),
       ('Nazlı', 'Şahin', 'Barista', 26500.00);

INSERT INTO EmployeeShift (EmployeeID, ShiftDate, StartTime, EndTime)
VALUES (1, '2025-01-20', '09:00:00', '17:00:00'),
       (2, '2025-01-20', '11:00:00', '19:00:00'),
       (3, '2025-01-21', '08:00:00', '16:00:00'),
       (4, '2025-01-22', '12:00:00', '20:00:00'),
       (5, '2025-01-23', '10:00:00', '18:00:00');

INSERT INTO Publisher (Name, Address)
VALUES ('Can Publishing', 'Istanbul, Turkey'),
       ('Penguin Random House', 'New York, USA'),
       ('Everest Yayınları', 'Istanbul, Turkey'),
       ('HarperCollins', 'London, UK'),
       ('Vintage Books', 'New York, USA');

INSERT INTO Category (Name, Description)
VALUES ('Novel', 'A long fictional narrative with complex characters and plot.'),
       ('Science Fiction', 'Fiction based on imagined future scientific or technological advances.'),
       ('Mystery', 'Stories involving solving a crime or uncovering secrets.'),
       ('Poetry', 'Expressive literary works written in verse or rhythmic language.'),
       ('Non-fiction', 'Informative content based on factual events and real people.');

INSERT INTO Author (Name, Biography)
VALUES ('Orhan Pamuk', 'Nobel laureate Turkish author.'),
       ('George Orwell', 'British author, known for 1984 and Animal Farm.'),
       ('Ahmet Ümit', 'Turkish crime fiction author.'),
       ('Victor Hugo', 'Renowned French novelist and author of Les Misérables.'),
       ('Sait Faik Abasıyanık', 'Influential Turkish short story writer and poet.');

INSERT INTO WebUser (CustomerID, Username, PasswordHash, Email)
VALUES (1, 'haticeozates', 'hatice_22', 'haticeozates@gmail.com'),
       (2, 'sudegunal', 'sude53lv', 'sudegunal@gmail.com'),
       (3, 'sarakaya', 'saraeyp', 'sarakaya@gmail.com'),
       (4, 'alperendasoglu', 'alpodas_49', 'alperendasoglur@gmail.com'),
       (5, 'yusufsen', 'yusufi*', 'yusufsen@gmail.com'),
       (6, 'zikraosman', 'zikozik', 'zikraosman@gmail.com');

INSERT INTO `Order` (CustomerID, OrderDate, Status, TotalAmount, SalesChannel)
VALUES (1, '2025-05-01', 'Delivered', 250.00, 'Online'),
       (2, '2025-05-02', 'Pending', 180.00, 'Store'),
       (3, '2025-05-03', 'Shipped', 320.00, 'Online'),
       (4, '2025-05-04', 'Cancelled', 0.00, 'Store'),
       (5, '2025-05-05', 'Delivered', 150.00, 'Online'),
       (6, '2025-05-27', 'Cancelled', 100.00, 'Store'),
       (6, '2025-05-28', 'Delivered', 200.00, 'Online'),
       (6, '2025-05-29', 'Delivered', 300.00, 'Store'),
       (6, '2025-05-30', 'Pending', 0.00, 'Online');

INSERT INTO DiscountCampaign (Name, DiscountRate, StartDate, EndDate)
VALUES ('New Year Sale', 15.00, '2024-12-15', '2025-12-31'),
       ('Back to School Campaign', 10.00, '2024-09-01', '2024-09-30'),
       ('May Deals', 20.00, '2025-05-01', '2026-05-31'),
       ('Ramadan Specials', 25.00, '2025-03-10', '2025-04-15'),
       ('Poetry Month', 18.00, '2025-04-01', '2025-04-30');

INSERT INTO Supplier (Name, Phone, Address)
VALUES ('Odak Book Distribution', '02125550011', 'Şişli, Istanbul'),
       ('Penguin Coffee Inc.', '02165550022', 'Coffee Factory, Izmir'),
       ('Atlas Book Co.', '02121234567', 'Fatih, Istanbul'),
       ('Barista Beans Ltd.', '02123334455', 'Bakırköy, Istanbul'),
       ('Global Books', '02129998877', 'New York, USA');

INSERT INTO SupplyOrder (SupplierID, OrderDate, Status)
VALUES (1, '2024-12-01', 'Completed'),
       (2, '2025-01-05', 'In Transit'),
       (3, '2025-02-10', 'Completed'),
       (4, '2025-03-06', 'Pending'),
       (5, '2025-04-02', 'Completed');

INSERT INTO `Return` (ReturnDate, Reason, TotalRefundAmount, OrderID, CustomerID, ProcessedByEmployeeID)
VALUES ('2025-01-20', 'Printing error on pages', 175.00, 1, 1, 2),
       ('2025-01-22', 'Damaged cover', 125.00, 2, 2, 3),
       ('2025-02-18', 'Missing pages', 110.00, 3, 3, 4),
       ('2025-03-06', 'Stale cake', 140.00, 4, 4, 5),
       ('2025-04-09', 'Leaking bottle', 160.00, 5, 5, 1);

INSERT INTO Menu (Name, CreationDate)
VALUES ('Coffees', '2025-01-01'),
       ('Desserts', '2025-01-01');

INSERT INTO Product (Name, Price, Description)
VALUES ('Book A', 175.00, 'Fiction Book'),
       ('Book B', 160.00, 'Science Book'),
       ('Book C', 120.00, 'History Book'),
       ('Cafe Latte', 62.50, 'Hot coffee drink'),
       ('Cafe Mocha', 70.00, 'Chocolate flavored coffee'),
       ('Cold Brew', 95.00, 'Cold coffee drink');
SELECT ProductID, Name FROM Product;


INSERT INTO Book (ProductID, ISBN, NumberOfPages, PublisherID)
VALUES (1, '9789750719624', 260, 1),
       (2, '9780451524935', 328, 2),
       (3, '9780062316097', 512, 5);

INSERT INTO CafeProduct (ProductID, GramWeight, Category)
VALUES (4, '30ml', 'Hot Beverages'),
       (5, '150g', 'Cake Slices'),
       (6, '250ml', 'Cold Beverages');

INSERT INTO BookAuthor (BookProductID, AuthorID)
VALUES (1, 1),
       (2, 2),
       (3, 5);

INSERT INTO BookCategory (BookProductID, CategoryID)
VALUES (1, 1),
       (2, 2),
       (3, 5);

INSERT INTO CustomerReviews (CustomerID, ProductID, Rating, CommentText, ReviewDate)
VALUES (1, 1, 5, 'Amazing book!', '2025-01-20'),
       (2, 4, 4, 'Coffee was great.', '2025-01-18'),
       (3, 3, 5,'Very informative!', '2025-03-06'),
       (4, 5, 1, 'Dessert was terrible.', '2025-04-09'),
       (5, 2, 5, 'Classic, a must-read.', '2025-01-05'),
       (6, 6, 4, 'Refreshing cold brew!', '2025-05-01');
SELECT CustomerID, Name FROM Customer ORDER BY CustomerID;

INSERT INTO EventReservation (EventID, CustomerID, BookingDate, NumberOfGuests, Status)
VALUES (1, 1, '2025-02-20', 2, 'Confirmed'),
       (1, 2, '2025-02-21', 1, 'Cancelled'),
       (2, 3, '2025-03-01', 3, 'Confirmed'),
       (3, 4, '2025-04-05', 2, 'Pending'),
       (4, 5, '2025-04-06', 1, 'Confirmed');

INSERT INTO OrderDetail (OrderID, ProductID, Quantity, Price)
VALUES
    (1, 1, 1, 175.00),
    (1, 4, 2, 62.50),
    (1, 5, 1, 70.00),
    (2, 2, 2, 160.00),
    (2, 4, 1, 62.50),
    (3, 1, 1, 175.00),
    (3, 5, 1, 70.00),
    (4, 4, 2, 62.50),
    (4, 2, 3, 160.00),
    (5, 5, 1, 70.00),
    (5, 6, 1, 95.00);


INSERT INTO Discount_Product_AppliedTo (CampaignID, ProductID)
VALUES (1, 2),
       (1, 4),
       (3, 1),
       (4, 5),
       (5, 3);

INSERT INTO ProductSupplyDetail (SupplyOrderID, ProductID, Quantity, UnitPrice)
VALUES (1, 1, 10, 100.00),
       (2, 4, 20, 75.00),
       (3, 2, 15, 110.00),
       (4, 5, 30, 90.00),
       (5, 3, 12, 120.00);

INSERT INTO ProductReturnDetail (ReturnID, ProductID, Quantity)
VALUES
    (1, 1, 1),
    (2, 2, 1),
    (3, 3, 1),
    (4, 4, 1),
    (5, 5, 1);


INSERT INTO Menu_CafeProduct_Contains (MenuID, CafeProductID)
VALUES (1, 4),
       (2, 5),
       (1, 6),
       (2, 6),
       (2, 4);

SELECT * FROM EventType;
SELECT * FROM Publisher;
SELECT * FROM Category;
SELECT * FROM Author;
SELECT * FROM Menu;
SELECT * FROM Product;
SELECT * FROM Book;
SELECT * FROM CafeProduct;
SELECT * FROM BookAuthor;
SELECT * FROM BookCategory;
SELECT * FROM Customer;
SELECT * FROM Employee;
SELECT * FROM `Order`;
SELECT * FROM OrderDetail;
SELECT * FROM Event;
SELECT * FROM EventReservation;
SELECT * FROM CustomerReviews;
SELECT * FROM Supplier;
SELECT * FROM SupplyOrder;
SELECT * FROM ProductSupplyDetail;
SELECT * FROM `Return`;
SELECT * FROM ProductReturnDetail;
SELECT * FROM DiscountCampaign;
SELECT * FROM Discount_Product_AppliedTo;
SELECT * FROM GiftCard;
SELECT * FROM WebUser;
SELECT * FROM EmployeeShift;
SELECT * FROM Menu_CafeProduct_Contains;



-- 1. Complex SQL Queries:


-- Query 1: List the top 3 most ordered products
-- Techniques used: JOIN + SUM + GROUP BY + ORDER BY + LIMIT
SELECT
    p.Name AS ProductName,
    SUM(od.Quantity) AS TotalOrdered
FROM OrderDetail od
         JOIN Product p ON od.ProductID = p.ProductID
GROUP BY od.ProductID
ORDER BY TotalOrdered DESC
LIMIT 3;




-- Query 2: List the total spending of each customer
-- Techniques used: JOIN + SUM + GROUP BY
SELECT
       c.Name,
       c.Surname,
       SUM(o.TotalAmount) AS TotalSpent
FROM Customer c
         JOIN `Order` o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name, c.Surname;



-- Query 3: List authors who have written the most books
-- Techniques used: JOIN + COUNT + GROUP BY + HAVING + ORDER BY
SELECT
        a.Name AS AuthorName,
        COUNT(baw.BookProductID) AS BookCount
FROM Author a
         JOIN BookAuthor baw ON a.AuthorID = baw.AuthorID
GROUP BY a.AuthorID, a.Name
HAVING COUNT(baw.BookProductID) >= 1
ORDER BY BookCount DESC;



-- Query 4: List customers who have placed more than 3 orders along with their total spending
-- Techniques used: JOIN + COUNT + SUM + GROUP BY + HAVING + ORDER BY
SELECT
    c.Name,
    c.Surname,
    COUNT(o.OrderID) AS NumberOfOrders,
    SUM(o.TotalAmount) AS TotalSpent
FROM Customer c
         JOIN `Order` o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name, c.Surname
HAVING COUNT(o.OrderID) > 2
ORDER BY TotalSpent DESC;


-- Query 5: List discounted books and their authors
-- Techniques used: JOIN + SUBQUERY + WHERE + DATE validation
SELECT
    p.Name AS ProductName,
    a.Name AS AuthorName
FROM Product p
         JOIN Book b ON p.ProductID = b.ProductID
         JOIN BookAuthor baw ON b.ProductID = baw.BookProductID
         JOIN Author a ON baw.AuthorID = a.AuthorID
WHERE p.ProductID IN (
    SELECT dpa.ProductID
    FROM Discount_Product_AppliedTo dpa
             JOIN DiscountCampaign dc ON dpa.CampaignID = dc.CampaignID
    WHERE CURDATE() BETWEEN dc.StartDate AND dc.EndDate
);




-- 2. User-Defined Functions (UDFs):

DELIMITER $$

-- Function 1: fn_GetCustomerEventCount
-- Purpose: Returns the number of events a customer has participated in
CREATE FUNCTION fn_GetCustomerEventCount(custID INT)
    RETURNS INT
    DETERMINISTIC
BEGIN
    DECLARE totalEvents INT;

    SELECT COUNT(*)
    INTO totalEvents
    FROM EventReservation
    WHERE CustomerID = custID;

    RETURN totalEvents;
END $$

DELIMITER ;


-- Example usage of the function to retrieve event count per customer
SELECT
    c.CustomerID,
    c.Name,
    c.Surname,
    fn_GetCustomerEventCount(c.CustomerID) AS EventCount
FROM Customer c;






DELIMITER $$

-- Function 2: fn_GetCustomerTotalSpent
-- Purpose: Returns the total order spending of a customer
CREATE FUNCTION fn_GetCustomerTotalSpent(custID INT)
    RETURNS DECIMAL(12,2)
    DETERMINISTIC
BEGIN
    DECLARE totalSpent DECIMAL(12,2);

    SELECT IFNULL(SUM(TotalAmount), 0)
    INTO totalSpent
    FROM `Order`
    WHERE CustomerID = custID;

    RETURN totalSpent;
END $$

DELIMITER ;


-- Example usage of the function to retrieve total spending per customer
SELECT
    c.CustomerID,
    c.Name,
    c.Surname,
    fn_GetCustomerTotalSpent(c.CustomerID) AS TotalSpent
FROM Customer c;




-- 3. Stored Procedures:


-- Procedure 1: UpdateCustomerEmail
-- Purpose: Updates the email address; if it has changed, also writes an entry to the audit log.
-- Techniques used: IF, SELECT INTO, UPDATE, INSERT, OUT parameter
DELIMITER $$
CREATE PROCEDURE UpdateCustomerEmail(
    IN p_CustomerID INT,
    IN p_NewEmail VARCHAR(100),
    OUT p_Message VARCHAR(255)
)
BEGIN
    DECLARE v_exists INT;
    DECLARE v_OldEmail VARCHAR(255);

    -- First, check if the customer exists
    SELECT COUNT(*) INTO v_exists FROM Customer WHERE CustomerID = p_CustomerID;

    IF v_exists = 0 THEN
        SET p_Message = 'Customer not found.';
    ELSE
        -- Retrieve the current email address
        SELECT Email INTO v_OldEmail FROM Customer WHERE CustomerID = p_CustomerID;

        -- If the email is the same, do not update or log
        IF v_OldEmail = p_NewEmail THEN
            SET p_Message = 'Email is already the same.';
        ELSE
            -- Update the customer's email address
            UPDATE Customer
            SET Email = p_NewEmail
            WHERE CustomerID = p_CustomerID;

            -- Insert a record into the audit log table
            INSERT INTO CustomerEmailAudit (CustomerID, OldEmail, NewEmail)
            VALUES (p_CustomerID, v_OldEmail, p_NewEmail);

            SET p_Message = 'Email updated and audit logged successfully.';
        END IF;
    END IF;
END $$

DELIMITER ;

-- Test examples related to UpdateCustomerEmail and CustomerEmailAudit are provided below.

DELIMITER $$

-- Procedure 2: AddNewBook
-- Purpose: Adds a new book after checking that the product name is unique.
-- Inserts into both Product and Book tables. Returns a result message via OUT parameter.
CREATE PROCEDURE AddNewBook(
    IN p_ProductName VARCHAR(255),
    IN p_Price DECIMAL(10,2),
    IN p_ISBN VARCHAR(20),
    IN p_NumberOfPages INT,
    IN p_PublisherID INT,
    OUT p_NewProductID INT,
    OUT p_Message VARCHAR(255)
)
BEGIN
    DECLARE existingProductID INT;

    -- Check if a product with the same name already exists
    SELECT ProductID INTO existingProductID
    FROM Product
    WHERE Name = p_ProductName
    LIMIT 1;

    IF existingProductID IS NOT NULL THEN
        SET p_Message = 'Product name already exists. No new record inserted.';
        SET p_NewProductID = NULL;
    ELSE
        -- First, insert into the Product (supertype) table
        INSERT INTO Product(Name, Price)
        VALUES (p_ProductName, p_Price);

        -- Retrieve the last inserted AUTO_INCREMENT ID in MySQL
        SET p_NewProductID = LAST_INSERT_ID();

        -- Then, insert into the Book (subtype) table
        INSERT INTO Book(ProductID, ISBN, NumberOfPages, PublisherID)
        VALUES (p_NewProductID, p_ISBN, p_NumberOfPages, p_PublisherID);

        SET p_Message = CONCAT('New book added with ProductID: ', p_NewProductID);
    END IF;
END$$
DELIMITER ;


-- Example procedure call to insert a new book
CALL AddNewBook('Atomik Alışkanlıklar', 289.99, '978-0-00-000000-4',
                315, 3, @newProductID, @message);
SELECT @newProductID AS NewProductID, @message AS Message;


-- 4. Triggers:

-- The following table is used by the trg_CustomerEmail_Update trigger to store audit logs
CREATE TABLE CustomerEmailAudit
(
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OldEmail VARCHAR(255),
    NewEmail VARCHAR(255),
    ChangedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE CASCADE
);

DELIMITER $$

-- Trigger 1: trg_CustomerEmail_Update
-- Purpose: Logs the old and new email values when an email address is changed
CREATE TRIGGER trg_CustomerEmail_Update
    AFTER UPDATE ON Customer
    FOR EACH ROW
BEGIN
    IF (OLD.Email IS NULL AND NEW.Email IS NOT NULL)
        OR (OLD.Email IS NOT NULL AND NEW.Email IS NULL)
        OR (OLD.Email <> NEW.Email) THEN
        INSERT INTO CustomerEmailAudit(CustomerID, OldEmail, NewEmail)
        VALUES (NEW.CustomerID, OLD.Email, NEW.Email);
    END IF;
END$$

DELIMITER ;

-- UpdateCustomerEmail and CustomerEmailAudit examples
SELECT Email FROM Customer WHERE CustomerID = 1;
SELECT Email FROM Customer WHERE CustomerID = 2;


-- Example calls to the procedure
CALL UpdateCustomerEmail(1, 'haticeozatesnew@gmail.com', @msg);
SELECT @msg;

CALL UpdateCustomerEmail(2, 'sudegunalnew@gmail.com', @msg);
SELECT @msg;


-- View audit log records
SELECT * FROM CustomerEmailAudit WHERE CustomerID = 1;
SELECT * FROM CustomerEmailAudit WHERE CustomerID = 2;

-- View audit log showing email changes and their timestamps
SELECT * FROM CustomerEmailAudit;


DELIMITER $$

-- Trigger 2: trg_Set_VIP_Status
-- Purpose: Automatically updates the 'Status' field in the Customer table to 'VIP'
-- when a customer's total spending exceeds 500.
CREATE TRIGGER trg_Set_VIP_Status
    AFTER INSERT ON `Order`  -- Triggered after every new order insertion
    FOR EACH ROW
BEGIN
    DECLARE total_spent DECIMAL(10,2); -- Holds the customer's total spending

    -- Calculate the total amount spent by the customer so far
    SELECT SUM(TotalAmount)
    INTO total_spent
    FROM `Order`
    WHERE CustomerID = NEW.CustomerID;

    -- If the total spending exceeds 500, update the customer's status to VIP
    IF total_spent > 500 THEN
        UPDATE Customer
        SET Status = 'VIP'
        WHERE CustomerID = NEW.CustomerID;
    END IF;
END$$

DELIMITER ;

-- Manual VIP status update for existing data.
-- Updates customers who have already spent more than 500 before the trigger was created.
UPDATE Customer
SET Status = 'VIP'
WHERE CustomerID IN (
    SELECT CustomerID
    FROM `Order`
    GROUP BY CustomerID
    HAVING SUM(TotalAmount) > 500
);

-- Query to list all VIP customers
SELECT * FROM Customer WHERE Status = 'VIP';


-- drop database penguin_bookstore;

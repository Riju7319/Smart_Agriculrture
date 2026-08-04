-- =============================================
-- Smart Agriculture - Company & Invoice Schema
-- Run this on: rjss_Agriculture database
-- =============================================

-- 1. Companies Master Table
CREATE TABLE Companies (
    CompanyID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyName VARCHAR(150) NOT NULL,
    ContactPerson VARCHAR(100) NULL,
    Email VARCHAR(100) NULL,
    Phone VARCHAR(20) NULL,
    TaxID_GSTIN VARCHAR(50) NULL,
    PANNumber VARCHAR(20) NULL,
    Address VARCHAR(255) NULL,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- 2. Customers Table
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyID INT NOT NULL FOREIGN KEY REFERENCES Companies(CompanyID),
    CustomerName VARCHAR(150) NOT NULL,
    Email VARCHAR(100) NULL,
    Phone VARCHAR(20) NULL,
    Address VARCHAR(255) NULL,
    GSTIN VARCHAR(50) NULL,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- 3. Invoices Master Table
CREATE TABLE Invoices (
    InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyID INT NOT NULL FOREIGN KEY REFERENCES Companies(CompanyID),
    CustomerID INT NULL FOREIGN KEY REFERENCES Customers(CustomerID),
    InvoiceNumber VARCHAR(50) NOT NULL UNIQUE,
    InvoiceDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    SubTotal DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    CGSTPercent DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    SGSTPercent DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    CGSTAmount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    SGSTAmount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    TaxAmount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    TotalAmount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    BankAccountID INT NULL,
    IsSent BIT DEFAULT 0,
    PaymentStatus VARCHAR(20) DEFAULT 'Pending',
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- 4. Invoice Items Table
CREATE TABLE InvoiceItems (
    ItemID INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceID INT NOT NULL FOREIGN KEY REFERENCES Invoices(InvoiceID) ON DELETE CASCADE,
    ItemName VARCHAR(150) NOT NULL,
    ItemDescription VARCHAR(500) NULL,
    Quantity INT NOT NULL DEFAULT 1,
    UnitPrice DECIMAL(18,2) NOT NULL,
    TotalPrice AS (Quantity * UnitPrice)
);

-- 5. Bank Accounts Table
CREATE TABLE BankAccounts (
    BankAccountID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyID INT NOT NULL FOREIGN KEY REFERENCES Companies(CompanyID),
    AccountName VARCHAR(150) NOT NULL,
    AccountNumber VARCHAR(50) NOT NULL,
    IFSCCode VARCHAR(20) NULL,
    UPIID VARCHAR(100) NULL,
    BankName VARCHAR(100) NULL,
    PANNumber VARCHAR(20) NULL,
    IsDefault BIT DEFAULT 0,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- 5. Expenses Table
CREATE TABLE Expenses (
    ExpenseID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyID INT NOT NULL FOREIGN KEY REFERENCES Companies(CompanyID),
    ExpenseDate DATE NOT NULL,
    Category VARCHAR(100) NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    PaymentMethod VARCHAR(50) NULL,
    Description VARCHAR(500) NULL,
    ReceiptPath VARCHAR(255) NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- 6. Company Notes Table
CREATE TABLE CompanyNotes (
    NoteID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyID INT NOT NULL FOREIGN KEY REFERENCES Companies(CompanyID),
    NoteText VARCHAR(MAX) NOT NULL,
    CreatedBy VARCHAR(100) NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- 7. Financial Summary View
CREATE VIEW vw_CompanyFinancialSummary AS
SELECT 
    c.CompanyID,
    c.CompanyName,
    c.ContactPerson,
    c.Phone,
    c.Email,
    ISNULL(SUM(i.TotalAmount), 0) AS TotalIncome,
    ISNULL(e.TotalExpense, 0) AS TotalExpenses,
    (ISNULL(SUM(i.TotalAmount), 0) - ISNULL(e.TotalExpense, 0)) AS NetProfitLoss,
    ISNULL(u.UnpaidCount, 0) AS UnpaidInvoiceCount
FROM Companies c
LEFT JOIN Invoices i ON c.CompanyID = i.CompanyID AND i.PaymentStatus = 'Paid'
LEFT JOIN (
    SELECT CompanyID, SUM(Amount) AS TotalExpense 
    FROM Expenses 
    GROUP BY CompanyID
) e ON c.CompanyID = e.CompanyID
LEFT JOIN (
    SELECT CompanyID, COUNT(*) AS UnpaidCount
    FROM Invoices
    WHERE PaymentStatus IN ('Pending', 'Overdue', 'Partially Paid')
    GROUP BY CompanyID
) u ON c.CompanyID = u.CompanyID
WHERE c.IsActive = 1
GROUP BY c.CompanyID, c.CompanyName, c.ContactPerson, c.Phone, c.Email, e.TotalExpense, u.UnpaidCount;

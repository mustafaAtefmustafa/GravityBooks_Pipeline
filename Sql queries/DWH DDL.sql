/*this scritp for DDL DWH 
Author: Mustafa Atef 
Date: 20/8/2025
Breif: Creating the tables structure for building the DWH.
*/


--1 Create Author Table
GO

CREATE TABLE DimAuthor(
	AuthorId_SK INT PRIMARY KEY IDENTITY(1,1),
	AuthorId_BK INT NOT NULL,
	AuthorName VARCHAR(400)
)
--2 Create Book Table
GO

CREATE TABLE DimBook(
	BookId_SK INT PRIMARY KEY IDENTITY(1,1),
	BookId_BK INT NOT NULL,
	BookTitle VARCHAR(400),
	ISBN VARCHAR(13),
	LanguageId_BK INT NOT NULL,
	LanguageCode VARCHAR(8),
	LanguageName VARCHAR(50),
	NumOfPages INT,
	PublicationDate DATE,
	PublisherIdBK INT NOT NULL,
	PublisherName VARCHAR(1000)
)
--3 Create BookAuthor Table
GO

CREATE TABLE DimBookAuthor(
	BridgeBookId_FK INT NOT NULL,
	BridgeAuthorId_FK INT NOT NULL
	CONSTRAINT pk_comps_book_author PRIMARY KEY(BridgeBookId_FK, BridgeAuthorId_FK),
	CONSTRAINT fk_book_author_book FOREIGN KEY(BridgeBookId_FK) REFERENCES DimBook(BookId_SK),
	CONSTRAINT fk_book_author_author FOREIGN KEY(BridgeAuthorId_FK) REFERENCES DimAuthor(AuthorId_SK)
)
--4 Create Customer Table
GO

CREATE TABLE DimCustomer(
	CustomerId_SK INT PRIMARY KEY IDENTITY(1,1),
	CustomerId_BK INT NOT NULL,
	CustomerFirstName VARCHAR(200),
	CustomerLastName VARCHAR(200),
	CustomerEmail VARCHAR(350),	
	StatusId_BK INT NOT NULL,
	AddressStatus VARCHAR(30),
	AddressId_BK INT,

)

--5 Create Address Table
GO

CREATE TABLE DimAddress(
	AddressId_SK INT PRIMARY KEY IDENTITY(1,1),
	AddressId_BK INT NOT NULL,
	StreetNumber VARCHAR(10),
	StreetName VARCHAR(200),
	City VARCHAR(100),
	CountryId_BK INT NOT NULL,
	CountryName VARCHAR(200)
	--StatusId_BK INT NOT NULL,
	--AddressStatus VARCHAR(30),
)
--6 Create CustomerAddress Table
GO

CREATE TABLE DimCustomerAddress(
	BridgeCustomerId_FK INT NOT NULL,
	BridgeAddressId_FK INT NOT NULL
	CONSTRAINT pk_comps_customer_address PRIMARY KEY(BridgeCustomerId_FK, BridgeAddressId_FK),
	CONSTRAINT fk_customer_address_customer FOREIGN KEY(BridgeCustomerId_FK) REFERENCES DimCustomer(CustomerId_SK),
	CONSTRAINT fk_customer_address_address FOREIGN KEY(BridgeAddressId_FK) REFERENCES DimAddress(AddressId_SK)
)
GO
--7 Create ShippingMethod table
GO

CREATE TABLE DimShippingMethod(
	MethodId_SK INT PRIMARY KEY IDENTITY(1,1),
	MethodId_BK INT NOT NULL,
	MethodName VARCHAR(100),
	ShippingCost DECIMAL(6, 2),
	st_date DATETIME,
	end_date DATETIME,
	is_current BIT
)
--8 Create SalesFact Table
GO
CREATE TABLE SalesFact(
	FactSalesId_SK INT PRIMARY KEY IDENTITY(1,1),
	LineId_DD INT NOT NULL,
	OrderId_DD INT NOT NULL,
	CustomerId_FK INT NOT NULL,
	ShippingMethodId_FK INT NOT NULL,
	BookId_FK INT NOT NULL,
	--OrderHistoryId_FK INT NOT NULL,
	Date_FK INT,
	Time_FK INT,
	LinePrice DECIMAL(5, 2)
	CONSTRAINT cust_fk FOREIGN KEY(CustomerId_FK) REFERENCES DimCustomer(CustomerId_SK),
	CONSTRAINT method_fk FOREIGN KEY(ShippingMethodId_FK) REFERENCES DimShippingMethod(MethodId_SK),
	CONSTRAINT book_fk FOREIGN KEY(BookId_FK) REFERENCES DimBook(BookId_SK),
	--CONSTRAINT history_fk FOREIGN KEY(OrderHistoryId_FK) REFERENCES DimOrderHistory(HistoryId_SK),
	CONSTRAINT date_fk FOREIGN KEY(Date_FK) REFERENCES Dim_Date(Date_SK),
	CONSTRAINT time_fk FOREIGN KEY(Time_FK) REFERENCES Dim_Time(Time_SK),
)

Go

--9 Create OrderStatus Dim
CREATE TABLE DimOrderStatus(
	OrderStatusId_SK INT PRIMARY KEY IDENTITY(1,1),
	OrderStatusId_BK INT,
	StatusValue VARCHAR(20)
)

--10 Create OrderHistoryStatusFact
GO

Create TABLE OrderHistoryStatusFact(
	FactOrderHistoryStatus_SK INT PRIMARY KEY IDENTITY(1,1),
	HistoryId_BK_DD INT,
	OrderId_DD INT,
	StatusId_FK INT,
	StatusDate_FK INT,
	StatusTime_FK INT,
	DaysInPreviousStatus INT
	CONSTRAINT status_fk FOREIGN KEY(StatusId_FK) REFERENCES DimOrderStatus(OrderStatusId_SK),
	CONSTRAINT statusdate_fk FOREIGN KEY(StatusDate_FK) REFERENCES Dim_Date(Date_SK),
	CONSTRAINT statustime_fk FOREIGN KEY(StatusTime_FK) REFERENCES Dim_Time(Time_SK),

)

/*
ALTER TABLE DimAddress
DROP COLUMN StatusId_BK, AddressStatus

ALTER TABLE DimCustomerAddress
ADD StatusId_BK INT NOT NULL, AddressStatus VARCHAR(30)

ALTER TABLE DimCustomer
ADD st_date DATE, end_date DATE, is_current BIT

ALTER TABLE DimCustomer
DROP COLUMN st_date, end_date, is_current

ALTER TABLE DimCustomerAddress
DROP COLUMN StatusId_BK, AddressStatus

ALTER TABLE DimCustomer
ADD StatusId_BK INT NOT NULL, AddressStatus VARCHAR(30)

ALTER TABLE DimCustomer
ADD AddressId_BK INT NOT NULL

ALTER TABLE DimCustomer
ADD CustomerFullname VARCHAR(200)

ALTER TABLE DimCustomer
ALTER COLUMN AddressId_BK INT NULL

ALTER TABLE DimCustomer
ALTER COLUMN Statusid_BK INT NULL

ALTER TABLE DimOrderHistory
ADD OrderId INT

ALTER TABLE DimShippingMethod
ALTER COLUMN end_date DATETIME

ALTER TABLE SalesFact
Drop COLUMN TotalPrice

ALTER TABLE SalesFact
Drop COLUMN OrderHistoryId_FK

DROP TABLE DimOrderHistory
*/


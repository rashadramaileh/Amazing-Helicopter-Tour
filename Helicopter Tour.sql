--Creation Script for HEINER_RAMAILEH_HELICOPTERS
--Richard Heiner, Rashad Ramaileh
--3/14/2023

USE MASTER

GO

IF EXISTS (SELECT * FROM sysdatabases WHERE name='HEINER_RAMAILEH_HELICOPTERS')
DROP DATABASE HEINER_RAMAILEH_HELICOPTERS

GO

CREATE DATABASE HEINER_RAMAILEH_HELICOPTERS

ON PRIMARY
(
NAME = 'HEINER_RAMAILEH_HELICOPTERS',
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\HEINER_RAMAILEH_HELICOPTERS.mdf',
--FILENAME LOCAL
SIZE = 12MB,
MAXSIZE = 50MB,
FILEGROWTH = 10%
)

LOG ON
(
NAME = 'HEINER_RAMAILEH_HELICOPTERS_LOG',
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\HEINER_RAMAILEH_HELICOPTERS.ldf',
--FILENAME LOCAL
SIZE = 1200kb,
MAXSIZE = 5MB,
FILEGROWTH = 25%
)
GO

USE HEINER_RAMAILEH_HELICOPTERS

CREATE TABLE [BILLING] (
  [CharterBillingID]		smallint		NOT NULL		IDENTITY,
  [BillingDescription]		char(30)		NOT NULL,
  [BillingAmount]			smallmoney		NOT NULL,
  [BillingItemQty]			tinyint			NOT NULL,
  [BillingItemDate]			date			NOT NULL,
  [FlightCharterID]			smallint		NOT NULL,
  [BillingCategoryID]		smallint		NOT NULL,
  PRIMARY KEY ([CharterBillingID])
);

CREATE TABLE [TOURTIME] (
  [TourTimeID]				smallint		NOT NULL		IDENTITY,
  [TourTimeStart]			smalldatetime	NOT NULL,
  [TourTimeDescription]		varchar(30)		NULL,
  PRIMARY KEY ([TourTimeID])
);

CREATE TABLE [ROUTE] (
  [RouteID]					smallint		NOT NULL		IDENTITY,
  [Distance]				smallint		NOT NULL,
  [RouteRate]				smallmoney		NOT NULL,
  [RouteName]				varchar(30)		NOT NULL,
  [RouteDescription]		varchar(200)	NOT NULL,
  [HotelID]					smallint		NOT NULL,
  PRIMARY KEY ([RouteID])
);

CREATE TABLE [TOUR] (
  [TourID]					smallint		NOT NULL		IDENTITY,
  [CapacityStatus]			char(1)			NOT NULL,
  [SeatRate]				smallmoney		NOT NULL,
  [HelicopterID]			smallint		NOT NULL,
  [RouteID]					smallint		NOT NULL,
  [TourTimeID]				smallint		NOT NULL,
  PRIMARY KEY ([TourID]),

);

CREATE TABLE [FLIGHTCHARTER] (
  [FlightCharterID]			smallint		NOT NULL		IDENTITY,
  [Status]					char(1)			NOT NULL,
  [GuestCount]				tinyint			NOT NULL,
  [CustomerArrivalTime]		smalldatetime	NULL,
  [TourID]					smallint		NOT NULL,
  [DiscountID]				smallint		NOT NULL,
  [ReservationID]			smallint		NOT NULL,
  PRIMARY KEY ([FlightCharterID]),
);

CREATE TABLE [BILLINGCATEGORY] (
  [BillingCategoryID]		smallint		NOT NULL		IDENTITY,
  [BillingCatDescription]	varchar(30)		NOT NULL,
  [BillingCatTaxable]		bit				NOT NULL,
  PRIMARY KEY ([BillingCategoryID])
);

CREATE TABLE [DISCOUNT] (
  [DiscountID]				smallint		NOT NULL		IDENTITY,
  [DiscountDescription]		varchar(50)		NOT NULL,
  [DiscountExpiration]		date			NOT NULL,
  [DiscountRules]			varchar(100)	NULL,
  [DiscountPercent]			decimal(4,2)	NULL,
  [DiscountAmount]			smallmoney		NULL,
  PRIMARY KEY ([DiscountID])
);

CREATE TABLE [CUSTOMER] (
  [CustomerID]				smallint		NOT NULL		IDENTITY(3000,1),
  [CustFirst]				varchar(20)		NOT NULL,
  [CustLast]				varchar(20)		NOT NULL,
  [CustAddress1]			varchar(30)		NOT NULL,
  [CustAddress2]			varchar(30)		NULL,
  [CustCity]				varchar(30)		NOT NULL,
  [CustState]				char(2)			NULL,
  [CustPostalCode]			char(10)		NOT NULL,
  [CustCountry]				varchar(10)		NOT NULL,
  [CustPhone]				varchar(20)		NOT NULL,
  [CustEmail]				varchar(30)		NULL,
  [IsHotelGuest]			bit				NOT NULL,
  [GuestID]					smallint		NULL,
  PRIMARY KEY ([CustomerID])
);

CREATE TABLE [HELICOPTER] (
  [HelicopterID]			smallint		NOT NULL		IDENTITY,
  [HelicopterName]			varchar(20)		NOT NULL,
  [Capacity]				tinyint			NOT NULL,
  [Range]					smallint		NOT NULL,
  [HelicopterRate]			smallmoney		NOT NULL,
  PRIMARY KEY ([HelicopterID])
);

CREATE TABLE [RESERVATION] (
  [ReservationID]			smallint		NOT NULL		IDENTITY(6000,1),
  [ReservationDate]			date			NOT NULL,
  [ReservationStatus]		char(1)			NOT NULL,
  [ReservationComments]		varchar(200)	NULL,
  [CustomerID]				smallint		NOT NULL,
  PRIMARY KEY ([ReservationID])
);

--Now creating foreign keys
ALTER TABLE [TOUR]
	ADD

	CONSTRAINT FK_HelicopterID
	FOREIGN KEY ([HelicopterID]) REFERENCES  [HELICOPTER] ([HelicopterID])
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	CONSTRAINT FK_RouteID
	FOREIGN KEY ([RouteID]) REFERENCES  [ROUTE] ([RouteID])
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	CONSTRAINT FK_TourTimeID
	FOREIGN KEY ([TourTimeID]) REFERENCES  [TOURTIME] ([TourTimeID])
	ON UPDATE CASCADE
	ON DELETE CASCADE

ALTER TABLE [FLIGHTCHARTER]
	ADD

	CONSTRAINT FK_TourID
	FOREIGN KEY ([TourID]) REFERENCES  [TOUR] ([TourID])
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	CONSTRAINT FK_DiscountID
	FOREIGN KEY ([DiscountID]) REFERENCES  [DISCOUNT] ([DiscountID])
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	CONSTRAINT FK_ReservationID
	FOREIGN KEY ([ReservationID]) REFERENCES  [RESERVATION] ([ReservationID])
	ON UPDATE CASCADE
	ON DELETE CASCADE

ALTER TABLE [RESERVATION]
	ADD

	CONSTRAINT FK_CustomerID
	FOREIGN KEY ([CustomerID]) REFERENCES  [CUSTOMER] ([CustomerID])
	ON UPDATE CASCADE
	ON DELETE CASCADE

ALTER TABLE [BILLING]
	ADD

	CONSTRAINT FK_FlightCharterID
	FOREIGN KEY ([FlightCharterID]) REFERENCES  [FLIGHTCHARTER] ([FlightCharterID])
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	CONSTRAINT FK_BillingCategoryID
	FOREIGN KEY ([BillingCategoryID]) REFERENCES  [BILLINGCATEGORY] ([BillingCategoryID])
	ON UPDATE CASCADE
	ON DELETE CASCADE
GO

ALTER TABLE [RESERVATION]
	ADD CONSTRAINT CK_ResStatusMustMatch
	CHECK (ReservationStatus IN ('R', 'A', 'C', 'X'))

ALTER TABLE [FLIGHTCHARTER]
	ADD CONSTRAINT CK_CharterStatusMustMatch
	CHECK (Status IN ('R', 'A', 'C', 'X'))

ALTER TABLE [TOUR]
	ADD CONSTRAINT CK_CapacityStatusMustMatch
	CHECK (CapacityStatus IN ('F', 'P', 'E'))
GO

--Insert Statements for CUSTOMER table
PRINT 'Inserting data into CUSTOMER Table'
INSERT INTO CUSTOMER
VALUES	('Joe', 'Bob', '333 W 3000 S', NULL, 'Salt Lake City', 'UT', '84111', 'USA', '801-999-9999', NULL, 0, NULL),
		('Sammy', 'Sosa', '200 North Main Street', 'Apt 10', 'Chicago', 'IL', '60007', 'USA', '801-132-3113', NULL, 0, NULL),
		('Jill', 'Thompson', '444 E 5000 S', NULL, 'Bountiful', 'UT', '84010', 'USA', '801-232-2323', NULL, 0, NULL),
		('Kieth', 'Cozart', '3000 E 2212 S', NULL, 'Layton', 'UT', '84041', 'USA', '801-634-4244', NULL, 0, NULL),
		('Anita', 'Proul', '4462 Maybeck Place', 'Unit A', 'Provo', 'UT', '84601', 'USA', '801-957-4769','Anita@cougarlife.com', 0, 1500);


--Insert Statements for RESERVATION table
PRINT 'Inserting data into RESERVATION Table'
INSERT INTO RESERVATION
VALUES	('3/2/2023', 'R', '1st Time Customer', 3000),
		('3/11/2023', 'R', 'Regular Customer. 10th tour booked', 3001),
		('4/13/2023', 'A', '', 3002),
		('2/23/2023', 'C', '', 3003),
		('3/23/2023', 'R', '',  3004);
GO

--Insert Statements for HELICOPTER
PRINT 'Inserting data into HELICOPTER Table'
INSERT INTO HELICOPTER
	VALUES
		('Bumblebee',	6,  350, 1000),
		('Thor',		5,  300, 900),
		('The Bus',		10, 400, 1500)

--Insert Statements for TOURTIME
PRINT 'Inserting data into TOURTIME Table'
INSERT INTO TOURTIME
	VALUES
		('2023/04/28 8:30:00 AM', NULL),
		('2023/04/28 9:00:00 AM', NULL),
		('2023/04/28 9:30:00 AM', NULL),
		('2023/04/28 10:30:00 AM', NULL),
		('2023/04/28 6:30:00 PM', NULL),
		('2023/04/28 7:00:00 PM', NULL),
		('2023/04/28 7:30:00 PM', NULL),
		('2023/04/29 8:30:00 AM', NULL),
		('2023/04/29 9:00:00 AM', NULL),
		('2023/04/29 9:30:00 AM', NULL),
		('2023/04/29 10:30:00 AM', NULL),
		('2023/04/29 6:30:00 PM', NULL),
		('2023/04/29 7:00:00 PM', NULL),
		('2023/04/29 7:30:00 PM', NULL)


--Insert Statements for ROUTE
PRINT 'Inserting data into ROUTE Table'
INSERT INTO ROUTE --Ogden is 2300
	VALUES
		(230,	5.5, 'Bear Lake',		'Flight over Logan and to bear lake',				2300), --1265
		(90,	2.5, 'Great Salt Lake', 'Flight over the Spiral Jetty and Antelope Island', 2300), --225
		(300,	5.5, 'Uinta Mountains', 'Flight over Wasatch to Uinta',						2300), --1650
		(180,	4.5, 'Provo',			'Flight over the city skyline to Provo',			2300), --810
		(50,	2.5, 'Salt Lake City',	'Flight over Salt Lake City',						2300), --125
		(130,	4.5, 'Park City',		'Flight over the mountains to Park City',			2300)  --585

--Insert Statements for BILLINGCATEGORY
PRINT 'Inserting data into BILLINGCATEGORY Table'
INSERT INTO BILLINGCATEGORY
VALUES	('SeatRate', 1),
		('Drinks', 1),
		('Food', 1),
		('Souvenir', 1),
		('Parking', 0),
		('Photos', 1),
		('County Sales Tax', 0);

--Insert Statements for DISCOUNT
PRINT 'Inserting data into DISCOUNT Table'
INSERT INTO DISCOUNT
VALUES	('No Discount (Default)', '2039-12-31', 'Default Discount', 0, 0),
		('Internet Discount', '2023-12-31', 'Discount for anyone who books tour online', 10, 0),
		('Hotel Guest Discount', '2023-12-31', 'Discount for anyone who is currently a guest at the hotel', 10, 0),
		('Multiple Passenger Discount', '2023-12-31', 'Discount for anyone who books more than 4 seats', 0, 50),
		('TV Commercial Discount', '2023-12-31', 'Discount found on TV, Take $20 off your tour price', 0, 20)


PRINT 'Inserting data into TOUR Table'
INSERT INTO TOUR
	VALUES
		('F', 377.5, 1, 1, 1),
		('P', 225, 2, 2, 2),
		('E', 315, 3, 3, 7),
		('E', 204, 1, 2, 14)	

--Insert statement for FLIGHTCHARTER
PRINT 'Inserting data into FLIGHTCHARTER Table'
INSERT INTO FLIGHTCHARTER
VALUES	('R', 3, NULL, 1, 1, 6000),
		('R', 2, NULL, 2, 2, 6000),
		('A', 2, '2023/04/29 6:00:00 PM', 3, 3, 6003),
		('C', 4, '2023/04/29 7:00:00 AM', 4, 4, 6003),
		('R', 3, NULL, 3, 5, 6002),
		('R', 5, NULL, 2, 1, 6004)

--Insert Statements for BILLING
PRINT 'Inserting data into BILLING Table'
INSERT INTO BILLING
VALUES	('Seat Rate', 60.00, 3, '2/23/2023', 1, 1),
		('Pepsi 20 oz', 4.00, 5, '2/23/2023', 1, 2),
		('Cheeseburger', 6.50, 3, '2/23/2023', 1, 3),
		('Souvenir Pin', 3.00, 1, '2/23/2023', 1, 4),
		('Parking', 20.00, 1, '2/23/2023', 1, 5),
		('County Tax', 26.19, 1, '2/23/2023', 1, 7)

-----------------------------------------------------------------------------------------------
--Creating Procedure sp_InsertDiscount
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'sp_InsertDiscount')
	DROP PROCEDURE sp_InsertDiscount;
GO

CREATE PROCEDURE sp_InsertDiscount
@DiscountDescription	varchar(50),
@DiscountExpiration		date,
@DiscountRules			varchar(100) = NULL,
@DiscountPercent		decimal = NULL,
@DiscountAmount			smallmoney = NULL


AS
	BEGIN

	DECLARE @DiscountPercentString	varchar(10) = @DiscountPercent
	DECLARE @DiscountAmountString varchar(8) = @DiscountAmount

	DECLARE @ErrMessage  varchar(max)
BEGIN TRY
		IF @DiscountPercent is NULL AND @DiscountAmount is NULL
		BEGIN 
			SET @ErrMessage = ('Must enter a DiscountPercent or DiscountAmount. Both cannot be empty')
			RAISERROR (@ErrMessage, -1, -1, @DiscountPercentString, @DiscountAmountString)
		RETURN -1
		END
	END TRY
	BEGIN CATCH
	RETURN -1
	END CATCH

	IF @DiscountPercent IS NULL
	BEGIN
		SET @DiscountPercent = 0
	END

	IF @DiscountAmount IS NULL
	BEGIN
		SET @DiscountAmount = 0
	END
	
		INSERT INTO DISCOUNT(DiscountDescription,DiscountExpiration, DiscountRules, DiscountPercent, DiscountAmount)
		VALUES (@DiscountDescription, @DiscountExpiration, @DiscountRules, @DiscountPercent, @DiscountAmount)
	
	END
GO

-----------------------------------------------------------------------------------------------
--Creating Procedure sp_InsertRoute
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'sp_InsertRoute')
	DROP PROCEDURE sp_InsertRoute;
GO

CREATE PROCEDURE sp_InsertRoute
@Distance				smallint,
@RouteRate				smallmoney,
@RouteName				varchar(30),
@RouteDescription		varchar(200),
@HotelID				smallint

AS
	BEGIN

DECLARE @ErrMessage  varchar(max)
BEGIN TRY
		IF @Distance < 1
		BEGIN 
			SET @ErrMessage = ('Distance of route cannot be negative or zero')
			RAISERROR (@ErrMessage, -1, -1, @Distance)
		RETURN -1
		END
	END TRY
	BEGIN CATCH
	RETURN -1
	END CATCH

	INSERT INTO ROUTE(Distance, RouteRate, RouteName, RouteDescription, HotelID)
	VALUES (@Distance, @RouteRate, @RouteName, @RouteDescription, @HotelID)

END
GO

--------------------------------------------------------------------------------------------
--Creating Procedure sp_IsHotelGuest
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'sp_IsHotelGuest')
	DROP PROCEDURE sp_isHotelGuest
GO

CREATE PROCEDURE sp_IsHotelGuest
@CustFirst				varchar(20),
@CustLast				varchar(20),
@Date					smalldatetime

AS
	BEGIN

DECLARE @ErrMessage  varchar(max)
DECLARE @isHotelGuest tinyint = 0
DECLARE @TSQL Nvarchar(300) 
DECLARE @VAR Nvarchar(20)
DECLARE @NameTBL TABLE (Name VARCHAR(20))
DECLARE @IDFirst TABLE (GuestID smallint)
DECLARE @IDLast TABLE (GuestID smallint)
DECLARE @CheckinDateTBL TABLE (ID smallint NOT NULL IDENTITY, CheckinDate smalldatetime)
DECLARE @NightsTBL TABLE (ID smallint NOT NULL IDENTITY, Nights tinyint)
DECLARE @firstName varchar(20)
DECLARE @lastName varchar(20)


--checking to see if FirstName matches any in Guest Table
SET @TSQL = N'SELECT * FROM OPENQUERY(LOCALSERVER,''Select GuestFirst FROM FARMS.dbo.Guest where GuestFirst =''''' + @CustFirst + ''''''')'
INSERT INTO @NameTBL EXEC sp_executesql @TSQL

SELECT @firstName = m.Name
FROM @NameTBL m

IF(@firstName = @CustFirst)
BEGIN
	SET @isHotelGuest = 1
END

IF @isHotelGuest = 1
BEGIN
	SET @TSQL = N'SELECT * FROM OPENQUERY(LOCALSERVER,''Select GuestLast FROM FARMS.dbo.Guest where GuestLast =''''' + @CustLast + ''''''')'
	DELETE FROM @NameTBL
	
	INSERT INTO @NameTBL EXEC sp_executesql @TSQL

	SELECT @lastName = m.Name
	FROM @NameTBL m

	IF(@lastName = @CustLast)
	BEGIN
		SET @isHotelGuest = 1
	END
END

IF @isHotelGuest = 1
BEGIN
	DECLARE @CustomerID smallint
	DECLARE @GuestIDFirst smallint
	DECLARE @GuestIDLast smallint
	

	SET @TSQL = N'SELECT * FROM OPENQUERY(LOCALSERVER,''Select GuestID FROM FARMS.dbo.Guest where GuestFirst =''''' + @firstName + ''''''' )'
	--DELETE FROM @NameTBL
	INSERT INTO @IDFirst EXEC sp_executesql @TSQL

	SELECT @GuestIDFirst = m.GuestID
	FROM @IDFirst m
	
	SET @TSQL = N'SELECT * FROM OPENQUERY(LOCALSERVER,''Select GuestID FROM FARMS.dbo.Guest where GuestLast =''''' + @lastName + ''''''' )'
	--DELETE FROM @NameTBL
	INSERT INTO @IDLast EXEC sp_executesql @TSQL

	SELECT @GuestIDLast = m.GuestID
	FROM @IDLast m

	IF @GuestIDFirst = @GuestIDLast  
	BEGIN
		SET @isHotelGuest = 1
	END
	ELSE
	BEGIN
		SET @isHotelGuest = 0
	END
END

IF @isHotelGuest = 1
BEGIN
	DECLARE @CheckinDate smalldatetime
	DECLARE @Nightcount tinyint
	DECLARE @IDFirstN nvarchar(4)
	DECLARE @NightsN nvarchar (2)
	DECLARE @ExpectedCheckOutDate smalldatetime
	DECLARE @DateDifference smallint
	DECLARE @CheckOutDateTBL TABLE (CheckInDate smalldatetime, CheckOutDate smalldatetime)

	SET @IDFirstN = CONVERT(Nvarchar(4), @GuestIDFirst)

	SET @TSQL = N'SELECT * FROM OPENQUERY(LOCALSERVER,''Select CheckInDate FROM FARMS.dbo.FOLIO where GuestID =''''' + @IDFirstN + ''''''' )'
	--DELETE FROM @NameTBL
	INSERT INTO @CheckinDateTBL EXEC sp_executesql @TSQL

	SELECT @CheckinDate = m.CheckinDate
	FROM @CheckinDateTBL m
	
	SET @TSQL = N'SELECT * FROM OPENQUERY(LOCALSERVER,''Select Nights FROM FARMS.dbo.FOLIO where GuestID =''''' +  @IDFirstN + ''''''' )'
	--DELETE FROM @NameTBL
	INSERT INTO @NightsTBL EXEC sp_executesql @TSQL

	SELECT @Nightcount = m.Nights
	FROM @NightsTBL m

	DECLARE @idColumn int
	DECLARE @newDate smalldatetime
	DECLARE @CNights tinyint
	DECLARE @CDate smalldatetime
	SELECT @idColumn = min(ID) from @CheckinDateTBL

	WHILE @idColumn is not null
	BEGIN	
			SELECT @CNights = Nights from @NightsTBL where ID = @idColumn
			
			SELECT @CDate = CheckinDate from @CheckinDateTBL where ID = @idColumn
			
			SET @newDate = DATEADD(DAY, @CNights, @CDate)

			INSERT INTO @CheckOUTDateTBL VALUES (@cDate,@newDate)
			select @idColumn = min( ID ) from @CheckinDateTBL where ID > @idColumn
	END

	DECLARE @isHotelGuestcount tinyint
	SET @isHotelGuestcount = (SELECT COUNT (CheckInDate) FROM @CheckOutDateTBL where CheckOutDate >= @Date AND @DATE >= CheckInDate)

	IF @isHotelGuest > 0
	BEGIN
		SELECT @CustomerID = m.CustomerID
		FROM CUSTOMER m
		WHERE CustFirst = @firstName AND @CustLast = @lastName

		UPDATE CUSTOMER
		SET IsHotelGuest = 1, GuestID = @GuestIDLast
		WHERE CustFirst = @firstName AND CustLast = @lastName AND @CustomerID = CustomerID;
	END
END

END
GO


--Building dbo.CalculateRouteRate
PRINT 'Building dbo.CalculateRouteRate'
IF OBJECT_ID(N'dbo.CalculateRouteRate', N'FN') IS NOT NULL
	DROP FUNCTION CalculateRouteRate
GO

CREATE FUNCTION dbo.CalculateRouteRate(@Distance smallint)
RETURNS smallmoney
AS
BEGIN
	DECLARE
		@RetVal smallmoney

	IF (@Distance > 200)
		BEGIN
			SET @RetVal = 5.50
		END
	ELSE IF (@Distance > 100)
		BEGIN
			SET @RetVal =  4.50
		END
	ELSE 
		BEGIN
			SET @RetVal =  2.50
		END
		
	RETURN @RetVal
END
GO

PRINT 'Building dbo.CalculateSeatRate'
IF OBJECT_ID(N'dbo.CalculateSeatRate', N'FN') IS NOT NULL
	DROP FUNCTION CalculateSeatRate
GO

CREATE FUNCTION dbo.CalculateSeatRate(@HelicopterID smallint, @RouteID smallint)
RETURNS smallmoney
AS
BEGIN
	DECLARE
		@RetVal			smallmoney,
		@Seats			smallint,
		@HelicopterRate smallmoney,
		@RoutRate		smallmoney,
		@RouteDistance	smallint

	SELECT 
		@Seats = h.Capacity,
		@HelicopterRate = h.HelicopterRate 
	FROM HELICOPTER h
	WHERE h.HelicopterID = @HelicopterID

	SELECT 
		@RoutRate = r.RouteRate, 
		@RouteDistance = r.Distance
	FROM ROUTE r
	WHERE r.RouteID = @RouteID

	SELECT @RetVal = ((@RouteDistance * @RoutRate) + @HelicopterRate) / @Seats

	RETURN @RetVal
END
GO

-----------------------------------------------------------------------------------------------------------
PRINT''
PRINT 'Building dbo.ProduceBill'

IF OBJECT_ID(N'dbo.ProduceBill', N'FN') IS NOT NULL
	DROP FUNCTION ProduceBill
GO

CREATE FUNCTION dbo.ProduceBill(@FlightCharterID smallint)
RETURNS @Ret TABLE(Description Varchar(20),  Quantity varchar(3), Information varchar(35))
AS
BEGIN
	INSERT INTO @Ret
	VALUES
		(
			'Name:',
			'',
			(SELECT CONCAT(CustFirst, ' ', CustLast) AS lineData
			FROM CUSTOMER c
			JOIN RESERVATION r on c.CustomerID = r.CustomerID
			JOIN FLIGHTCHARTER f on r.ReservationID = f.ReservationID
			WHERE f.FlightCharterID = @FlightCharterID)
		),
		(
			'Address:',
			'',
			(SELECT c.CustAddress1 AS lineData
			FROM CUSTOMER c
			JOIN RESERVATION r on c.CustomerID = r.CustomerID
			JOIN FLIGHTCHARTER f on r.ReservationID = f.ReservationID
			WHERE f.FlightCharterID = @FlightCharterID)
		),
		(
			'',
			'',
			(SELECT CONCAT(c.CustCity, ' ', c.CustState, ' ', c.CustPostalCode) AS lineData
			FROM CUSTOMER c
			JOIN RESERVATION r on c.CustomerID = r.CustomerID
			JOIN FLIGHTCHARTER f on r.ReservationID = f.ReservationID
			WHERE f.FlightCharterID = @FlightCharterID)
		),
		(
			'Route:',
			'',
			(SELECT r.RouteName AS lineData
			FROM ROUTE r
			JOIN TOUR t on r.RouteID = t.RouteID 
			JOIN FLIGHTCHARTER f on t.TourID = f.TourID
			WHERE f.FlightCharterID = @FlightCharterID)
		),
		(
			'Helicopter:',
			'',
			(SELECT h.HelicopterName AS lineData
			FROM HELICOPTER h
			JOIN TOUR t on h.HelicopterID = t.HelicopterID 
			JOIN FLIGHTCHARTER f on t.TourID = f.TourID
			WHERE f.FlightCharterID = @FlightCharterID)
		),
		(
			'Charter Time:',
			'',
			CONVERT(varchar(30),(SELECT tt.TourTimeStart AS lineData
			FROM TOURTIME tt
			JOIN TOUR t on tt.TourTimeID = t.TourTimeID 
			JOIN FLIGHTCHARTER f on t.TourID = f.TourID
			WHERE f.FlightCharterID = @FlightCharterID))
		)

	DECLARE
		@BillingDescription varchar(30),
		@BillingItemQty		tinyint,
		@TotalItem			smallint,
		@BillingAmount		smallmoney,
		@BillingItemTotal	smallmoney,
		@BillingTotal		smallmoney

	SET @BillingAmount = 0
	SET @BillingItemTotal = 0
	SET @BillingTotal = 0
	SET @TotalItem = 0

	DECLARE cur_billingItems CURSOR 
		FOR SELECT 
			BillingDescription,
			BillingItemQty,
			BillingAmount
		FROM BILLING 
		WHERE FlightCharterID = @FlightCharterID

	OPEN cur_billingItems
	FETCH NEXT FROM cur_billingItems INTO @BillingDescription, @BillingItemQty, @BillingAmount
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @Ret
			VALUES
				(@BillingDescription, @BillingItemQty, CONCAT('$', @BillingAmount))
		SET @BillingItemTotal = @BillingItemQty * @BillingAmount
		SET @BillingTotal += @BillingItemTotal
		SET @TotalItem += @BillingItemQty
		FETCH NEXT FROM cur_billingItems INTO @BillingDescription, @BillingItemQty, @BillingAmount
	END
	CLOSE cur_billingItems
	DEALLOCATE cur_billingItems

	INSERT INTO @Ret
		VALUES
			('TOTALS:', @TotalItem, CONCAT('$',@BillingTotal))
	
	RETURN
END
GO


--------------------------------------------------------------
--Creating Trigger tr_FlightCharter
CREATE TRIGGER tr_FlightCharter ON FLIGHTCHARTER AFTER UPDATE
AS	
	IF UPDATE([Status])
    BEGIN
        DECLARE @FlightCharterID smallint
		DECLARE @Status char(1)
		DECLARE @GuestCount tinyint
		DECLARE @CustomerArrivalTime smalldatetime
		DECLARE @TourID smallint
		DECLARE @DiscountID smallint
		DECLARE @ReservationID smallint

		DECLARE @TourTimeID smallint
		DECLARE @TourTimeStart smalldatetime
		DECLARE @CancelDate smalldatetime = '2023/04/27 6:45:00 PM'
		DECLARE @CancelDateDifference smallint
		DECLARE @ArrivalDateDifference smallint
		DECLARE @SeatRate smallmoney

		DECLARE @IsHotelGuest bit
		DECLARE @CustomerID smallint

		SELECT 
			@FlightCharterID = i.FlightCharterID,
			@Status = i.Status,
			@GuestCount = i.GuestCount,
			@CustomerArrivalTime = i.CustomerArrivalTime, 
			@TourID = i.TourID,
			@DiscountID = i.DiscountID,
			@ReservationID = i.ReservationID
		FROM INSERTED i

		IF @Status = 'C'
		BEGIN

		--getting seat rate and TourTimeStart to compare
		SELECT @SeatRate = Seatrate FROM TOUR WHERE @TourID = TourID
		SELECT @TourTimeID = TourTimeID FROM TOUR WHERE @TourID = TourID
		SELECT @TourTimeStart = TourTimeStart FROM TOURTIME WHERE @TourTimeID = TourTimeID

		--getting ISHotelGuest status to see if 10% discount should be applied
		SELECT @CustomerID = CustomerID FROM RESERVATION WHERE @ReservationID = ReservationID
		SELECT @IsHotelGuest = isHotelGuest FROM CUSTOMER WHERE @CustomerID = CustomerID

		SET @CancelDateDifference = DATEDIFF(HOUR, @CancelDate, @TourTimeStart)

		IF @CancelDate is NULL
			BEGIN
				INSERT INTO BILLING (BillingDescription, BillingAmount, BillingItemQty, BillingItemDate, FlightCharterID, BillingCategoryID)
				VALUES ('Seat Rate', @SeatRate, @GuestCount, GETDATE(), @FlightCharterID, 1)

				IF @IsHotelGuest = 1
				BEGIN
					UPDATE FLIGHTCHARTER
					SET DiscountID = 3
					WHERE @FlightCharterID = FlightCharterID
				END

			END
		
		IF @CancelDateDifference >= 24 AND @CancelDateDifference < 48
			BEGIN
				INSERT INTO BILLING (BillingDescription, BillingAmount, BillingItemQty, BillingItemDate, FlightCharterID, BillingCategoryID)
				VALUES ('Cancel Fee', @SeatRate * .5, @GuestCount, GETDATE(), @FlightCharterID, 1)
			END
		
		IF @CancelDateDifference < 24
			BEGIN
				INSERT INTO BILLING (BillingDescription, BillingAmount, BillingItemQty, BillingItemDate, FlightCharterID, BillingCategoryID)
				VALUES ('Cancel Fee', @SeatRate * .8, @GuestCount, GETDATE(), @FlightCharterID, 1)
			END


		SET @ArrivalDateDifference = DATEDIFF(MINUTE, @CustomerArrivalTime, @TourTimeStart)
		--PRINT CAST(@ArrivalDateDifference AS VARCHAR(30))+ 'Arrival date difference'

		IF @ArrivalDateDifference < 30
			BEGIN
				INSERT INTO BILLING (BillingDescription, BillingAmount, BillingItemQty, BillingItemDate, FlightCharterID, BillingCategoryID)
				VALUES ('Late Fee', @SeatRate * .1, @GuestCount, GETDATE(), @FlightCharterID, 1)
			END
	END
END
GO

CREATE TRIGGER tr_UpdateRouteRate ON ROUTE AFTER INSERT, UPDATE
AS	
	DECLARE @RouteID smallint
	DECLARE @Distance smallint
	DECLARE @RouteRate smallmoney
	DECLARE @RouteName varchar(30)
	DECLARE @RouteDescription varchar(200)
	DECLARE @HotelID smallint
	IF UPDATE([DISTANCE])
	BEGIN

	SELECT 
		@RouteID = i.RouteID,
		@Distance = i.Distance
	FROM INSERTED i
       
	IF @Distance > 0 AND @Distance <= 100
	BEGIN
		SET @RouteRate = dbo.CalculateRouteRate(@Distance)
	END
	IF @Distance > 100 AND @Distance <= 200
	BEGIN
		SET @RouteRate = dbo.CalculateRouteRate(@Distance)
	END
	IF @Distance > 200
	BEGIN
		SET @RouteRate = dbo.CalculateRouteRate(@Distance)
	END

	UPDATE ROUTE
	SET RouteRate = @RouteRate
	WHERE RouteID = @RouteID


END
GO

----------------------------------------------------
--CREATING tr_GenerateBill
PRINT 'CREATING tr_GenerateBill' + char(10)
GO

CREATE TRIGGER tr_GenerateBill
	ON BILLING
	AFTER INSERT
	AS
	PRINT 'tr_GenerateBill has been triggered'
	DECLARE
		@BCID smallint,
		@FCID smallint,
		@Name varchar(60)

	SET @BCID = (SELECT BillingCategoryID FROM inserted)
	SET @FCID = (SELECT FlightCharterID FROM inserted)
	SELECT @Name = CONCAT(c.CustFirst, ' ', c.CustLast)
		FROM CUSTOMER c
		JOIN RESERVATION r ON r.CustomerID = c.CustomerID
		JOIN FLIGHTCHARTER f ON f.ReservationID = r.ReservationID
		WHERE f.FlightCharterID = @FCID

	PRINT '@BCID is ' + CONVERT(varchar(3), @BCID)
	PRINT '@FCID is ' + CONVERT(varchar(3), @FCID)
	PRINT 'NAME is ' + @Name
	IF @BCID = 1
		BEGIN
		PRINT 'Bill is being produced for ' + @Name
		SELECT * FROM dbo.ProduceBill(@FCID)
		END
GO

--------------------------------------------------------------------
CREATE TRIGGER tr_UpdateSeatRate
	ON TOUR
	INSTEAD OF INSERT
	AS
	PRINT 'tr_UpdateSeatRate has been triggered'
	
	DECLARE
		--@TourID			smallint	= (SELECT TourID FROM inserted),
		@CapacityStatus	char(1)		= (SELECT CapacityStatus FROM inserted),
		@SeatRate		smallmoney,
		@HelicopterID	smallint	= (SELECT HelicopterID FROM inserted),
		@RouteID		smallint	= (SELECT RouteID FROM inserted),
		@TourTimeID		smallint	= (SELECT TourTimeID FROM inserted)

	SELECT @SeatRate = dbo.CalculateSeatRate(@HelicopterID, @RouteID)

	INSERT INTO TOUR(CapacityStatus, SeatRate, HelicopterID, RouteID, TourTimeID)
		VALUES(@CapacityStatus, @SeatRate, @HelicopterID, @RouteID, @TourTimeID)
GO



-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

--Showing stored procedure sp_IsHotelGuest
PRINT'Showing stored procedure sp_IsHotelGuest' + CHAR(10)

--Showing guest Anita Proul isHotelGuest status being changed from 0 to 1
PRINT'Showing guest Anita Proul isHotelGuest status being changed from 0 to 1 since she is a Hotel Guest' + CHAR(10)
SELECT * FROM CUSTOMER

EXEC sp_IsHotelGuest
@CustFirst = 'Anita',
@CustLast = 'Proul',
@Date = N'2023/03/17 7:00:00 AM'
GO

SELECT * FROM CUSTOMER
GO

--Showing guest Joe Bob isHotelGuest status being unchanged due to not being hotel guest
PRINT'Showing guest Joe Bob isHotelGuest status being unchanged due to not being hotel guest'

EXEC sp_IsHotelGuest
@CustFirst = 'Joe',
@CustLast = 'Bob',
@Date = N'2023/03/17 7:00:00 AM'
GO

SELECT * FROM CUSTOMER
GO

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

-- Showing Stored procedure for sp_InsertDiscount
PRINT 'Showing Stored procedure for sp_InsertDiscount' + CHAR(10)
-- Showing Discount Table before a discount is inserted and after.
PRINT'Showing Discount Table before a discount is inserted and after.' + char(10)

SELECT * FROM DISCOUNT

EXEC sp_InsertDiscount
@DiscountDescription = 'May Discount',
@DiscountExpiration	= '2023-5-31',
@DiscountRules = 'New Discount For May Only',
@DiscountAmount = 50
GO

SELECT * FROM DISCOUNT

-- Showing error being thrown if customer doesnt enter a discount percent or amount
PRINT'Showing error being thrown if customer doesnt enter a discount percent or amount' + char(10)
EXEC sp_InsertDiscount
@DiscountDescription = 'Incorrect Discount',
@DiscountExpiration	= '2023-7-31',
@DiscountRules = 'Bad Dscount'
GO

SELECT * FROM DISCOUNT
GO

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

-- Showing stored procedure dbo.InserRoute
PRINT'Showing stored procedure dbo.InserRoute' + char(10)
-- Showing Route Table before one is inserted and after.
PRINT 'Showing Route Table before one is inserted and after.' + char(10)

SELECT * FROM ROUTE

EXEC sp_InsertRoute
@Distance = 80,
@RouteRate = 2.50,
@RouteName = 'Wasatch Front',
@RouteDescription = 'Flight Across Wasatch Front',
@HotelID = 2100
GO

SELECT * FROM ROUTE

-- Showing Error Being Thrown if negative or 0 distance is entered
PRINT 'Showing Error Being Thrown if negative or 0 distance is entered' + char(10)
EXEC sp_InsertRoute
@Distance = -1,
@RouteRate = 2.50,
@RouteName = 'Yellowstone',
@RouteDescription = 'Flight Across Yellowstone',
@HotelID = 2100
GO

SELECT * FROM ROUTE	
GO


-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

--Showing UDF dbo.CalculateRouteRate
PRINT 'Showing UDF dbo.CalculateRouteRate' + char(10)
PRINT 'RouteRates are $2.50, $4.50, and $5.50. per mile'
PRINT 'A tour less then 100 miles will have a $' + CONVERT(varchar(6), dbo.CalculateRouteRate(50)) + ' rate.'
PRINT 'A tour between 100 and 200 miles will have a $' + CONVERT(varchar(6), dbo.CalculateRouteRate(101)) + ' rate.'
PRINT 'A tour greater than 200 miles will have a $' + CONVERT(varchar(6), dbo.CalculateRouteRate(201)) + ' rate.'

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

--Showing UDF dbo.CalculateSeatRate
PRINT 'Showing UDF dbo.CalculateSeatRate' + char(10)
PRINT 'This is to test dbo.CalculateSeatRate'
PRINT 'IF we make a tour using Bumblebee and fly the Great Salt Lake route, the Seat Rate is $' + CONVERT(varchar(6),dbo.CalculateSeatRate(1, 2))
PRINT 'IF we make a tour using Thor and fly the Salt Lake City route, the Seat Rate is $' + CONVERT(varchar(6),dbo.CalculateSeatRate(2, 5))

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

--Showing UDF dbo.dbo.ProduceBill
PRINT 'Showing UDF dbo.ProduceBill' + char(10)
PRINT 'Testing dbo.ProduceBill'
SELECT * FROM dbo.ProduceBill(1)
GO

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

--Showing tr_UpdateRouteRate
PRINT'Showing trigger tr_UpdateRouteRate' +  CHAR (10)

--Showing Route being inserted with distance of 50 but incorrect route rate
PRINT'Showing Route being inserted with distance of 50 but incorrect route rate' + char(10)
INSERT INTO ROUTE
VALUES(50, 100, 'Bryce Canyon', 'Flight through the Bryce Canyon National Park', 2200)
SELECT * FROM ROUTE
GO

--Showing Route being inserted with distance of 125 but incorrect route rate
PRINT'Showing Route being inserted with distance of 125 but incorrect route rate' + char(10)
INSERT INTO ROUTE
VALUES(125, 3, 'Arches', 'Flight through the Arches National Park', 2300)
SELECT * FROM ROUTE
GO

--Showing Route being inserted with distance of 225 but incorrect route rate
PRINT'Showing Route being inserted with distance of 125 but incorrect route rate' + char(10)
INSERT INTO ROUTE
VALUES(225, 350, 'Bountiful', 'Flight through the city of Bountiful', 2300)
SELECT * FROM ROUTE
GO

--Showing the previous routes distance being updated, causing the trigger to update the route rate to the correct value
PRINT'Showing Route being inserted with distance of 125 but incorrect route rate' + char(10)
UPDATE ROUTE
SET Distance = 30
WHERE RouteID = 10
SELECT * FROM ROUTE
GO

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

--Showing Trigger tr_UpdateSeatRate
PRINT 'TESTING tr_UpdateSeatRate' + char(10)
SELECT * FROM TOUR

INSERT INTO TOUR
	VALUES('E', 100, 1, 2, 1)

SELECT * FROM TOUR

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

--Showing trigger tr_GenerateBill
PRINT 'TESTING tr_GenerateBill with an insert statement into the bill table'

SELECT c.CustomerID, CONCAT(c.CustFirst, ' ', c.CustLast) as Name, f.FlightCharterID, f.Status, f.GuestCount, t.SeatRate
FROM CUSTOMER c
JOIN RESERVATION r ON c.CustomerID = r.CustomerID
JOIN FLIGHTCHARTER f ON r.ReservationID = f.ReservationID
JOIN TOUR t ON f.TourID = t.TourID

INSERT INTO BILLING
	VALUES 
		('Seat Rate TEST', 
		(SELECT t.SeatRate FROM TOUR t JOIN FLIGHTCHARTER f ON t.TourID = f.TourID WHERE f.FlightCharterID = 5), 
		(SELECT GuestCount FROM FLIGHTCHARTER WHERE FlightCharterID = 5),
		GETDATE(),
		5,
		1)


PRINT 'TESTING tr_GenerateBill with an update statement'
UPDATE FLIGHTCHARTER 
SET Status = 'C'
WHERE FlightCharterID = 2
GO

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

--testing Trigger tr_FlightCharter
PRINT 'testing Trigger tr_FlightCharter' +char(10)


--Showing results of a FLIGHTCHARTER whose status is changed to ''C'' and ends up canceling 24 hours before.
PRINT'Showing results of a FLIGHTCHARTER whose status is changed to ''C'' and ends up canceling 24 hours before.' + char(10)
SELECT * FROM BILLING
SELECT * FROM FLIGHTCHARTER
GO

UPDATE FLIGHTCHARTER 
SET Status = 'C'
WHERE FlightCharterID = 2
GO

SELECT * FROM BILLING
SELECT * FROM FLIGHTCHARTER
GO

--altering Trigger to show a customer with no canceldate and that shows up to the tour 15 minutes before it starts assessing a late fee. Also shows
-- DiscountID being updated from 1 to 3 due to being a hotelguest
ALTER TRIGGER tr_FlightCharter ON FLIGHTCHARTER AFTER UPDATE
AS	
	IF UPDATE([Status])
    BEGIN
        DECLARE @FlightCharterID smallint
		DECLARE @Status char(1)
		DECLARE @GuestCount tinyint
		DECLARE @CustomerArrivalTime smalldatetime
		DECLARE @TourID smallint
		DECLARE @DiscountID smallint
		DECLARE @ReservationID smallint

		DECLARE @TourTimeID smallint
		DECLARE @TourTimeStart smalldatetime
		DECLARE @CancelDate smalldatetime = NULL
		DECLARE @CancelDateDifference smallint
		DECLARE @ArrivalDateDifference smallint
		DECLARE @SeatRate smallmoney

		DECLARE @IsHotelGuest bit
		DECLARE @CustomerID smallint

		SELECT 
			@FlightCharterID = i.FlightCharterID,
			@Status = i.Status,
			@GuestCount = i.GuestCount,
			@CustomerArrivalTime = i.CustomerArrivalTime, 
			@TourID = i.TourID,
			@DiscountID = i.DiscountID,
			@ReservationID = i.ReservationID
		FROM INSERTED i

		IF @Status = 'C'
		BEGIN

		--getting seat rate and TourTimeStart to compare
		SELECT @SeatRate = Seatrate FROM TOUR WHERE @TourID = TourID
		SELECT @TourTimeID = TourTimeID FROM TOUR WHERE @TourID = TourID
		SELECT @TourTimeStart = TourTimeStart FROM TOURTIME WHERE @TourTimeID = TourTimeID

		--getting ISHotelGuest status to see if 10% discount should be applied
		SELECT @CustomerID = CustomerID FROM RESERVATION WHERE @ReservationID = ReservationID
		SELECT @IsHotelGuest = isHotelGuest FROM CUSTOMER WHERE @CustomerID = CustomerID

		SET @CancelDateDifference = DATEDIFF(HOUR, @CancelDate, @TourTimeStart)

		IF @CancelDate is NULL
			BEGIN
				INSERT INTO BILLING (BillingDescription, BillingAmount, BillingItemQty, BillingItemDate, FlightCharterID, BillingCategoryID)
				VALUES ('Seat Rate', @SeatRate, @GuestCount, GETDATE(), @FlightCharterID, 1)

				IF @IsHotelGuest = 1
				BEGIN
					UPDATE FLIGHTCHARTER
					SET DiscountID = 3
					WHERE @FlightCharterID = FlightCharterID
				END

			END
		
		IF @CancelDateDifference >= 24 AND @CancelDateDifference < 48
			BEGIN
				INSERT INTO BILLING (BillingDescription, BillingAmount, BillingItemQty, BillingItemDate, FlightCharterID, BillingCategoryID)
				VALUES ('Cancel Fee', @SeatRate * .5, @GuestCount, GETDATE(), @FlightCharterID, 1)
			END
		
		IF @CancelDateDifference < 24
			BEGIN
				INSERT INTO BILLING (BillingDescription, BillingAmount, BillingItemQty, BillingItemDate, FlightCharterID, BillingCategoryID)
				VALUES ('Cancel Fee', @SeatRate * .8, @GuestCount, GETDATE(), @FlightCharterID, 1)
			END


		SET @ArrivalDateDifference = DATEDIFF(MINUTE, @CustomerArrivalTime, @TourTimeStart)
		--PRINT CAST(@ArrivalDateDifference AS VARCHAR(30))+ 'Arrival date difference'

		IF @ArrivalDateDifference < 30
			BEGIN
				INSERT INTO BILLING (BillingDescription, BillingAmount, BillingItemQty, BillingItemDate, FlightCharterID, BillingCategoryID)
				VALUES ('Late Fee', @SeatRate * .1, @GuestCount, GETDATE(), @FlightCharterID, 1)
			END
	END
END
GO

--Showing altered trigger to show a customer with no canceldate and that shows up to the tour 15 minutes before it starts assessing a late fee
PRINT'Showing altered trigger to show a customer with no canceldate and that shows up to the tour 15 minutes before it starts assessing a late fee' + char(10)
PRINT'Also shows DiscountID being updated from 1 to 3 due to customer being a HotelGuest' + char(10)
UPDATE FLIGHTCHARTER  
SET CustomerArrivalTime = '2023/04/28 8:45:00 AM'
WHERE FlightCharterID = 6
GO

UPDATE FLIGHTCHARTER 
SET Status = 'C'
WHERE FlightCharterID = 6
GO

SELECT * FROM BILLING
SELECT * FROM FLIGHTCHARTER

GO

USE MASTER
GO
DROP DATABASE IF EXISTS HEINER_RAMAILEH_HELICOPTERS
PRINT 'DATABASE DROPPED'
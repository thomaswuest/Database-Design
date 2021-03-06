FROM BIKE..BICYCLE

--Use Bikes

Use Bike

--1

SELECT	B.CUSTOMERID, C.LASTNAME, C.FIRSTNAME, B.MODELTYPE, P.COLORLIST, B.ORDERDATE, B.SALESTATE
FROM	BICYCLE B INNER JOIN CUSTOMER C ON B.CUSTOMERID = C.CUSTOMERID 
INNER JOIN PAINT P ON B.PAINTID = P.PAINTID INNER JOIN CITY CI ON CI.CITYID = C.CityID 
WHERE	CI.STATE = 'CA' AND P.COLORLIST = 'RED' AND B.MODELTYPE LIKE 'MOUNTAIN%' AND B.ORDERDATE BETWEEN '9-1-03' AND '9-30-03'

--2

SELECT	E.EMPLOYEEID, E.LASTNAME, B.SALESTATE, B.MODELTYPE, R.STOREID, B.ORDERDATE
FROM	EMPLOYEE E INNER JOIN BICYCLE B ON E.EMPLOYEEID = B.EMPLOYEEID
INNER JOIN RETAILSTORE R ON R.STOREID = B.STOREID INNER JOIN CUSTOMER C ON 
C.CUSTOMERID = B.CUSTOMERID INNER JOIN CITY CI ON CI.CITYID = C.CITYID
WHERE	B.MODELTYPE = 'RACE' AND CI.STATE = 'WI' AND R.STOREID IN ('1', '2') AND 
B.ORDERDATE BETWEEN '1-1-01' AND '12-31-01'

--3

SELECT	DISTINCT C.COMPONENTID, M.MANUFACTURERNAME, C.PRODUCTNUMBER
FROM	COMPONENT C INNER JOIN BIKEPARTS BP ON C.COMPONENTID = BP.COMPONENTID 
INNER JOIN BICYCLE B ON B.SerialNumber = BP.SerialNumber INNER JOIN Manufacturer M 
ON M.ManufacturerID = C.ManufacturerID
WHERE	B.SaleState = 'FL' AND B.ORDERDATE BETWEEN '1-01-02' AND '12-31-02' AND 
B.ModelType = 'ROAD' AND C.CATEGORY = 'REAR DERAILLEUR'

--4

SELECT	TOP 1 C.CUSTOMERID, C.LASTNAME, C.FIRSTNAME, B.MODELTYPE, B.SALESTATE,
B.FRAMESIZE, B.ORDERDATE
FROM	CUSTOMER C INNER JOIN BICYCLE B ON C.CUSTOMERID = B.CUSTOMERID INNER JOIN 
BIKEPARTS BP ON BP.SERIALNUMBER = B.SERIALNUMBER INNER JOIN COMPONENT CT ON 
CT.COMPONENTID = BP.COMPONENTID
WHERE	B.SALESTATE = 'GA' AND B.ORDERDATE BETWEEN '01-01-04' AND '12-31-04' 
AND B.MODELTYPE = 'MOUNTAIN FULL'
ORDER BY	B.FRAMESIZE DESC

--5

SELECT	TOP 1 M.MANUFACTURERID, M.MANUFACTURERNAME
FROM	PURCHASEORDER P INNER JOIN PURCHASEITEM I ON P.PURCHASEID = I.PURCHASEID 
INNER JOIN COMPONENT C ON I.COMPONENTID = C.COMPONENTID INNER JOIN MANUFACTURER M ON 
C.MANUFACTURERID = M.MANUFACTURERID
WHERE	P.ORDERDATE BETWEEN '01-01-2003' AND '12-31-2003'
ORDER BY	P.DISCOUNT DESC 	

--6
SELECT	TOP 1 C.COMPONENTID, M.MANUFACTURERNAME, C.PRODUCTNUMBER, C.ROAD, C.CATEGORY,
C.LISTPRICE, C.QUANTITYONHAND
FROM	MANUFACTURER M INNER JOIN COMPONENT C ON M.MANUFACTURERID = C.MANUFACTURERID
WHERE	C.QUANTITYONHAND > 200 AND C.ROAD = 'ROAD'
ORDER BY	C.LISTPRICE DESC

--7

SELECT	TOP 1 C.COMPONENTID, M.MANUFACTURERNAME, C.PRODUCTNUMBER, C.CATEGORY, C.YEAR,
C.ESTIMATEDCOST * C.QUANTITYONHAND AS 'VALUE'
FROM	MANUFACTURER M INNER JOIN COMPONENT C ON M.MANUFACTURERID = C.MANUFACTURERID
ORDER BY	VALUE DESC

--8

SELECT	TOP 1 E.EMPLOYEEID, E.LASTNAME, BP.DATEINSTALLED, COUNT(C.COMPONENTID) AS 'COUNTOFCOMPONENTID'
FROM	EMPLOYEE E INNER JOIN BICYCLE B ON E.EMPLOYEEID = B.EMPLOYEEID 
INNER JOIN BIKEPARTS BP ON BP.SERIALNUMBER = B.SERIALNUMBER INNER JOIN COMPONENT C
ON C.COMPONENTID = BP.COMPONENTID
GROUP BY	E.EMPLOYEEID, E.LASTNAME, BP.DATEINSTALLED
ORDER BY COUNTOFCOMPONENTID DESC

--9

SELECT	TOP 1 LETTERSTYLEID, COUNT(SERIALNUMBER) AS 'COUNTOFSERIALNUMBER'
FROM	BICYCLE
WHERE	ORDERDATE BETWEEN '01-01-03' AND '12-31-03' AND MODELTYPE = 'RACE'
GROUP BY	LETTERSTYLEID
ORDER BY	COUNTOFSERIALNUMBER DESC

--10

SELECT TOP 1 B.CUSTOMERID, C.LASTNAME, C.FIRSTNAME, COUNT(B.SERIALNUMBER) AS
[NUMBEROFBIKES], SUM(CT.AMOUNT) AS [AMOUNTSPENT]
FROM CUSTOMER C INNER JOIN CUSTOMERTRANSACTION CT ON C.CUSTOMERID = CT.CUSTOMERID
INNER JOIN BICYCLE B ON B.CUSTOMERID = C.CUSTOMERID
WHERE YEAR(TRANSACTIONDATE) = '2002' AND CT.AMOUNT > 0
GROUP BY B.CUSTOMERID, C.LASTNAME, C.FIRSTNAME
ORDER BY SUM(CT.AMOUNT) DESC;

--11

SELECT	COUNT(MODELTYPE) AS [SOLD IN 2002]
FROM	BIKE..BICYCLE
WHERE	MODELTYPE LIKE '%MOUNTAIN%' AND ORDERDATE LIKE '%2000%' 

SELECT	COUNT(MODELTYPE) AS [SOLD IN 2004] 
FROM	BIKE..BICYCLE 
WHERE	MODELTYPE LIKE '%MOUNTAIN%' AND ORDERDATE LIKE '%2004%'

--12

SELECT	I.COMPONENTID, M.MANUFACTURERNAME, C.PRODUCTNUMBER, C.CATEGORY, SUM(I.PRICEPAID) AS [VALUE]
FROM	BIKE..PURCHASEORDER PO INNER JOIN BIKE..PURCHASEITEM I ON PO.PURCHASEID = I.PURCHASEID 
		INNER JOIN BIKE..COMPONENT C ON I.COMPONENTID = C.COMPONENTID 
		INNER JOIN BIKE..MANUFACTURER M ON C.MANUFACTURERID = M.MANUFACTURERID 
WHERE	ORDERDATE LIKE '%2003%' 
GROUP BY I.COMPONENTID, M.MANUFACTURERNAME, C.PRODUCTNUMBER, C.CATEGORY
HAVING	SUM(I.PRICEPAID) = (SELECT	TOP 1 SUM(PRICEPAID) 
							FROM BIKE..PURCHASEITEM P INNER JOIN BIKE..PURCHASEORDER PO ON P.PURCHASEID = PO.PURCHASEID 
							WHERE PO.ORDERDATE LIKE '%2003%' 
							GROUP BY COMPONENTID 
							ORDER BY SUM(PRICEPAID) DESC 
							)

--13

SELECT E.EMPLOYEEID, E.LASTNAME, COUNT(B.PAINTID) AS [NUMBERPAINTED]
FROM BIKE..EMPLOYEE E INNER JOIN BIKE..BICYCLE B ON E.EMPLOYEEID = B.EMPLOYEEID
		   INNER JOIN BIKE..PAINT P ON B.PAINTID = P.PAINTID
WHERE ORDERDATE BETWEEN '05/01/2003' AND '05/31/2003'
GROUP BY E.EMPLOYEEID, E.LASTNAME

--14

SELECT	B.STOREID, R.STORENAME, C.CITY, SUM(B.SALEPRICE) AS "SumOfSalePrice"
FROM	BIKE..BICYCLE B INNER JOIN BIKE..RETAILSTORE R ON B.STOREID = R.STOREID 
		INNER JOIN BIKE..CITY C ON R.CITYID = C.CITYID  
WHERE	B.SALESTATE = 'CA' AND
		YEAR(B.ORDERDATE) = '2003'
GROUP BY B.STOREID, R.STORENAME, C.CITY
HAVING	SUM(B.SALEPRICE) = (SELECT	TOP 1 SUM(SALEPRICE)
							FROM	BIKE..BICYCLE B INNER JOIN BIKE..RETAILSTORE R ON B.STOREID = R.STOREID 
									INNER JOIN BIKE..CITY C ON R.CITYID = C.CITYID  
							WHERE	SALESTATE = 'CA' AND
									YEAR(ORDERDATE) = '2003'
							GROUP BY STORENAME	 
							ORDER BY SUM(SALEPRICE) DESC 
							) 

--15

SELECT SUM(CO.WEIGHT) AS TOTALWEIGHT 
FROM BIKE..COMPONENT CO INNER JOIN BIKE..BIKEPARTS BP ON CO.COMPONENTID = BP.COMPONENTID
WHERE BP.SERIALNUMBER = 11356

--16

SELECT G.GROUPNAME, SUM(CO.LISTPRICE) AS SUMOFLISTPRICE
FROM BIKE..GROUPO G INNER JOIN BIKE..GROUPCOMPONENTS GC ON G.COMPONENTGROUPID = GC.GROUPID
	 INNER JOIN BIKE..COMPONENT CO ON GC.COMPONENTID = CO.COMPONENTID
WHERE G.GROUPNAME = 'CAMPY RECORD 2002'
GROUP BY G.GROUPNAME
ORDER BY SUM(CO.LISTPRICE)

--17

SELECT T.MATERIAL, COUNT(B.SerialNumber) as CountOfSerialNumber
From BIKE..TubeMaterial T INNER JOIN BIke..BicycleTubeUsage BTU on
                   T.TubeID = BTU.TubeID
            INNER JOIN BIKE..Bicycle B on
                   BTU.SerialNumber = B.SerialNumber
            INNER JOIN BIKE..BikeTubes BT on
                   B.SerialNumber = BT.SerialNumber

Where Year(B.StartDate) = 2003 AND
             B.ModelType = 'Race' AND
             (T.Material LIKE '%carbon%' Or
             T.Material LIKE '%Titanium%') AND
             BT.TubeName = 'Down'

Group by T.Material
Order by Count(*) desc

--18

Select AVG(P.PricePaid) as AvgOfPricePaid
From Bike..PurchaseItem P  INNER JOIN Bike..Component C on
                        C.ComponentID = P.ComponentID
                       INNER JOIN Bike..GroupComponents GC on
                        C.ComponentID = GC.ComponentID
                       INNER JOIN Bike..Groupo G on
                           GC.GroupID = G.ComponentGroupID

Where C.Category = 'Rear Derailleur' AND
      G.GroupName = 'Shimano XTR 2001'

--19 

Select AVG(B.TopTube) as AvgOfTopTube
From  Bike..Bicycle B  INNER JOIN Bike..BikeTubes BT on

           BT.SerialNumber = B.SerialNumber
      INNER JOIN Bike..BikeParts BP on
           B.SerialNumber = BP.SerialNumber
      INNER JOIN Bike..PurchaseItem P on
           BP.ComponentID = P.ComponentID

Where B.FrameSize = 54 AND
      B.ModelType = 'Road' AND
      Year(B.StartDate) = 1999 AND
      BT.TubeName = 'Top'

--20 

Select Road, Avg(ListPrice) as AvgOfListPrice
From Bike..Component
Where Category LIKE '%Wheel%' AND

(
Road = 'Road' Or
Road = 'MTB'
)
Group by Road
Order by AvgOfListPrice desc

--21 

Select Distinct E.EmployeeID, E.LastName
From Bike..Bicycle B INNER JOIN Bike..Employee E on
                   B.EmployeeID = E.EmployeeID

Where B.Painter = B.EmployeeID AND
      Year(B.OrderDate) = 2003 AND
      Month(B.OrderDate) = 5 AND
      B.ModelType = 'Road'


--23

SELECT SERIALNUMBER, MODELTYPE, ORDERDATE, SALEPRICE
FROM BICYCLE
WHERE MODELTYPE = 'RACE' AND
	  YEAR(ORDERDATE) = 2003 AND
	  SALEPRICE > ( SELECT AVG(SALEPRICE) FROM BICYCLE WHERE MODELTYPE = 'RACE' AND YEAR(ORDERDATE) = 2002);

--24

SELECT DISTINCT M.MANUFACTURERNAME, C.PRODUCTNUMBER, C.CATEGORY, (C.ESTIMATEDCOST * C.QUANTITYONHAND) AS VALUE, C.COMPONENTID
FROM COMPONENT C
INNER JOIN BIKEPARTS BP ON C.COMPONENTID = BP.COMPONENTID
INNER JOIN MANUFACTURER M ON C.MANUFACTURERID = M.MANUFACTURERID
WHERE YEAR(BP.DATEINSTALLED) <> 2004 AND (C.ESTIMATEDCOST * C.QUANTITYONHAND) =
(SELECT MAX(C.ESTIMATEDCOST*C.QUANTITYONHAND)
 FROM COMPONENT C 
 INNER JOIN BIKEPARTS BP ON C.COMPONENTID = BP.COMPONENTID
 WHERE YEAR(BP.DATEINSTALLED) <> 2004);

--25

SELECT R.STORENAME, R.PHONE
FROM RETAILSTORE R
INNER JOIN BICYCLE B ON B.STOREID = R.STOREID
INNER JOIN CITY C ON C.CITYID = R.CITYID
WHERE YEAR(B.ORDERDATE) = 2004 AND (C.STATE = 'CA' OR B.SALESTATE = 'CA')
GROUP BY R.STORENAME, R.PHONE

--26

SELECT (SELECT LASTNAME
	FROM EMPLOYEE
	WHERE EMPLOYEEID = (SELECT EMPLOYEEID
			    FROM EMPLOYEE
			    WHERE LASTNAME = 'VENETIAAN')) AS [MANAGER NAME], EMPLOYEEID,
	FIRSTNAME, LASTNAME, TITLE
FROM EMPLOYEE
WHERE CURRENTMANAGER = (SELECT EMPLOYEEID
			FROM EMPLOYEE
			WHERE LASTNAME = 'VENETIAAN');

--27

SELECT C.COMPONENTID, M.MANUFACTURERNAME, C.PRODUCTNUMBER, C.CATEGORY, SUM(QUANTITYRECEIVED) AS [TOTAL RECEIVED], SUM(B.QUANTITY) AS [TOTAL USE], SUM(QUANTITYRECEIVED) - SUM(B.QUANTITY) AS [NETGAIN], (SUM(QUANTITYRECEIVED) - SUM(B.QUANTITY)) / SUM(B.QUANTITY) AS [NETPCT], LISTPRICE
FROM MANUFACTURER M
INNER JOIN COMPONENT C ON M.MANUFACTURERID = C.MANUFACTURERID
INNER JOIN PURCHASEITEM P ON P.COMPONENTID = C.COMPONENTID
INNER JOIN PURCHASEORDER PO ON P.PURCHASEID = PO.PURCHASEID
INNER JOIN BIKEPARTS B ON C.COMPONENTID = B.COMPONENTID
WHERE B.DATEINSTALLED < '2000-07-01' AND ORDERDATE < '2000-07-01'
GROUP BY C.COMPONENTID, M.MANUFACTURERNAME, C.PRODUCTNUMBER, C.CATEGORY, LISTPRICE
HAVING (SUM(QUANTITYRECEIVED) - SUM(B.QUANTITY)) / SUM(B.QUANTITY) >= 1.25;

--28

SELECT YEAR(ORDERDATE) AS [YEAR], AVG(DATEDIFF(DAY, ORDERDATE, SHIPDATE)) AS [BUILD TIME]
FROM BICYCLE
GROUP BY YEAR(ORDERDATE)
HAVING AVG(DATEDIFF(DAY, ORDERDATE, SHIPDATE)) > (SELECT AVG(DATEDIFF(DAY, ORDERDATE, SHIPDATE)) AS [TOTAL AVERAGE]
						  FROM BICYCLE);
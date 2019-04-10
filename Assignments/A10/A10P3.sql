CREATE PROCEDURE A10
AS
BEGIN


ALTER TABLE FACTTABLE
DROP CONSTRAINT FK_FACT_PILOTDIM

ALTER TABLE FACTTABLE
DROP CONSTRAINT FK_FACT_AIRCRAFTDIM 

ALTER TABLE FACTTABLE
DROP CONSTRAINT FK_FACT_TIMEDIM


TRUNCATE TABLE FACTTABLE
TRUNCATE TABLE PILOTDIM
TRUNCATE TABLE AIRCRAFTDIM
TRUNCATE TABLE TIMEDIM

ALTER TABLE FACTTABLE
ADD CONSTRAINT FK_FACT_PILOTDIM FOREIGN KEY (PILOT_KEY) REFERENCES PILOTDIM(PILOT_KEY)

ALTER TABLE FACTTABLE
ADD CONSTRAINT FK_FACT_AIRCRAFTDIM FOREIGN KEY (AIRCRAFT_KEY) REFERENCES AIRCRAFTDIM(AIRCRAFT_KEY)

ALTER TABLE FACTTABLE
ADD CONSTRAINT FK_FACT_TIMEDIM FOREIGN KEY (TIME_KEY) REFERENCES TIMEDIM(TIME_KEY)


INSERT INTO PILOTDIM (EMP_NUM, EMP_FNAME, EMP_LNAME) 
SELECT P.EMP_NUM, E.EMP_FNAME, E.EMP_LNAME
FROM PILOT P INNER JOIN EMPLOYEE E ON P.EMP_NUM = E.EMP_NUM



INSERT INTO AIRCRAFTDIM (AIRCRAFT_KEY)
SELECT MOD_CODE
FROM MODEL

INSERT INTO TIMEDIM (CHAR_DATE)
SELECT CHAR_DATE
FROM CHARTER

TRUNCATE TABLE STAGING 


INSERT INTO STAGING (EMP_NUM, EMP_FNAME, EMP_LNAME, AIRCRAFT_KEY, CHAR_DATE, CHAR_FUEL_GALLONS, CHAR_DISTANCE, REVENUE)
SELECT P.EMP_NUM, E.EMP_FNAME, E.EMP_LNAME, M.MOD_CODE, CH.CHAR_DATE, CH.CHAR_FUEL_GALLONS, CH.CHAR_DISTANCE,SUM(CHAR_FUEL_GALLONS*CHAR_DISTANCE)AS REVENUE
FROM  PILOT P INNER JOIN EMPLOYEE E ON P.EMP_NUM = E.EMP_NUM
	  INNER JOIN CREW C ON E.EMP_NUM = C.EMP_NUM
	  INNER JOIN CHARTER CH ON C.CHAR_TRIP = CH.CHAR_TRIP
	  INNER JOIN AIRCRAFT A ON CH.AC_NUMBER = A.AC_NUMBER
	  INNER JOIN MODEL M ON A.MOD_CODE = M.MOD_CODE  
GROUP BY P.EMP_NUM, E.EMP_FNAME, E.EMP_LNAME, M.MOD_CODE, CH.CHAR_DATE, MONTH(CH.CHAR_DATE), YEAR(CH.CHAR_DATE), CH.CHAR_FUEL_GALLONS, CH.CHAR_DISTANCE


UPDATE STAGING 
SET PILOT_KEY = P.PILOT_KEY
FROM STAGING S INNER JOIN PILOTDIM P ON S.EMP_NUM = P.EMP_NUM

UPDATE STAGING
SET MODEL_KEY = A.AIRCRAFT_KEY
FROM STAGING S INNER JOIN AIRCRAFTDIM A ON S.MOD_CODE = A.MOD_CODE

UPDATE STAGING
SET TIME_KEY = T.TIME_KEY
FROM STAGING S INNER JOIN TIMEDIM T ON S.CHAR_DATE = T.CHAR_DATE

INSERT INTO FACTTABLE (PILOT_KEY, AIRCRAFT_KEY, TIME_KEY, CHAR_FUEL_GALLONS)  
SELECT PILOT_KEY, AIRCRAFT_KEY, TIME_KEY, CHAR_FUEL_GALLONS
FROM STAGING

END

EXEC A10

SELECT *
FROM STAGING

SELECT *
FROM FACTTABLE
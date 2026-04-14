create database Data_crea_and_mig
use Data_crea_and_mig


-- CREATING TABLES
-- SUPPLIER   [SUPPLIERID , SUPPLIERCODE, SUPPLIER NAME]



-- SUPPLIERS
CREATE TABLE SUPPLIERS(
  SUPPLIEID INT PRIMARY KEY IDENTITY(1,1),
  SUPPLIERCODE NVARCHAR(50) NOT NULL UNIQUE,
  SUPPLIERNAME VARCHAR(50) NOT NULL 
  )
SELECT * FROM SUPPLIERS

SP_RENAME 'SUPPLIERS.SUPPLIEID','SUPPLIERID'


 -- CUSTOMERS
 CREATE TABLE CUSTOMERS(
   CUSTOMERID INT PRIMARY KEY IDENTITY(1,1),
   CUSTOMERCODE NVARCHAR(50) NOT NULL UNIQUE,
   CUSTOMERNAME VARCHAR(100) NOT NULL
   )
SELECT * FROM CUSTOMERS



-- RAW MATERIAL
CREATE TABLE RAWMATERIALS(
   MATERIALID INT PRIMARY KEY IDENTITY(1,1),
   MATERIALNAME NVARCHAR(100) NOT NULL,
   MATERIALGRADE  NVARCHAR(50) NULL,
   CONSTRAINT UNIQUE_MATERIAL UNIQUE(MATERIALNAME, MATERIALGRADE)
   )
SELECT * FROM RAWMATERIALS


-- MACHINES 
CREATE TABLE MACHINES(
   MACHINEID INT PRIMARY KEY IDENTITY(1,1),
   MACHINECODE  NVARCHAR(50) NOT NULL UNIQUE,
   MACHINENAME NVARCHAR(50) NOT NULL,
   MACHINETYPE NVARCHAR(50) NULL , 
   PLANTID NVARCHAR(10) NOT NULL,
   LASTMAINTAINANCEDATE DATE NULL
   )
SELECT * FROM MACHINES


-- PRODUCTIONORDERS
CREATE TABLE PRODUCTIONORDERS(
  PRODUCTIONID INT PRIMARY KEY IDENTITY(1,1),
  PRODUCTIONCODE NVARCHAR(20) NOT NULL UNIQUE,
  CUSTOMERID  INT NOT NULL,
  COMPONENTTOPRODUCE  NVARCHAR(255) NOT NULL,
  QUANTITYTOPRODUCE  INT NOT NULL, 
  ORDERDATE DATETIME NOT NULL,
  SCHEDULEDSTARTDATE DATETIME NOT NULL,
  SCHEDULEDENDDATE DATETIME NOT NULL,
  [STATUS]  NVARCHAR(50) NOT NULL,
  ASSIGNEDMACHINEID INT NULL , 
  PLANTID INT NOT NULL,

  FOREIGN KEY (CUSTOMERID) REFERENCES CUSTOMERS(CUSTOMERID),
  FOREIGN KEY (ASSIGNEDMACHINEID) REFERENCES MACHINES(MACHINEID),
  CONSTRAINT CHK_PRODUCTION_STATUS CHECK([STATUS] IN ('Scheduled','In Progress','Complete', 'On Hold', 'Cancelled','Rework Required','Quoted','Pending Materials','Rework Completed')),
  CONSTRAINT CHK_ORDERDATES CHECK(SCHEDULEDSTARTDATE >=ORDERDATE),
  CONSTRAINT CHK_SCHEDULESEQUENCE CHECK (SCHEDULEDENDDATE >= SCHEDULEDSTARTDATE)
  )
SELECT * FROM PRODUCTIONORDERS




---MATERIAL INVENTORY
CREATE TABLE MATERIALINVENTORY(
  BATCHID INT PRIMARY KEY IDENTITY(1,1),
  ORIGINALBTACHID NVARCHAR(50) UNIQUE,
  MATERIALID INT NOT NULL,
  SUPPLIERID INT NOT NULL,
  RECEIVED_DATE  DATE NOT NULL,
  INITIAL_QUANTITY DECIMAL(10,2) NOT NULL,
  REMAINING_QUANTITY DECIMAL(10,2) NOT NULL,
  UNIT NVARCHAR(10) NOT NULL,

  FOREIGN KEY (MATERIALID) REFERENCES  RAWMATERIALS(MATERIALID),
  FOREIGN KEY (SUPPLIERID) REFERENCES SUPPLIERS(SUPPLIERID))

SELECT * FROM MATERIALINVENTORY



-- PRODUCTIONMATERIALUSAGE
CREATE TABLE PRODUCTIOMATERIALUSAGE(
	 UsageID int primary key identity(1,1),
	 ProductionOrderID int not null,
	 BatchID int not null, 
	 Quantity_Used decimal(10,2) not null,

	 FOREIGN KEY (ProductionOrderID) references PRODUCTIONORDERS(PRODUCTIONID),
	 Foreign key (BatchID) references MATERIALINVENTORY(BATCHID)
	 )

select * from PRODUCTIOMATERIALUSAGE


-- EMPLOYEES
create table employees(
   EmployeeID int primary key identity(1,1),
   FullName Nvarchar(100) not null ,
   [Role] nvarchar(50) not null
   )
select * from employees


-- QUALITYCHECK
Create table Qualitychecks(
    Qualitycheckid int primary key identity(1,1),
	OrigianlQualityCheckID nvarchar(50),
	ProductionOrderID int not null,
	InspectorID int not null,
	CheckTimeStamp Datetime not null,
	Results  Nvarchar(10) ,

	foreign key (ProductionOrderID) references PRODUCTIONORDERS(PRODUCTIONID),

	foreign key (InspectorID) references employees(EmployeeID)
)




--   -------------------   -------- MIGRATION OF DATA FROM THE ORIGINAL DATA SOURCE TO MY DATABASES ------------------------------


-- SUPPLIERS
select * from SUPPLIERS

select supplierid , suppliername from abc_10000

select distinct supplierid from abc_10000
select distinct suppliername from abc_10000
select distinct supplierid , suppliername from abc_10000

--
alter table suppliers
drop column suppliercode
-- 
alter table suppliers
drop UQ__SUPPLIER__114532B91F9C323B
--
select * from SUPPLIERS
--
select Distinct 
   case 
     when suppliername like '%PlasticPro%' then 'PlasticPro Inc.'
	 when suppliername like 'Steel Corp%' then 'SteelCorp'
	 when suppliername like 'Copper Co%' then 'CopperCo'
	 when suppliername like 'Alu Works%' then 'AluWorks'
	 when suppliername like 'GlobalMetals%' then 'Global Metals'
	 else suppliername
	end
 from abc_10000 where suppliername is not null
 


 -- 
 insert into SUPPLIERS(SUPPLIERNAME)
 select Distinct 
   case 
     when suppliername like '%PlasticPro%' then 'PlasticPro Inc.'
	 when suppliername like 'Steel Corp%' then 'SteelCorp'
	 when suppliername like 'Copper Co%' then 'CopperCo'
	 when suppliername like 'Alu Works%' then 'AluWorks'
	 when suppliername like 'GlobalMetals%' then 'Global Metals'
	 else suppliername
	end
 from abc_10000 where suppliername is not null
 

 select * from abc_10000

 select * from SUPPLIERS




-- Customers table
select * from CUSTOMERS
SELECT * FROM ABC_10000

SELECT DISTINCT CUSTOMERORDERID FROM ABC_10000
SELECT DISTINCT CUSTOMERNAME FROM ABC_10000


SELECT DISTINCT CUSTOMERORDERID, CUSTOMERNAME FROM ABC_10000

SELECT * FROM CUSTOMERS
--
ALTER TABLE CUSTOMERS
DROP COLUMN  CUSTOMERCODE
-- 
ALTER TABLE CUSTOMERS
DROP UQ__CUSTOMER__39788EB06507E8E8
--
SELECT * FROM CUSTOMERS


-- INSERT
INSERT INTO CUSTOMERS(CUSTOMERNAME)
SELECT DISTINCT CUSTOMERNAME FROM ABC_10000

SELECT * FROM  CUSTOMERS






-- RAW MATERIAL TABLE
SELECT * FROM RAWMATERIALS
SELECT * FROM ABC_10000

SELECT  DISTINCT MATERIALNAME FROM ABC_10000
SELECT DISTINCT MATERIALGRADE FROM ABC_10000

SELECT DISTINCT MATERIALNAME, MATERIALGRADE FROM ABC_10000

-- INSERT 
INSERT INTO RAWMATERIALS(MATERIALNAME, MATERIALGRADE)
SELECT DISTINCT MATERIALNAME, MATERIALGRADE FROM ABC_10000


--
SELECT * FROM RAWMATERIALS



--- MACHINES
SELECT * FROM MACHINES
SELECT * FROM ABC_10000


-- MACHINE CODE
SELECT DISTINCT MACHINEID FROM ABC_10000
SELECT DISTINCT MACHINEID , MACHINENAME FROM ABC_10000
--
ALTER TABLE MACHINES
DROP COLUMN MACHINECODE
-- 
ALTER TABLE MACHINES
DROP UQ__MACHINES__3EF2FB62C55D58FD
--
SELECT * FROM MACHINES

-- MACHINE NAMES
SELECT DISTINCT TRIM(REPLACE(REPLACE(MACHINENAME,'P1-',''),'P2-','')) FROM ABC_10000

-- MACHINE TPYE
SELECT DISTINCT TRIM(MACHINETYPE) FROM ABC_10000


-- PLANT ID 
SELECT DISTINCT LEFT(MACHINENAME, 2) FROM ABC_10000

-- LAST MAINTAINANCE DATE
INSERT INTO MACHINES(MACHINENAME, MACHINETYPE,PLANTID, LASTMAINTAINANCEDATE)
SELECT TRIM(REPLACE(REPLACE(MACHINENAME,'P1-',''),'P2-','')),TRIM(MACHINETYPE), LEFT(MACHINENAME, 2) , 
MAX(LASTMAINTENANCEDATE) FROM ABC_10000
GROUP BY TRIM(REPLACE(REPLACE(MACHINENAME,'P1-',''),'P2-','')),TRIM(MACHINETYPE), LEFT(MACHINENAME, 2) 


-- CAST AND CONVERT [MM-DD-YY]
INSERT INTO MACHINES(MACHINENAME, MACHINETYPE,PLANTID, LASTMAINTAINANCEDATE)
SELECT TRIM(REPLACE(REPLACE(MACHINENAME,'P1-',''),'P2-','')),TRIM(MACHINETYPE), LEFT(MACHINENAME, 2) , 
MAX(TRY_CONVERT(DATE, LASTMAINTENANCEDATE)) FROM ABC_10000
GROUP BY TRIM(REPLACE(REPLACE(MACHINENAME,'P1-',''),'P2-','')),TRIM(MACHINETYPE), LEFT(MACHINENAME, 2) 


SELECT * FROM MACHINES




-------------   material inventory
select * from MATERIALINVENTORY
select * from ABC_10000


-- original batch id 
select distinct RawMaterialBatchID from ABC_10000
select distinct LEFT(RawMaterialBatchID,7) from ABC_10000


-- material id 
select * from RAWMATERIALS


-- supplier id 
select * from SUPPLIERS


-- received date
select ReceiveDate from ABC_10000   -- daate type , consistent values .
select ReceiveDate, TRY_CONVERT(date, ReceiveDate, 105) from ABC_10000


--initial quantity
select InitialQuantity from ABC_10000
select  CAST(initialquantity AS float) from ABC_10000  -- error 
--
select  InitialQuantity from ABC_10000 where InitialQuantity like '%[^0-9.]%'
-- clean  [, $, scientific , space]
select  initialquantity , cast(cast(replace(replace(REPLACE(initialquantity, '$',''),',',''),' ','') as float) as decimal(10,2)) from ABC_10000


-- remaining  quantity cannot be filleds at this stage

-- constraint
alter table MATERIALINVENTORY
add  CONSTRAINT chk_Unit CHECK (Unit IN ('KG', 'M', 'PCS', 'FT', 'SQ_FT'))


-- unit
select *  from abc_10000 where Unit like '%lbS%'

alter table materialinventory 
drop chk_Unit

alter table MATERIALINVENTORY
add  CONSTRAINT chk_Unit CHECK (Unit IN ('KG', 'M', 'PCS', 'FT', 'SQ_FT', 'LBS'))



-- unit 
select unit from ABC_10000

SELECT DISTINCT STANDARDUNIT FROM 
(
select unit, 
case 
   WHEN UPPER(TRIM(Unit)) IN ('KG', 'KILOGRAM', 'KGS') THEN 'KG'
   WHEN UPPER(TRIM(UNIT)) IN ('M','METERS','METER') THEN 'M'
   WHEN UPPER(TRIM(UNIT)) IN ('PCS','PIECES') THEN 'PCS'
   WHEN UPPER(TRIM(UNIT)) IN ('FT', 'FEET') THEN 'FT'
   WHEN UPPER(TRIM(UNIT)) IN ('SQ FT' ,'SQUARE FEET') THEN 'SQ_FT'
   WHEN UPPER(TRIM(UNIT)) ='LBS' THEN 'LBS'
   ELSE NULL
   END AS STANDARDUNIT
from ABC_10000
)K


-- COMBINE ALL
-- COMMON COLUMN
--- 70% INFO ABC, 15- RAWMATERAIL , 15- SUPPLIER 
WITH T AS 
( 
  SELECT LEFT(RawMaterialBatchID,7) AS RAWMATERIALBATCHID ,
  TRY_CONVERT(date, ReceiveDate, 105) AS RECEIVEDDATE,
  cast(cast(replace(replace(REPLACE(initialquantity, '$',''),',',''),' ','') as float) as decimal(10,2))  AS INITIAL_QUANTITY,
  case 
   WHEN UPPER(TRIM(Unit)) IN ('KG', 'KILOGRAM', 'KGS') THEN 'KG'
   WHEN UPPER(TRIM(UNIT)) IN ('M','METERS','METER') THEN 'M'
   WHEN UPPER(TRIM(UNIT)) IN ('PCS','PIECES') THEN 'PCS'
   WHEN UPPER(TRIM(UNIT)) IN ('FT', 'FEET') THEN 'FT'
   WHEN UPPER(TRIM(UNIT)) IN ('SQ FT' ,'SQUARE FEET') THEN 'SQ_FT'
   WHEN UPPER(TRIM(UNIT)) ='LBS' THEN 'LBS'
   ELSE NULL
   END AS STANDARDUNIT
FROM DUMMY
)
SELECT * FROM T

-- SUPPLIER 
SELECT * INTO DUMMY FROM ABC_10000
SELECT * FROM DUMMY
SELECT * FROM SUPPLIERS

UPDATE DUMMY 
SET SupplierName= 
LTRIM(RTRIM(
    case 
     when suppliername like '%PlasticPro%' then 'PlasticPro Inc.'
	 when suppliername like 'Steel Corp%' then 'SteelCorp'
	 when suppliername like 'Copper Co%' then 'CopperCo'
	 when suppliername like 'Alu Works%' then 'AluWorks'
	 when suppliername like 'GlobalMetals%' then 'Global Metals'
	 else suppliername
	end))

SELECT DISTINCT SUPPLIERNAME FROM ABC_10000
SELECT DISTINCT SUPPLIERNAME FROM DUMMY WHERE SupplierName IS NOT NULL
-- SUPPLIER ID


-- RAW MATERIAL TABLE
-- ABC[T]--- SUPPLIER   (SUPPLIER NAME)
-- ABC[]--- RAW MATERIAL TABLE( MATERIALNAME, MATERIALGRADE)


-- LETS JOIN
WITH T AS 
( 
  SELECT LEFT(RawMaterialBatchID,7) AS RAWMATERIALBATCHID ,
  TRY_CONVERT(date, ReceiveDate, 105) AS RECEIVEDDATE,
  cast(cast(replace(replace(REPLACE(initialquantity, '$',''),',',''),' ','') as float) as decimal(10,2))  AS INITIAL_QUANTITY,
  case 
   WHEN UPPER(TRIM(Unit)) IN ('KG', 'KILOGRAM', 'KGS') THEN 'KG'
   WHEN UPPER(TRIM(UNIT)) IN ('M','METERS','METER') THEN 'M'
   WHEN UPPER(TRIM(UNIT)) IN ('PCS','PIECES') THEN 'PCS'
   WHEN UPPER(TRIM(UNIT)) IN ('FT', 'FEET') THEN 'FT'
   WHEN UPPER(TRIM(UNIT)) IN ('SQ FT' ,'SQUARE FEET') THEN 'SQ_FT'
   WHEN UPPER(TRIM(UNIT)) ='LBS' THEN 'LBS'
   ELSE NULL
   END AS STANDARDUNIT, SupplierName, MaterialName, MaterialGrade
FROM DUMMY
)
SELECT T.RAWMATERIALBATCHID, m.MATERIALID, s.SUPPLIERID,t.RECEIVEDDATE,t.INITIAL_QUANTITY , T.STANDARDUNIT FROM T INNER JOIN 
SUPPLIERS  as s on s.SUPPLIERNAME= T.SupplierName
inner join  RAWMATERIALS as m 
on m.MATERIALGRADE=T.MaterialGrade and m.MATERIALNAME=T.MaterialName

-- insert
select * from MATERIALINVENTORY
WITH T AS 
( 
  SELECT LEFT(RawMaterialBatchID,7) AS RAWMATERIALBATCHID ,
  TRY_CONVERT(date, ReceiveDate, 105) AS RECEIVEDDATE,
  cast(cast(replace(replace(REPLACE(initialquantity, '$',''),',',''),' ','') as float) as decimal(10,2))  AS INITIAL_QUANTITY,
  case 
   WHEN UPPER(TRIM(Unit)) IN ('KG', 'KILOGRAM', 'KGS') THEN 'KG'
   WHEN UPPER(TRIM(UNIT)) IN ('M','METERS','METER') THEN 'M'
   WHEN UPPER(TRIM(UNIT)) IN ('PCS','PIECES') THEN 'PCS'
   WHEN UPPER(TRIM(UNIT)) IN ('FT', 'FEET') THEN 'FT'
   WHEN UPPER(TRIM(UNIT)) IN ('SQ FT' ,'SQUARE FEET') THEN 'SQ_FT'
   WHEN UPPER(TRIM(UNIT)) ='LBS' THEN 'LBS'
   ELSE NULL
   END AS STANDARDUNIT, SupplierName, MaterialName, MaterialGrade
FROM DUMMY
)
insert into MATERIALINVENTORY(ORIGINALBTACHID, MATERIALID, SUPPLIERID,RECEIVED_DATE,INITIAL_QUANTITY, UNIT)
SELECT T.RAWMATERIALBATCHID, m.MATERIALID, s.SUPPLIERID,t.RECEIVEDDATE,t.INITIAL_QUANTITY , T.STANDARDUNIT FROM T INNER JOIN 
SUPPLIERS  as s on s.SUPPLIERNAME= T.SupplierName
inner join  RAWMATERIALS as m 
on m.MATERIALGRADE=T.MaterialGrade and m.MATERIALNAME=T.MaterialName

-- remove
alter table materialinventory
alter column remaining_quantity decimal(9,2) null

alter table materialinventory
drop UQ__MATERIAL__AD0C51EF12A9B714



select * from MATERIALINVENTORY


delete from MATERIALINVENTORY
dbcc  checkident('MATERIALINVENTORY', reseed, 0)




---------------------------------------------------------- PRODUCTION ORDERS ----------------------------------
SELECT * FROM PRODUCTIONORDERS
-- 60 -- DATA IS FROM ABC
-- 10 CUSTOMER --- CUSTOMERS ID 
-- 30 MACHINES ---- MACHINE ID AND PLANT ID 


-- PRODUCTION CODE
SELECT DISTINCT ProductionOrderID FROM ABC_10000
SELECT DISTINCT REPLACE(REPLACE(PRODUCTIONORDERID,'/','-'),'_','-') FROM ABC_10000

---
SELECT DISTINCT RIGHT(REPLACE(REPLACE(PRODUCTIONORDERID,'/','-'),'_','-'),4) FROM ABC_10000


---CUSTOMER ID
SELECT * FROM CUSTOMERS
SELECT * FROM DUMMY AS D
INNER JOIN 
CUSTOMERS as c  on c.CUSTOMERNAME= D.CustomerName

--- component to produce
select componenttoproduce from ABC_10000


-- quantity to produce
select quantitytoproduce from ABC_10000
select cast(ceiling(QuantityToProduce) as int) from ABC_10000

-- order date 
select orderdate, TRY_CONVERT(datetime, OrderDate,105) from ABC_10000 -- dd-mm-yy
select orderdate, TRY_CONVERT(datetime, OrderDate,110) from ABC_10000 -- mm-dd-yy
select orderdate , coalesce(
          TRY_CONVERT(datetime, OrderDate,105),
		  TRY_CONVERT(datetime, OrderDate,110)) from ABC_10000
	
	
-- schedule start date and schedule end date 
select ScheduledStart, TRY_CONVERT(datetime, ScheduledStart, 105) , ScheduledEnd, TRY_CONVERT(datetime, ScheduledEnd,105) from ABC_10000


-- status
select distinct [Status]  from ABC_10000

([STATUS]='Rework Completed' OR [STATUS]='Pending Materials' OR [STATUS]='Quoted' OR [STATUS]='Rework Required' OR [STATUS]='Cancelled' OR [STATUS]='On Hold' OR [STATUS]='Complete' OR [STATUS]='In Progress' OR [STATUS]='Scheduled')


-- machine id and plant id 
select * from MACHINES
select * from ABC_10000


update DUMMY 
set MachineName =  TRIM(REPLACE(REPLACE(MACHINENAME,'P1-',''),'P2-','')),
MachineType =  TRIM(MACHINETYPE) 

select * from DUMMY

select * from MACHINES as m
inner join DUMMY as d
 on m.MACHINENAME= d.MachineName and m.MACHINETYPE= d.MachineType


--- data selection
select right(REPLACE(REPLACE(d.PRODUCTIONORDERID,'/','-'),'_','-'),4) as originalProductionId, c.CUSTOMERID, d.ComponentToProduce,cast(ceiling(d.QuantityToProduce) as int)as Quantity_to_produce ,
 coalesce(
          TRY_CONVERT(datetime, OrderDate,105),
		  TRY_CONVERT(datetime, OrderDate,110)) as OrderDate,
		TRY_CONVERT(datetime, ScheduledStart, 105)  as scheduledStart, 
		TRY_CONVERT(datetime, ScheduledEnd,105) as ScheduledEnd,
		d.Status, m.MACHINEID, m.PLANTID
FROM dummy as d 
inner join CUSTOMERS as c on c.CUSTOMERNAME= d.CustomerName
 inner join MACHINES  as m  on m.MACHINENAME= d.MachineName and m.MACHINETYPE= d.MachineType


 -- insertion 
 insert into PRODUCTIONORDERS(PRODUCTIONCODE, CUSTOMERID, COMPONENTTOPRODUCE, QUANTITYTOPRODUCE, ORDERDATE, SCHEDULEDSTARTDATE, SCHEDULEDENDDATE, [STATUS], ASSIGNEDMACHINEID, PLANTID)
 select right(REPLACE(REPLACE(d.PRODUCTIONORDERID,'/','-'),'_','-'),4) as originalProductionId, c.CUSTOMERID, d.ComponentToProduce,cast(ceiling(d.QuantityToProduce) as int)as Quantity_to_produce ,
 coalesce(
          TRY_CONVERT(datetime, OrderDate,105),
		  TRY_CONVERT(datetime, OrderDate,110)) as OrderDate,
		TRY_CONVERT(datetime, ScheduledStart, 105)  as scheduledStart, 
		TRY_CONVERT(datetime, ScheduledEnd,105) as ScheduledEnd,
		d.[Status], m.MACHINEID, m.PLANTID
FROM dummy as d 
inner join CUSTOMERS as c on c.CUSTOMERNAME= d.CustomerName
 inner join MACHINES  as m  on m.MACHINENAME= d.MachineName and m.MACHINETYPE= d.MachineType
 where  TRY_CONVERT(datetime, ScheduledEnd,105)>=TRY_CONVERT(datetime, ScheduledStart, 105)and TRY_CONVERT(datetime, ScheduledStart, 105)>= coalesce(
          TRY_CONVERT(datetime, OrderDate,105),
		  TRY_CONVERT(datetime, OrderDate,110))
 --
 select distinct [status] from DUMMY


 select * from productionorders

 -- editing 
 alter table productionorders
 alter column plantid nvarchar(3)


 alter table productionorders
 drop UQ__PRODUCTI__A52DAC97B35B3D92


 alter table productionorders
 drop CHK_PRODUCTION_STATUS

 alter table productionorders
 add constraint  CHK_PRODUCTION_STATUS  CHECK([STATUS] IN ('Scheduled','In Progress','Completed', 'On Hold', 'Cancelled','Rework Required','Quoted','Pending Materials','Rework Complete'))

delete  from PRODUCTIONORDERS

dbcc  checkident('PRODUCTIONORDERS', reseed, 0)

 -------------------------- production material usage 
 select * from PRODUCTIOMATERIALUSAGE
 select * from DUMMY where RawMaterialBatchID = 'RM-0002'

 select * from MATERIALINVENTORY
 select * from RAWMATERIALS
 select * from PRODUCTIONORDERS

--- add column
alter table PRODUCTIOMATERIALUSAGE	
add MaterialId int 

-- 
alter table PRODUCTIOMATERIALUSAGE
add constraint fk_production foreign key (MaterialId)  references  RAWMATERIALS(materialid)

-- col2 - production orders
-- col3 - material inventory 
-- col4 - dummy 
-- col5 - material inventory 


select * from DUMMY

update DUMMY 
set ProductionOrderID = RIGHT(REPLACE(REPLACE(PRODUCTIONORDERID,'/','-'),'_','-'),4),
    ScheduledStart= TRY_CONVERT(datetime, ScheduledStart, 105),
	ScheduledEnd= TRY_CONVERT(datetime, ScheduledEnd, 105),
	QuantityToProduce=  cast(ceiling(QuantityToProduce) as int)


select * from DUMMY as d
inner join PRODUCTIONORDERS as p 
on d.ProductionOrderID= p.PRODUCTIONCODE and d.ScheduledStart= p.SCHEDULEDSTARTDATE and d.ScheduledEnd= p.SCHEDULEDENDDATE and d.QuantityToProduce= p.QUANTITYTOPRODUCE and d.ComponentToProduce= p.COMPONENTTOPRODUCE


--batch id 
select distinct ORIGINALBTACHID from MATERIALINVENTORY
select distinct MaterialUsedBatchID from DUMMY



select distinct ORIGINALBTACHID from MATERIALINVENTORY 
where ORIGINALBTACHID in 
( 
select distinct MaterialUsedBatchID from DUMMY
)


-- join  and insert 
select * from PRODUCTIOMATERIALUSAGE
insert into PRODUCTIOMATERIALUSAGE(ProductionOrderID, BatchID, Quantity_Used, materialId)
select p.PRODUCTIONID, m.BATCHID, d.QuantityUsed, m.MATERIALID from DUMMY as d
inner join PRODUCTIONORDERS as p 
on d.ProductionOrderID= p.PRODUCTIONCODE and d.ScheduledStart= p.SCHEDULEDSTARTDATE and d.ScheduledEnd= p.SCHEDULEDENDDATE and d.QuantityToProduce= p.QUANTITYTOPRODUCE and d.ComponentToProduce= p.COMPONENTTOPRODUCE
inner join MATERIALINVENTORY as m on m.ORIGINALBTACHID= d.MaterialUsedBatchID


-- editing
alter table PRODUCTIOMATERIALUSAGE
alter column quantity_used decimal(10,2) null

delete from PRODUCTIOMATERIALUSAGE
dbcc  checkident('PRODUCTIOMATERIALUSAGE', reseed, 0)
-- 
select * from PRODUCTIOMATERIALUSAGE


-- 
select * from MATERIALINVENTORY
update m
set m.remaining_quantity= m.initial_quantity- p.quantity_used
from PRODUCTIOMATERIALUSAGE as p 
inner join MATERIALINVENTORY as m 
on p.BatchID= m.BATCHID and p.materialid= m.MATERIALID



select * from MATERIALINVENTORY
update MATERIALINVENTORY
set REMAINING_QUANTITY= INITIAL_QUANTITY where REMAINING_QUANTITY is null



--- ---------------- employees
select * from employees_raw
select * from employees


insert into  employees(FullName, Role)
select * from employees_raw


select * from employees





---------------------------------------- quality check 
select * from Qualitychecks;


--col2 - dummy , col3 -productionorders , col4- employees , col5,6 dummy 

-- col2
select QualityCheckID from DUMMY where QualityCheckID is not null


--- col3
select * from PRODUCTIONORDERS


select * from DUMMY as d
inner join PRODUCTIONORDERS as p 
on d.ProductionOrderID= p.PRODUCTIONCODE and d.ScheduledStart= p.SCHEDULEDSTARTDATE and d.ScheduledEnd= p.SCHEDULEDENDDATE and d.QuantityToProduce= p.QUANTITYTOPRODUCE and d.ComponentToProduce= p.COMPONENTTOPRODUCE where QualityCheckID is not null


--col4
select *,try_convert(datetime, d.CheckTimestamp, 105) from DUMMY as d
inner join PRODUCTIONORDERS as p 
on d.ProductionOrderID= p.PRODUCTIONCODE and d.ScheduledStart= p.SCHEDULEDSTARTDATE and d.ScheduledEnd= p.SCHEDULEDENDDATE and d.QuantityToProduce= p.QUANTITYTOPRODUCE and d.ComponentToProduce= p.COMPONENTTOPRODUCE inner join employees as e on e.FullName= d.InspectorName where QualityCheckID is not null




-- filter and insert 
insert into Qualitychecks(OrigianlQualityCheckID, ProductionOrderID, InspectorID, CheckTimeStamp, Results)
select d.QualityCheckID, p.PRODUCTIONID, e.EmployeeID,try_convert(datetime, d.CheckTimestamp, 105), d.Result from DUMMY as d
inner join PRODUCTIONORDERS as p 
on d.ProductionOrderID= p.PRODUCTIONCODE and d.ScheduledStart= p.SCHEDULEDSTARTDATE and d.ScheduledEnd= p.SCHEDULEDENDDATE and d.QuantityToProduce= p.QUANTITYTOPRODUCE and d.ComponentToProduce= p.COMPONENTTOPRODUCE inner join employees as e on e.FullName= d.InspectorName where QualityCheckID is not null

-- editing
alter table qualitychecks
alter column checktimestamp datetime null


-- 
select * from Qualitychecks



-------------------------    END   ----------------

SELECT * FROM DUMMY


---- SCENERIO - 1
-- QUALITY CHECK - FAILED , 

SELECT * FROM DUMMY WHERE Result= 'FAILED'

SELECT * FROM PRODUCTIOMATERIALUSAGE

-- SCENERIO 2
-- PRODUCTION MATERIAL USAGE -- TABLE --- UPDATED ANY QUANTITY, OR INSERTED ANY NEW ROW ,
-- MATERIAL INVENTORY -- REMAINING QUANTITY


-- SCENERIO 3 
SELECT * FROM PRODUCTIONORDERS
-- NEW PRODUCTION --- INSERT  OR UPDATING SCHEDULE FOR ANY PRODUCTION --- MACHINE THAT IS  TO BE USED IS FREE OF NOT.



-- SCENERIO 4
-- MATERIAL INVENTORY TABLE , I HAVE NO ALARMING SYSTEM.




--------------------------------
        -------------------------------
		                -- SCENERIO -1  -- FAILED QUALITY CHECK  , STATUS SHOULD BE  REWORK REQUIRED.


-- QUALITY CHECK -- QUALITY 
-- STATUS PRODUCTION
--- QUALITY --- FAILED --- PRODUCTION ID --- PRODUCTION TABLE -- STATUS -- UPDATE.

UPDATE PRODUCTIONORDERS 
SET [STATUS]= 'Rework Required' 
where 
PRODUCTIONID IN 
(
SELECT ProductionOrderID FROM Qualitychecks WHERE  Results ='FAILED'
)


select * from  PRODUCTIONORDERS where
PRODUCTIONID IN 
(
SELECT ProductionOrderID FROM Qualitychecks WHERE  Results ='FAILED'
)



-- production table 
-- quality check   [ result]

-- infuture quality result failed , look for the production id  and for that production id , update the status as rework required.
-- trigger - quality check -- after insert 


-- update -- production table ,
-- check --- insert magic table
-- join 

create trigger updateProductionStatus_onfail
on qualitychecks
after insert 
as
begin
    update p
	set P.STATUS='Rework Required'
	from inserted as i 
	inner join PRODUCTIONORDERS as p 
	on i.ProductionOrderID= p.PRODUCTIONID
	where i.Results='Failed'
end 


select * from PRODUCTIONORDERS
select * from Qualitychecks where ProductionOrderID=1



insert into Qualitychecks(OrigianlQualityCheckID, ProductionOrderID, InspectorID, CheckTimeStamp,Results)
values ('QC-283', 1,1, null, 'Failed')





--  scenetio 2
-- any updations in my production material used table should make relative chnages in the inventory table.

    -- any row inserted into production material usgae should show relative changes in the remaining quantity column of the table material inventory.
	-- any updation in already existing material usage should show relative changes in the remaining quantity column.
	-- is quantity used is more than quantity remaining in inventory table , dont allow entiry of that row , or updation of that row.


	-- record quantity used -- 100 remaining -- 500
	         -- quantity used -- 150

-- update inserted -150  , deleted - 100

			 -- old remaining+old used - new used quantity 
			 -- 500+100-150 
			 -- 450 

select * from PRODUCTIOMATERIALUSAGE

-- insert -- insert magic 
-- update -- deleted magic [ old values ] , inserted magic [ new values]



-- actual insert == MI [Rem- Quantity] 
-- update insert == MI[Rem-Quantiy]


-- insert material1= remaining[MI]=1000
-- row insert -- 150 


create trigger trg_updatematerialRemaining
on PRODUCTIOMATERIALUSAGE
after insert , update 
as
begin 

     -- update
	 -- delete 
	 if exists(select 1 from deleted)
	 begin 
	     
		 update mi 
		 set mi.REMAINING_QUANTITY= mi.REMAINING_QUANTITY+d.Quantity_Used   -- 500+100   -- remaning_quantity == 600
		 from deleted as d inner join
		 MATERIALINVENTORY as mi 
		 on d.BatchID= mi.BATCHID and d.MaterialId= mi.MATERIALID
	 end

	 -- insert 
	 update mi 
	 set mi.REMAINING_QUANTITY= mi.REMAINING_QUANTITY-i.Quantity_Used   -- 600- 150  = 450 / 1000-150 = 850
	 from MATERIALINVENTORY as mi 
	 inner join inserted as i 
	 on i.BatchID= mi.BATCHID and i.MaterialId=mi.MATERIALID


	 -- 
	 if exists(select 1
	 from MATERIALINVENTORY as mi 
	 inner join inserted as i 
	 on i.BatchID= mi.BATCHID and i.MaterialId=mi.MATERIALID
	 where mi.REMAINING_QUANTITY<0)

	 begin 
	     raiserror('Insufficient material',16,1)
		 rollback transaction
		 return 
	 end
end 


--
select * from MATERIALINVENTORY where BATCHID= 105
select * from PRODUCTIOMATERIALUSAGE where BatchID= 105

insert into PRODUCTIOMATERIALUSAGE(ProductionOrderID, BatchID, Quantity_Used, MaterialId)
values(5, 105, 200, 573)


update PRODUCTIOMATERIALUSAGE set Quantity_Used= 300 where UsageID= 123477


select * from PRODUCTIONORDERS
--------------------
-- scenerio 3 [ avoidiong multiple machines to be scheduled at same time for different tasks]
CREATE TRIGGER trg_CheckMachineSchedule
ON ProductionOrders
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted AS i
        JOIN ProductionOrders AS p 
            -- Must be for the same machine
            ON i.AssignedMachineID = p.AssignedMachineID 
            -- Must not be the *exact same* order (handles self-updates)
            AND i.ProductionID <> p.ProductionID 
        WHERE
             i.Status NOT IN ('completed', 'cancelled')
            
            -- This is the overlap logic:
            -- 1. The new order's START is before the existing order's END
            AND (i.ScheduledStartDate < p.ScheduledEndDate 
            -- 2. AND the new order's END is after the existing order's START
                 AND i.ScheduledEndDate > p.ScheduledStartDate)
    )
    BEGIN
        -- If a conflict is found, raise an error and cancel the operation
        RAISERROR ('Schedule conflict: The assigned machine is already occupied during this time period.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;



-- 

INSERT INTO ProductionOrders (PRODUCTIONCODE, CustomerID, ComponentToProduce, QuantityToProduce, OrderDate, ScheduledStartDate, ScheduledEndDate, Status, AssignedMachineID, PlantID)
    VALUES (1001, 38, 'Component E6', 88, '2023-12-19 12:20:00.000', '2025-02-16 19:54:00.000', '2025-02-26 18:18:00.000', 'scheduled', 46, 'P1');


select max(ScheduledEndDate) from productionorders


INSERT INTO ProductionOrders (PRODUCTIONCODE, CustomerID, ComponentToProduce, QuantityToProduce, OrderDate, ScheduledStartDate, ScheduledEndDate, Status, AssignedMachineID, PlantID)
    VALUES (1001, 38, 'Component E6', 88, '2023-12-19 12:20:00.000', '2025-12-16 19:54:00.000', '2026-02-26 18:18:00.000', 'scheduled', 46, 'P1');


----  SCENERIO 4 
-- MATERIAL INVENTORY -- KEEP AN ALARM ON MATERIALS WHOSE QUANTITY BECOMES LESS THAN 500 
-- MATERIAL ORDER

CREATE TABLE MaterialLowStockLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    MaterialID INT NOT NULL,
    MaterialName NVARCHAR(100),
    MaterialGrade NVARCHAR(50),
    AlertTriggerQuantity DECIMAL(10, 2), -- How much was left when triggered
    QuantityToOrder DECIMAL(10, 2),      -- The new calculated column
    AlertDate DATETIME DEFAULT GETDATE()
);
SELECT * FROM MATERIALINVENTORY
SELECT * FROM RAWMATERIALS




DROP TRIGGER TRG_LOWSTOCK
-- TRIGGER  MATERIAL INVENTORY 
-- AFTER INSERT OR UPDATE 
CREATE TRIGGER TRG_LOWSTOCK
ON MATERIALINVENTORY
AFTER INSERT , UPDATE 
AS
BEGIN 

    INSERT INTO MaterialLowStockLog(MaterialID, MaterialName, MaterialGRADE, AlertTriggerQuantity, QuantityToOrder)
    SELECT I.MATERIALID, M.MATERIALNAME, M.MATERIALGRADE, I.REMAINING_QUANTITY, (4000-I.REMAINING_QUANTITY) FROM inserted AS I 
	INNER JOIN  RAWMATERIALS AS M ON I.MATERIALID= M.MATERIALID
	WHERE I.REMAINING_QUANTITY<500

END


-- TESTING
SELECT * FROM  MaterialLowStockLog

SELECT * FROM MATERIALINVENTORY
INSERT INTO materialinventory (ORIGINALBTACHID, MaterialID, SupplierID, Received_Date, Initial_Quantity, Remaining_Quantity, Unit)
VALUES ('RM-0001', 2320, 1, '2025-10-25', 400.00, 400.00, 'KG');



UPDATE MATERIALINVENTORY 
SET REMAINING_QUANTITY= 400 WHERE BATCHID= 3






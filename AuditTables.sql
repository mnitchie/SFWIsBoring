CREATE TABLE dbo.workerjobs(
	id uniqueidentifier PRIMARY KEY,
	name nvarchar(max),
	jobdefinition xml,
	ispaused bit,
	modifiedby uniqueidentifier,
	modifieddate datetime
)
GO

CREATE TABLE dbo.workerjobs_audit(
	id uniqueidentifier,
	workerjob_id uniqueidentifier,
	name nvarchar(max),
	jobdefinition xml,
	ispaused bit,
	modifiedby uniqueidentifier,
	modifieddate datetime
)
GO

-- OR

CREATE TABLE dbo.workerjobs_audit(
	id uniqueidentifier DEFAULT NEWID(),
	workerjob_id uniqueidentifier,
	old_name nvarchar(max),
	new_name nvarchar(max),
	old_jobdefinition xml,
	new_jobdefinition xml,
	old_ispaused bit,
	new_ispaused bit,
	modifiedby uniqueidentifier,
	modifieddate datetime
)
GO

CREATE TRIGGER workerjobs_update ON workerjobs WITH EXECUTE AS CALLER AFTER UPDATE, INSERT
AS
SET NOCOUNT ON -- Avoid "(x row(s) affected)" chatter
INSERT INTO workerjobs_audit(
	workerjob_id,
	name,
	jobdefinition,
	ispaused,
	modifiedby,
	modifieddate
)
SELECT i.id,
	i.name,
	i.jobdefinition,
	i.ispaused,
	i.modifiedby,
	i.modifieddate
FROM inserted i
GO

CREATE TRIGGER workerjobs_update ON workerjobs WITH EXECUTE AS CALLER AFTER UPDATE, INSERT
AS
SET NOCOUNT ON -- Avoid "(x row(s) affected)" chatter
INSERT INTO workerjobs_audit(
	workerjob_id,
	old_name,
	new_name,
	old_jobdefinition,
	new_jobdefinition,
	old_ispaused,
	new_ispaused,
	modifiedby,
	modifieddate
)
SELECT i.id,
	d.name,
	i.name,
	d.jobdefinition,
	i.jobdefinition,
	d.ispaused,
	i.ispaused,
	i.modifiedby,
	i.modifieddate
FROM inserted i
JOIN deleted d
	on i.id = d.id
GO

CREATE TABLE dbo.workerjobs(
	id int identity(1,1) NOT NULL PRIMARY KEY,
	name nvarchar(max),
	jobdefinition xml,
	ispaused bit,
	modifiedby int,
	validfrom datetime2 GENERATED ALWAYS AS ROW START,
    validto datetime2 GENERATED ALWAYS AS ROW END,
    PERIOD FOR SYSTEM_TIME (validfrom, validto)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.workerjob_audit));

-- both sets are null

insert into workerjobs(name, jobdefinition, ispaused, modifiedby)
values('First Job', '<Job>1</Job>', 0, 25)

id	name	jobdefinition	ispaused	modifiedby	validfrom	validto
1	First Job	<Job>1</Job>	0	25	2018-08-05 18:27:24.5958669	9999-12-31 23:59:59.9999999

id	name	jobdefinition	ispaused	modifiedby	validfrom	validto

update workerjobs
set ispaused = 1
where id = 1

id	name	jobdefinition	ispaused	modifiedby	validfrom	validto
1	First Job	<Job>1</Job>	1	25	2018-08-05 18:28:26.1098438	9999-12-31 23:59:59.9999999

id	name	jobdefinition	ispaused	modifiedby	validfrom	validto
1	First Job	<Job>1</Job>	0	25	2018-08-05 18:27:24.5958669	2018-08-05 18:28:26.1098438

delete from workerjobs

id	name	jobdefinition	ispaused	modifiedby	validfrom	validto

id	name	jobdefinition	ispaused	modifiedby	validfrom	validto
1	First Job	<Job>1</Job>	0	25	2018-08-05 18:27:24.5958669	2018-08-05 18:28:26.1098438
1	First Job	<Job>1</Job>	1	25	2018-08-05 18:28:26.1098438	2018-08-05 18:29:15.5649488



select avg(datediff(year,dob,getdate())) from demographics where dob is not null

select top 1 PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ages.age) 
    OVER (PARTITION BY 1) AS MedianCont
from (
	select datediff(year,dob,getdate()) as age
	from demographics
	where dob is not null
) as ages

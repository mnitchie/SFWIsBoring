-- Good reference

CREATE TABLE dbo.workerjobs(
	id uniqueidentifier PRIMARY KEY,
	name nvarchar(max),
	jobdefinition xml,
	ispaused bit,
	modifiedby datetime,
	modifieddate datetime
	--...
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

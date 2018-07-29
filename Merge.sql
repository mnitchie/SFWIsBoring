CREATE TABLE Products(
    ID int NOT NULL PRIMARY KEY,
    Name nvarchar(200),
    Description nvarchar(max)
)

UPDATE Target 
SET    Target.Name = Source.Name,
       Target.Description = Source.Description 
FROM   Products AS Target 
       JOIN SourceProducts Source 
            ON Target.ID = Source.ID

INSERT INTO Products (ID, Name, Description)
SELECT S.ID, S.Name, S.Description
FROM   SourceProducts S
WHERE NOT EXISTS (SELECT T.ID
                  FROM   Products T
                  WHERE  T.ID = S.ID)

DELETE T
FROM   Products T
WHERE  NOT EXISTS (SELECT S.ID
                   FROM   SourceProducts S
                   WHERE  T.ID = S.ID)

MERGE INTO <TargetTable>
USING <SourceTable>
ON <JoinCondition> -- The join will vary
WHEN NOT MATCHED BY SOURCE
     THEN DELETE
WHEN NOT MATCHED BY TARGET
     THEN INSERT ...
WHEN MATCHED
     THEN UPDATE ...
;
 
MERGE Products T
USING SourceProducts S
ON (S.ProductID = T.ProductID)
WHEN NOT MATCHED BY SOURCE
     THEN DELETE
WHEN NOT MATCHED BY TARGET
     THEN INSERT (ID, Name, Description)
      VALUES (S.ID, S.Name, S.Description)
WHEN MATCHED 
     THEN UPDATE SET
          T.Name = S.Name,
          T.ProductNumber = S.ProductNumber,
          T.Color = S.Color;
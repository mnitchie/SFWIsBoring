select productcategoryID as id,
coalesce(convert(varchar(10), parentproductcategoryid), '#') as parent,
name as text
from productcategory
for json path
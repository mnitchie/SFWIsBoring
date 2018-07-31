SELECT id, parent, text
FROM Products
FOR JSON PATH


select productcategoryID as id,
coalesce(convert(varchar(10), parentproductcategoryid), '#') as parent,
name as text
from productcategory
for json path

-- for json does the magic
-- delegate the conversion of rowset to json to sql server. If you're going to be doing it anyway why spend the overhead to load it up into memory into your application, transform it to business objects, then probably serialize it to json anyway.
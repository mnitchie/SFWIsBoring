SELECT *
FROM JsonizedProducts
where JSON_VALUE(details, '$.parent') != '#'

DECLARE @json VARCHAR(max)
SET @json = '[{"id":1,"parent":"#","text":"Bikes"},{"id":2,"parent":"#","text":"Components"},{"id":3,"parent":"#","text":"Clothing"},{"id":4,"parent":"#","text":"Accessories"},{"id":5,"parent":"1","text":"Mountain Bikes"},{"id":6,"parent":"1","text":"Road Bikes"},{"id":7,"parent":"1","text":"Touring Bikes"},{"id":8,"parent":"2","text":"Handlebars"},{"id":9,"parent":"2","text":"Bottom Brackets"},{"id":10,"parent":"2","text":"Brakes"},{"id":11,"parent":"2","text":"Chains"},{"id":12,"parent":"2","text":"Cranksets"},{"id":13,"parent":"2","text":"Derailleurs"},{"id":14,"parent":"2","text":"Forks"},{"id":15,"parent":"2","text":"Headsets"},{"id":16,"parent":"2","text":"Mountain Frames"},{"id":17,"parent":"2","text":"Pedals"},{"id":18,"parent":"2","text":"Road Frames"},{"id":19,"parent":"2","text":"Saddles"},{"id":20,"parent":"2","text":"Touring Frames"},{"id":21,"parent":"2","text":"Wheels"},{"id":22,"parent":"3","text":"Bib-Shorts"},{"id":23,"parent":"3","text":"Caps"},{"id":24,"parent":"3","text":"Gloves"},{"id":25,"parent":"3","text":"Jerseys"},{"id":26,"parent":"3","text":"Shorts"},{"id":27,"parent":"3","text":"Socks"},{"id":28,"parent":"3","text":"Tights"},{"id":29,"parent":"3","text":"Vests"},{"id":30,"parent":"4","text":"Bike Racks"},{"id":31,"parent":"4","text":"Bike Stands"},{"id":32,"parent":"4","text":"Bottles and Cages"},{"id":33,"parent":"4","text":"Cleaners"},{"id":34,"parent":"4","text":"Fenders"},{"id":35,"parent":"4","text":"Helmets"},{"id":36,"parent":"4","text":"Hydration Packs"},{"id":37,"parent":"4","text":"Lights"},{"id":38,"parent":"4","text":"Locks"},{"id":39,"parent":"4","text":"Panniers"},{"id":40,"parent":"4","text":"Pumps"},{"id":41,"parent":"4","text":"Tires and Tubes"}]'

SELECT *  
FROM OPENJSON(@json)  
  WITH (id int '$.id',  
        parent nvarchar(50) '$.parent', 
        text nvarchar(50) '$.text')  



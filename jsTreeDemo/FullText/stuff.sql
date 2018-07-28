CREATE TABLE Products(
    ID nvarchar(200) NOT NULL PRIMARY KEY,
    Name nvarchar(200),
    Description nvarchar(max)
)

CREATE FULLTEXT CATALOG SFWIsBoringCatalog

CREATE FULLTEXT INDEX ON Products(Description)  
KEY INDEX PK__Products__2CB664DD7ABDA210 ON SFWIsBoringCatalog
WITH CHANGE_TRACKING AUTO

INSERT INTO Products -- A bunch of stuff


--https://docs.microsoft.com/en-us/sql/t-sql/queries/contains-transact-sql?view=sql-server-2017
-- exact words or groups of words with some powerful pattern matching
select Title
from books
where contains(text, 'creeps') -- dickens invented the word

-- contains and containstable
-- Match single words and phrases with precise or fuzzy (less precise) matching.
-- You can also do the following things:
-- Specify the proximity of words within a certain distance of one another.
-- Return weighted matches.
-- Combine search conditions with logical operators. For more info, see Using Boolean operators (AND, OR, and NOT) later in this article.

--https://docs.microsoft.com/en-us/sql/t-sql/queries/freetext-transact-sql?view=sql-server-2017
-- exact or related words, as determined by some built-in magic
select *
from Books
where freetext(text, 'turkey')

-- Match the meaning, but not the exact wording, of specified words, phrases, or sentences (the freetext string).
-- Matches are generated if any term or form of any term is found in the full-text index of a specified column.

-- Can also do stuff like index structured data where you might have a well-defined "title" and "body" and table of contents and other fields

select *
from containstable(books, text, '"the creeps"')

select *
from containstable(books, text, 'turkey')

select *
from freetexttable(books, text, 'creeps')

select *
from freetexttable(books, text, 'turkey')

-- verb tense games
select *
from Books
where freetext(text, 'formsof(inflectional, "celebrate")')

--https://docs.microsoft.com/en-us/sql/relational-databases/search/query-with-full-text-search?view=sql-server-2016

-- wordcounts
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-fts-index-keywords-transact-sql?view=sql-server-2016
select * from sys.dm_fts_index_keywords(db_id('adventureworkslt2016'),object_id('books'))
order by document_count desc

-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-fts-index-keywords-by-document-transact-sql?view=sql-server-2016
select * from sys.dm_fts_index_keywords_by_document  
(   
    DB_ID('adventureworkslt2016'),     OBJECT_ID('books')   
)
order by occurrence_count desc

sELECT * FROM sys.dm_fts_parser (' "The Microsoft business analysis" ', 1033, 0, 0);
sELECT * FROM sys.dm_fts_parser ('formsof(inflectional, "marriage")', 1033, 0, 0);
sELECT * FROM sys.dm_fts_parser ('FORMSOF( freetext, "better" )', 1033, 0, 0);

SELECT * FROM sys.dm_fts_parser ('FORMSOF( thesaurus, "good" )', 1033, 0, 0)

-- can make more interesting queries combining boolean expressions etc...
-- ignore thesaurus and stopwords

select *
from sys.fulltext_system_stopwords
where language_id = 1033

SELECT * FROM sys.dm_fts_parser ('FORMSOF( thesaurus, "metal" )', 1033, 0, 0)

where display_term in(
'foil',
'aluminum',
'bullion',
'gold'
)
and phrase_id in (2,5,32,89)
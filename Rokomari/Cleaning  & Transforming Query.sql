Create database RokomariUnicode Collate LATIN1_GENERAL_100_CI_AS_SC_UTF8;

Select* From [dbo].[rokomari_book_categories]

Select* From [dbo].[rokomari_books];

--Making a duplicate of the rokomari_books table to ETL 
Select*
Into duplicate_rokomari_books
From rokomari_books

Select* From [dbo].[duplicate_rokomari_books]

--Exploring and transforming

Select distinct Language
From duplicate_rokomari_books

update duplicate_rokomari_books
SET Language = 'বাংলা'
Where Language = 'other languages'

--Removing dulication of country value 
Select distinct Country
From duplicate_rokomari_books

Select*
From duplicate_rokomari_books
Where Country = 'Bangladesh'

update duplicate_rokomari_books
SET Country = 'বাংলাদেশ'
Where Country = 'Bangladesh'

--Stock_availability

Select distinct LEN(Stock_Availability)
From duplicate_rokomari_books

Select Distinct Stock_Availability, No_of_copies_available
From duplicate_rokomari_books
Where LEN(Stock_Availability) <> 8

-- No_of_copies_available
update duplicate_rokomari_books
SET No_of_copies_available = substring(Stock_Availability,11,2)
Where [No_of_copies_available] IS NULL


Select Stock_Availability, No_of_copies_available
From duplicate_rokomari_books
Where Stock_Availability is NULL

Update duplicate_rokomari_books
SET Stock_Availability = 'No'
Where Stock_Availability is NULl and No_of_copies_available is NULL

Update duplicate_rokomari_books
Set Stock_Availability = 'Yes'
Where Stock_Availability <> 'No'

Select distinct Stock_Availability, No_of_copies_available
From duplicate_rokomari_books

--------------------------Creating view for Analysis
Select * From [dbo].[rokomari_book_categories]
 ----- 
 Create View tableu_data as
	  Select  
		   b.[Title]
		  ,b.[Author_s]
		  ,bc.Category
		  ,b.[Original_Price]
		  ,b.[Sale_Price]
		  ,b.[Discount_Amount]
		  ,b.[Discount_Percentage]
		  ,b.[Stock_Availability]
		  ,b.[No_of_copies_available]
		  ,b.[No_of_Reviews]
		  ,b.[E_Book_Availability]
		  ,b.[E_Book_Price]
		  ,b.[Publisher]
		  , substring(b.Edition, 0, CHARINDEX(',', b.Edition)) as Edition_no
		  ,substring(b.Edition, CHARINDEX(',', b.Edition) + 1, LEN(b.Edition)) as Edition_year
		  ,[Number_of_Pages]
		  ,[Country]
		  ,[Language]

	  From [dbo].[duplicate_rokomari_books] as b
	  Inner Join [dbo].[rokomari_book_categories] as bc
		ON b.Category = bc.Sub_Category

Select*
From tableu_data
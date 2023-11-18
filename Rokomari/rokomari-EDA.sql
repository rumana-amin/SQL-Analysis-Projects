USE RokomariUnicode
--Count the number of records
Select count(1) as total_books from rokomari_books;

--Books by language
Select Language, count(Language) as total_books
From rokomari_books
Group by Language
Order by total_books desc;

---Number of E books
Select 
	count(E_Book_Availability) as total_ebooks, cast(count(E_Book_Availability)/count(1) as float) as ebook_perc
From 
	rokomari_books
Where 
	E_Book_Availability = 'Yes';

--Most and least expensive books
Select
	Title, Author_s, Publisher, Sale_Price
From 
	rokomari_books
Where 
	Sale_Price = (Select Max(Sale_Price) as most_expensive from rokomari_books)
Group by
	Title, Author_s, Publisher, Sale_Price

UNION

Select
	Title, Author_s, Publisher, Sale_Price
From 
	rokomari_books
Where 
	Sale_Price = (Select MIN(Sale_Price) as lest_expensive from rokomari_books)
Group by
	Title, Author_s, Publisher, Sale_Price;


--The top 10 expensive books
Select Top 10 
	Title, Category, Original_Price, Sale_Price
From 
	[dbo].[rokomari_books]
Order by 
	Sale_Price desc

--All the highest discounted books
Select Top 20
	Title, Publisher, Discount_Amount, round((Discount_Percentage*100),4) as Discount_Percentage
From 
	rokomari_books
--Group by 
--	Title, Publisher,
Order by Discount_Amount desc, Discount_Percentage ;

--Top 15 publisher 
Select Top 15
	Publisher,  count(Title) as no_of_books
From
	rokomari_books
Group by 
	Publisher
Order by 
	no_of_books desc;

--Top 15 publisher
Select Top 10
	Publisher,  count(Title) as no_of_books
From
	rokomari_books
Group by 
	 Publisher
Order by 
	no_of_books desc;

--Top 15 Authors
Select Top 10
	Author_s, count(Title) as no_of_books
From
	rokomari_books
Group by 
	Author_s
Order by 
	no_of_books desc;

-- Top 20 books category
Select Top 20
	bc.Category, count(Title) as no_of_books
From
	rokomari_books  as b Inner Join rokomari_book_categories bc
		ON bc.Sub_Category = b.Category
Group by 
	bc. Category
Order by 
	no_of_books desc;

--Books by country
Select 
	Country, count(Title) as no_of_books
From
	rokomari_books
Group by 
	Country
Order by 
	no_of_books desc;

--Highest reviewed book
Select	
	Title, Publisher, No_of_Reviews
From 
	rokomari_books
Where No_of_Reviews = (Select max(No_of_Reviews) From rokomari_books );


--Top 5 reviewed book
Select	Top 5
	Title, Publisher, No_of_Reviews
From 
	rokomari_books
Order by 
	No_of_Reviews desc;

-- need restocking
Select
	Title, Publisher, No_of_copies_available
From 
	rokomari_books
Where
	No_of_copies_available <=1
Order by 
	Publisher;

-- Books by Language
Select
	Language, count(1)
From 
	rokomari_books
Group by 
	Language
Order by 
	Language desc;
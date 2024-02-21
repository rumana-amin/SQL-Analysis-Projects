/*SQL Case Study - Paintings
Problem Statements*/


--1. Fetch all the paintings which are not displayed on any museums?
Select*
From work
Where museum_id is null;


--2. Are there museums without any paintings?
Select*
From work as w
Left Join museum as m
	on w.museum_id = m.museum_id
Where w.work_id is NULL

--Another Solution
select * from museum m
	where not exists (select 1 from work w
					 where w.museum_id=m.museum_id)


--3. How many paintings have an asking price of more than their regular price?
Select count(work_id) as no_of_work
From product_size
Where sale_price > regular_price;


--4. Identify the paintings whose asking price is less than 50% of its regular price
Select*
From product_size
Where sale_price < (regular_price*0.5);


--5. Which canva size costs the most
Select size_id, sale_price as most_costs
From product_size
Where sale_price = (Select max(sale_price)
					From product_size);

--6. Delete duplicate records from work, product_size, subject and image_link tables
With cte as
	(Select work_id, ROW_NUMBER()OVER(partition by work_id order by work_id) as duplicant_count
	From work)
Delete From cte
Where duplicant_count > 1

With cte as
	(Select work_id, ROW_NUMBER()OVER(partition by work_id, size_id order by work_id) as duplicant_count
	From product_size)
Delete From cte
Where duplicant_count > 1

With cte as
	(Select work_id, subject, ROW_NUMBER()OVER(partition by work_id, subject order by work_id) as duplicant_count
	From subject)
Delete From cte
Where duplicant_count > 1

With cte as
	(Select work_id, url, ROW_NUMBER()OVER(partition by work_id, url order by work_id) as duplicant_count
	From image_link)
Delete From cte
Where duplicant_count > 1


--7. Identify the museums with invalid city information in the given dataset(city contains only number)
Select*
From museum
Where city like '[0-9]%[0-9]'
OR CITY LIKE '[0-9]'

	
--8. Museum_Hours table has 1 invalid entry. Identify it and remove it.
----Could't Identify the Invalid Entry.
Select*
From museum_hours
Where day is NULL;


--9. Fetch the top 10 most famous painting subject.
Select top (10) subject, count(subject) as subject_count
From subject
Group by subject
Order by subject_count desc;

--Only Subject Name
Select t.subject
From 
	(Select top (10) subject, count(subject) as subject_count
	From subject
	Group by subject
	Order by subject_count desc) as t;

--Only Subject Name with position
Select t.subject,t.rnk
From 
	(Select top (10) subject, count(subject) as subject_count, 
		ROW_NUMBER() over(order by count(subject) desc) as rnk
	From subject
	Group by subject) as t;


--10. Identify the museums which are open on both Sunday and Monday. Display museum name, city.
Select mh.name, mh.city
From museum_hours as mh1
Join  museum as mh 
	ON mh1.museum_id = mh.museum_id 
Where day  = 'Sunday'
and exists (Select 1
		From museum_hours as mh2
		Where mh2.museum_id = mh1.museum_id and mh2.day = 'Monday')


----11. How many museums are open every single day?
Select count(1) as no_of_museum
From(
	Select museum_id 
	From museum_hours
	Group by museum_id
	HAving count(day) = 7) t;


----12. Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)
Select top (5)  m.museum_id, m.name, count(w.work_id) as no_of_painting
From work as w
Left Join museum as m
	ON w.museum_id = m.museum_id
Where m.museum_id  is NOT NULL
Group by m.museum_id, m.name
Order by no_of_painting desc ;


----13. Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)
Select top 5 count(w.work_id) as no_of_work, a.full_name
From work as w
Left Join artist as a
	ON w.artist_id = a.artist_id
Group by a.full_name
Order by no_of_work desc;


----14. Display the 3 least popular canvas sizes
Select*
from(
	Select size_id, count(1) as no_of_painting,
		dense_rank()over(order by count(work_id) asc) as rnk
	From product_size
	Group by size_id) t
Where rnk <=3;


----15. Which museum is open for the longest during a day. Dispay museum name, state and hours open and which day?
----------------------------------------------------------------
Select*--, CONVERT(time, open, 'hh:mm') as opentime
From museum_hours

UPDATE museum_hours
SET [open] = CONVERT(TIME, SUBSTRING([open], 1, 7) + ' ' + RIGHT([open], 2));

GO
With cte as
	(SELECT 
		[open],
		TRY_CONVERT(TIME, [open], 0) AS opentime
	FROM 
		museum_hours)
Select* From cte where opentime IS NOT NULL;

Select CONVERT(TIME, [open], 0) as opentime
From museum_hours

Select try_CAST([open] as time)
From museum_hours

Select [open] as opentime
From museum_hours
---------------------------------------------------------------------------------

----16. Which museum has the most no of most popular painting style?
Select  top 1 w.museum_id, m.name, count(w.work_id) as no_of_work
From work as w
Left Join subject as s
	ON w.work_id = s.work_id
Join museum as m
	On m.museum_id = w.museum_id
Where w.museum_id  is not NULL
Group by w.museum_id, m.name
Order by no_of_work desc;


----17. Identify the artists whose paintings are displayed in multiple countries.
Select
	w.artist_id, a.full_name, count(m.country) as no_of_country
From work as w
	Left Join museum as m ON w.museum_id = m.museum_id
	Join artist as a on a.artist_id = w.artist_id
Where
	w.museum_id is not Null
Group by 
	w.artist_id, a.full_name
Having
	count(m.country) > 1
Order by
	no_of_country desc;


----18. Display the country and the city with most no of museums. Output 2 seperate columns to mention the city and country.
------If there are multiple value, seperate them with comma.
Select STRING_AGG (t.city, ', ') as city, STRING_AGG(t.country, ', ') as country
From(
	Select city, country, count(museum_id) as no_of_museum,
	dense_rank() over(Order by count(museum_id) desc) as rnk
	From museum
	Group by city, country) t
Where rnk = 1;


/* 19. Identify the artist and the museum where the most expensive and least expensive painting is placed. 
	Display the artist name, sale_price, painting name, museumname, museum city and canvas label. */
With cte as(
	Select work_id, try_cast(size_id as int) as size_id, sale_price,
		rank()over(order by sale_price desc) as rnk,
		rank()over(order by sale_price asc) as rnk_asc	
	From product_size)
Select a.full_name, p.sale_price, w.name as paintning_name, m.name as museum_name, m.city, c.label
From CTE as p
Join work as w
	On p.work_id = w.work_id
Join artist as a
	ON w.artist_id = a.artist_id
Join museum as m
	ON w.museum_id = m.museum_id
Join canvas_size as c
	ON p.size_id = c.size_id
Where rnk = 1 OR rnk_asc = 1;


----20. Which country has the 5th highest no of paintings?
With cte as(
		Select dense_rank() over(order by count(w.work_id) desc) as rnk, m.country
		From work as w
		Left Join museum as m
			ON w.museum_id = m.museum_id
		Where m.country is Not NULL
		Group by m.country)
Select country
From cte
Where rnk = 5;

----21. Which are the 3 most popular and 3 least popular painting styles?
With cte as(
		Select a.style,
		count(w.work_id) as no_of_work, 
		rank() over(order by count(w.work_id) desc) as rnk,
		count(1) over() no_of_records
		From work as w
		Left Join artist as a
			ON w.artist_id = a.artist_id
		Where a.style is NOt NULL
		Group by a.style)
Select style,
	case when rnk <= 3 then 'Most Popular' else 'Least Popular' end as remarks
From cte
where rnk <= 3 OR rnk > no_of_records - 3;


----22. Which artist has the most no of Portraits paintings outside USA?.
----Display artist name, no of paintings and the artist nationality.
With cte as (
	Select 
		a.full_name, 
		count(w.work_id) as no_of_painting, 
		dense_rank() over(order by count(w.work_id)desc) as rnk, 
		a.nationality
	From work as w
	Left Join artist as a
		ON w.artist_id = a.artist_id
	Join subject as s
		ON s.work_id = w.work_id
	where a.nationality != 'American'
		and s.subject = 'Portraits'
	Group by 
		a.full_name, a.nationality)

Select full_name, no_of_painting, nationality
From cte
Where rnk = 1;


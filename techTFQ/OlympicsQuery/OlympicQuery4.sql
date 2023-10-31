--4. Which year saw the highest and lowest no of countries participating in olympics
Select Top (1) a. Games, count(distinct n.region) as no_of_country
From athlete_events as a
Inner Join noc_regions as n ON n.NOC = a.NOC
Group by a.Games
Order by no_of_country desc;

Select Top (1) a. Games, count(distinct n.region) as no_of_country
From athlete_events as a
Inner Join noc_regions as n ON n.NOC = a.NOC
Group by a.Games
Order by no_of_country;

--Trying to combine these two query into a single one
With cte as
	(
	Select a. Games, count(distinct n.region) as no_of_country
	From athlete_events as a
	Inner Join noc_regions as n ON n.NOC = a.NOC
	Group by a.Games
	)
Select
	max(Games) as Game, 
	max(no_of_country) as no_of_country, 
	min(Games) as Game, 
	min(no_of_country) as min_country
From cte
Where no_of_country = (Select max(no_of_country) From cte)
	OR no_of_country = (Select min(no_of_country) from cte)	












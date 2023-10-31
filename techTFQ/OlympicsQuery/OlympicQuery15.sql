--15. List down total gold, silver and broze medals won by each country corresponding to each olympic games.

with cte as
	(Select a.games, n.region as country, a.medal, count(a.Medal) as total_medals --gold, silver, bronze
	From athlete_events as a
	Inner Join noc_regions as n ON n.NOC = a.NOC
	Where a.Medal IN ('Gold', 'Silver', 'Bronze')
	Group by a.games, n.region, a.Medal
	)
Select*
From cte
PIVOT (
	SUM(total_medals)
	FOR Medal IN([Gold],[Silver],[Bronze])
	) As pvt
Order by Games;

---Solution with ISNULL OR Coalesce
with cte as
	(Select a.games, n.region as country, a.medal, count(a.Medal) as total_medals --gold, silver, bronze
	From athlete_events as a
	Inner Join noc_regions as n ON n.NOC = a.NOC
	Where a.Medal IN ('Gold', 'Silver', 'Bronze')
	Group by a.games, n.region, a.Medal
	)
SELECT
games,
country,
coalesce(Gold, 0) AS Gold,
ISNULL(Silver, 0) AS Silver,
ISNULL(Bronze, 0) AS Bronze
FROM cte
PIVOT (
SUM(total_medals)
FOR Medal IN([Gold],[Silver],[Bronze])
) AS pvt
ORDER BY Games;

--if the categories will vary (i.e. more medal types will be added in future), then use a dynamic query.

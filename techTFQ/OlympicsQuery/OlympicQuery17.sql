--17. Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.
With cte as (
		Select 
			a.Games, n.region as country, a.Medal, count(a.Medal) as total_medal
		From athlete_events as a
		Inner Join noc_regions as n
			ON n.NOC = a.NOC
		Where
			a.Medal IN ('Gold', 'Silver', 'Bronze')
		Group by Rollup (a.Games, n.region,  a.Medal)
		)
---Incomplete
	Select Games, country,
	ISNULL(Gold, 0) as gold,
	ISNULL(Silver, 0) as silver,
	IsNull(Bronze, 0) as bronze
	From cte 
	PIVOT(
	SUM(total_medal)
	FOR Medal IN ([Gold],[Silver],[Bronze]))
	as pvt
	Order by Games, Country;
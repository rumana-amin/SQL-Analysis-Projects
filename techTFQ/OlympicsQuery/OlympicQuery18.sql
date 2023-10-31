--18. Which countries have never won gold medal but have won silver/bronze medals?
With cte as
	(
	Select n.region as country, a.Medal, count(a.Medal) as no_of_medal
	From athlete_events as a
	Inner Join noc_regions as n on n.NOC = a.NOC
	Where a.Medal In ('Silver', 'Bronze')
	group by n.region, a.Medal
	)

SELECT
	country,
	ISNull(Gold, 0) AS Gold,
	ISNULL(Silver, 0) AS Silver,
	ISNULL(Bronze, 0) AS Bronze
FROM cte
PIVOT (
	SUM(no_of_medal)
	FOR Medal IN([Gold],[Silver],[Bronze])
	) AS pvt
Order by Silver desc, Bronze desc;

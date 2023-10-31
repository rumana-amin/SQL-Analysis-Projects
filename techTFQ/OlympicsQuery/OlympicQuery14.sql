--14. List down total gold, silver and bronze medals won by each country in different colums.

With cte as 
		(Select n.region as country, a.Medal, count(a.Medal) as no_of_medal
		From athlete_events as a
		Inner Join noc_regions as n ON a.NOC = n.NOC
		Where a.Medal IN ('Gold','Silver','Bronze')
		Group by n.region, a.Medal
		)

SELECT country, 
	ISNULL([Gold], 0) AS [Gold], 
	ISNULL([Silver], 0) AS [Silver], 
	ISNULL([Bronze], 0) AS [Bronze]
FROM cte AS source_table
PIVOT (
	SUM(no_of_medal) 
	FOR Medal IN ([Gold], [Silver], [Bronze])
	) AS pvt;



--Soution with CASE
WITH cte AS (
    SELECT Team, Medal, COUNT(Medal) AS no_of_medal
    FROM athlete_events
    WHERE Medal IN ('Gold', 'Silver', 'Bronze')
    GROUP BY Team, Medal
),
cte1 AS (
    SELECT Team, Medal, SUM(no_of_medal) AS total_medal
    FROM cte
    GROUP BY Team, Medal
)
SELECT Team, 
       SUM(CASE WHEN Medal = 'Gold' THEN total_medal ELSE 0 END) AS Gold,
       SUM(CASE WHEN Medal = 'Silver' THEN total_medal ELSE 0 END) AS Silver,
       SUM(CASE WHEN Medal = 'Bronze' THEN total_medal ELSE 0 END) AS Bronze
FROM cte1
GROUP BY Team;


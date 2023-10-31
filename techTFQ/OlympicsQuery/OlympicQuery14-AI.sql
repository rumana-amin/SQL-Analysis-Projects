--14. List down total gold, silver and bronze medals won by each country in different colums.
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
SELECT *
FROM cte1
PIVOT (
    SUM(total_medal)
    FOR Medal IN ([Gold], [Silver], [Bronze])
) AS PivotTable;

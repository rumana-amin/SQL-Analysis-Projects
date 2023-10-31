--16. Identify which country won the most gold, most silver and most bronze medals in each olympic games.

WITH cte AS (
    SELECT
        a.games,
        n.region AS country,
        a.medal,
        COUNT(a.medal) AS total_medals
    FROM
        athlete_events AS a
    INNER JOIN
        noc_regions AS n ON n.NOC = a.NOC
    WHERE
        a.medal IN ('Gold', 'Silver', 'Bronze')
    GROUP BY
        a.games,
        n.region,
        a.medal
)
, cte_ranked AS (
    SELECT
        games,
        country,
        medal,
        total_medals,
        ROW_NUMBER() OVER (PARTITION BY games, medal ORDER BY total_medals DESC) AS ranking
    FROM
        cte
)
SELECT
    games,
    concat(country,'-', ISNULL(MAX(CASE WHEN medal = 'Gold' THEN total_medals END), 0)) AS Gold,
    concat(country, '-', ISNULL(MAX(CASE WHEN medal = 'Silver' THEN total_medals END), 0)) AS Silver,
    concat(country, '-', ISNULL(MAX(CASE WHEN medal = 'Bronze' THEN total_medals END), 0)) AS Bronze
FROM
    cte_ranked
WHERE
    ranking = 1
GROUP BY
    games, country
ORDER BY
    games;

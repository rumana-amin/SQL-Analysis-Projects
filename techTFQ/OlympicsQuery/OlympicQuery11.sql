
--11. Fetch the top 5 athletes who have won the most gold medals.

With cte as 
(	Select Name,
	count(Medal) as no_of_gold_medal
	From athlete_events
	Where Medal = 'Gold'
	Group by Name
	),

ranking as 
	(
	Select Name, no_of_gold_medal, DENSE_RANK() Over (Order by no_of_gold_medal desc) as rank
	From cte
	)

Select ranking.Name, ranking.no_of_gold_medal, ranking.rank
From cte, ranking
Where ranking.rank between 1 and 5
Group by ranking.Name, ranking.no_of_gold_medal, ranking.rank
Order by no_of_gold_medal desc;



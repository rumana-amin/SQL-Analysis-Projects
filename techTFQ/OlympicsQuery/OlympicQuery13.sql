--13. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
With medals as
	(
	Select n.region as country,  count(1) as total_medals 
	From athlete_events as a
	Inner Join noc_regions as n ON n.NOC = a.NOC
	Where Medal IN ('Gold', 'Silver', 'Bronze')
	Group by n.region
	),
ranking as 
	(Select*, DENSE_RANK() over (order by total_medals desc) as rnk
	From medals)

Select*
from ranking
Where rnk <= 5
Order by rnk;
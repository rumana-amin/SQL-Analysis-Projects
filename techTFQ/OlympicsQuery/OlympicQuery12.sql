--12.Fetch the top 5 athletes who have won the most medals (gold/silver/bronze)

With medals as
	(
	Select Name,Team,  count(1) as total_medals 
	From athlete_events
	Where Medal IN ('Gold', 'Silver', 'Bronze')
	Group by Name, Team
		),
ranking as 
	(Select*, DENSE_RANK() over (order by total_medals desc) as rnk
	From medals)

Select Name, Team, total_medals, rnk
from ranking
Where rnk <= 5;



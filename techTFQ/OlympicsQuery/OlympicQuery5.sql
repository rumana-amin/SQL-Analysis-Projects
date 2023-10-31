--5. Which nation has participated in all of the olympic games
-- fist count the total no of games

Select n.region as Country
From athlete_events as a
Inner Join noc_regions as n ON n.NOC = a.NOC
Group by n.region
Having count(distinct Games) = (Select Count(Distinct Games)
								From athlete_events)
Order by Country;								

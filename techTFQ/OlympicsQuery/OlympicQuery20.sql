--20. Break down all olympic games where India won medal for Hockey and how many medals in each olympic games.

Select a.Games, count(a.Medal) as Total_Medals
From athlete_events as a
Join noc_regions as n on n.NOC = a.NOC
Where n.region = 'India' and Medal != 'NA' and a.Sport = 'Hockey'
Group by a.Games
Order by Total_Medals desc;
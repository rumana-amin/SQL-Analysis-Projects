--3. Mention the total no of nations who participated in each olympics game?

Select a.Games, count(Distinct n.region) as no_of_nations
From athlete_events as a
Inner Join noc_regions as n ON n.NOC = a.NOC
Group by a.Games
Order by Games;


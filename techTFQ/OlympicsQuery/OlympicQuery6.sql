--6. Identify the sport which was played in all summer olympics.
--My Solution
Select Sport
From athlete_events
Group by Sport
Having Count(Distinct Games) = 
				( 
				Select Top (1)Count(Distinct Games) as no_of_games
				From athlete_events
				Where Season = 'Summer'
				Order by no_of_games Desc
				)
Order by Sport;


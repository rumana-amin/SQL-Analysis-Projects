--8. Fetch the total no of sports played in each olympic games.

Select Games, count(Distinct Sport) As total_sport_played
From athlete_events
Group by Games
Order by Games;

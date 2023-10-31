--7.Which Sports were just played only once in the olympics.

Select Sport, count( Distinct Games) as no_of_sport_played
From athlete_events
Group by Sport
Having count(Distinct Games) = 1
Order by Sport;

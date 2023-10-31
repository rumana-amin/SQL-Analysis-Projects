--9. Fetch oldest athletes to win a gold medal

Select *
From athlete_events
Where Medal = 'Gold' AND Age =
				(
				Select max(Age) 
				From athlete_events
				Where Medal = 'Gold' 
				);


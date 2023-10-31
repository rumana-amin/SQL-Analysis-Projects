--19. In which Sport/event, India has won highest medals.

Select Top(1) a.Event, count(a.Medal) as Most_Medals
From athlete_events as a
Join noc_regions as n on n.NOC = a.NOC
Where n.region = 'India' and Medal != 'NA'
Group by a.Event
Order by Most_Medals desc;



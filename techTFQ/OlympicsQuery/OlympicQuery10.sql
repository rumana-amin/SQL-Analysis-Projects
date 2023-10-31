--10. Find the Ratio of male and female athletes participated in all olympic games.
--Find the number of male and female athletes, 

with male as 
	(Select Count (Name) as no_of_male
	From athlete_events
	Where Sex = 'M'
),
female as 
	(Select Count(Name) as no_of_female
	From athlete_events
	Where Sex = 'F'
	)

SELECT CONCAT(1, ':', CAST(ROUND(male.no_of_male * 1.0 / female.no_of_female, 2) AS DECIMAL(10, 2))) as male_to_female_ratio
FROM male, female;
  



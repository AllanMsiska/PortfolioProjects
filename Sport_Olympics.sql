




select*
from Sportsproject..OlympicAthletes$




-- Athletes by their respective countries

select Athlete,Country
from Sportsproject..OlympicAthletes$
--where Country like '%United states%'
where Athlete is not null
order by Athlete





-- Athlete by thier respective sport

select Athlete,Sport
from Sportsproject..OlympicAthletes$
--where Country like '%United states%'
where Athlete is not null
order by Athlete





-- Country by sport  

select Sport, Country
from Sportsproject..OlympicAthletes$
--where Country like '%United states%'
where Athlete is not null
order by Country





-- Countries with athletes between the the age of 15 - 30 (YOUNG)  

select Athlete, age, Country
from Sportsproject..OlympicAthletes$
--where Country like '%United 
where age between 15 and 30
order by Age desc





-- Countries with athletes between the the age of 31 - 75 (OLD)  

select Athlete, age, Country
from Sportsproject..OlympicAthletes$
--where Country like '%United 
where age between 31 and 75
order by Age desc




-- How Frequent a particular sport was played (In general)

select COUNT(Sport) as How_Many_times_Played
from Sportsproject..OlympicAthletes$
--where Country like '%United states%'
where Sport like '%gymnastics%'
--order by Country





-- How Frequent a particular sport was played (by country)

select COUNT(Sport) as How_Many_times_Played
from Sportsproject..OlympicAthletes$
--where Country like '%United states%'
where Sport like '%gymnastics%' And Country like '%United States%'
--order by Country





-- countries by number by Gold medals won

select Country, SUM(cast([Gold Medals] as int)) as Gold_Medal_won
from Sportsproject..OlympicAthletes$
--where Country like '%United states%'
--where Athlete is not null
group by Country 
--order by 1,2




-- countries by number by Silver medals won

select Country, SUM(cast([Silver Medals] as int)) as Silver_Medal_won
from Sportsproject..OlympicAthletes$
--where Country like '%United states%'
--where Athlete is not null
group by Country 
--order by 1,2




-- countries by number by Bronzer medals won

select Country, SUM(cast([Bronze Medals] as int)) as Bronze_Medal_won
from Sportsproject..OlympicAthletes$
--where Country like '%United states%'
--where Athlete is not null
group by Country 
--order by 1,2




-- Overall MEDALS Won

select
 SUM(cast([Gold Medals] as int)) as Gold_Medal_won
, SUM(cast([Silver Medals] as int)) as Silver_Medal_won
, SUM(cast([Bronze Medals] as int)) as Bronze_Medal_won
from Sportsproject..OlympicAthletes$
--where Country like '%United states%'
--where Athlete is not null
--group by Country 
--order by 1,2 





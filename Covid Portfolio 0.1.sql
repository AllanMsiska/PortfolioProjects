select*
from PortfoiloProject..CovidDeaths
where continent is not null
order by 3,4


--select*
--from PortfoiloProject..covidVaccinations
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from PortfoiloProject..CovidDeaths
where continent is not null
order by 1,2


-- Looking for cases Vs total Dealth (how many cases & deaths they have in the country)
-- Shows the likelyhood of dying if you get covid in your country

select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfoiloProject..CovidDeaths
where location like '%malawi%'
where continent is not null
order by 1,2


-- Loooking at total cases vs Population
-- shows what percentage of pulation got covid

select location, date,population, total_cases, (total_cases/population)*100 as CasesbyPopulation
from PortfoiloProject..CovidDeaths
--where location like '%malawi%'
where continent is not null
order by 1,2


-- Looking at countries with highest infection rate compared to population

select location,population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfoiloProject..CovidDeaths
--where location like '%malawi%'
where continent is not null
group by location, population
order by PercentPopulationInfected desc



--showing the countries with highest death count per population

select location, MAX(cast(total_deaths as int)) as TotalDeathCount 
from PortfoiloProject..CovidDeaths
--where location like '%malawi%'
where continent is not null
group by location
order by TotalDeathCount desc


-- Lets break things down by continent
-- Continents with the highest death count

select location, MAX(cast(total_deaths as int)) as TotalDeathCountbycontinent
from PortfoiloProject..CovidDeaths
--where location like '%malawi%'
where continent is null
group by location
order by TotalDeathCountbycontinent desc


select continent, MAX(cast(total_deaths as int)) as TotalDeathCountbycontinent
from PortfoiloProject..CovidDeaths
--where location like '%malawi%'
where continent is not null
group by continent
order by TotalDeathCountbycontinent desc




-- Global Numbers and Overall deaths 


select date, SUM(new_cases) as total_Cases ,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfoiloProject..CovidDeaths
--where location like '%malawi%'
where continent is not null
group by date
order by 1,2

select SUM(new_cases) as total_Cases ,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfoiloProject..CovidDeaths
--where location like '%malawi%'
where continent is not null
--group by date
order by 1,2











-- Looking at total Population VS Vaccination

select *
From PortfoiloProject..CovidDeaths dea
JOin PortfoiloProject..covidVaccinations vac
     on dea.location = vac.location 
	 and dea.date = vac.date


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfoiloProject..CovidDeaths dea
JOin PortfoiloProject..covidVaccinations vac
     on dea.location = vac.location 
	 and dea.date = vac.date
	 where dea.continent is not null
	 order by 2,3

--ROLLOUT 

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinanted
--, (RollingPeopleVaccinanted/population)*100
From PortfoiloProject..CovidDeaths dea
JOin PortfoiloProject..covidVaccinations vac
     on dea.location = vac.location 
	 and dea.date = vac.date
	 where dea.continent is not null
	 order by 2,3


--USE CTE

with PopvsVac (continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinanted)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinanted
--, (RollingPeopleVaccinanted/population)*100
From PortfoiloProject..CovidDeaths dea
JOin PortfoiloProject..covidVaccinations vac
     on dea.location = vac.location 
	 and dea.date = vac.date
	 where dea.continent is not null
	 --order by 2,3
	 )

	 select*,(RollingPeopleVaccinanted/Population)*100
	 from PopvsVac





--TEMP Table

DROP table if exists #PercentpopulationVaccinanted
Create Table #PercentpopulationVaccinanted
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinanted numeric
)
	 insert into #PercentpopulationVaccinanted
	 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinanted
--, (RollingPeopleVaccinanted/population)*100
From PortfoiloProject..CovidDeaths dea
JOin PortfoiloProject..covidVaccinations vac
     on dea.location = vac.location 
	 and dea.date = vac.date
	 where dea.continent is not null
	 --order by 2,3

 select*,(RollingPeopleVaccinanted/Population)*100
	 from #PercentpopulationVaccinanted





--CREATING VIEWs TO STORE DATA FOR LATER VISUAL


create view PercentpopulationVaccinanted as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinanted
--, (RollingPeopleVaccinanted/population)*100
From PortfoiloProject..CovidDeaths dea
JOin PortfoiloProject..covidVaccinations vac
     on dea.location = vac.location 
	 and dea.date = vac.date
	 where dea.continent is not null
	 --order by 2,3


create view DeathPercentageOverall as
select SUM(new_cases) as total_Cases ,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfoiloProject..CovidDeaths
--where location like '%malawi%'
where continent is not null
--group by date
--order by 1,2


create view DeathPercentageCountbyContinent as
select continent, MAX(cast(total_deaths as int)) as TotalDeathCountbycontinent
from PortfoiloProject..CovidDeaths
--where location like '%malawi%'
where continent is not null
group by continent
--order by TotalDeathCountbycontinent desc


create view DeathCountbyCountry as
select location, MAX(cast(total_deaths as int)) as TotalDeathCount 
from PortfoiloProject..CovidDeaths
--where location like '%malawi%'
where continent is not null
group by location
--order by TotalDeathCount desc





	 Select*
	 from PercentpopulationVaccinanted
-- Selecting Data to be used.
select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeathsCSV
Where continent is not null
order by 1,2

-- Total Cases Vs Total Deaths
-- Showing likelihood of dying from covid19 in your country
select location, date, total_cases,total_deaths,(cast(total_deaths as float) / cast(total_cases as float))*100 as DeathPercentage
from PortfolioProject..CovidDeathsCSV
where location like '%Tanzania%'
order by 1,2

-- Total Cases Vs Population
-- Shows what percentage of population got covid
select location, date, population, total_cases,(cast(total_deaths as float) / cast(population as float))*100 as PercentofPopInfected
from PortfolioProject..CovidDeathsCSV
where location like '%Tanzania%'
order by 1,2

-- Countries with highest infection rate compared to population
select location, population, MAX(total_cases) as HighestCovidCount, MAX((cast(total_deaths as float) / cast(population as float)))*100 as PercentofPopInfected
from PortfolioProject..CovidDeathsCSV
group by location, population
order by PercentofPopInfected desc

-- Countries with the highest deathCount per population
select location, MAX(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeathsCSV
Where continent is not null
group by location, population
order by TotalDeathCount desc

-- By Continent
select continent, MAX(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeathsCSV
Where continent is not null
group by continent
order by TotalDeathCount desc

-- Global numbers
select date, SUM(cast(new_cases as int)) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths
from PortfolioProject..CovidDeathsCSV
Where continent is not null
group by date
order by 1,2


--- VACCINATION and POPULATION
select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations
, SUM(cast(vaccine.new_vaccinations as float)) OVER (partition by death.location order by death.location, death.date) as PeopleVaccinated
from PortfolioProject..CovidDeathsCSV death
Join PortfolioProject..CovidVaccineCSV vaccine
  on death.location = vaccine.location
  and death.date = vaccine.date
  where death.continent is not null
  order by 1,2,3

-- Percentage of people vaccinated (using CTE)
with PopVsVaccine (Continent, Date, Location, population, New_Vaccination, PeopleVaccinated)
as
(
select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations
, SUM(cast(vaccine.new_vaccinations as float)) OVER (partition by death.location order by death.location, death.date) as PeopleVaccinated
from PortfolioProject..CovidDeathsCSV death
Join PortfolioProject..CovidVaccineCSV vaccine
  on death.location = vaccine.location
  and death.date = vaccine.date
  where death.continent is not null
 -- order by 1,2,3
)
select *, (cast(PeopleVaccinated as float)/cast(population as float))*100
from PopVsVaccine

-- Create a view for visualisation
Create view PercentPopVaccinated as
select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations
, SUM(cast(vaccine.new_vaccinations as float)) OVER (partition by death.location order by death.location, death.date) as PeopleVaccinated
from PortfolioProject..CovidDeathsCSV death
Join PortfolioProject..CovidVaccineCSV vaccine
  on death.location = vaccine.location
  and death.date = vaccine.date
  where death.continent is not null
 -- order by 1,2,3








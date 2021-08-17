--checking whether data was imported sucessfully

SELECT *
FROM CovidDeaths
ORDER BY 3, 4

SELECT *
FROM CovidVaccinations
ORDER BY 3, 4

--selecting data to be used

SELECT location, date, total_cases,new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1, 2

--looking at total cases vs total deaths

SELECT location, date, total_cases, total_deaths, population, (total_deaths/total_cases*100) AS death_percentage
FROM CovidDeaths
ORDER BY 1, 2

--let's check death_percentage in Kenya
--likelihood of dying if infected in kenya

SELECT location, date, total_cases, total_deaths, population, (total_deaths/total_cases*100) AS death_percentage
FROM CovidDeaths
WHERE location = 'Kenya'
ORDER BY 1, 2

--looking at total cases vs population

SELECT location, date, total_cases, population, (total_cases/population*100) AS infected_percentage
FROM CovidDeaths
ORDER BY 1, 2


--looking at Kenyan case of total cases vs population
--it shows percentage of population got covid

SELECT location, date, total_cases, population, (total_cases/population*100) AS infected_percentage
FROM CovidDeaths
WHERE location = 'Kenya'
ORDER BY 1, 2

--countries with highest infection rate compared to population

SELECT location, MAX(total_cases) AS HighestInfectionCount, population, MAX((total_cases/population*100)) AS infected_percentage
FROM CovidDeaths
GROUP BY location, population
ORDER BY infected_percentage DESC

--Showing countries with highest death count per population

SELECT location, MAX(cast(total_deaths as int)) AS HighestDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY HighestDeathCount DESC

--looking at continents

SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

--accurate figures

SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC

--looking at continents with highest death count per poplation

SELECT location, population, MAX(cast(total_deaths as int)/population*100) AS percentageDeaths
FROM CovidDeaths
WHERE continent is null
GROUP BY location, population
ORDER BY percentageDeaths DESC

--global view, deaths
-- daily global deaths

SELECT  date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
FROM CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1, 2

--total deaths globally

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
FROM CovidDeaths
WHERE continent is not null
ORDER BY 1, 2

--joining the covid deathstable with covid vaccination table

SELECT *
FROM CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date

--looking at total population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 1, 2, 3

--looking at population vs vaccinations in kenya

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.location = 'Kenya'
ORDER BY 1, 2, 3

--rolling vaccination count count

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) AS roling_vac_count
FROM CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2, 3


--using CTE

with PopvsVac (continent, location, date, population, new_vaccinations, roling_peoplevac_count)
as
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) AS roling_peoplevac_count
FROM CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, (roling_peoplevac_count/population)*100
from PopvsVac

--TEMP TABLE
--DROP Table if exists #percentPopulationVaccinated
create table #percentPopulationVaccinated
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
roling_peoplevac_count numeric)

insert into #percentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) AS roling_peoplevac_count
FROM CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
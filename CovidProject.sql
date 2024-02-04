--Select the data to used
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid..CovidDeaths
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths
SELECT location, date, total_cases, total_deaths, (try_cast(total_deaths as decimal(18,2))/NULLIF(try_cast(total_cases as int),0))*100 AS 'TotalDeaths Percentage'
FROM covid..CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2
 
 --Solving the date issue
 SELECT date
 FROM CovidDeaths

 SET DATEFORMAT ymd

 ALTER TABLE CovidDeaths 
 ALTER COLUMN date DATE
 
 --Looking at Total Cases vs Population

 SELECT location, date, total_cases, population, (try_cast(total_cases as decimal(18))/(try_cast(population as bigint)))*100 AS 'Cases Percentage'
FROM covid..CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

--Solving the population data type issue

ALTER TABLE CovidDeaths
ALTER COLUMN population BIGINT
ALTER TABLE CovidDeaths
ALTER COLUMN total_cases BIGINT

--Looking at Countries with highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX(try_cast(total_cases as decimal(18))/(try_cast(population as bigint)))*100 AS 'Cases Percentage'
FROM covid..CovidDeaths
GROUP BY location, population
ORDER BY 'Cases Percentage' DESC


--Showing Countries with the Highest Death Count per Population

SELECT location, MAX(CAST(total_deaths as int)) AS 'Total Deaths'
FROM covid..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY 'Total Deaths' DESC


SELECT * 
FROM CovidDeaths
WHERE location like '%income%'

--Breaking things down by Continent

--Showing continents with the highest death count per population
SELECT continent, MAX(CAST(total_deaths as int)) AS 'Total Deaths'
FROM covid..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY 'Total Deaths' DESC

--GLOBAL NUMBERS

SELECT date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, (SUM(new_deaths)/ NULLIF(SUM(new_cases),0)) AS 'TotalDeaths Percentage'
FROM covid..CovidDeaths
WHERE continent is NOT NULL
GROUP BY date
ORDER BY 1,2 

--Transforming VARCHAR COLUMNS INTO INT
ALTER TABLE CovidDeaths
ALTER COLUMN new_cases BIGINT
ALTER TABLE CovidDeaths
ALTER COLUMN new_deaths BIGINT

--USE CTE
--Total Population vs Vaccinations

WITH PopvsVac --( continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) 
AS (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as BIGINT)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM covid..CovidDeaths dea
JOIN covid..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date 
WHERE dea.continent is NOT NULL
--ORDER BY 2,3
)

SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac

ALTER TABLE CovidVaccinations
ALTER COLUMN new_vaccinations INT

--TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as BIGINT)) OVER (Partition by dea.location ORDER BY dea.location,
dea.date) AS RollingPeopleVaccinated
FROM covid..CovidDeaths dea
JOIN covid..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date 
--WHERE dea.continent is NOT NULL
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated


--Create View to store data for later visualisations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as BIGINT)) OVER (Partition by dea.location ORDER BY dea.location,
dea.date) AS RollingPeopleVaccinated
FROM covid..CovidDeaths dea
JOIN covid..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date 
WHERE dea.continent is NOT NULL
--ORDER BY 2,3




   
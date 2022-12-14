USE PortfolioProject;
SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location,  date

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY Location, date

-- Total Cases vs Total Deaths
-- Shows the Likelyhood of dying if you contract in your country

SELECT Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE Location LIKE '%states%'AND continent IS NOT NULL
ORDER BY Location, date

--Looking at Total Cases Vs Population

SELECT Location, date, total_cases, Population, 
(total_cases/population)*100 AS PerecentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE Location LIKE '%states%' AND continent IS NOT NULL
ORDER BY Location, date

--Countries with Highest Infection Rate compared to Population

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, 
MAX(total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE Location LIKE '%states%'
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC

-- Highest Countries Highest Death Count 

SELECT Location, Max(cast(total_deaths AS INT)) AS TotalDeaths
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL
GROUP BY continent
ORDER BY TotalDeaths DESC

--Continents with the Highest Death Count Per Population

SELECT continent, Max(cast(total_deaths AS INT)) AS TotalDeaths
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeaths DESC

-- World Wide Numbers

SELECT date, SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS INT)) AS total_deaths,
SUM(cast(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE Location LIKE '%states%'  
WHERE Continent IS NOT NULL
GROUP BY date
ORDER BY date, total_cases

-- Duplicates 
SELECT continent, Location, date, COUNT(*) AS NumberDuplicates
FROM PortfolioProject..CovidDeaths
WHERE continent = 'Asia'
GROUP BY continent, date, location

--Delete Duplicates By Population 
DELETE FROM PortfolioProject..CovidDeaths
WHERE population IS NULL


--Total Population vs Vaccinations 
--Converting columns to integer error Columns Varchar

Select death.continent, death.location, death.date, death.population, 
vac.new_vaccinations, SUM(CONVERT(INT,vac.new_vaccinations)) 
OVER (PARTITION BY death.location ORDER BY death.location, death.date) 
AS RollingPeopleVaccination
FROM PortfolioProject..CovidDeaths death
Join PortfolioProject..CovidVacination vac
 ON death.location = vac.location 
  AND death.date = vac.date
WHERE death.continent IS NOT NULL 
ORDER BY location, date

-- Using CTE 
WITH PopvsVac (Continent, Location, Date, Population, New_vaccinations, 
RollingPeopleVaccinated)
AS 
(
Select death.continent, death.location, death.date, death.population, 
vac.new_vaccinations, SUM(CONVERT(INT,vac.new_vaccinations)) 
OVER (PARTITION BY death.location ORDER BY death.location, death.date) 
AS RollingPeopleVaccination
FROM PortfolioProject..CovidDeaths death
Join PortfolioProject..CovidVacination vac
 ON death.location = vac.location 
  AND death.date = vac.date
WHERE death.continent IS NOT NULL 
--ORDER BY location, date
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac

--Temp Table

DROP TABLE IF EXISTS #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select death.continent, death.location, death.date, death.population, 
vac.new_vaccinations, SUM(CONVERT(INT,vac.new_vaccinations)) 
OVER (PARTITION BY death.location ORDER BY death.location, death.date) 
AS RollingPeopleVaccination
FROM PortfolioProject..CovidDeaths death
Join PortfolioProject..CovidVacination vac
 ON death.location = vac.location 
  AND death.date = vac.date
--WHERE death.continent IS NOT NULL 
--ORDER BY location, date

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated

CREATE VIEW PercentPopulationVaccinated AS
Select death.continent, death.location, death.date, death.population, 
vac.new_vaccinations, SUM(CONVERT(INT,vac.new_vaccinations)) 
OVER (PARTITION BY death.location ORDER BY death.location, death.date) 
AS RollingPeopleVaccination
FROM PortfolioProject..CovidDeaths death
Join PortfolioProject..CovidVacination vac
 ON death.location = vac.location 
  AND death.date = vac.date
WHERE death.continent IS NOT NULL 
--ORDER BY location, date

CREATE VIEW TotalDeath AS
SELECT continent, Max(cast(total_deaths AS INT)) AS TotalDeaths
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent  


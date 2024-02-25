SELECT *
FROM Covid_Deaths
WHERE continent is not null
ORDER BY 3,4

SELECT *
FROM Covid_Vaccinations
WHERE continent is not null
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Covid_Deaths
WHERE continent is not null
ORDER BY 1,2

--Total cases Vs Total Deaths
--SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)
--FROM Covid_Deaths
--ORDER BY 1,2

SELECT location, date, total_cases, total_deaths,
	CAST(total_deaths AS DECIMAL(16, 5))/CAST(total_cases AS DECIMAL(16, 5))*100 AS DeathPercentage
	FROM Covid_Deaths
	ORDER BY 1,2
--total likelihood of dying if you contract Covid in your country
SELECT location, date, total_cases, total_deaths,
	CAST(total_deaths AS DECIMAL(16, 5))/CAST(total_cases AS DECIMAL(16, 5))*100 AS DeathPercentage
	FROM Covid_Deaths
	WHERE location like '%ghana%' and continent is not null
	ORDER BY 1,2

--total cases vs Population
--shows the likelihood of dying if you contract covid in your country
SELECT location, date, Population, total_cases,
	CAST(total_cases AS DECIMAL(16, 5))/CAST(Population AS DECIMAL(16, 5))*100 AS PercentPopulationInfected
	FROM Covid_Deaths
	WHERE location like '%states%' and continent is not null
	ORDER BY 1,2

--countries with highest infection rate compared to population
SELECT 
    location, 
    Population, 
    MAX(total_cases) as HighestInfection,
    MAX(CAST(total_cases AS DECIMAL(16, 5))) / CAST(Population AS DECIMAL(16, 5)) * 100 AS PercentPopulationInfected
FROM 
    Covid_Deaths
WHERE continent is not null
GROUP BY 
    location, 
    Population
ORDER BY 
    PercentPopulationInfected desc

--countries with the highest death count per population
SELECT 
    location, 
    MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM 
    Covid_Deaths
WHERE continent is not null
GROUP BY 
    location
ORDER BY 
    TotalDeathCount desc

--LETS BREAK THINGS DOWN BY CONTINENT
--total death count by continent
SELECT
	location,
    MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM 
    Covid_Deaths
WHERE continent is null
GROUP BY 
    location
ORDER BY 
    TotalDeathCount desc

--SELECT
--	continent,
--    MAX(CAST(total_deaths as int)) as TotalDeathCount
--FROM 
--    Covid_Deaths
--WHERE continent is not null
--GROUP BY 
--    continent
--ORDER BY 
--    TotalDeathCount desc

--Global numbers
SELECT date, SUM(CAST(new_cases AS INT)), SUM(CAST(new_deaths AS INT))
		FROM Covid_Deaths
	WHERE continent is not null
	GROUP BY date
	ORDER BY 1,2

SELECT date, 
	SUM(CAST(new_cases AS INT)) AS Total_Cases, 
	SUM(CAST(new_deaths AS INT)) AS Total_Deaths,
	SUM(CAST(new_deaths AS DECIMAL))/SUM(CAST(new_cases AS DECIMAL))*100 AS DeathPercentage
		FROM Covid_Deaths
	WHERE continent is not null
	GROUP BY date
	ORDER BY 1,2

SELECT
	SUM(CAST(new_cases AS INT)) AS Total_Cases, 
	SUM(CAST(new_deaths AS INT)) AS Total_Deaths,
	SUM(CAST(new_deaths AS DECIMAL))/SUM(CAST(new_cases AS DECIMAL))*100 AS DeathPercentage
		FROM Covid_Deaths
	WHERE continent is not null
	ORDER BY 1,2


--total population vs vaccination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM Covid_Deaths dea
JOIN Covid_Vaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

--the code beneath won't work because of what is highlighted in green. Unless you create CTE or Temptables cua
----you can't use a newly created column in subsequent calculation
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY
 dea.location, dea.date) AS RollingPeopleVaccinated
 --, (RollingPeopleVaccinated/population)*100
FROM Covid_Deaths dea
JOIN Covid_Vaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

--using a CTE
with PopvsVac (Continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY
 dea.location, dea.date) AS RollingPeopleVaccinated
FROM Covid_Deaths dea
JOIN Covid_Vaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac

--using a Temp table
DROP Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY
 dea.location, dea.date) AS RollingPeopleVaccinated
FROM Covid_Deaths dea
JOIN Covid_Vaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated


--creating view to store data for later visualisation
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY
 dea.location, dea.date) AS RollingPeopleVaccinated
FROM Covid_Deaths dea
JOIN Covid_Vaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null

SELECT *
FROM PercentPopulationVaccinated
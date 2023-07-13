--Default state
SELECT * FROM Covid2$
WHERE continent is not null
ORDER BY 3,4

--Covid data we are using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Covid1$
WHERE continent is not null
ORDER BY 1,2

--Covid data total cases vs total deaths
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Covid1$
WHERE continent is not null
ORDER BY 1,2

--Covid data total cases vs total deaths of turkey
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPersentage
FROM Covid1$
WHERE location like '%turkey%' and continent is not null
ORDER BY 1,2

--Covid data population vs total cases of turkey
SELECT location, date, population, total_cases, (total_cases/population)*100 AS PopulationInfectionPersentage
FROM Covid1$
WHERE location like '%turkey%' and continent is not null
ORDER BY 1,2

--Covid data HightestPopulationInfectionPersentage
SELECT location, population, MAX(total_cases) AS InfectionCount,
MAX((total_cases/population))*100 AS PopulationInfectionPersentage
FROM Covid1$
WHERE continent is not null
GROUP BY location, population
ORDER BY PopulationInfectionPersentage DESC

--Covid data Total Deaths Countries
SELECT location, MAX(cast(total_deaths  AS INT)) AS TotalDeathCount
FROM Covid1$
WHERE continent is not null
GROUP BY location, population
ORDER BY TotalDeathCount desc

--Covid data Total Deaths Continents
SELECT continent, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM Covid1$
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

--Covid data Total Deaths Continents
SELECT continent, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM Covid1$
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

--Covid data Global numbers
SELECT date, SUM(new_cases) AS totalCases,
SUM(CAST(new_deaths AS INT)) AS totalDeaths,
SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS DeathPersentage
FROM Covid1$
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

--Covid data TotalPopulation vs Vaccination
SELECT cov.continent, cov.location, cov.date, cov.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY cov.location ORDER BY cov.location, cov.date) AS PeopleVaccinated
--(PeopleVaccinated/population)*100
FROM Covid1$ cov
JOIN Covid2$ vac
ON cov.location = vac.location and cov.date = vac.date
WHERE cov.continent is not null
ORDER BY 2,3

--USE CTE
WITH PopulationVaccinationRate (Continent, location, date, population, new_Vactination, PeopleVaccinated)
AS
(
--Covid data TotalPopulation vs Vaccination
SELECT cov.continent, cov.location, cov.date, cov.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY cov.location ORDER BY cov.location, cov.date) AS PeopleVaccinated
--(PeopleVaccinated/population)*100
FROM Covid1$ cov
JOIN Covid2$ vac
ON cov.location = vac.location and cov.date = vac.date
WHERE cov.continent is not null
--ORDER BY 2,3
)
SELECT *, (PeopleVaccinated/population) * 100
FROM PopulationVaccinationRate


--TEMP TABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
PeopleVaccinated numeric,

)
INSERT INTO #PercentPopulationVaccinated
SELECT cov.continent, cov.location, cov.date, cov.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY cov.location ORDER BY cov.location, cov.date) AS PeopleVaccinated
--(PeopleVaccinated/population)*100
FROM Covid1$ cov
JOIN Covid2$ vac
ON cov.location = vac.location and cov.date = vac.date
WHERE cov.continent is not null

SELECT *, (PeopleVaccinated/population) * 100
FROM #PercentPopulationVaccinated

--CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION
CREATE VIEW PercentPopulationVaccinated AS
SELECT cov.continent, cov.location, cov.date, cov.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY cov.location ORDER BY cov.location, cov.date) AS PeopleVaccinated
--(PeopleVaccinated/population)*100
FROM Covid1$ cov
JOIN Covid2$ vac
ON cov.location = vac.location and cov.date = vac.date
WHERE cov.continent is not null

SELECT *
FROM PercentPopulationVaccinated
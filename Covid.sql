-- Considering the following
SELECT location,date,total_cases,new_cases,total_deaths,population
FROM CovidDeaths$
ORDER BY location,date

-- Total Case vs Total Death
--Showing the total cases,deaths and deathpercentage
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths$
--WHERE location LIKE '%Nigeria%'
WHERE continent IS NOT NULL
ORDER BY location,date

-- The number of population that got Covid
SELECT location,date,total_cases,population,(total_cases/population)*100 AS PopulationPercentage
FROM CovidDeaths$
--WHERE location LIKE '%Nigeria%'
ORDER BY location,date

--Highest Infection Rate Compared to Population
SELECT location,MAX(total_cases) AS HighestInfectionCount,population,MAX((total_cases/population))*100 AS PopulationPercentage
FROM CovidDeaths$
--WHERE location LIKE '%Nigeria%'
GROUP BY Location,population
ORDER BY PopulationPercentage DESC

--Highest Death Count Per Population
SELECT location,MAX(cast(total_deaths as int)) AS HighestDeathCount,population,MAX((total_cases/population))*100 AS PopulationPercentage
FROM CovidDeaths$
--WHERE location LIKE '%Nigeria%'
WHERE continent IS NOT NULL
GROUP BY Location,population 
ORDER BY HighestDeathCount DESC

-- Based on Continent
-- Highest DeathCount based on Continent
SELECT Continent,MAX(cast(total_deaths as int)) AS HighestDeathCount
FROM CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY HighestDeathCount DESC

-- Looking at the data across the world
--Checking for the total cases,deaths and death rate across the world per day
SELECT date,SUM(new_cases) Total_cases,SUM(cast(new_deaths as int)) Total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY date

--Overall total cases,deaths and death rate across the world
SELECT SUM(new_cases) Total_cases,SUM(cast(new_deaths as int)) Total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM CovidDeaths$
WHERE continent IS NOT NULL

-- Joining the covid deaths and vaccination table
SELECT d.continent,d.location,d.date,d.population,v.new_vaccinations
FROM CovidDeaths$ d
JOIN CovidVaccinations$ v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY location,date

-- Total population vs Vaccination
SELECT d.continent,d.location,d.date,d.population,v.new_vaccinations,
SUM(cast(v.new_vaccinations as int)) OVER (PARTITION BY d.location order by d.location,d.date)RollingPeopleVaccination
FROM CovidDeaths$ d
JOIN CovidVaccinations$ v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY location,date

--USING CTE
WITH Population_Vaccination(continent,location,date,population,new_vaccinations,RollingPeopleVaccination) AS
(SELECT d.continent,d.location,d.date,d.population,v.new_vaccinations,
SUM(cast(v.new_vaccinations as int)) OVER (PARTITION BY d.location order by d.location,d.date)RollingPeopleVaccination
FROM CovidDeaths$ d
JOIN CovidVaccinations$ v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL
)

SELECT*,(RollingPeopleVaccination/population)*100 VaccinationPetcentage
FROM Population_Vaccination



















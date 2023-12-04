SELECT *
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 3,4;

SELECT *
FROM covidvaccinations
ORDER BY 3,4;


-- select data to be used
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- total cases vs total deaths
-- likelihood of dying if contract covid per country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM coviddeaths
-- WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
ORDER BY 1,2;


-- total cases vs population
-- percentage of population that got covid
SELECT location, date, total_cases, population, (total_cases/population)*100 AS infected_population_percentage
FROM coviddeaths
-- WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
ORDER BY 1,2;


-- countries with highest infection rate compared to the population
SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population))*100 AS infected_population_percentage
FROM coviddeaths
-- WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY infected_population_percentage DESC;

-- countries with highest death count per population
SELECT location, MAX(total_deaths) AS total_death_count
FROM coviddeaths
-- WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC;


-- continent breakdown



-- continents with the highest death count per population
SELECT continent, MAX(total_deaths) AS total_death_count
FROM coviddeaths
-- WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;

-- global numbers
SELECT date, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)* 100 AS death_percentage
FROM coviddeaths
-- WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;


-- total population vs vaccination

-- with cte
-- cannot call newly formed columns so need cte
WITH popvsvac (continent, location, date, population, new_vaccinations, people_vaccinated)
AS (
	SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS people_vaccinated
FROM coviddeaths cd
JOIN covidvaccinations cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
-- ORDER BY 2,3
)
SELECT *, (people_vaccinated / population)*100
FROM popvsvac;

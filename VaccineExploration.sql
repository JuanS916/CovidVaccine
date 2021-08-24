--Check if the dataset has been properly imported

SELECT *
FROM CovidVax..vaccinations

-- We want to explore Global numbers. Namely the total number of vaccines given the number of people fully vacionated

SELECT SUM(daily_vaccinations) as TotalNumOfVaccines
FROM CovidVax..vaccinations

--Calculates total number of people fully vaccinated and total number of doses given 
SELECT SUM(maxNum.TotalFullyVaccinated) as FullyVaccinated, SUM(maxNum.TotalNumOfVaccines) as TotalVaccineDoses
FROM (SELECT country, MAX(CAST(people_fully_vaccinated as INT)) AS TotalFullyVaccinated, SUM(daily_vaccinations) as TotalNumOfVaccines
FROM CovidVax..vaccinations
GROUP BY country) as maxNum

--Find the top 10 countries with the highest number of fully vaccinated

SELECT TOP 10 country, MAX(CAST(people_fully_vaccinated as INT)) AS TotalFullyVaccinated
FROM CovidVax..vaccinations
GROUP BY country
ORDER BY TotalFullyVaccinated DESC


--Find the trend for number of vaccine shots given by the top 10 countries

--First we need to create a temproray table
DROP TABLE IF EXISTS #maxCountries

SELECT *
INTO #maxCountries
FROM (
SELECT TOP 10 country, MAX(CAST(people_fully_vaccinated as INT)) AS TotalFullyVaccinated
FROM CovidVax..vaccinations
GROUP BY country
ORDER BY TotalFullyVaccinated DESC) as vax


--Join based on the top 10 countries
SELECT vax.country, date, daily_vaccinations
FROM CovidVax..vaccinations vax
JOIN #maxCountries cou
	on cou.country = vax.country

-- Create a map based on country and total vaccinations
SELECT country, MAX(CAST(people_fully_vaccinated as INT)) AS TotalFullyVaccinated
FROM CovidVax..vaccinations
GROUP BY country
ORDER BY TotalFullyVaccinated DESC
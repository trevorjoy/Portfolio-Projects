select *
from [Portfolio Project #1 - Covid]..CovidDeaths$
where continent is not null
order by 3,4

--select *
--from [Portfolio Project #1 - Covid]..CovidVaccinations$
--order by 3,4


select location, date, total_cases, new_cases, total_deaths, population
from [Portfolio Project #1 - Covid]..CovidDeaths$
where continent is not null
order by 1,2

--looking at total cases vs total deaths
--shows likelihood of dying if you get covid in your country

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [Portfolio Project #1 - Covid]..CovidDeaths$
Where location like '%states%'
order by 1,2

--looking at total cases vs population
--shows what percentage of population got covid

select location, date, population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
from [Portfolio Project #1 - Covid]..CovidDeaths$
Where location like '%states%'
order by 1,2

--looking at countries with highest infection rate compared to population

select location, population, MAX(total_cases) AS HighestInfectionCount,  MAX((total_cases/population))*100 as PercentPopulationInfected
from [Portfolio Project #1 - Covid]..CovidDeaths$
--Where location like '%states%'
where continent is not null
Group by location, population
order by PercentPopulationInfected desc


--showing the countries with the highest death count per population

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project #1 - Covid]..CovidDeaths$
--Where location like '%states%'
where continent is not null
Group by location
order by TotalDeathCount desc

--break things down by continent
--showing continents with highest death count per population

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project #1 - Covid]..CovidDeaths$
--Where location like '%states%'
where continent is null
Group by location
order by TotalDeathCount desc

--global numbers by day

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from [Portfolio Project #1 - Covid]..CovidDeaths$
--Where location like '%states%'
where continent is not null
group by date
order by 1,2

--global numbers total

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from [Portfolio Project #1 - Covid]..CovidDeaths$
--Where location like '%states%'
where continent is not null
--group by date
order by 1,2


--looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int))over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated --,RollingPeopleVaccinated/population)*100
from [Portfolio Project #1 - Covid]..CovidDeaths$ dea
join [Portfolio Project #1 - Covid]..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE

with PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int))over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated --,RollingPeopleVaccinated/population)*100
from [Portfolio Project #1 - Covid]..CovidDeaths$ dea
join [Portfolio Project #1 - Covid]..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac


--Temp Table

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int))over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated --,RollingPeopleVaccinated/population)*100
from [Portfolio Project #1 - Covid]..CovidDeaths$ dea
join [Portfolio Project #1 - Covid]..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


--creating view to store data for later visualizations

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int))over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated --,RollingPeopleVaccinated/population)*100
from [Portfolio Project #1 - Covid]..CovidDeaths$ dea
join [Portfolio Project #1 - Covid]..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select*
from PercentPopulationVaccinated
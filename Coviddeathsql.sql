
select * 
From PortfolioProject.dbo.coviddeaths
where continent is not null
order by 3,4


select * 
From PortfolioProject.dbo.covidvaccinations
order by 3,4


select location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject.dbo.coviddeaths
order by 1,2


select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject.dbo.coviddeaths
where location like '%Kenya%'
order by 1,2


select location,date,population,total_cases, (total_cases/population)*100 as PercentPopulationinfected
From PortfolioProject.dbo.coviddeaths
order by 1,2


select location,population, MAX(total_cases) as Highestinfectioncount, MAX((total_cases/population))*100 as PercentPopulationinfected
From PortfolioProject.dbo.coviddeaths
Group by location,population
order by PercentPopulationinfected DESC



select location, MAX(total_deaths) as TotalDeathCount
From PortfolioProject.dbo.coviddeaths
where continent is not null
Group by location
order by TotalDeathCount DESC


-
select location, MAX(total_deaths) as TotalDeathCount
From PortfolioProject.dbo.coviddeaths
where continent is  null
Group by location
order by TotalDeathCount DESC



select continent, MAX(total_deaths) as TotalDeathCount
From PortfolioProject.dbo.coviddeaths
where continent is not null
Group by continent
order by TotalDeathCount DESC

--Global Numbers
select SUM(new_cases) as Total_cases,SUM(CAST(new_deaths as int))as Total_deaths,SUM(CAST(new_deaths as int))/SUM(new_cases)* 100---,total_deaths,MAX(CAST(total_deaths/total_cases as float))*100 as DeathPercentage
From PortfolioProject.dbo.coviddeaths
where continent is not null
--Group by date
order by 1,2



select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
,RollingPeopleVaccinated/Population) * 100
From PortfolioProject.dbo.coviddeaths dea
join  PortfolioProject.dbo.covidvaccinations vac
      on dea.location = vac.location
	  and dea.date = vac.date
where dea.continent is not null
order by 2,3



With PopVsVac  (continent,location,date,popualtion,New_vaccinations,RollingPeopleVacccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (parttion by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population) * 100
From PortfolioProject.dbo.coviddeaths dea
join  PortfolioProject.dbo.covidvaccinations vac
      on dea.location = vac.location
	  and dea.date = vac.date
where dea.continent is not null
order by 2,3
)
Select *,RollingPeopleVaccinated/Population) * 100
From PopVsVac


DROP table if exists #PercentagePopulationVaccinated
Create Table #PercentagePopulationVaccinated
(
continent nvachar(255),
Location nvarchar(255),
date datetime,
Population numeric,
New_Vaccination numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentagePopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (parttion by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population) * 100
From PortfolioProject.dbo.coviddeaths dea
join  PortfolioProject.dbo.covidvaccinations vac
      on dea.location = vac.location
	  and dea.date = vac.date
where dea.continent is not null
order by 2,3

Select *,RollingPeopleVaccinated/Population) * 100
From #PercentagePopulationVaccinated



create View PercentagePopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (parttion by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population) * 100
From PortfolioProject.dbo.coviddeaths dea
join  PortfolioProject.dbo.covidvaccinations vac
      on dea.location = vac.location
	  and dea.date = vac.date
where dea.continent is not null
order by 2,3

select *
From PercentagePopulationVaccinated


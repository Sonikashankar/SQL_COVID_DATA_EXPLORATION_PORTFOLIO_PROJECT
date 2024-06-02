/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views

*/

#SELECT * FROM prj1dataexploration.coviddeathsss;

#select data we are using
select location, date,population,total_cases,new_cases,total_deaths from prj1dataexploration.coviddeathsss
order by 1,2;

#looking at total cases vs total deaths

select location, date,population,total_cases,new_cases,total_deaths, 
(total_deaths/total_cases)*100 as death_percentage from prj1dataexploration.coviddeathsss;

select location, date,population,total_cases,new_cases,total_deaths, 
(total_deaths/total_cases)*100 as death_percentage from prj1dataexploration.coviddeathsss
where location like '%states%'
order by 7;

#looking at total cases vs population

select location, date,population,total_cases,new_cases,total_deaths, 
(total_cases/population)*100 as infected_percentage from prj1dataexploration.coviddeathsss
order by infected_percentage desc;

select location, date,population,total_cases,new_cases,total_deaths, 
(total_cases/population)*100 as infected_percentage from prj1dataexploration.coviddeathsss
where location like '%United%'
order by infected_percentage desc;

#looking at highest infected country

select location,population,max(total_cases), 
max((total_cases/population)*100) as infected_percentage from prj1dataexploration.coviddeathsss
group by location,population
order by infected_percentage desc
limit 10;


#showing the countries with highest death counts per population              
select location,population,max(total_deaths) as deaths from prj1dataexploration.coviddeathsss
where continent is not null
group by location,population
order by deaths desc;

#lets break through continent
select continent ,max(total_deaths) as deaths from prj1dataexploration.coviddeathsss
where continent is not null
group by continent;

#global number on new caces
select sum(new_cases) as n_cases,sum(new_deaths) as n_deaths,sum(new_deaths)/sum(new_cases)*100 as de from prj1dataexploration.coviddeathsss
where continent is not null;

#covid_vaccination table
select * from  prj1dataexploration.covidvaccinationsss;

select * from  prj1dataexploration.coviddeathsss as dea join 
prj1dataexploration.covidvaccinationsss as vac
on dea.location=vac.location and dea.date=vac.date;

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from  prj1dataexploration.coviddeathsss as dea join 
prj1dataexploration.covidvaccinationsss as vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
order by 1,2,5 desc;

#looking at total vaccination according to location
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from prj1dataexploration.coviddeathsss as dea 
join prj1dataexploration.covidvaccinationsss as vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3;


#Total population vs vaccinations using cte
with popvsvacc(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated )
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated 
from prj1dataexploration.coviddeathsss as dea 
join prj1dataexploration.covidvaccinationsss as vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
)
Select *,(RollingPeopleVaccinated/population)*100 as total_vacc
From popvsvacc;


#creating temp table
drop  table if exists per_pop_vacc;

create temporary table per_pop_vacc
(
continent text,
location text,
dae datetime,
population double,
new_vaccinations double,
RollingPeopleVaccinated double
);
insert into per_pop_vacc
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from prj1dataexploration.coviddeathsss as dea 
join prj1dataexploration.covidvaccinationsss as vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3;

select *,(RollingPeopleVaccinated/population)*100 as total_vacc
from per_pop_vacc;


#creating view for tableu
drop view if exists per_pop_vacc;

create view per_pop_vacc 
as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from prj1dataexploration.coviddeathsss as dea 
join prj1dataexploration.covidvaccinationsss as vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null;

select * from per_pop_vacc





















use world;

-- Bài 1
-- 2
delimiter &&
create procedure pro_country(in country_code char(3))
begin
    select c.id, c.name as city_name, c.population
    from city c
    where c.countrycode = country_code;
end &&
delimiter &&  
-- 3 
call pro_country('NLD');
-- 4
drop procedure pro_country;

-- Bài 2
delimiter &&
create procedure CalculatePopulation(
    in p_countryCode char(3),
    out total_population int
) 
begin
    select sum(c.population)
    from city c
    where c.countrycode = p_countrycode;
end &&
delimiter &&
-- 3
call CalculatePopulation('USA', @total_population);
-- 4
drop procedure CalculatePopulation;

-- Bài 3
-- 2
delimiter &&
create procedure pro_language(in country_language char(30))
begin
    select cl.countrycode, cl.language, cl.percentage
    from countrylanguage cl
    where cl.percentage > 50 and cl.language = country_language;
end &&
delimiter &&
-- 3
call pro_language('Papiamento');
-- 4
drop procedure pro_language;

-- Bài 4  
-- 2
delimiter &&
create procedure UpdateCityPopulation(inout city_id int, in new_population int)
begin
    update city
    set population = new_population
    where id = city_id;
    
    select id, name, population
    from city where id = city_id;
end &&
delimiter &&
-- 3
set @city_id = 314;
set @new_population = 11000000;
call UpdateCityPopulation(@city_id, @new_population);
-- 4
drop procedure UpdateCityPopulation;

-- Bài 5
-- 2 
delimiter &&
create procedure GetLargeCitiesByCountry(in country_code char(3))
begin
    select c.id as cityId, c.name as cityName, c.population
    from city c 
    where c.population > 1000000 and c.countrycode = country_code
    order by c.population desc;
end &&
delimiter && 
-- 3
call GetLargeCitiesByCountry('USA'); 
-- 4
drop procedure GetLargeCitiesByCountry; 
 
-- Bài 6
-- 2
delimiter &&
create procedure GetCountriesWithLargeCities()
begin
    select ct.name as countryName, sum(c.population) as total_population
    from country ct 
    join city c on ct.code = c.countrycode
    where ct.continent = 'Asia'
    group by ct.name
    having sum(c.population) > 10000000
    order by total_population desc;
end &&
delimiter &&
-- 3
call GetCountriesWithLargeCities(); 
-- 4
drop procedure GetCountriesWithLargeCities();

-- Bài 7
-- 2
delimiter &&
create procedure GetEnglishSpeakingCountriesWithCities(in country_language char(30))
begin
    select ct.name as countryName, sum(c.population) as total_population
    from country ct
    join city c on c.countrycode = ct.code
    join countrylanguage cl on cl.countrycode = ct.code
    where cl.isOfficial = 'T' and cl.language = country_language
    group by ct.name
    having sum(c.population) > 5000000
    order by total_population desc limit 10;
end &&
delimiter &&   
-- 3
call GetEnglishSpeakingCountriesWithCities('English');
-- 4
drop procedure GetEnglishSpeakingCountriesWithCities;

-- BÀI 8
delimiter &&
create procedure GetCountriesByCityNames()
begin
    select ct.name as countryName, cl.language as OfficialLanguage, sum(c.population) as total_population
    from city c
    join country ct on ct.code = c.countrycode
    join countrylanguage cl on cl.countrycode = ct.code
    where c.name like 'A%' and cl.isofficial = 'T'
    group by ct.name, cl.language
    having sum(c.population) > 2000000
    order by countryName asc;
end &&
delimiter && 
-- 3
call GetCountriesByCityNames();
-- 4 
drop procedure GetCountriesByCityNames;

-- Bài 9
-- 2
create view CountryLanguageView
as 
    select ct.code as countryCode, ct.name as countryName, cl.language, cl.isOfficial
    from country ct
    join countrylanguage cl on cl.countrycode = ct.code
    where cl.isOfficial = 'T';
-- 3
select * from CountryLanguageView;
-- 4
delimiter &&
create procedure GetLargeCitiesWithEnglish()
begin
    select c.name as cityName, ct.name as countryName, c.population
    from city c
    join country ct on ct.code = c.countrycode
    join countrylanguage cl on cl.CountryCode = ct.code
    where c.population > 1000000 and cl.language = 'English' and cl.IsOfficial = 'T'
    order by c.population desc limit 20;
end &&
delimiter &&
-- 5
call GetLargeCitiesWithEnglish();
-- 6
drop procedure GetLargeCitiesWithEnglish;  
  
-- Bài 10
-- 2
create view OfficialLanguageView
as
    select ct.code as countryCode, ct.name as countryName, cl.language
    from country ct 
    join countrylanguage cl on cl.countrycode = ct.code
    where cl.isofficial = 'T';

-- 3
select * from OfficialLanguageView;

-- 4
create index idx_name on city(name);   
 
-- 5
delimiter &&
create procedure GetSpecialCountriesAndCities(
    language_name char(30)
)
begin
    select ct.name, c.name, c.population, ct.population
    from city c join country ct on c.countrycode = ct.code
    join countrylanguage cl on ct.code = cl.countrycode
    where ct.population > 5000000 and cl.language like language_name and c.name like 'New%'
    order by ct.population desc limit 10;
end &&
delimiter &&  

call GetSpecialCountriesAndCities('English');

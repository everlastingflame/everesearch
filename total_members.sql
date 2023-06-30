with cTable as(
select count(character_id), alliance_id, EXTRACT(year from killmail_date) as year, EXTRACT(month from killmail_date) as month
from extracted_kills_final
group by alliance_id, year, month
)

select  
from cTable
order by year, count desc
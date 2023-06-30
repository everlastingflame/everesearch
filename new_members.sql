with filter_table as(
select distinct(character_id), corporation_id, alliance_id, killmail_date
from extracted_kills_final
), 

cTable as(
select count(character_id), alliance_id, EXTRACT(year from killmail_date) as year, EXTRACT(month from killmail_date) as month
from filter_table
group by alliance_id, year, month
)

select * 
from cTable
order by count desc
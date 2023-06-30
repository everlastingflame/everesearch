WITH filter_table AS (
  SELECT DISTINCT character_id, corporation_id, alliance_id, killmail_date
  FROM extracted_kills_final
), 

cTable AS (
  SELECT COUNT(DISTINCT character_id) AS player_count, alliance_id, EXTRACT(year FROM killmail_date) AS year, EXTRACT(month FROM killmail_date) AS month
  FROM filter_table
  GROUP BY alliance_id, year, month
),

leave_table AS (
  SELECT COUNT(DISTINCT f1.character_id) AS player_count, f1.alliance_id, EXTRACT(year FROM f1.killmail_date) AS year, EXTRACT(month FROM f1.killmail_date) AS month
  FROM filter_table f1
  LEFT JOIN filter_table f2 ON f1.character_id = f2.character_id AND f1.alliance_id = f2.alliance_id
    AND (EXTRACT(year FROM f1.killmail_date) < EXTRACT(year FROM f2.killmail_date)
      OR (EXTRACT(year FROM f1.killmail_date) = EXTRACT(year FROM f2.killmail_date)
      AND EXTRACT(month FROM f1.killmail_date) < EXTRACT(month FROM f2.killmail_date)))
  WHERE f2.character_id IS NULL
  GROUP BY f1.alliance_id, EXTRACT(year FROM f1.killmail_date), EXTRACT(month FROM f1.killmail_date)
)

SELECT *
FROM leave_table
ORDER BY year, player_count DESC;

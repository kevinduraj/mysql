-- -----------------------------------------------------
-- m -N < export-health.sql | tee keywords_health.dat  
-- -----------------------------------------------------
SELECT terms 
FROM engine1.keywords_health 
WHERE static > 9 
ORDER BY count DESC
LIMIT 100
OFFSET 0;

-- -----------------------------------------------------

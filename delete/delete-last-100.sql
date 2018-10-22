-- SELECT sha256url, period 
-- FROM engine33.part_345
-- ORDER BY period
-- LIMIT (SELECT ( ( SELECT COUNT(*) AS total FROM engine33.part_345) - ( 122700 ))) 



-- LIMIT (
--         SELECT (
--           ( SELECT COUNT(*) AS total FROM engine33.part_345) - ( 122700 )
--        ) a


-- delete from orders
-- where orderid in (

SELECT sha256url, period 
FROM engine33.part_01b 
ORDER BY period
LIMIT 50;

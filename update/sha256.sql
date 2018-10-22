         UPDATE engine22.part_000
         SET 
             sha256url = 
                SHA2(
                  REPLACE(
                    REPLACE(
                
                      CASE ( RIGHT(url,1)) 
                      WHEN "/" 
                        THEN LEFT(url, (SELECT (LENGTH(url) - 1))) 
                        ELSE url 
                      END 
                
                    , 'http://', '' ) 
                   , 'www.', '' )
                  , 256)


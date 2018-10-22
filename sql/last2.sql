SELECT 

replace(
  replace(
    case ( right(url,1)) 
    when "/" then left(url, (select (length(url) - 1))) 
      else url 
    end
  ,'http://', '')
, 'www.', ''
)
FROM engine66.part_000;


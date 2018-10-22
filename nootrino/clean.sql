use engine1;

DELETE from keywords_nootrino where terms LIKE '%seduction%';
DELETE from keywords_nootrino where terms LIKE '%order%';
DELETE from keywords_nootrino where terms LIKE '% and %';
DELETE from keywords_nootrino where terms LIKE '%google%';
DELETE from keywords_nootrino where terms LIKE '%;%';
DELETE FROM keywords_nootrino WHERE terms REGEXP '^[0-9]+$';
DELETE from keywords_nootrino where terms like '% \'%';

UPDATE keywords_nootrino SET static = static + 1;


-- TEST COMMAND AND SAMPLE OUTPUT
-- Record your query (or queries, some clues require more than one) below the clue, then comment out the output below it
-- use two `-` to comment at the start of a line, or highlight the text and press `⌘/` to toggle comments
-- EXAMPLE: SELECT ALL FROM THE TABLE COUNTRY AND LIMIT IT TO ONE ENTRY

SELECT * FROM COUNTRY LIMIT 1;

--  -[ RECORD 1 ]--+--------------------------
-- code           | AFG
-- name           | Afghanistan
-- continent      | Asia
-- region         | Southern and Central Asia
-- surfacearea    | 652090
-- indepyear      | 1919
-- population     | 22720000
-- lifeexpectancy | 45.9
-- gnp            | 5976.00
-- gnpold         |
-- localname      | Afganistan/Afqanestan
-- governmentform | Islamic Emirate
-- headofstate    | Mohammad Omar
-- capital        | 1
-- code2          | AF


-- Clue #1: We recently got word that someone fitting Carmen Sandiego's description has been traveling through Southern Europe. She's most likely traveling someplace where she won't be noticed, so find the least populated country in Southern Europe, and we'll start looking for her there.

carmen=# SELECT code, name, population FROM country WHERE region = 'Southern Europe' ORDER BY population ASC LIMIT 1;
 code |             name              | population 
------+-------------------------------+------------
 VAT  | Holy See (Vatican City State) |       1000
(1 row)

-- Clue #2: Now that we're here, we have insight that Carmen was seen attending language classes in this country's officially recognized language. Check our databases and find out what language is spoken in this country, so we can call in a translator to work with you.

carmen=# SELECT "language", isofficial FROM countrylanguage WHERE countrycode = 'VAT';
 language | isofficial 
----------+------------
 Italian  | t
(1 row)

-- Clue #3: We have new news on the classes Carmen attended – our gumshoes tell us she's moved on to a different country, a country where people speak only the language she was learning. Find out which nearby country speaks nothing but that language.


carmen=# SELECT cl.countrycode, c.name FROM countrylanguage cl JOIN country c ON cl.countrycode = c.code WHERE cl."language" = 'Italian';
 countrycode |             name              
-------------+-------------------------------
 ARG         | Argentina
 AUS         | Australia
 BEL         | Belgium
 BRA         | Brazil
 ITA         | Italy
 CAN         | Canada
 LIE         | Liechtenstein
 LUX         | Luxembourg
 MCO         | Monaco
 FRA         | France
 DEU         | Germany
 SMR         | San Marino
 CHE         | Switzerland
 VAT         | Holy See (Vatican City State)
 USA         | United States
(15 rows)

-- need to do a sub query with the command to filter only  shows countries that only speak Italian 

carmen=# SELECT cl.countrycode, c.name FROM countrylanguage cl JOIN country c ON cl.countrycode = c.code WHERE cl."language" = 'Italian' AND NOT EXISTS ( SELECT 1 FROM countrylanguage sub_cl WHERE sub_cl.countrycode = cl.countrycode AND sub_cl."language" != 'Italian' );;
 countrycode |             name              
-------------+-------------------------------
 SMR         | San Marino
 VAT         | Holy See (Vatican City State)
(2 rows)


-- Clue #4: We're booking the first flight out – maybe we've actually got a chance to catch her this time. There are only two cities she could be flying to in the country. One is named the same as the country – that would be too obvious. We're following our gut on this one; find out what other city in that country she might be flying to.

carmen=# SELECT name FROM city WHERE countrycode = 'SMR';
    name    
------------
 Serravalle
 San Marino
(2 rows)


-- Clue #5: Oh no, she pulled a switch – there are two cities with very similar names, but in totally different parts of the globe! She's headed to South America as we speak; go find a city whose name is like the one we were headed to, but doesn't end the same. Find out the city, and do another search for what country it's in. Hurry!

carmen=# SELECT * FROM city WHERE name LIKE '%Serra%';
  id  |         name         | countrycode |     district      | population 
------+----------------------+-------------+-------------------+------------
  265 | Serra                | BRA         | Espï¿½rito Santo  |     302666
  310 | Taboï¿½o da Serra    | BRA         | Sï¿½o Paulo       |     197550
  370 | Itapecerica da Serra | BRA         | Sï¿½o Paulo       |     126672
 3170 | Serravalle           | SMR         | Serravalle/Dogano |       4802
(4 rows)

-- Clue #6: We're close! Our South American agent says she just got a taxi at the airport, and is headed towards the capital! Look up the country's capital, and get there pronto! Send us the name of where you're headed and we'll follow right behind you!

carmen=# SELECT city.name FROM city JOIN country ON country.capital = city.id WHERE country.code = 'BRA';
    name    
------------
 Brasï¿½lia
(1 row)

-- Clue #7: She knows we're on to her – her taxi dropped her off at the international airport, and she beat us to the boarding gates. We have one chance to catch her, we just have to know where she's heading and beat her to the landing dock.

-- Lucky for us, she's getting cocky. She left us a note, and I'm sure she thinks she's very clever, but if we can crack it, we can finally put her where she belongs – behind bars.

-- Our playdate of late has been unusually fun –
-- As an agent, I'll say, you've been a joy to outrun.
-- And while the food here is great, and the people – so nice!
-- I need a little more sunshine with my slice of life.
-- So I'm off to add one to the population I find
-- In a city of ninety-one thousand and now, eighty five.


-- We're counting on you, gumshoe. Find out where she's headed, send us the info, and we'll be sure to meet her at the gates with bells on.

carmen=# SELECT * FROM city WHERE population BETWEEN 91000 AND 91085;
  id  |     name     | countrycode |  district  | population 
------+--------------+-------------+------------+------------
  529 | Halifax      | GBR         | England    |      91069
  582 | Melipilla    | CHL         | Santiago   |      91056
 1444 | Semnan       | IRN         | Semnan     |      91045
 2245 | Putian       | CHN         | Fujian     |      91030
 3196 | Najran       | SAU         | Najran     |      91000
 3260 | Idlib        | SYR         | Idlib      |      91081
 3765 | Krasnogorsk  | RUS         | Moskova    |      91000
 4060 | Santa Monica | USA         | California |      91084
(8 rows)

--I'm guessing Santa Monica as its the closets


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

--I'm guessing Santa Monica as its the closets to 91085

-- Hungry for more?
-- Some of the entries have gotten a bit messed up. For example, the capital of Brazil is not Brasï¿½lia, rather, it is Brasília. Update this entry to the correct spelling. Record your update, in the find_carmen.sql file (below I found Carmen), and do a query for one row and copy paste it to show the update.

-- Update any other two entries that have gotten messed up.

carmen=# SELECT * FROM city WHERE countrycode ='BRA' AND name LIKE '%Bras%';
 id  |    name    | countrycode |     district     | population 
-----+------------+-------------+------------------+------------
 211 | Brasï¿½lia | BRA         | Distrito Federal |    1969868
(1 row)

carmen=# UPDATE city SET name = 'Brasilia' WHERE id = 211;

carmen=# SELECT * FROM city WHERE countrycode ='BRA' AND name LIKE '%Bras%';
 id  |   name   | countrycode |     district     | population 
-----+----------+-------------+------------------+------------
 211 | Brasilia | BRA         | Distrito Federal |    1969868
(1 row)

carmen=# UPDATE city SET district = 'Espírito Santo' WHERE district = 'Espï¿½rito Santo';
UPDATE 7
carmen=# SELECT * FROM city WHERE name LIKE '%Serra%';
  id  |         name         | countrycode |     district      | population 
------+----------------------+-------------+-------------------+------------
  310 | Taboï¿½o da Serra    | BRA         | Sï¿½o Paulo       |     197550
  370 | Itapecerica da Serra | BRA         | Sï¿½o Paulo       |     126672
 3170 | Serravalle           | SMR         | Serravalle/Dogano |       4802
  265 | Serra                | BRA         | Espírito Santo    |     302666
(4 rows)

carmen=# UPDATE city SET district = 'Sao Paulo' WHERE district = 'Sï¿½o Paulo';
UPDATE 69
carmen=# SELECT * FROM city WHERE name LIKE '%Serra%';
  id  |         name         | countrycode |     district      | population 
------+----------------------+-------------+-------------------+------------
  370 | Itapecerica da Serra | BRA         | Sao Paulo         |     126672
 3170 | Serravalle           | SMR         | Serravalle/Dogano |       4802
  265 | Serra                | BRA         | Espírito Santo    |     302666
  310 | Taboï¿½o da Serra    | BRA         | Sao Paulo         |     197550
(4 rows)

carmen=# UPDATE city SET name = 'Taboao da Serra' WHERE id = 310;
UPDATE 1
carmen=# SELECT * FROM city WHERE name LIKE '%Serra%';
  id  |         name         | countrycode |     district      | population 
------+----------------------+-------------+-------------------+------------
  370 | Itapecerica da Serra | BRA         | Sao Paulo         |     126672
 3170 | Serravalle           | SMR         | Serravalle/Dogano |       4802
  265 | Serra                | BRA         | Espírito Santo    |     302666
  310 | Taboao da Serra      | BRA         | Sao Paulo         |     197550
(4 rows)


-- =============================================================================================================================== --
-- ============================================ FLIGHTS ========================================================================== --

coralinelove=# CREATE DATABASE flights
coralinelove-# ;
CREATE DATABASE
coralinelove=# \c flights 
You are now connected to database "flights" as user "coralinelove".
flights=# CREATE TABLE airlines (
        id int,
        name varchar(255) DEFAULT NULL,
        alias varchar(255) DEFAULT NULL,
        iata varchar(255) DEFAULT NULL,
        icao varchar(255) DEFAULT NULL,
        callsign varchar(255) DEFAULT NULL,
        country varchar(255) DEFAULT NULL,
        active varchar(255) DEFAULT NULL
);

CREATE TABLE airports (
        id int,
        name varchar(255) DEFAULT NULL,
        city varchar(255) DEFAULT NULL,
        country varchar(255) DEFAULT NULL,
        iata_faa varchar(255) DEFAULT NULL,
        icao varchar(255) DEFAULT NULL,
        latitude varchar(255) DEFAULT NULL,
        longitude varchar(255) DEFAULT NULL,
        altitude varchar(255) DEFAULT NULL,
        utc_offset varchar(255) DEFAULT NULL,
        dst varchar(255) DEFAULT NULL,
        tz varchar(255) DEFAULT NULL
);

CREATE TABLE routes (
        airline_code varchar(255) DEFAULT NULL,
        airline_id int DEFAULT NULL,
        origin_code varchar(255) DEFAULT NULL,
        origin_id int DEFAULT NULL,
        dest_code varchar(255) DEFAULT NULL,
        dest_id int DEFAULT NULL,
        codeshare varchar(255) DEFAULT NULL,
        stops int DEFAULT NULL,
        equipment varchar(255) DEFAULT NULL
);
CREATE TABLE
CREATE TABLE
CREATE TABLE
flights=# \d
            List of relations
 Schema |   Name   | Type  |    Owner     
--------+----------+-------+--------------
 public | airlines | table | coralinelove
 public | airports | table | coralinelove
 public | routes   | table | coralinelove
(3 rows)

flights=# \d airlines 
                              Table "public.airlines"
  Column  |          Type          | Collation | Nullable |         Default         
----------+------------------------+-----------+----------+-------------------------
 id       | integer                |           |          | 
 name     | character varying(255) |           |          | NULL::character varying
 alias    | character varying(255) |           |          | NULL::character varying
 iata     | character varying(255) |           |          | NULL::character varying
 icao     | character varying(255) |           |          | NULL::character varying
 callsign | character varying(255) |           |          | NULL::character varying
 country  | character varying(255) |           |          | NULL::character varying
 active   | character varying(255) |           |          | NULL::character varying

flights=# \d airports 
                               Table "public.airports"
   Column   |          Type          | Collation | Nullable |         Default         
------------+------------------------+-----------+----------+-------------------------
 id         | integer                |           |          | 
 name       | character varying(255) |           |          | NULL::character varying
 city       | character varying(255) |           |          | NULL::character varying
 country    | character varying(255) |           |          | NULL::character varying
 iata_faa   | character varying(255) |           |          | NULL::character varying
 icao       | character varying(255) |           |          | NULL::character varying
 latitude   | character varying(255) |           |          | NULL::character varying
 longitude  | character varying(255) |           |          | NULL::character varying
 altitude   | character varying(255) |           |          | NULL::character varying
 utc_offset | character varying(255) |           |          | NULL::character varying
 dst        | character varying(255) |           |          | NULL::character varying
 tz         | character varying(255) |           |          | NULL::character varying

flights=# \d routes 
                                 Table "public.routes"
    Column    |          Type          | Collation | Nullable |         Default         
--------------+------------------------+-----------+----------+-------------------------
 airline_code | character varying(255) |           |          | NULL::character varying
 airline_id   | integer                |           |          | 
 origin_code  | character varying(255) |           |          | NULL::character varying
 origin_id    | integer                |           |          | 
 dest_code    | character varying(255) |           |          | NULL::character varying
 dest_id      | integer                |           |          | 
 codeshare    | character varying(255) |           |          | NULL::character varying
 stops        | integer                |           |          | 
 equipment    | character varying(255) |           |          | NULL::character varying

flights=# \copy routes FROM 'routes.csv' DELIMITER ',' CSV;
routes.csv: No such file or directory
flights=# \copy routes FROM '/Users/coralinelove/Downloads/routes.csv' DELIMITER ',' CSV;
COPY 67663
flights=# \copy airports FROM '/Users/coralinelove/Downloads/airports.csv' DELIMITER ',' CSV;
COPY 8107
flights=# \copy airlines FROM '^C
flights=# /copy airlines FROM '/Users/coralinelove/Downloads/airlines.csv' DELIMITER ',' CSV;
ERROR:  syntax error at or near "/"
LINE 1: /copy airlines FROM '/Users/coralinelove/Downloads/airlines....
        ^
flights=# \copy airlines FROM '/Users/coralinelove/Downloads/airlines.csv' DELIMITER ',' CSV;
COPY 6048
flights=# \d routes
                                 Table "public.routes"
    Column    |          Type          | Collation | Nullable |         Default         
--------------+------------------------+-----------+----------+-------------------------
 airline_code | character varying(255) |           |          | NULL::character varying
 airline_id   | integer                |           |          | 
 origin_code  | character varying(255) |           |          | NULL::character varying
 origin_id    | integer                |           |          | 
 dest_code    | character varying(255) |           |          | NULL::character varying
 dest_id      | integer                |           |          | 
 codeshare    | character varying(255) |           |          | NULL::character varying
 stops        | integer                |           |          | 
 equipment    | character varying(255) |           |          | NULL::character varying

flights=# SELECT * FROM ROUTES
flights-# ;
flights=# SELECT * FROM airports;
flights=# 
flights=# SELECT id, name, city  FROM airports WHERE city = 'New York';
  id  |            name             |   city   
------+-----------------------------+----------
 3697 | La Guardia                  | New York
 3797 | John F Kennedy Intl         | New York
 3993 | Wall Street Heliport        | New York
 4032 | East 34th Street Heliport   | New York
 6966 | Penn Station                | New York
 7729 | West 30th St. Heliport      | New York
 7767 | Idlewild Intl               | New York
 7881 | Port Authority Bus Terminal | New York
 8123 | One Police Plaza Heliport   | New York
 8591 | All Airports                | New York
 9350 | Grand Central Terminal      | New York
 9351 | Tremont                     | New York
 9451 | Port Authority              | New York
(13 rows)

flights=# SELECT * FROM airports WHERE city = 'New York' AND dst = 'Paris';
 id | name | city | country | iata_faa | icao | latitude | longitude | altitude | utc_offset | dst | tz 
----+------+------+---------+----------+------+----------+-----------+----------+------------+-----+----
(0 rows)

flights=# SELECT * FROM routes LIMIT 1;
 airline_code | airline_id | origin_code | origin_id | dest_code | dest_id | codeshare | stops | equipment 
--------------+------------+-------------+-----------+-----------+---------+-----------+-------+-----------
 2B           |        410 | AER         |      2965 | KZN       |    2990 |           |     0 | CR2
(1 row)

flights=# SELECT * FROM airports WHERE city = 'New York' AND city = 'Paris';
 id | name | city | country | iata_faa | icao | latitude | longitude | altitude | utc_offset | dst | tz 
----+------+------+---------+----------+------+----------+-----------+----------+------------+-----+----
(0 rows)

flights=# SELECT * FROM airports WHERE city = 'Paris';;
  id  |        name         | city  | country | iata_faa | icao | latitude  | longitude | altitude | utc_offset | dst |      tz      
------+---------------------+-------+---------+----------+------+-----------+-----------+----------+------------+-----+--------------
 1380 | Le Bourget          | Paris | France  | LBG      | LFPB | 48.969444 | 2.441389  | 218      | 1          | E   | Europe/Paris
 1382 | Charles De Gaulle   | Paris | France  | CDG      | LFPG | 49.012779 | 2.55      | 392      | 1          | E   | Europe/Paris
 1386 | Orly                | Paris | France  | ORY      | LFPO | 48.725278 | 2.359444  | 291      | 1          | E   | Europe/Paris
 6486 | La Defense Heliport | Paris | France  | JPU      | \\N  | 48.86667  | 2.333333  | 0        | 1          | E   | Europe/Paris
 7676 | Gare du Nord        | Paris | France  | XPG      | \\N  | 48.880931 | 2.355323  | 423      | 1          | E   | Europe/Paris
 7677 | Gare Montparnasse   | Paris | France  | XGB      | \\N  | 48.84     | 2.318611  | 423      | 1          | E   | Europe/Paris
 8586 | Gare de Lyon        | Paris | France  | PLY      | \\N  | 48.844722 | 2.373611  | 129      | 1          | E   | Europe/Paris
 8587 | Gare de LEst        | Paris | France  | XHP      | \\N  | 48.876944 | 2.359167  | 149      | 1          | E   | Europe/Paris
 8588 | All Airports        | Paris | France  | PAR      | \\N  | 48.856389 | 2.352222  | 107      | 1          | E   | Europe/Paris
 8896 | Paris Nord          | Paris | France  |          | \\N  | 48.880931 | 2.355323  | 0        | 1          | E   | Europe/Paris
(10 rows)

flights=# SELECT * FROM airports WHERE city = 'New York';;
  id  |            name             |   city   |    country    | iata_faa | icao | latitude  | longitude  | altitude | utc_offset | dst |        tz        
------+-----------------------------+----------+---------------+----------+------+-----------+------------+----------+------------+-----+------------------
 3697 | La Guardia                  | New York | United States | LGA      | KLGA | 40.777245 | -73.872608 | 22       | -5         | A   | America/New_York
 3797 | John F Kennedy Intl         | New York | United States | JFK      | KJFK | 40.639751 | -73.778925 | 13       | -5         | A   | America/New_York
 3993 | Wall Street Heliport        | New York | United States | JRB      | KJRB | 40.701214 | -74.009028 | 7        | -5         | A   | America/New_York
 4032 | East 34th Street Heliport   | New York | United States | TSS      | NONE | 40.7425   | -73.971944 | 10       | -5         | A   | America/New_York
 6966 | Penn Station                | New York | United States | ZYP      | \\N  | 40.7505   | -73.9935   | 35       | -5         | A   | America/New_York
 7729 | West 30th St. Heliport      | New York | United States | JRA      | KJRA | 40.7545   | -74.0071   | 7        | -5         | A   | America/New_York
 7767 | Idlewild Intl               | New York | United States | IDL      | KIDL | 40.639751 | -73.778924 | 13       | -5         | A   | America/New_York
 7881 | Port Authority Bus Terminal | New York | United States |          | NYPA | 40.75616  | -73.9906   | 0        | -5         | A   | America/New_York
 8123 | One Police Plaza Heliport   | New York | United States |          | NK39 | 40.7126   | -73.9996   | 244      | -5         | A   | America/New_York
 8591 | All Airports                | New York | United States | NYC      | \\N  | 40.714167 | -74.005833 | 31       | -5         | A   | America/New_York
 9350 | Grand Central Terminal      | New York | United States |          | \\N  | 40.752726 | -73.977229 | 70       | -5         | A   | America/New_York
 9351 | Tremont                     | New York | United States |          | \\N  | 40.847301 | -73.89955  | 200      | -5         | A   | America/New_York
 9451 | Port Authority              | New York | United States |          | \\N  | 40.756667 | -73.991111 | 33       | -5         | A   | America/New_York
(13 rows)

flights=# SELECT * FROM routes limit 15;
 airline_code | airline_id | origin_code | origin_id | dest_code | dest_id | codeshare | stops | equipment 
--------------+------------+-------------+-----------+-----------+---------+-----------+-------+-----------
 2B           |        410 | AER         |      2965 | KZN       |    2990 |           |     0 | CR2
 2B           |        410 | ASF         |      2966 | KZN       |    2990 |           |     0 | CR2
 2B           |        410 | ASF         |      2966 | MRV       |    2962 |           |     0 | CR2
 2B           |        410 | CEK         |      2968 | KZN       |    2990 |           |     0 | CR2
 2B           |        410 | CEK         |      2968 | OVB       |    4078 |           |     0 | CR2
 2B           |        410 | DME         |      4029 | KZN       |    2990 |           |     0 | CR2
 2B           |        410 | DME         |      4029 | NBC       |    6969 |           |     0 | CR2
 2B           |        410 | DME         |      4029 | TGK       |         |           |     0 | CR2
 2B           |        410 | DME         |      4029 | UUA       |    6160 |           |     0 | CR2
 2B           |        410 | EGO         |      6156 | KGD       |    2952 |           |     0 | CR2
 2B           |        410 | EGO         |      6156 | KZN       |    2990 |           |     0 | CR2
 2B           |        410 | GYD         |      2922 | NBC       |    6969 |           |     0 | CR2
 2B           |        410 | KGD         |      2952 | EGO       |    6156 |           |     0 | CR2
 2B           |        410 | KZN         |      2990 | AER       |    2965 |           |     0 | CR2
 2B           |        410 | KZN         |      2990 | ASF       |    2966 |           |     0 | CR2
(15 rows)

flights=# SELECT * FROM routes WHERE origin_code = 'JFK';
flights=# SELECT * FROM routes WHERE origin_code = 'JFK' AND dest_code = 'PAR';
 airline_code | airline_id | origin_code | origin_id | dest_code | dest_id | codeshare | stops | equipment 
--------------+------------+-------------+-----------+-----------+---------+-----------+-------+-----------
(0 rows)

flights=# SELECT * FROM routes WHERE dest_code = 'PAR';
 airline_code | airline_id | origin_code | origin_id | dest_code | dest_id | codeshare | stops | equipment 
--------------+------------+-------------+-----------+-----------+---------+-----------+-------+-----------
(0 rows)

flights=# SELECT * FROM routes WHERE origin_code = 'JFK';
flights=# SELECT * FROM routes WHERE origin_code = 'PAR';
 airline_code | airline_id | origin_code | origin_id | dest_code | dest_id | codeshare | stops | equipment 
--------------+------------+-------------+-----------+-----------+---------+-----------+-------+-----------
(0 rows)

flights=# SELECT * FROM routes WHERE origin_code = 'JFK' AND dest_code = 'LBG';
 airline_code | airline_id | origin_code | origin_id | dest_code | dest_id | codeshare | stops | equipment 
--------------+------------+-------------+-----------+-----------+---------+-----------+-------+-----------
(0 rows)

flights=# SELECT * FROM routes WHERE origin_code = 'JFK' AND dest_code = 'LBG' AND dest_code = 'CDG' AND dest_code = 'ORY' AND dest_code = 'JPU' AND dest_code = 'XPG' AND dest_code = 'XGB' AND dest_code = 'PLY' AND dest_code = 'XHP' AND dest_code = 'PAR';
 airline_code | airline_id | origin_code | origin_id | dest_code | dest_id | codeshare | stops | equipment 
--------------+------------+-------------+-----------+-----------+---------+-----------+-------+-----------
(0 rows)

flights=# SELECT * FROM routes WHERE origin_id = 3797 AND dest_id = 8588;
 airline_code | airline_id | origin_code | origin_id | dest_code | dest_id | codeshare | stops | equipment 
--------------+------------+-------------+-----------+-----------+---------+-----------+-------+-----------
(0 rows)

flights=# SELECT * FROM routes WHERE origin_id = 3797 AND dest_id = 1382;
 airline_code | airline_id | origin_code | origin_id | dest_code | dest_id | codeshare | stops |    equipment    
--------------+------------+-------------+-----------+-----------+---------+-----------+-------+-----------------
 AA           |         24 | JFK         |      3797 | CDG       |    1382 |           |     0 | 763 757
 AF           |        137 | JFK         |      3797 | CDG       |    1382 |           |     0 | 332 772 388 343
 AY           |       2350 | JFK         |      3797 | CDG       |    1382 |           |     0 | 763 757
 AZ           |        596 | JFK         |      3797 | CDG       |    1382 | Y         |     0 | 332 388 772 343
 BA           |       1355 | JFK         |      3797 | CDG       |    1382 | Y         |     0 | 763 757
 DL           |       2009 | JFK         |      3797 | CDG       |    1382 |           |     0 | 332 772 388 343
 EY           |       2222 | JFK         |      3797 | CDG       |    1382 | Y         |     0 | 763 757
 IB           |       2822 | JFK         |      3797 | CDG       |    1382 | Y         |     0 | 763 757
 QR           |       4091 | JFK         |      3797 | CDG       |    1382 | Y         |     0 | 757
 SE           |       5479 | JFK         |      3797 | CDG       |    1382 |           |     0 | 763 332
 US           |       5265 | JFK         |      3797 | CDG       |    1382 |           |     0 | 763 757
(11 rows)

flights=# SELECT * FROM routes WHERE origin_code = 'JFK' AND dest_code = 'CDG';
 airline_code | airline_id | origin_code | origin_id | dest_code | dest_id | codeshare | stops |    equipment    
--------------+------------+-------------+-----------+-----------+---------+-----------+-------+-----------------
 AA           |         24 | JFK         |      3797 | CDG       |    1382 |           |     0 | 763 757
 AF           |        137 | JFK         |      3797 | CDG       |    1382 |           |     0 | 332 772 388 343
 AY           |       2350 | JFK         |      3797 | CDG       |    1382 |           |     0 | 763 757
 AZ           |        596 | JFK         |      3797 | CDG       |    1382 | Y         |     0 | 332 388 772 343
 BA           |       1355 | JFK         |      3797 | CDG       |    1382 | Y         |     0 | 763 757
 DL           |       2009 | JFK         |      3797 | CDG       |    1382 |           |     0 | 332 772 388 343
 EY           |       2222 | JFK         |      3797 | CDG       |    1382 | Y         |     0 | 763 757
 IB           |       2822 | JFK         |      3797 | CDG       |    1382 | Y         |     0 | 763 757
 QR           |       4091 | JFK         |      3797 | CDG       |    1382 | Y         |     0 | 757
 SE           |       5479 | JFK         |      3797 | CDG       |    1382 |           |     0 | 763 332
 US           |       5265 | JFK         |      3797 | CDG       |    1382 |           |     0 | 763 757
(11 rows)

flights=# SELECT * FROM routes WHERE origin_code = 'JFK';
flights=# SELECT COUNT (*) FROM routes WHERE origin_code ='JFK';
 count 
-------
   456
(1 row)

flights=# SELECT COUNT (*) FROM routes WHERE origin_code ='NYC';
 count 
-------
     0
(1 row)

flights=# SELECT COUNT (*) FROM routes WHERE origin_id ='8591';
 count 
-------
     0
(1 row)

flights=# SELECT COUNT (*) FROM routes WHERE origin_id =3697 AND origin_id = 3797;
 count 
-------
     0
(1 row)

flights=# SELECT COUNT (*) FROM airports CROSS JOIN routes WHERE city = 'New York';
 count  
--------
 879619
(1 row)

flights=# SELECT COUNT (*) FROM airports JOIN routes ON airports.id = routes.origin_id WHERE city = 'New York';
 count 
-------
   614
(1 row)

flights=# SELECT COUNT (*) FROM airports JOIN routes on airports.id = routes.dest_id WHERE city = 'Paris';
 count 
-------
   720
(1 row)

flights=# SELECT COUNT (*) FROM airports JOIN routes ON airports.id = routes.origin_id WHERE city = 'New York' AND ( SELECT 1 FROM sub_airports JOIN sub_routes ON sub_airports.id = sub_routes.dest_id WHERE city = 'Paris' );
ERROR:  relation "sub_airports" does not exist
LINE 1: ...in_id WHERE city = 'New York' AND ( SELECT 1 FROM sub_airpor...
                                                             ^
flights=# SELECT COUNT (*) FROM airports AS origin JOIN routes ON origin.id = routes.origin_id JOIN airports AS destination ON routes.dest_id = destination.id WHERE origin.city = 'New York' AND destination.city = 'Paris';
 count 
-------
    14
(1 row)

flights=# SELECT * FROM airports AS origin JOIN routes ON origin.id = routes.origin_id JOIN airports AS destination ON routes.dest_id = destination.id WHERE origin.city = 'New York' AND destination.city = 'Paris';

  id  |        name         |   city   |    country    | iata_faa | icao | latitude  | longitude  | altitude | utc_offset | dst |        tz        | airline_code | airline_id | origin_code | origin_id | dest_code | dest_id | codeshare | stops |    equipment    |  id  |       name        | city  | country | iata_faa | icao | latitude  | longitude | altitude | utc_offset | dst |      tz      
------+---------------------+----------+---------------+----------+------+-----------+------------+----------+------------+-----+------------------+--------------+------------+-------------+-----------+-----------+---------+-----------+-------+-----------------+------+-------------------+-------+---------+----------+------+-----------+-----------+----------+------------+-----+--------------
 3797 | John F Kennedy Intl | New York | United States | JFK      | KJFK | 40.639751 | -73.778925 | 13       | -5         | A   | America/New_York | AA           |         24 | JFK         |      3797 | CDG       |    1382 |           |     0 | 763 757         | 1382 | Charles De Gaulle | Paris | France  | CDG      | LFPG | 49.012779 | 2.55      | 392      | 1          | E   | Europe/Paris
 3797 | John F Kennedy Intl | New York | United States | JFK      | KJFK | 40.639751 | -73.778925 | 13       | -5         | A   | America/New_York | AA           |         24 | JFK         |      3797 | ORY       |    1386 | Y         |     0 | 757             | 1386 | Orly              | Paris | France  | ORY      | LFPO | 48.725278 | 2.359444  | 291      | 1          | E   | Europe/Paris
 3797 | John F Kennedy Intl | New York | United States | JFK      | KJFK | 40.639751 | -73.778925 | 13       | -5         | A   | America/New_York | AF           |        137 | JFK         |      3797 | CDG       |    1382 |           |     0 | 332 772 388 343 | 1382 | Charles De Gaulle | Paris | France  | CDG      | LFPG | 49.012779 | 2.55      | 392      | 1          | E   | Europe/Paris
 3797 | John F Kennedy Intl | New York | United States | JFK      | KJFK | 40.639751 | -73.778925 | 13       | -5         | A   | America/New_York | AY           |       2350 | JFK         |      3797 | CDG       |    1382 |           |     0 | 763 757         | 1382 | Charles De Gaulle | Paris | France  | CDG      | LFPG | 49.012779 | 2.55      | 392      | 1          | E   | Europe/Paris
 3797 | John F Kennedy Intl | New York | United States | JFK      | KJFK | 40.639751 | -73.778925 | 13       | -5         | A   | America/New_York | AZ           |        596 | JFK         |      3797 | CDG       |    1382 | Y         |     0 | 332 388 772 343 | 1382 | Charles De Gaulle | Paris | France  | CDG      | LFPG | 49.012779 | 2.55      | 392      | 1          | E   | Europe/Paris
 3797 | John F Kennedy Intl | New York | United States | JFK      | KJFK | 40.639751 | -73.778925 | 13       | -5         | A   | America/New_York | BA           |       1355 | JFK         |      3797 | CDG       |    1382 | Y         |     0 | 763 757         | 1382 | Charles De Gaulle | Paris | France  | CDG      | LFPG | 49.012779 | 2.55      | 392      | 1          | E   | Europe/Paris
 3797 | John F Kennedy Intl | New York | United States | JFK      | KJFK | 40.639751 | -73.778925 | 13       | -5         | A   | America/New_York | BA           |       1355 | JFK         |      3797 | ORY       |    1386 | Y         |     0 | 752             | 1386 | Orly              | Paris | France  | ORY      | LFPO | 48.725278 | 2.359444  | 291      | 1          | E   | Europe/Paris
 3797 | John F Kennedy Intl | New York | United States | JFK      | KJFK | 40.639751 | -73.778925 | 13       | -5         | A   | America/New_York | DL           |       2009 | JFK         |      3797 | CDG       |    1382 |           |     0 | 332 772 388 343 | 1382 | Charles De Gaulle | Paris | France  | CDG      | LFPG | 49.012779 | 2.55      | 392      | 1          | E   | Europe/Paris
 3797 | John F Kennedy Intl | New York | United States | JFK      | KJFK | 40.639751 | -73.778925 | 13       | -5         | A   | America/New_York | EY           |       2222 | JFK         |      3797 | CDG       |    1382 | Y         |     0 | 763 757         | 1382 | Charles De Gaulle | Paris | France  | CDG      | LFPG | 49.012779 | 2.55      | 392      | 1          | E   | Europe/Paris
 3797 | John F Kennedy Intl | New York | United States | JFK      | KJFK | 40.639751 | -73.778925 | 13       | -5         | A   | America/New_York | IB           |       2822 | JFK         |      3797 | CDG       |    1382 | Y         |     0 | 763 757         | 1382 | Charles De Gaulle | Paris | France  | CDG      | LFPG | 49.012779 | 2.55      | 392      | 1          | E   | Europe/Paris
 3797 | John F Kennedy Intl | New York | United States | JFK      | KJFK | 40.639751 | -73.778925 | 13       | -5         | A   | America/New_York | IB           |       2822 | JFK         |      3797 | ORY       |    1386 | Y         |     0 | 752             | 1386 | Orly              | Paris | France  | ORY      | LFPO | 48.725278 | 2.359444  | 291      | 1          | E   | Europe/Paris
 3797 | John F Kennedy Intl | New York | United States | JFK      | KJFK | 40.639751 | -73.778925 | 13       | -5         | A   | America/New_York | QR           |       4091 | JFK         |      3797 | CDG       |    1382 | Y         |     0 | 757             | 1382 | Charles De Gaulle | Paris | France  | CDG      | LFPG | 49.012779 | 2.55      | 392      | 1          | E   | Europe/Paris
 3797 | John F Kennedy Intl | New York | United States | JFK      | KJFK | 40.639751 | -73.778925 | 13       | -5         | A   | America/New_York | SE           |       5479 | JFK         |      3797 | CDG       |    1382 |           |     0 | 763 332         | 1382 | Charles De Gaulle | Paris | France  | CDG      | LFPG | 49.012779 | 2.55      | 392      | 1          | E   | Europe/Paris
 3797 | John F Kennedy Intl | New York | United States | JFK      | KJFK | 40.639751 | -73.778925 | 13       | -5         | A   | America/New_York | US           |       5265 | JFK         |      3797 | CDG       |    1382 |           |     0 | 763 757         | 1382 | Charles De Gaulle | Paris | France  | CDG      | LFPG | 49.012779 | 2.55      | 392      | 1          | E   | Europe/Paris
(14 rows)


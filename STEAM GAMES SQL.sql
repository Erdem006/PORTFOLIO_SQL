--GENERAL
SELECT * FROM steamspy_data$

--GENERAL
SELECT * FROM steam_app_data$

--GAMES PRICE AND DEVELOPERS
SELECT name, price / 100, developer, publisher
FROM steamspy_data$

--GAMES LIKERATE
SELECT name, (positive / NULLIF(negative,0) * 100) AS LIKERATE
FROM steamspy_data$

--GAMES AND DLC'S
SELECT steam_app_data$.name, dlc
FROM steamspy_data$
INNER JOIN steam_app_data$ ON steamspy_data$.name = steam_app_data$.name
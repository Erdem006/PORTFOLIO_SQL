--BASICS
SELECT * FROM Games_Sales

--BY YEAR
SELECT Rank, Year, Name
FROM Games_Sales
WHERE Year is not null
ORDER BY Year

--TOP SALES
SELECT Name, Year, Global_Sales AS Total_Sales
FROM Games_Sales
ORDER BY Global_Sales DESC

--TOP NA SALES
SELECT Name, Year, NA_Sales
FROM Games_Sales
ORDER BY NA_Sales DESC

--TOP EU SALES
SELECT Name, Year, EU_Sales
FROM Games_Sales
ORDER BY EU_Sales DESC

--JAPAN SALES
SELECT Name, Year, JP_Sales
FROM Games_Sales
ORDER BY JP_Sales DESC

--OTHER SALES
SELECT Name, Year, Other_Sales
FROM Games_Sales
ORDER BY Other_Sales DESC

--GENERAL INFORMATION ORDERED BY GENRE
SELECT Name, Genre, Platform, Publisher
FROM Games_Sales
ORDER BY Genre DESC

-- TOP NA AND EU SALER
SELECT Name, NA_Sales + EU_Sales AS West_Seller
FROM Games_Sales
ORDER BY West_Seller DESC

SELECT Name, JP_Sales + Other_Sales AS East_Seller
FROM Games_Sales
ORDER BY East_Seller DESC
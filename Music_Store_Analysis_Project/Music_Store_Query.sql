/*Question Set 1 - Easy*/

/*1. Who is the senior most employee based on job title?*/
SELECT TOP(1) *
FROM dbo.employee
ORDER BY hiredate DESC;


/* Q2: Which countries have the most Invoices? */
SELECT TOP(1) billingcountry, COUNT(invoiceid) as [No_of_Invoices]
FROM dbo.invoice
GROUP BY billingcountry 
ORDER BY 2 DESC;

/*3. What are top 3 values of total invoice?*/
SELECT TOP(3) *
FROM dbo.invoice
ORDER BY total DESC;
  
/*4. Which city has the best customers? We would like to throw a promotional Music 
Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
totals*/

SELECT TOP(1) billingcity AS [City], SUM(total) AS [Invoice_total]
FROM dbo.invoice
GROUP BY billingcity 
ORDER BY [Invoice_total] DESC;

/*5. Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money*/

SELECT TOP(1) cu.customerid, cu.firstname, cu.lastname, SUM(i.total) AS total_spending
FROM dbo.customer cu
INNER JOIN dbo.invoice i ON cu.customerid = i.customerid
GROUP BY cu.customerid, cu.firstname, cu.lastname 
ORDER BY total_spending DESC;

/*Question Set 2 – Moderate*/

/*1. Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A*/

SELECT DISTINCT cu.firstname, cu.lastname, cu.email, g.name
FROM dbo.customer cu
INNER JOIN dbo.invoice i ON cu.customerid = i.customerid
INNER JOIN dbo.invoiceline il ON i.invoiceid = il.invoiceid
INNER JOIN dbo.track tr ON tr.trackid = il.trackid
INNER JOIN dbo.genre g ON tr.genreid = g.genreid
WHERE g.name = 'Rock'
ORDER BY cu.email;

/*2. Let's invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands*/

SELECT TOP(10) ar.artistid, ar.name, COUNT(tr.trackid) AS [No of Songs] 
FROM dbo.artist ar
INNER JOIN dbo.album al ON ar.artistid = al.artistid
INNER JOIN dbo.track tr ON tr.albumid = al.albumid
INNER JOIN dbo.genre g ON tr.genreid = g.genreid
WHERE g.name = 'Rock'
GROUP BY ar.artistid, ar.name
ORDER BY [No of Songs] DESC;

/*3. Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first*/

SELECT trackid, name, milliseconds 
FROM dbo.track
WHERE milliseconds > (SELECT AVG(milliseconds) FROM dbo.track)
ORDER BY milliseconds DESC;

/*Question Set 3 – Advance*/

/**1. provide a list of customers who have spent the most money on songs by the best-selling artist? 
Include their customer IDs, first names, last names, and the total amount they have spent on those songs
Additionally, please identify which customer has spent the highest amount on this artist.*/

WITH Bestselling_Artist AS (
    SELECT TOP(1)    
        ar.ArtistId,
        ar.Name AS [Artist_Name],
        SUM(il.UnitPrice * il.Quantity) AS [Total_Sales]
    FROM dbo.invoiceline il
    INNER JOIN dbo.track tr ON tr.trackid = il.trackid
    INNER JOIN dbo.album al ON tr.albumid = al.albumid
    INNER JOIN dbo.artist ar ON al.ArtistId = ar.ArtistId
    GROUP BY ar.ArtistId, ar.Name
    ORDER BY [Total_Sales] DESC
)

SELECT
    cu.FirstName + ' ' + cu.LastName AS [CustomerName], bs.Artist_Name,
    SUM(il.UnitPrice * il.Quantity) AS [Total_Spent]
FROM dbo.customer cu
INNER JOIN dbo.invoice i ON cu.customerid = i.customerid
INNER JOIN dbo.invoiceline il ON i.invoiceid = il.invoiceid
INNER JOIN dbo.track tr ON tr.trackid = il.trackid
INNER JOIN dbo.album al ON tr.albumid = al.albumid
INNER JOIN Bestselling_Artist bs ON al.ArtistId = bs.ArtistId
GROUP BY cu.FirstName + ' ' + cu.LastName, bs.Artist_Name 
ORDER BY [Total_Spent] DESC;

/*2. We want to find out the most popular music Genre for each country. We determine the 
most popular genre as the genre with the highest amount of purchases. Write a query 
that returns each country along with the top Genre. For countries where the maximum 
number of purchases is shared return all Genres*/

WITH PopularGenre_by_Country AS (
    SELECT
        i.BillingCountry,
        g.Name,
        COUNT(il.Quantity) AS [No of Purchases],
        ROW_NUMBER() OVER (PARTITION BY i.BillingCountry ORDER BY COUNT(il.Quantity) DESC) AS Rank
    FROM dbo.invoice i
        INNER JOIN dbo.invoiceline il ON i.invoiceid = il.invoiceid
        INNER JOIN dbo.track tr ON tr.trackid = il.trackid
        INNER JOIN dbo.genre g ON tr.genreid = g.genreid
    GROUP BY i.BillingCountry, g.Name
)
SELECT
    BillingCountry AS [CountryName],
    Name AS [PopularGenre]
	FROM PopularGenre_by_Country
	WHERE Rank = 1
	ORDER BY BillingCountry ASC;






































 













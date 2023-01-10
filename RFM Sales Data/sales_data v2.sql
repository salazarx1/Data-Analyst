USE PortfolioProject;
-- Sales Data Table
SELECT *
FROM dbo.[SalesData]

-- Distinct Unique Data
SELECT DISTINCT STATUS	
FROM dbo.SalesData

SELECT DISTINCT YEAR_ID
FROM dbo.SalesData
ORDER BY YEAR_ID DESC

SELECT DISTINCT PRODUCTLINE
FROM dbo.SalesData

SELECT DISTINCT COUNTRY
FROM dbo.SalesData
ORDER BY COUNTRY

SELECT DISTINCT DEALSIZE
FROM dbo.SalesData

SELECT DISTINCT TERRITORY
FROM dbo.SalesData

-- Grouping Sales By Productline
SELECT PRODUCTLINE, SUM(SALES) as Revenue
FROM dbo.SalesData
GROUP BY PRODUCTLINE
ORDER BY Revenue DESC

SELECT YEAR_ID, SUM(SALES) AS Revenue
FROM dbo.SalesData
GROUP BY YEAR_ID
ORDER BY YEAR_ID, Revenue

-- Full Month or Half Month Operation 
SELECT DISTINCT MONTH_ID
FROM dbo.SalesData
WHERE YEAR_ID = 2005

SELECT DEALSIZE, SUM(SALES) AS Revenue
FROM dbo.SalesData
GROUP BY DEALSIZE
ORDER BY REVENUE DESC

--Best Product in United States
SELECT COUNTRY, YEAR_ID, PRODUCTLINE, SUM(SALES) AS Revenue
FROM dbo.SalesData
WHERE COUNTRY = 'USA'
GROUP BY COUNTRY, YEAR_ID, PRODUCTLINE
ORDER BY Revenue

--  Which city has the highest number of sales in a specific country
SELECT CITY, SUM(sales) Revenue
from dbo.SalesData
where country = 'UK'
group by city

--Best Month for sales in what year?How much Revenue in particular Month?
--Sales Increase AS More Months was operational
SELECT MONTH_ID, SUM(SALES) AS Revenue, COUNT(ORDERNUMBER) AS OrderCount
FROM dbo.SalesData
WHERE YEAR_ID = 2003
GROUP BY MONTH_ID
ORDER BY Revenue DESC

--November Best Month, Best Product Classic Card, Vintage
SELECT MONTH_ID,PRODUCTLINE, SUM(SALES) AS Revenue, 
COUNT(ORDERNUMBER) AS ORDERCOUNT
FROM dbo.SalesData
WHERE YEAR_ID = 2003 AND MONTH_ID = 11
GROUP BY MONTH_ID, PRODUCTLINE
ORDER BY Revenue DESC

--Using CTE Best Customer Recency Frequent Monetary (RFM) 

DROP TABLE IF EXISTS #rfm
 ;WITH rfm AS 
(
      SELECT
          CUSTOMERNAME,
	      SUM(SALES) AS MonetaryValue,
	      AVG(SALES) AS AvgMonetaryValue,
          COUNT(ORDERNUMBER) AS OrderCount,
	      MAX(ORDERDATE) AS DatePurchase,
 ( 
 SELECT MAX(ORDERDATE)
   FROM dbo.SalesData
     )  AS RecentPurchase,
 DATEDIFF(DD, MAX(ORDERDATE), (SELECT MAX(ORDERDATE) 
   FROM dbo.SalesData))  AS Occurence
 
 FROM dbo.SalesData
GROUP BY CUSTOMERNAME
),
rfm_calc AS  --Using CTE Inside of CTE
(   
      
	  --Ntile =  getting 4 buckets to sort them by 1- 4, 4 = highest number piority, 1 = lowest
	  -- Ntile is a rating, number 1 -4 caterogize them 1 is lowsest low pirority and 4 is highest pirority
    SELECT r.*,
      NTILE(4) OVER (ORDER BY Occurence DESC) rfm_Ocurrence,--Closer the dates Less occurrence,Farther the date, Higher the Occurrence 
	  NTILE(4) OVER (ORDER BY OrderCount) rfm_OrderCount, -- Higher OrderCount, Better Sales
	  NTILE(4) OVER (ORDER BY MonetaryValue) rfm_Monetary --Higher the numbers, Better Sales, Revenue
FROM rfm r
)

  SELECT c.*, rfm_Ocurrence + rfm_OrderCount + rfm_Monetary AS Total_rfm, -- Calculating giving total
	cast(rfm_Ocurrence AS VARCHAR) + cast(rfm_OrderCount AS VARCHAR) + --Converting to string than
	 cast(rfm_Monetary AS VARCHAR) AS Total_rfm_string             -- showing Total individualy as string
INTO #rfm
FROM rfm_calc c


SELECT CUSTOMERNAME, rfm_Ocurrence, rfm_OrderCount, rfm_Monetary,
    CASE
		WHEN Total_rfm_string in (111, 112 , 121, 122, 123, 132, 211, 212, 114, 141) then 'lost_customers'  --lost customers
		WHEN Total_rfm_string in (133, 134, 143, 244, 334, 343, 344, 144) then 'slipping away, cannot lose' -- (Big spenders who haven’t purchased lately) slipping away
		WHEN Total_rfm_string in (311, 411, 331) then 'new customers'
		WHEN Total_rfm_string in (222, 223, 233, 322) then 'potential churners'
		WHEN Total_rfm_string in (323, 333,321, 422, 332, 432) then 'active' --(Customers who buy often & recently, but at low price points)
		WHEN Total_rfm_string in (433, 434, 443, 444) then 'loyal'
	END rfm_segment
FROM #rfm

-- Products Sold Together
SELECT DISTINCT ORDERNUMBER, STUFF(
    (SELECT ',' + PRODUCTCODE -- Comma to aprehend,seperate it with productline 
FROM dbo.SalesData AS S --for 1 coulmn instead of different rows
WHERE ORDERNUMBER IN      
(
     SELECT ORDERNUMBER
	 FROM (
 
        SELECT ORDERNUMBER , COUNT(*) AS OrderCount
	    FROM dbo.SalesData
	    WHERE STATUS = 'Shipped'
	    GROUP BY ORDERNUMBER
	    )AS ProductsSold
	     WHERE OrderCount = 3 --Which Number of products Sold Together
          )
           AND S.ORDERNUMBER = SD.ORDERNUMBER
 FOR XML PATH (''))   -- Convert to XLM result
              , 1, 1, '') AS ProductCodes --Converted the result to a string removing the first comma
FROM dbo.SalesData SD
ORDER BY PRODUCTCODES DESC


SELECT ORDERNUMBER, COUNT(*) AS OrderCount
FROM dbo.SalesData 
WHERE STATUS = 'Shipped'
GROUP BY ORDERNUMBER

Select *
FROM dbo.SalesData 
WHERE ORDERNUMBER = 10411





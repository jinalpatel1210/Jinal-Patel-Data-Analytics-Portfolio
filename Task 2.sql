-- 1: Top 5 Products by Revenue (Last 6 Months) --

SELECT "Description",
       SUM("TotalAmount") AS Revenue
FROM online_retail
WHERE TO_TIMESTAMP("InvoiceDate", 'YYYY-MM-DD HH24:MI:SS') >= (
    SELECT MAX(TO_TIMESTAMP("InvoiceDate", 'YYYY-MM-DD HH24:MI:SS'))
    FROM online_retail
) - INTERVAL '6 months'
GROUP BY "Description"
ORDER BY Revenue DESC
LIMIT 5;

-- 2: Monthly Revenue Trend --

SELECT DATE_TRUNC('month', "InvoiceDate") AS Month,
       SUM("TotalAmount") AS MonthlyRevenue
FROM online_retail
GROUP BY Month
ORDER BY Month;

-- 3: Average Order Value (AOV) --

SELECT AVG(OrderTotal) AS AvgOrderValue
FROM (
    SELECT "InvoiceNo",
           SUM("TotalAmount") AS OrderTotal
    FROM online_retail
    GROUP BY "InvoiceNo"
) AS order_summary;

-- 4: Top 10 Customers by Revenue --

SELECT "CustomerID",
       SUM("TotalAmount") AS CustomerRevenue
FROM online_retail
GROUP BY "CustomerID"
ORDER BY CustomerRevenue DESC
LIMIT 10;

-- 5: Revenue by Country --

SELECT "Country",
       SUM("TotalAmount") AS TotalRevenue
FROM online_retail
GROUP BY "Country"
ORDER BY TotalRevenue DESC;

-- 6: Most Sold Products by Quantity --

SELECT "Description",
       SUM("Quantity") AS UnitsSold
FROM online_retail
GROUP BY "Description"
ORDER BY UnitsSold DESC
LIMIT 10;

-- 7: Monthly Growth Percentage --

SELECT Month,
       Revenue,
       LAG(Revenue) OVER (ORDER BY Month) AS PreviousMonthRevenue,
       ((Revenue - LAG(Revenue) OVER (ORDER BY Month)) /
        LAG(Revenue) OVER (ORDER BY Month)) * 100 AS GrowthPercent
FROM (
    SELECT DATE_TRUNC('month', "InvoiceDate") AS Month,
           SUM("TotalAmount") AS Revenue
    FROM online_retail
    GROUP BY Month
) sub;




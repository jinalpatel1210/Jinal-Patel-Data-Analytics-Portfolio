-- Task 3: Deep Dive Analysis & Interactive Dashboarding --

-- Step 1: Define core KPIs --
-- KPI 1: Total Revenue --

SELECT SUM("Quantity" * "UnitPrice") AS Total_Revenue
FROM online_retail;

-- KPI 2: Total Orders --

SELECT COUNT(DISTINCT "InvoiceNo") AS Total_Orders
FROM online_retail;

-- KPI 3: Average Order Value --

SELECT 
    SUM("Quantity" * "UnitPrice") /
    COUNT(DISTINCT "InvoiceNo") AS Avg_Order_Value
FROM online_retail;

-- KPI 4: Customer Retention Rate --

SELECT 
    total.total_customers,
    ret.returning_customers,
    ROUND(
        (ret.returning_customers::numeric 
        / NULLIF(total.total_customers, 0)) * 100,
        2
    ) AS retention_rate
FROM 
(
    SELECT COUNT(DISTINCT "CustomerID") AS total_customers
    FROM online_retail
    WHERE "CustomerID" IS NOT NULL
) AS total
CROSS JOIN
(
    SELECT COUNT(*) AS returning_customers
    FROM (
        SELECT "CustomerID"
        FROM online_retail
        WHERE "CustomerID" IS NOT NULL
        GROUP BY "CustomerID"
        HAVING COUNT(DISTINCT "InvoiceNo") > 1
    ) AS inner_sub
) AS ret;

-- KPI 5: Monthly Revenue Growth Rate --

SELECT 
    m.Month,
    m.Revenue,
    LAG(m.Revenue) OVER (ORDER BY m.Month) AS Previous_Month_Revenue,
    ROUND(
        (
            (m.Revenue - LAG(m.Revenue) OVER (ORDER BY m.Month))::numeric
            /
            NULLIF(LAG(m.Revenue) OVER (ORDER BY m.Month), 0)::numeric
        ) * 100,
        2
    ) AS Growth_Percentage
FROM
(
    SELECT 
        DATE_TRUNC('month', "InvoiceDate") AS Month,
        SUM("Quantity" * "UnitPrice")::numeric AS Revenue
    FROM online_retail
    GROUP BY DATE_TRUNC('month', "InvoiceDate")
) AS m
ORDER BY m.Month;
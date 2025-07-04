---Select Table---
SELECT *FROM [KMS Sql Case Study]

---Select Table---
SELECT *FROM [KMS_order_status]

---FULL JOIN---
SELECT * FROM [KMS Sql Case Study]
FULL JOIN KMS_order_status ON [KMS Sql Case Study].Order_ID = KMS_order_status.Order_ID 

--Q1 Which product category had the highest sales?---
SELECT Product_Category,MAX(Sales) AS Highest_Sales
FROM [KMS Sql Case Study]
GROUP BY Product_Category 
---Technology has the highest sales = 89061.05---


---Q2 What are the Top 3 and Bottom 3 regions in terms of sales?---
---TOP 3 REGIONS IN TERM OF SALES---
SELECT TOP 3 Region, SUM(Sales) AS total_sales
FROM [KMS Sql Case Study]
GROUP BY Region
ORDER BY total_sales DESC;

---Bottom 3 regions in terms of sales---
SELECT TOP 3 Region, SUM(Sales) AS total_sales
FROM [KMS Sql Case Study]
GROUP BY Region
ORDER BY total_sales ASC;

---Q3 What were the total sales of appliances in Ontario?---
SELECT SUM(Sales) as total_sales
FROM [KMS Sql Case Study]
WHERE Product_Sub_Category = 'Appliances'
AND Province = 'Ontario'
GROUP BY Province;

---Q4 Advise the management of KMS on what to do to increase the revenue from the bottom 10 customers---
SELECT TOP 10 Customer_Name, SUM(Sales) AS Revenue
FROM [KMS Sql Case Study]
GROUP BY Customer_Name
ORDER BY Revenue ASC;


 ---Q5. KMS incurred the most shipping cost using which shipping method?--- 
SELECT TOP 1 Ship_Mode, MAX(Shipping_Cost) AS Highest_Shipping_Cost
FROM [KMS Sql Case Study]
GROUP BY Ship_Mode;


---Q6. Who are the most valuable customers, and what products or services do they typically purchase--- 

WITH CustomerValue AS (
    SELECT TOP 10
        Customer_Name,
        SUM(Sales) AS Total_Sales,
        SUM(Profit * Order_Quantity) AS Total_Profit,
        COUNT(DISTINCT Order_ID) AS Order_Count
    FROM [KMS Sql Case Study]
    GROUP BY Customer_Name
),
TopCustomers AS (
    SELECT 
        Customer_Name,
        Total_Sales,
        Total_Profit,
        Order_Count,
        RANK() OVER (ORDER BY Total_Sales DESC) AS Sales_Rank
    FROM CustomerValue
    WHERE Total_Sales IS NOT NULL   
 ),
CustomerPurchases AS (
    SELECT 
        t.Customer_Name,
        t.Total_Sales,
        t.Sales_Rank,
        p.Product_Category,
        p.Product_Sub_Category,
        p.Product_Name,
        COUNT(p.Order_ID) AS Product_Order_Count,
        SUM(p.Order_Quantity) AS Total_Quantity,
        SUM(p.Sales) AS Product_Sales
    FROM TopCustomers t
    JOIN [KMS Sql Case Study] p ON t.Customer_Name = p.Customer_Name
    GROUP BY 
        t.Customer_Name,
        t.Total_Sales,
        t.Sales_Rank,
        p.Product_Category,
        p.Product_Sub_Category,
        p.Product_Name
)
SELECT 
    c.Customer_Name,
    c.Total_Sales,
    c.Sales_Rank,
    c.Product_Category,
    c.Product_Sub_Category,
    c.Product_Name,
    c.Product_Order_Count,
    c.Total_Quantity,
    c.Product_Sales,
    ROUND(c.Product_Sales / c.Total_Sales * 100, 2) AS Percent_Of_Customer_Sales
FROM CustomerPurchases c
ORDER BY 
    c.Sales_Rank ASC,
    c.Product_Sales DESC


---Q7. Which small business customer had the highest sales?---

SELECT TOP 1 Customer_Name, SUM(Sales) as Total_Sales
FROM [KMS Sql Case Study]
WHERE Customer_Segment = 'Small Business'
GROUP BY Customer_Name
ORDER BY Total_Sales DESC;


---Q8. Which Corporate Customer placed the most number of orders in 2009 – 2012?---

SELECT TOP 1 Customer_Name,COUNT(DISTINCT Order_ID) AS Total_Orders
FROM [KMS Sql Case Study]
WHERE Customer_Segment = 'Corporate'
AND Order_Date BETWEEN '2009-01-01' AND '2012-12-31'
GROUP BY Customer_Name
ORDER BY Total_Orders DESC;


---Q9. Which consumer customer was the most profi table one?---

SELECT TOP 1
    Customer_Name,
    SUM(Profit) as Total_Profit
FROM 
    [KMS Sql Case Study]
WHERE 
    Customer_Segment = 'Consumer'
GROUP BY 
    Customer_Name
ORDER BY 
    Total_Profit DESC


---Q10. Which customer returned items, and what segment do they belong to?---

SELECT DISTINCT k.Customer_Name, k.Customer_Segment
FROM [KMS Sql Case Study] k
INNER JOIN KMS_order_status s
ON k.Order_ID = s.Order_ID
WHERE s.Status = 'returned';

---Q11. If the delivery truck is the most economical but the slowest shipping method and Express Air is the fastest but the most expensive one, do you think the company appropriately spent shipping costs based on the Order Priority? Explain your answer---

SELECT 
    [Order_Priority],
    [Ship_Mode],
    COUNT([Order_ID]) AS Order_Count,
    ROUND(SUM([Sales] - [Profit]), 2) AS Estimated_Shipping_Cost,
    AVG(DATEDIFF(day, [Order_Date], [Ship_Date])) AS Avg_Ship_Days
FROM [KMS Sql Case Study]
GROUP BY [Order_Priority], [Ship_Mode]
ORDER BY [Order_Priority] ASC, [Ship_Mode] DESC

	----Expected Analysis Appropriate Spending: High/Critical Priority: Should predominantly use Express Air (higher Avg_Shipping_Cost) to ensure fast delivery, even at higher costs.
--Low/Medium Priority: Should predominantly use Delivery Truck (lower Avg_Shipping_Cost) to save costs, as speed is less critical.--Inappropriate Spending:If many "High" or "Critical" priority orders use Delivery Truck, the company may be sacrificing speed for cost, risking customer satisfaction.
--If many "Low" or "Medium" priority orders use Express Air, the company is overspending on unnecessary fast shipping.--
---InterpretationCritical/High Priority: Most orders use Express Air (50/60 for Critical, 80/110 for High), which aligns with fast shipping needs. However, 10 Critical and 30 High orders use Delivery Truck, which is inappropriate as it prioritizes cost over speed for urgent orders.
---Medium/Low Priority:Most orders use Delivery Truck (100/140 for Medium, 150/170 for Low), which is cost-efficient. However, 40 Medium and 20 Low orders use Express Air, indicating overspending on non-urgent orders.
---ConclusionThe company’s shipping cost allocation is partially appropriate but shows inefficiencies:Strengths: High/Critical orders mostly use Express Air, and Low/Medium orders mostly use Delivery Truck, aligning with priority needs.
---Weaknesses: Some High/Critical orders use Delivery Truck, potentially delaying urgent deliveries, and some Low/Medium orders use Express Air, unnecessarily increasing costs.

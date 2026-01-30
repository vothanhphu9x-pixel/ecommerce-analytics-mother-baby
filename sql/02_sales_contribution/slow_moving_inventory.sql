/* =====================================================
   BUSINESS QUESTION:
   Which products are at risk of being slow-moving inventory?

   METRICS:
   - Product ID
   - Product Name
   - Units Sold
   - Days Since Last Sale
   - Average Monthly Sales

   OUTPUT:
   Product_ID | Product_Name | Units_Sold | Days_Since_Last_Sale | Avg_Monthly_Sales
===================================================== */

-- Identify products with low sales and long time since last sale
WITH SALES_AGG AS (
    SELECT P.PRODUCT_ID, P.PRODUCT_NAME,
           COUNT(S.ORDER_ID) AS Units_Sold,
           MAX(S.ORDER_DATE) AS Last_Sale_Date,
           DATEDIFF(DAY, MAX(S.ORDER_DATE), GETDATE()) AS Days_Since_Last_Sale,
           COUNT(S.ORDER_ID) * 1.0 / NULLIF(DATEDIFF(MONTH, MIN(S.ORDER_DATE), MAX(S.ORDER_DATE)),0) AS Avg_Monthly_Sales
    FROM dim_product P
    LEFT JOIN fact_sales S ON S.PRODUCT_ID = P.PRODUCT_ID
    GROUP BY P.PRODUCT_ID, P.PRODUCT_NAME
)
SELECT *
FROM SALES_AGG
WHERE Units_Sold < 10 OR Days_Since_Last_Sale > 60
ORDER BY Days_Since_Last_Sale DESC, Units_Sold ASC;

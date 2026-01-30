/* =====================================================
   BUSINESS QUESTION:
   How effective are promotions in driving sales and profit?

   METRICS:
   - Revenue
   - Discount Amount
   - Number of Orders
   - Profit
   - Uplift % (vs. non-promotion)

   OUTPUT:
   Promotion | Period | Revenue | Discount | Orders | Profit | Uplift %
===================================================== */

-- Example: Compare sales during promotion vs. non-promotion periods
WITH SALES_BASE AS (
    SELECT S.ORDER_ID, S.ORDER_DATE, S.REVENUE, S.COGS, S.DISCOUNT_AMOUNT, S.PRODUCT_ID, C.CAMPAIGN_NAME, C.OBJECTIVE,
           CASE WHEN S.DISCOUNT_AMOUNT > 0 THEN 'Promotion' ELSE 'No Promotion' END AS PROMO_FLAG
    FROM fact_sales S
    INNER JOIN dim_campaign C ON C.CAMPAIGN_ID = CAST(S.CAMPAIGN_ID AS decimal(10))
)
, AGG AS (
    SELECT PROMO_FLAG, COUNT(DISTINCT ORDER_ID) AS Orders,
           SUM(REVENUE) AS Revenue,
           SUM(DISCOUNT_AMOUNT) AS Discount,
           SUM(REVENUE) - SUM(COGS) - SUM(DISCOUNT_AMOUNT) AS Profit
    FROM SALES_BASE
    GROUP BY PROMO_FLAG
)
SELECT *,
       CASE WHEN PROMO_FLAG = 'Promotion' THEN
            (Revenue - LAG(Revenue) OVER(ORDER BY PROMO_FLAG)) * 100.0 / LAG(Revenue) OVER(ORDER BY PROMO_FLAG)
        END AS Uplift_Percent
FROM AGG;

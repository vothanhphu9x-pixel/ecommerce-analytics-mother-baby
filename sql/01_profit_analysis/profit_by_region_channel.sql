/* =====================================================
    BUSINESS QUESTION:
    What is the profit by region and sales channel?

    METRICS:
    - Revenue
    - COGS
    - Discount
    - Marketing Spend
    - Profit

    OUTPUT:
    Year | Month | Campaign | Channel | Revenue | COGS | Discount | Spend | Profit
===================================================== */

WITH T1 AS (
    SELECT S.ORDER_ID, S.CUSTOMER_ID, S.PRODUCT_ID, S.CHANNEL, S.CHANNEL_MARKETING, M.CHANNEL AS CHANNEL_FACTMARKETING, S.REGION, S.ORDER_DATE, S.REVENUE, S.COGS, 
        S.DISCOUNT_AMOUNT, S.[STATUS], C.CAMPAIGN_ID, M.CLICKS, M.IMPRESSION, M.VISIT, M.SPEND, C.CAMPAIGN_NAME, C.OBJECTIVE, c.END_DATE
    FROM fact_sales S
        INNER JOIN fact_marketing M ON M.CAMPAIGN_ID = CAST(S.CAMPAIGN_ID AS decimal(10)) AND S.CHANNEL_MARKETING = M.CHANNEL
        INNER JOIN dim_campaign C ON C.CAMPAIGN_ID = CAST(S.CAMPAIGN_ID AS decimal(10))
)
, T2 AS (
    SELECT YEAR(END_DATE) AS YEAR, MONTH(END_DATE) AS MONTH, CAMPAIGN_ID, CHANNEL_FACTMARKETING, 
            MAX(SPEND) AS SPEND,
            SUM(REVENUE) AS REVENUE,
            SUM(COGS) AS COGS,
            SUM(DISCOUNT_AMOUNT) AS DISCOUNT
        FROM T1
        GROUP BY YEAR(END_DATE), MONTH(END_DATE), CAMPAIGN_ID, CHANNEL_FACTMARKETING
)
SELECT *, 
        REVENUE - COGS - DISCOUNT - SPEND AS PROFIT
FROM T2
ORDER BY [YEAR], [MONTH], CAMPAIGN_ID

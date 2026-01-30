/* =====================================================
    BUSINESS QUESTION:
    How does each campaign perform over time?

    METRICS:
    - Revenue
    - COGS
    - Discount
    - Spend
    - Clicks
    - Impressions
    - Visits
    - Total Orders

    OUTPUT:
    Year | Month | Campaign | Channel | Campaign Name | Total_Order | Spend | Revenue | COGS | Discount | Clicks | Impressions | Visits
===================================================== */

WITH CTE_OVERALL AS (
    SELECT S.ORDER_ID, S.CUSTOMER_ID, S.PRODUCT_ID, S.CHANNEL, S.CHANNEL_MARKETING, M.CHANNEL AS CHANNEL_FACTMARKETING, S.REGION, S.ORDER_DATE, S.REVENUE, S.COGS, 
        S.DISCOUNT_AMOUNT, S.[STATUS], C.CAMPAIGN_ID, M.CLICKS, M.IMPRESSION, M.VISIT, M.SPEND, C.CAMPAIGN_NAME, C.OBJECTIVE, c.END_DATE
    FROM fact_sales S
        INNER JOIN fact_marketing M ON M.CAMPAIGN_ID = CAST(S.CAMPAIGN_ID AS decimal(10)) AND S.CHANNEL_MARKETING = M.CHANNEL
        INNER JOIN dim_campaign C ON C.CAMPAIGN_ID = CAST(S.CAMPAIGN_ID AS decimal(10))
)
SELECT YEAR(END_DATE) AS YEAR, MONTH(END_DATE) AS MONTH, CAMPAIGN_ID, CHANNEL_FACTMARKETING, CAMPAIGN_NAME, 
        COUNT(DISTINCT ORDER_ID) AS Total_Order, 
        MAX(SPEND) AS SPEND,
        SUM(REVENUE) AS REVENUE,
        SUM(COGS) AS COGS,
        SUM(DISCOUNT_AMOUNT) AS DISCOUNT,
        MAX(CLICKS) AS CLICKS, 
        MAX(IMPRESSION) AS IMPRESSION, 
        MAX(VISIT) AS VISIT
FROM CTE_OVERALL
GROUP BY YEAR(END_DATE), MONTH(END_DATE), CAMPAIGN_ID, CHANNEL_FACTMARKETING, CAMPAIGN_NAME
ORDER BY [YEAR], [MONTH], CAMPAIGN_ID

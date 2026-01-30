/* =====================================================
    BUSINESS QUESTION:
    How do key marketing KPIs (spend, clicks, impressions, visits) change over time?

    METRICS:
    - Spend
    - Clicks
    - Impressions
    - Visits
    - Total Campaigns

    OUTPUT:
    Year | Month | Total_Campaign | TOTAL_SPEND | TOTAL_CLICKS | TOTAL_VISIT | TOTAL_IMPRESSION
===================================================== */

WITH T1 AS (
    SELECT S.ORDER_ID, S.CUSTOMER_ID, S.PRODUCT_ID, S.CHANNEL, S.CHANNEL_MARKETING, M.CHANNEL AS CHANNEL_FACTMARKETING, S.REGION, S.ORDER_DATE, S.REVENUE, S.COGS, 
        S.DISCOUNT_AMOUNT, S.[STATUS], C.CAMPAIGN_ID, M.CLICKS, M.IMPRESSION, M.VISIT, M.SPEND, C.CAMPAIGN_NAME, C.OBJECTIVE, C.END_DATE
    FROM fact_sales S
        INNER JOIN fact_marketing M ON M.CAMPAIGN_ID = CAST(S.CAMPAIGN_ID AS decimal(10)) AND S.CHANNEL_MARKETING = M.CHANNEL
        INNER JOIN dim_campaign C ON C.CAMPAIGN_ID = CAST(S.CAMPAIGN_ID AS decimal(10))
)
, T2 AS (
    SELECT YEAR(END_DATE) AS YEAR, MONTH(END_DATE) AS MONTH, CAMPAIGN_ID, CHANNEL_FACTMARKETING,
            MAX(CLICKS) AS CLICKS, 
            MAX(IMPRESSION) AS IMPRESSION, 
            MAX(VISIT) AS VISIT, 
            MAX(SPEND) AS SPEND
        FROM T1
        GROUP BY YEAR(END_DATE), MONTH(END_DATE), CAMPAIGN_ID, CHANNEL_FACTMARKETING
)
SELECT [YEAR], [MONTH],
        COUNT(distinct CAMPAIGN_ID) AS Total_Campaign,
        SUM(SPEND) AS TOTAL_SPEND,
        SUM(CLICKS) AS TOTAL_CLICKS,
        SUM(VISIT) AS TOTAL_VISIT,
        SUM(IMPRESSION) AS TOTAL_IMPRESSION
FROM T2
GROUP BY [YEAR], [MONTH]
ORDER BY [YEAR], [MONTH]

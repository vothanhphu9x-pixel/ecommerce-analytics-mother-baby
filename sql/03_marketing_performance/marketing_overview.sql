/* =====================================================
    BUSINESS QUESTION:
    What is the overall marketing performance by campaign and channel?

    METRICS:
    - Revenue
    - COGS
    - Discount
    - Marketing Spend
    - Clicks
    - Impressions
    - Visits

    OUTPUT:
    Order | Customer | Product | Channel | Region | Revenue | COGS | Discount | Spend | Clicks | Impressions | Visits | Campaign | Objective
===================================================== */

WITH T1 AS (
    SELECT S.ORDER_ID, S.CUSTOMER_ID, S.PRODUCT_ID, S.CHANNEL, S.CHANNEL_MARKETING, M.CHANNEL AS CHANNEL_FACTMARKETING, S.REGION, S.ORDER_DATE, S.REVENUE, S.COGS, 
        S.DISCOUNT_AMOUNT, S.[STATUS], C.CAMPAIGN_ID, M.CLICKS, M.IMPRESSION, M.VISIT, M.SPEND, C.CAMPAIGN_NAME, C.OBJECTIVE
    FROM fact_sales S
        INNER JOIN fact_marketing M ON M.CAMPAIGN_ID = CAST(S.CAMPAIGN_ID AS decimal(10)) AND S.CHANNEL_MARKETING = M.CHANNEL
        INNER JOIN dim_campaign C ON C.CAMPAIGN_ID = CAST(S.CAMPAIGN_ID AS decimal(10))
)
SELECT ORDER_ID, CUSTOMER_ID, PRODUCT_ID, CHANNEL_FACTMARKETING, REGION, ORDER_DATE, REVENUE, COGS, 
    DISCOUNT_AMOUNT, [STATUS], CAMPAIGN_ID, CLICKS, IMPRESSION, VISIT, SPEND, CAMPAIGN_NAME, OBJECTIVE
FROM T1
ORDER BY CAMPAIGN_ID

/* =====================================================
    BUSINESS QUESTION:
    Which regions are the top contributors to revenue by channel?

    METRICS:
    - Revenue
    - COGS
    - Gross Margin
    - Discount
    - Channel

    OUTPUT:
    Year | Region | Channel | Gross_Margin | Rank
===================================================== */

WITH T1 AS (
    SELECT YEAR(ORDER_DATE) AS YEAR, REGION, S.CHANNEL,
        SUM(REVENUE) - SUM(COGS) AS Gross_Margin,
        DENSE_RANK() OVER(PARTITION BY YEAR(ORDER_DATE), S.CHANNEL ORDER BY (SUM(REVENUE) - SUM(DISCOUNT_AMOUNT)) DESC) AS DR
    FROM fact_sales S
        INNER JOIN fact_marketing M ON M.CAMPAIGN_ID = CAST(S.CAMPAIGN_ID AS decimal(10)) AND S.CHANNEL_MARKETING = M.CHANNEL
        INNER JOIN dim_campaign C ON C.CAMPAIGN_ID = CAST(S.CAMPAIGN_ID AS decimal(10))
    GROUP BY YEAR(ORDER_DATE), REGION, S.CHANNEL
)
SELECT *
FROM T1
WHERE DR <= 5
ORDER BY [YEAR]

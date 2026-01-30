/* =====================================================
    BUSINESS QUESTION:
    Which regions contribute most to total profit (Pareto analysis)?

    METRICS:
    - Revenue
    - COGS
    - Gross Margin
    - Contribution %
    - Pareto %

    OUTPUT:
    Region | Gross_Margin | Contribution % | Pareto
===================================================== */

WITH T1 AS (
    SELECT REGION,
        SUM(REVENUE) - SUM(COGS) AS Gross_Margin
    FROM fact_sales S
        INNER JOIN fact_marketing M ON M.CAMPAIGN_ID = CAST(S.CAMPAIGN_ID AS decimal(10)) AND S.CHANNEL_MARKETING = M.CHANNEL
        INNER JOIN dim_campaign C ON C.CAMPAIGN_ID = CAST(S.CAMPAIGN_ID AS decimal(10))
    GROUP BY REGION
)
, T2 AS (
    SELECT *,
            CAST((Gross_Margin *100 / SUM(Gross_Margin) OVER()) AS decimal(10,2)) AS PERCENTAGE
        FROM T1
)
SELECT *,
        SUM([PERCENTAGE]) OVER(ORDER BY PERCENTAGE DESC) AS PARETO
FROM T2

/* =====================================================
    BUSINESS QUESTION:
    Which campaigns are most effective in each season?

    METRICS:
    - CTR
    - CPC
    - CPM
    - ROI
    - ROAS
    - CR
    - AOV
    - Profit
    - Score by Season

    OUTPUT:
    Season | Campaign | Campaign Name | Total_Order | Spend | Profit | CTR | CPC | CPM | CR | ROAS | ROI | AOV | Score_SEASON | Rank
===================================================== */

WITH CTE_OVERALL AS (
    SELECT S.ORDER_ID, S.CUSTOMER_ID, S.PRODUCT_ID, S.CHANNEL, S.CHANNEL_MARKETING, M.CHANNEL AS CHANNEL_FACTMARKETING, S.REGION, S.ORDER_DATE, S.REVENUE, S.COGS, 
        S.DISCOUNT_AMOUNT, S.[STATUS], C.CAMPAIGN_ID, M.CLICKS, M.IMPRESSION, M.VISIT, M.SPEND, C.CAMPAIGN_NAME, C.OBJECTIVE, c.END_DATE,
        CASE 
            WHEN MONTH(C.END_DATE) IN (1,2) THEN 'Tet_Holidays'
            WHEN MONTH(C.END_DATE) IN (3,4,5) THEN 'Low_Season'
            WHEN MONTH(C.END_DATE) IN (6,7) THEN 'Summer_Sale'
            WHEN MONTH(C.END_DATE) IN (8,9) THEN 'Back_to_School'
            WHEN MONTH(C.END_DATE) IN (10,11,12) THEN 'YearEnd_Sale'        
        END AS SEASON
    FROM fact_sales S
        INNER JOIN fact_marketing M ON M.CAMPAIGN_ID = CAST(S.CAMPAIGN_ID AS decimal(10)) AND S.CHANNEL_MARKETING = M.CHANNEL
        INNER JOIN dim_campaign C ON C.CAMPAIGN_ID = CAST(S.CAMPAIGN_ID AS decimal(10))
)
, CTE_INDEX AS (
    SELECT SEASON, CAMPAIGN_ID, CHANNEL_FACTMARKETING, CAMPAIGN_NAME, OBJECTIVE,
            COUNT(DISTINCT ORDER_ID) AS Total_Order, 
            MAX(SPEND) AS SPEND,
            SUM(REVENUE) AS REVENUE,
            SUM(COGS) AS COGS,
            SUM(DISCOUNT_AMOUNT) AS DISCOUNT,
            MAX(CLICKS) AS CLICKS, 
            MAX(IMPRESSION) AS IMPRESSION, 
            MAX(VISIT) AS VISIT
        FROM CTE_OVERALL
        GROUP BY SEASON, CAMPAIGN_ID, CHANNEL_FACTMARKETING, CAMPAIGN_NAME, OBJECTIVE
)
, CTE_INDEX_MARKETING AS (
    SELECT SEASON, CAMPAIGN_ID, CAMPAIGN_NAME, OBJECTIVE,
            SUM(Total_Order) AS Total_Order,
            SUM(DISCOUNT) AS DISCOUNT,
            SUM(SPEND) AS SPEND,
            CAST(SUM(CLICKS) AS decimal(10,2)) *100 / SUM(IMPRESSION) AS CTR,
            CAST((SUM(SPEND) / SUM(CLICKS)) AS decimal(10)) AS CPC,
            CAST(((SUM(SPEND) / SUM(IMPRESSION)) * 1000) AS DECIMAL(10)) AS CPM,
            SUM(REVENUE) - SUM(COGS) - SUM(DISCOUNT) - SUM(SPEND) AS PROFIT,            
            CAST(SUM(Total_Order) AS decimal(10,2)) *100  / SUM(CLICKS) AS CR,
            CAST((SUM(REVENUE) *100 / SUM(SPEND)) AS decimal(10,2)) AS ROAS,
            CAST(((SUM(REVENUE) - SUM(COGS) - SUM(DISCOUNT) - SUM(SPEND)) *100 / SUM(SPEND)) AS DECIMAL(10,2)) AS ROI,
            CAST((SUM(REVENUE) / SUM(Total_Order)) AS decimal(15,2)) AS AOV
        FROM CTE_INDEX
        GROUP BY SEASON, CAMPAIGN_ID, CAMPAIGN_NAME, OBJECTIVE
)
, CTE_Score_Lowseason AS (
    SELECT *,
            (CTR - MIN_CTR) *100 / (MAX_CTR - MIN_CTR) AS Score_CTR,
            (MAX_CPM - CPM) *100 / (MAX_CPM - MIN_CPM) AS Score_CPM,
            (ROI - MIN_ROI) *100 / (MAX_ROI - MIN_ROI) AS Score_ROI
        FROM(
        SELECT *,
                MIN(CTR) OVER(PARTITION BY SEASON) AS MIN_CTR,
                MAX(CTR) OVER(PARTITION BY SEASON) AS MAX_CTR,
                MIN(CPM) OVER(PARTITION BY SEASON) AS MIN_CPM,
                MAX(CPM) OVER(PARTITION BY SEASON) AS MAX_CPM,
                MIN(ROI) OVER(PARTITION BY SEASON) AS MIN_ROI,
                MAX(ROI) OVER(PARTITION BY SEASON) AS MAX_ROI
            FROM CTE_INDEX_MARKETING
        ) AS T
)
SELECT SEASON, CAMPAIGN_ID, CAMPAIGN_NAME, Total_Order, SPEND, PROFIT, CTR, CPC, CPM, CR, ROAS, ROI,
        Score_CTR * 0.5 + Score_CPM * 0.3 + Score_ROI * 0.2 AS Score_SEASON,
        DENSE_RANK() OVER(PARTITION BY SEASON 
            ORDER BY
                CASE
                    WHEN SEASON IN ('Tet_Holidays','YearEnd_Sale') THEN ROI
                    WHEN SEASON IN ('Tet_Holidays','YearEnd_Sale') THEN ROAS
                    ELSE NULL
                END DESC,
                CASE
                    WHEN SEASON IN ('Back_to_School','Summer_Sale') THEN ROI
                    WHEN SEASON IN ('Back_to_School','Summer_Sale') THEN CR 
                    ELSE NULL
                END DESC,
                CASE
                    WHEN SEASON IN ('Low_Season') THEN Score_CTR * 0.5 + Score_CPM * 0.3 + Score_ROI * 0.2
                END DESC
        ) AS DS_4MUA
FROM CTE_Score_Lowseason

# Ecommerce Analytics – Mother & Baby Retail (Con Cung Case Study)

## 1. Business Context

- Industry: Mother & Baby Ecommerce (Omnichannel: Web, App, Store)
- Business Goal:
  - Monitor sales, profit, and marketing performance
  - Understand customer behavior & retention
  - Optimize promotions and inventory decisions

## 2. Business Questions

### Sales & Profit

- Which products/categories drive revenue & profit?
- Revenue & profit trends over time?

### Marketing & Promotion

- Promotion effectiveness (uplift, ROI, ROAS)?
- Which campaigns perform best by season?

### Customer Behavior

- Customer retention & repeat purchase rate?
- Customer lifetime value (CLV) by campaign?

### Inventory

- Identify slow-moving inventory
- Products with low sales or long time since last sale

## 3. Data Architecture

Source Systems → SQL Server → Star Schema → Power BI Dashboard
![Data Architecture](docs/data_architecture.png)

## 4. Data Model

The data warehouse follows a star schema design to support analytical queries.

- Fact tables: fact_sales, fact_marketing, fact_ux
- Dimension tables: dim_customer, dim_product, dim_campaign

![Star Schema](docs/SCHEMA.PNG)

## 5. Key Metrics

### Sales & Profit

- GMV, Revenue, Profit
- AOV (Average Order Value)

### Marketing

- CTR, CPC, CPM
- ROAS, ROI
- Promotion uplift %, Orders during promotion

### Customer

- Conversion rate
- Repeat rate
- CLV (Customer Lifetime Value)

### Inventory

- Units sold
- Days since last sale
- Avg monthly sales (slow-moving inventory)

## 6. Dashboard Preview

#### 6.1. Overview of Campaign Performance Over Time

![Overview of Campaign Performance](dashboard/sales_overview.png)
**Key Insights:**

- Total clicks, impressions, spend, profit, and discount by month
- Profit & loss (P&L) by year, with breakdown of increase/decrease
- Number of campaigns running by month
- Revenue and profit trends, outlier periods

---

#### 6.2. Metrics of Marketing Performance

![Metrics of Marketing Performance](dashboard/marketing_performance.png)
**Key Insights:**

- Relationship between conversion rate (CR), click-through rate (CTR), spend, profit, CPM, CPC
- Identify which marketing metrics drive profit
- Outlier campaigns/periods with high spend but low profit

---

#### 6.3. Discount of Marketing Performance

![Discount of Marketing Performance](dashboard/discount_performance.png)
**Key Insights:**

- Impact of discount on CR and profit
- Correlation between discount and marketing performance
- Periods with high discount but low conversion/profit

---

#### 6.4. Campaign Information & Index

![Campaign Information](dashboard/campaign_information.png)
**Key Insights:**

- Profit, discount, spend, AOV, CTR, CR, ROAS, ROI by campaign/month
- Campaign & channel breakdown
- Identify top and bottom campaigns by key metrics

---

#### 6.5. Segment by Season & Channel

![Segment by Season & Channel](dashboard/segment_by_season_channel.png)
**Key Insights:**

- Campaign performance by season and channel
- Segment analysis: OWNER/DIRECT, SEARCH/E-commerce, Social Media
- Top campaigns by season, channel, and segment

---

#### 6.6. Campaign Comparison (Detail)

![Campaign Comparison](dashboard/campaign_comparison.png)
**Key Insights:**

- Compare spend, discount, profit, clicks, impressions, CTR, CR, CPC, CPM, ROAS, ROI between selected campaigns
- Visualize campaign effectiveness and efficiency

## 7. Tech Stack

- SQL Server
- SQL (CTE, Window Function)
- Power BI

## Project Scope & Deliverables

This project is developed as a comprehensive case study based on a mother & baby retail platform (Con Cung),
covering end-to-end analytics from data modeling to business insights.

### Key Deliverables

- Data warehouse design (Star Schema)
- SQL-based ETL & analytical queries
- Marketing & promotion analysis
- Inventory risk analysis
- Power BI dashboards

## Project Structure

- **sql/01_profit_analysis/**: Profit analysis (over time, by region/channel)
  - `profit_over_time.sql`
  - `profit_by_region_channel.sql`
- **sql/02_sales_contribution/**: Sales contribution & inventory risk
  - `pareto_region.sql` (Pareto analysis by region)
  - `top_region_by_channel.sql` (Top revenue regions by channel)
  - `slow_moving_inventory.sql` (Identify slow-moving inventory)
- **sql/03_marketing_performance/**: Marketing & promotion analytics
  - `marketing_overview.sql` (Marketing performance overview)
  - `marketing_kpi_over_time.sql` (Marketing KPIs over time)
  - `campaign_performance.sql` (Campaign performance)
  - `promotion_effectiveness.sql` (Promotion effectiveness)
- **sql/04_campaign_scoring/**: Campaign scoring & comparison
  - `seasonal_campaign_scoring.sql`
  - `campaign_comparison.sql`
- **sql/05_customer_behavior/**: Customer analytics
  - `cohort_retention.sql` (Cohort retention analysis)
  - `clv_by_campaign.sql` (Customer lifetime value by campaign)
- **concung.sql**: Legacy/main SQL script (all-in-one, for reference)
- **data/**: Raw and processed CSV data files:
  - `dim_campaign.csv`, `dim_customer.csv`, `dim_product.csv`, `fact_marketing.csv`, `fact_sales.csv`, `fact_ux.csv`
- **01_Vietnam_DA_BI_Business_Analysis_2025.md**: Business analysis documentation
- **02_Group_Assignment_Data_Warehouse_Design.md**: Data warehouse design
- **data_dictionary.md**: Data dictionary for all datasets
- **SCHEMA.PNG**: Star schema diagram
- **concung.pbix**: Power BI dashboard/report
- **chart_power bi/**: Additional charts and CSVs for reporting

## How to Use

1. Review the SQL scripts in `concung.sql` for ETL and analysis logic.
2. Explore the `data/` folder for sample datasets.
3. Open the Power BI file (`concung.pbix`) for interactive dashboards.
4. Refer to the markdown files for business context and data warehouse design.

## Portfolio Highlights

- Data modeling and warehouse design
- ETL and SQL analytics
- Data visualization with Power BI
- Documentation and data dictionary

---

_This project is intended for portfolio demonstration purposes._

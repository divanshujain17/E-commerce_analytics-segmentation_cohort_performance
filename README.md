# E-Commerce Analytics: Sales, Customers, Retention, and Operations

An end-to-end analytics project using the Brazilian Olist e-commerce dataset. The project combines a normalized MySQL model, reproducible Python analysis, and Power BI reporting across sales, customer value, retention, products, geography, and operations.

## Business Problem

The analysis answers a progression of business questions: how much the business sells, who buys, who returns, which customers and products are valuable, where demand is concentrated, and where operations need attention.

## Project Phases

### Phase 1: Sales and Executive Analytics

Revenue, orders, customers, AOV, state performance, category performance, and monthly trends.

### Phase 2: Customer and RFM Analytics

Customer value, repeat purchase behavior, churn risk, and the retained segmentation:

- High Value Active
- High Value At Risk
- Recent Low Value
- At Risk
- Regular Customers

### Phase 3: Product Analytics

Category revenue, order volume, average price, catalog size, and revenue concentration.

### Phase 4: Time-Series Analytics

Monthly revenue, orders, AOV, peak periods, annual performance, and growth.

### Phase 5: Observed Customer Lifetime Value

Observed CLV is historical customer revenue, not a prediction of future value. The analysis includes customer lifetime revenue, average customer value, top customers, Pareto concentration, CLV by state, and CLV by category.

### Phase 6: Cohort and Retention Analytics

Monthly cohorts, cohort size, month 1/3/6 retention, retention heatmaps, and cohort revenue.

### Phase 7: Geographic Intelligence

State and city revenue, AOV, order volume, customer concentration, and optional geolocation enrichment.

### Phase 8: Delivery and Operations Analytics

Approval, processing, carrier handoff, delivery duration, late orders, and on-time delivery by state and category.

### Phase 9: Payments and Catalog Intelligence

Payment method, transaction value, installments, product dimensions, freight, and products with no observed sales.

### Phase 10-14: Reviews, Sellers, Operations, Catalog, and Market Basket

Delivery and payment operations are covered in `sql/12_operations_and_delivery.sql`; deeper catalog analysis is in `sql/13_catalog_intelligence.sql`. Market basket analysis is a Python/ML module in `python/market_basket_analysis.py` and writes association rules using support, confidence, and lift. Review satisfaction and seller scorecards are prepared in `sql/14_review_and_seller_extensions.sql` and require the optional Olist reviews and sellers CSV files, which are not included in this checkout.

### SQL and data setup

The numbered SQL scripts create the normalized MySQL model, load the available Olist source data, and provide analysis for each supported phase.

Run the scripts in numeric order from `sql/` after placing the CSV files in `datasets/`.

### Phase 2: Python

Open `notebook/Ecommerce_Analysis.ipynb`. It uses relative paths and writes reusable CSV outputs to `sql/reports/` for RFM, CLV, cohort retention, product analysis, and time series analysis.

Install the required packages with:

```text
pandas
numpy
matplotlib
seaborn
jupyter
mlxtend  # optional, for market basket analysis
```

### Power BI

Open `dashboard/Ecommerce_Analytics_Report.pbix` to explore the available report pages:

- Executive overview
- Customer analysis and RFM segmentation
- Product performance
- Time series performance
- Customer lifetime value and retention
- Geographic and operational analysis

Recommended future pages are Customer Retention & Cohort Analysis and Operations, combining delivery, payments, and order status.

Dashboard screenshots are available in `Images/`.

## Business Questions Answered

1. How much revenue, how many orders, customers, and what AOV does the business generate?
2. Which states and categories drive revenue and orders?
3. Which customers are high value or at risk?
4. What proportion of revenue comes from the top 10% and top 20% of customers?
5. Which states and categories attract high-value customers?
6. When do customers return, and how does retention change by cohort?
7. How long does delivery take, and where are late orders concentrated?
8. Which payment methods and product attributes shape transaction performance?

## Key Findings

The notebook and SQL reports calculate the latest values from the included datasets. Avoid hard-coding findings in dashboard captions: refresh the extracts after changing filters or source data.

## Repository Structure

```text
Git/
├── dashboard/     Power BI report and icons
├── datasets/      Source CSV files
├── Images/        Dashboard screenshots
├── notebook/      Reproducible Python analysis
├── python/        Optional ML analysis modules
└── sql/           Database setup, phase analysis, and report extracts
```

The CSV files are retained for reproducibility. Review dataset licensing and hosting limits before publishing the repository publicly.

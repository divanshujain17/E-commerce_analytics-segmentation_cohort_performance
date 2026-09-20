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

### Executive sales answers

1. **How much revenue, how many orders, customers, and what AOV?** 
Approximately **$13.6M** in delivered-item revenue across **98.7K orders** and **93.4K unique customers**, with an overall AOV of approximately **$137.70**.
2. **Which states generate revenue?** 
**Sao Paulo** leads by a wide margin at approximately **$5.21M**, followed by Rio de Janeiro at **$1.82M** and Minas Gerais at **$1.59M**. Smaller states can show higher AOV despite lower total revenue.
3. **Which categories perform best?** 
**Beauty & Health** leads revenue at **$1.23M**, followed by Watches Gifts at **$1.17M** and Bed, Bath & Table Linens at **$1.02M**.
4. **How does revenue change over time?** 
Revenue rises through 2017, peaks in **November 2017 at approximately $987.8K**, remains strong in December and January, and then fluctuates through 2018.

### Customer and RFM answers

5. **Who are high-value and at risk?** 
The retained segmentation identifies High Value Active, High Value At Risk, Recent Low Value, At Risk, and Regular Customers. High Value Active customers have the largest segment value at approximately **$6.05M**, while High Value At Risk customers contribute approximately **$1.98M** and are the clearest re-engagement audience.
6. **How many purchase once?** 
Approximately **96.95%** of unique customers purchase once, confirming that repeat purchase and retention are the primary growth opportunity.
7. **Which segments generate revenue?** 
High Value Active contributes the most value, followed by Regular Customers at approximately **$4.02M**. High Value At Risk customers have a higher average observed value than High Value Active customers, so retention work should prioritize them despite their smaller population.

### CLV and retention answers

8. **What is observed CLV?** 
Observed CLV is historical customer revenue, not a forecast. The current report measures customer lifetime revenue, average customer value, top customers, revenue concentration, CLV by state, and CLV by category.
9. **What proportion of revenue comes from the top 10% and top 20%?** 
The notebook calculates both shares from the customer-level monetary distribution and writes the ranked data used by the Pareto chart. These are concentration measures, not predictive CLV estimates.
10. **When do customers return?** 
Cohort retention falls sharply after the first purchase month. The cohort extract and heatmap expose month 1, month 3, and month 6 retention by acquisition cohort, making the retention problem visible by timing rather than only as a one-time-buyer percentage.

### Product, geography, and operations answers

11. **Which categories attract high-value customers?** 
The CLV-by-category output ranks categories by unique customers, total revenue, and revenue per customer; category results should be interpreted alongside catalog size and order volume rather than revenue alone.
12. **Where are customers concentrated?** 
Sao Paulo dominates customers, orders, and revenue. City-level and ZIP-prefix outputs add the detail needed for ranking cities and building a bubble or filled map.
13. **How is delivery performing?** 
The operations SQL and notebook calculate average delivery days, on-time percentage, late orders, approval time, processing time, and carrier-to-customer time, with state and category breakdowns. These outputs identify operational bottlenecks without treating missing timestamps as completed deliveries.
14. **Which payment methods dominate?** 
The payment module compares payment type, payment value, average transaction value, installments, and payment method by category. Reviews, seller satisfaction, and seller-balanced scoring require the optional source files documented in `sql/14_review_and_seller_extensions.sql`.

## Key Findings

- The business is large but highly retention-dependent: roughly 97% of unique customers purchase only once.
- Revenue is geographically concentrated in Sao Paulo, while several lower-volume states have higher AOVs.
- Beauty & Health, Watches Gifts, and Bed, Bath & Table Linens are the leading revenue categories in the current extract.
- November 2017 is the strongest observed revenue month.
- High Value Active customers contribute the largest observed segment revenue, while High Value At Risk customers have the highest average observed value and should be prioritized for re-engagement.
- Cohort retention declines quickly after the first purchase, which supports a dedicated retention page instead of relying on a generic customer-count visual.
- The Pareto, delivery, payment, catalog, and market-basket modules generate the detailed outputs used for dashboard decisions. Refresh the extracts before publishing final KPI captions.

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

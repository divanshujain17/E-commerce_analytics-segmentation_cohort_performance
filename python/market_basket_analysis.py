"""Category-level market basket analysis for Olist orders.

Install the optional dependency with: pip install mlxtend
Run from this directory: python market_basket_analysis.py
"""

from pathlib import Path

import pandas as pd
from mlxtend.frequent_patterns import apriori, association_rules


ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = ROOT / "datasets"
OUTPUT_DIR = ROOT / "sql" / "reports"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

orders = pd.read_csv(DATA_DIR / "olist_orders_dataset.csv", usecols=["order_id", "order_status"])
items = pd.read_csv(DATA_DIR / "olist_order_items_dataset.csv", usecols=["order_id", "product_id"])
products = pd.read_csv(DATA_DIR / "olist_products_dataset.csv", usecols=["product_id", "product_category_name"])

delivered = orders.loc[orders["order_status"].eq("delivered"), ["order_id"]]
basket = (
    delivered.merge(items, on="order_id")
    .merge(products, on="product_id")
    .dropna(subset=["product_category_name"])
    .drop_duplicates(["order_id", "product_category_name"])
)
one_hot = pd.crosstab(basket["order_id"], basket["product_category_name"]).astype(bool)
frequent_sets = apriori(one_hot, min_support=0.01, use_colnames=True)
rules = association_rules(frequent_sets, metric="lift", min_threshold=1.0)
rules = rules.sort_values(["lift", "confidence"], ascending=False)
rules.to_csv(OUTPUT_DIR / "market_basket_rules.csv", index=False)
print(rules[["antecedents", "consequents", "support", "confidence", "lift"]].head(20))
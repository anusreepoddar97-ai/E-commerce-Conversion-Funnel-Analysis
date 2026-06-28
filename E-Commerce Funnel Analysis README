E-Commerce Funnel & Revenue Leakage Analysis

📌 Project Overview

This project is an end-to-end data analytics pipeline designed to identify revenue leakage within an e-commerce purchasing funnel. By simulating a relational database of user behavior, modeling the data in Tableau, and utilizing custom calculated fields, this dashboard isolates exact drop-off points in the customer journey and highlights top-performing products.

🔗 View the Interactive Tableau Dashboard Here (<-- Insert your Tableau Public link here before sharing!)

🛠️ Tech Stack

Python (Pandas, Faker): Synthetic data generation and ETL simulation.

Tableau: Data visualization, relational data modeling, custom calculated fields, and interactive dashboard design.

Data Architecture: Relational CSV models (Users, Products, Events).

💼 The Business Problem

An e-commerce company is seeing high top-of-funnel traffic but a lower-than-expected final conversion rate. Stakeholders need to answer three core questions:

At which specific stage of the checkout process are users abandoning the platform?

Which products are driving the most actual revenue (completed purchases), rather than just generating page views?

How is platform traffic distributed across device types to inform UI/UX optimization?

📊 Methodology & Execution

Data Engineering (Python): Engineered a Python script (generate_ecommerce_data.py) to generate a synthetic dataset spanning three relational tables: users.csv, products.csv, and events.csv. The script utilized weighted probabilities to simulate realistic conversion drop-offs and platform preferences.

Data Modeling: Connected the disparate CSVs using relational modeling (Primary/Foreign Keys) directly within Tableau to form a unified data source.

Data Cleaning & Custom Calculations: Diagnosed a data duplication issue where product prices were aggregating incorrectly across all non-purchase event types due to the relational joins. Engineered a custom Calculated Field (COUNT([Event Id]) * MAX([Price])) to accurately isolate and calculate true revenue based solely on completed purchase events.

Advanced Visualizations & UI Design:

Utilized Quick Table Calculations (Percent Difference) to calculate step-by-step funnel drop-off percentages.

Applied business aliasing to raw database strings (e.g., transforming page_view to 1. Product Views) for executive readability.

Designed a cohesive, dark-mode UI with high-contrast, color-coordinated elements to focus stakeholder attention on actionable metrics and establish visual hierarchy.

💡 Key Business Insights

Based on the dashboard analysis, several key insights were uncovered:

Critical Funnel Bottleneck: The most significant revenue leak occurs in the middle of the funnel, with a -47.80% drop-off between users who add an item to their cart and those who actually initiate checkout.

Revenue Drivers: The Smart Watch is the strongest performer by a wide margin, driving $21,500 in actual revenue.

Platform Optimization Need: Mobile traffic absolutely dominates the platform, accounting for over 60% of all events (2,618 out of 4,350 total interactions). Given the high cart abandonment rate, this suggests the mobile checkout UI specifically requires urgent optimization.

Built for data analytics portfolio presentation.

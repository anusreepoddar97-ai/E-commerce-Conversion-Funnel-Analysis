# E-commerce Conversion Funnel Analysis

## Project Overview
This project provides a data-driven analysis of e-commerce user behavior. By designing a relational database to track customer touchpoints, I developed a framework to identify friction points in the conversion funnel and quantify the financial impact of cart abandonment.

## Business Problem
E-commerce platforms often struggle with high cart abandonment rates. Without granular event tracking, businesses cannot distinguish between a user who is "just browsing" and one who intends to buy but encounters friction (e.g., pricing, checkout complexity). This project provides the SQL tooling to bridge that gap.

## Approach & Tech Stack
- **Database Architecture:** Designed a relational schema with three core entities (Users, Products, Events) to map the customer journey from browsing to purchase.
- **SQL (Data Warehouse):** Engineered complex queries utilizing Common Table Expressions (CTEs), Joins, and Aggregations to transform raw event logs into actionable business insights.
- **Tools:** DBeaver (SQL Development), PostgreSQL.

## Key Insights
- **Conversion Funnel:** Built a step-by-step model tracking users from `page_view` to `purchase`.
- **Revenue Impact:** Identified high-value product categories that suffer from high abandonment, allowing for targeted re-marketing strategies.

## Featured Analysis
*The following query calculates the total revenue lost per product due to cart abandonment:*

```sql
WITH AbandonedCarts AS (
    SELECT user_id, product_id
    FROM Events
    WHERE event_type = 'add_to_cart'
    AND user_id NOT IN (
        SELECT user_id 
        FROM Events 
        WHERE event_type = 'purchase'
    )
)
SELECT 
    p.product_name,
    COUNT(a.user_id) AS missed_sales,
    SUM(p.price) AS total_lost_revenue
FROM AbandonedCarts a
JOIN Products p ON a.product_id = p.product_id
GROUP BY p.product_name;

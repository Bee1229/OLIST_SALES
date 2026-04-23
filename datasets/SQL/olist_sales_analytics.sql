use database ecommerce_db;

use schema analytics;

--FULL TABLE
CREATE OR REPLACE TABLE analytics.olist_sales AS
SELECT 
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.delivery_time,
    o.estimated_delivery_day,
    o.late_delivery,

    c.customer_city,
    c.customer_state,
    c.order_count,
    c.repeating_customer,

    oi.product_id,
    oi.price,
    oi.freight_value,
    oi.profit,

    p.product_category_name,

    op.payment_type,
    op.payment_value,

    ro.review_score,

    s.seller_city,
    s.seller_state

FROM STAGING.orders o
LEFT JOIN STAGING.order_payments op ON o.order_id = op.order_id  
LEFT JOIN STAGING.order_reviews ro ON o.order_id = ro.order_id
LEFT JOIN STAGING.customers c ON o.customer_id = c.customer_id
LEFT JOIN STAGING.order_items oi ON o.order_id = oi.order_id
LEFT JOIN STAGING.sellers s ON  oi.seller_id = s.seller_id
LEFT JOIN STAGING.products p ON oi.product_id = p.product_id;

--REVENUE & GROWTH KPI
--Revenue KPI 
CREATE OR REPLACE VIEW analytics.revenue_kpi AS
SELECT SUM(payment_value) as revenue
FROM analytics.olist_sales;

--Monthly Revenue
CREATE OR REPLACE VIEW analytics.monthly_revenue_kpi AS
SELECT EXTRACT(MONTH FROM order_purchase_timestamp) AS months_2016_to_2018,
SUM(PAYMENT_VALUE) AS revenue
FROM analytics.olist_sales
GROUP BY months_2016_to_2018;

--Yearly Revenue
CREATE OR REPLACE VIEW analytics.yearly_revenue_kpi AS
SELECT EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
ROUND(SUM(PAYMENT_VALUE),2) AS revenue
FROM analytics.olist_sales
GROUP BY year;

--Product with the most Revenue
CREATE OR REPLACE VIEW analytics.product_with_highest_revenue_kpi AS
SELECT product_category_name, 
    SUM(payment_value) AS revenue
FROM olist_sales
GROUP BY product_category_name
ORDER BY revenue DESC
LIMIT 1;

--Average Order Value (the higher the AOV the more customers spend per purchase)
CREATE OR REPLACE VIEW analytics.AOV_kpi AS
SELECT (SUM(payment_value) / count(DISTINCT order_id)) AS avg_order_value
FROM olist_sales;


--PROFITABILITY KPI

--Gross Profit: shows how much money is kept by the company
CREATE OR REPLACE VIEW analytics.gross_profit_kpi AS
SELECT SUM(profit) AS gross_profit
FROM olist_sales;

--Gross Margin: Measures the business effeciency 
CREATE OR REPLACE VIEW analytics.gross_margin_kpi AS
SELECT (SUM(profit)/ SUM(payment_value)) * 100 AS gross_margin
FROM olist_sales;

--profit by product
CREATE OR REPLACE VIEW analytics.gross_profit_by_product_kpi AS
SELECT product_category_name,
        SUM(profit) as gross_profit 
FROM olist_sales
GROUP BY product_category_name
ORDER BY gross_profit DESC;

--CUSTOMER KPI
--Total customer
CREATE OR REPLACE VIEW analytics.total_customer_kpi AS
SELECT COUNT(customer_id) AS total_customer
FROM olist_sales;

--customer purchase frequency
CREATE OR REPLACE VIEW analytics.customer_purchase_frequency_kpi AS
SELECT (COUNT( DISTINCT order_id)/ COUNT(customer_id)) * 100 AS customer_purchase_frequency
FROM olist_sales;

--Repeat Customers rate
CREATE OR REPLACE VIEW  analytics.repeat_customer_rate AS
SELECT (COUNT(repeating_customer) / COUNT(customer_id)) AS repeating_customer_rate
FROM olist_sales
WHERE olist_sales.repeating_customer = TRUE;

--Customer Lifetime Value CLV (AOV * Purchase Frequency)
CREATE OR REPLACE VIEW analytics.customer_lifetime_value AS 
WITH aov AS (
    SELECT (SUM(payment_value) / count(DISTINCT order_id)) AS avg_order_value,
    COUNT(DISTINCT order_id) / COUNT(DISTINCT customer_id) AS purchase_frequency
    FROM olist_sales
)
SELECT avg_order_value * purchase_frequency AS estimated_clv
FROM aov;


--OPERATIONAL KPI: Measures how well the company delievers


use database ecommerce_db;

select * from analytics.olist_sales;
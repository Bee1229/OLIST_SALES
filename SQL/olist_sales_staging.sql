
CREATE OR REPLACE TABLE STAGING.orders AS 
SELECT order_id,
    customer_id,
    order_status,
    TO_TIMESTAMP(order_purchase_timestamp) AS order_purchase_timestamp,
    TO_TIMESTAMP(order_approved_at) AS order_approved_at,
    TO_TIMESTAMP(order_delivered_carrier_date) AS order_delivered_carrier_date,
    TO_TIMESTAMP(order_delivered_customer_date) AS order_delivered_customer_date,
    TO_TIMESTAMP(order_estimated_delivery_date) AS order_estimated_delivery_date,
    delivery_time,
    estimated_delivery_day,
    late_delivery,
FROM RAW.ORDERS_RAW;


CREATE OR REPLACE TABLE STAGING.customers AS 
WITH order_count AS(
    SELECT customer_id, COUNT(DISTINCT order_id) AS order_count
    FROM RAW.ORDERS_RAW
    GROUP BY customer_id
)

SELECT c.customer_id, c.customer_unique_id, c.customer_city, 
    c.customer_state, c.customer_zip_code_prefix, o.order_count,
    CASE 
        WHEN o.order_count > 1 THEN true
        ELSE false
    END AS repeating_customer
FROM RAW.customer_raw c
LEFT JOIN order_count o 
    ON o.customer_id = c.customer_id;

CREATE OR REPLACE TABLE STAGING.order_items AS 
SELECT *
FROM RAW.order_items_raw;

CREATE OR REPLACE TABLE STAGING.order_reviews AS 
SELECT *
FROM RAW.order_reviews_raw;

CREATE OR REPLACE TABLE STAGING.order_payments AS 
SELECT *
FROM RAW.order_payments_raw
WHERE payment_value > 0;


CREATE OR REPLACE TABLE STAGING.products AS 
SELECT *
FROM RAW.product_raw;

CREATE OR REPLACE TABLE STAGING.sellers AS 
SELECT *
FROM RAW.sellers_raw;

select * from staging.orders;
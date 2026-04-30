USE DATABASE ecommerce_db;
USE SCHEMA raw;

--customer table
CREATE OR REPLACE TABLE RAW.customer_raw (
    customer_id VARCHAR(255) PRIMARY KEY NOT NULL, 
    customer_unique_id VARCHAR(255),
    customer_zip_code_prefix INTEGER,
    customer_city VARCHAR(255), 
    customer_state VARCHAR(255)
);

--Order Items table
CREATE OR REPLACE TABLE RAW.order_items_raw (
    order_id VARCHAR(255) , 
    order_item_id INTEGER PRIMARY KEY NOT NULL, 
    product_id VARCHAR(255), 
    seller_id VARCHAR(255),
    shipping_limit_date DATE, 
    price FLOAT, 
    freight_value FLOAT, 
    profit FLOAT,
    FOREIGN KEY (order_id)
        REFERENCES RAW.orders_raw(order_id),
    FOREIGN KEY (product_id)
        REFERENCES RAW.product_raw(product_id),
    FOREIGN KEY (seller_id)
        REFERENCES RAW.sellers_raw(seller_id)
);

--order table
CREATE OR REPLACE TABLE RAW.orders_raw (
    order_id VARCHAR(255) PRIMARY KEY,
    customer_id VARCHAR(255),
    order_status VARCHAR(50),
    order_purchase_timestamp STRING,
    order_approved_at STRING,
    order_delivered_carrier_date STRING,
    order_delivered_customer_date STRING,
    order_estimated_delivery_date STRING,
    delivery_time FLOAT,
    estimated_delivery_day FLOAT,
    late_delivery BOOLEAN,

    FOREIGN KEY (customer_id)
        REFERENCES RAW.customer_raw(customer_id)
);

--order payments table
CREATE OR REPLACE TABLE RAW.order_payments_raw (
    order_id VARCHAR(255), 
    payment_sequential INTEGER, 
    payment_type VARCHAR(255),
    payment_installments INTEGER, 
    payment_value FLOAT,


    FOREIGN KEY (order_id)
        REFERENCES RAW.orders_raw(order_id)
);

--order reviews table 
CREATE OR REPLACE TABLE RAW.order_reviews_raw (
    review_id VARCHAR(255) PRIMARY KEY NOT NULL, 
    order_id VARCHAR(255), 
    review_score INTEGER,  
    review_creation_date DATE,
    review_answer_timestamp DATE,


    FOREIGN KEY (order_id)
        REFERENCES RAW.orders_raw(order_id)
);

--product table
CREATE OR REPLACE TABLE RAW.product_raw (
    product_id VARCHAR(255) PRIMARY KEY NOT NULL, 
    product_category_name VARCHAR(255), 
    product_name_lenght FLOAT,
    product_description_lenght FLOAT, 
    product_photos_qty FLOAT, 
    product_weight_g FLOAT,
    product_length_cm FLOAT, 
    product_height_cm FLOAT, 
    product_width_cm FLOAT
);

--sellers table
CREATE OR REPLACE TABLE RAW.sellers_raw (
    seller_id VARCHAR(255) PRIMARY KEY NOT NULL, 
    seller_zip_code_prefix INTEGER, 
    seller_city VARCHAR(255), 
    seller_state VARCHAR(255)
);


SELECT * FROM RAW.ORDERs_RAW;

use database ecommerce_db;
CREATE SCHEMA stage;

SET search_path TO stage;

CREATE TABLE stage.orders(
    order_id VARCHAR(255),
    customer_id VARCHAR(255),
    order_status VARCHAR(255),
    order_purchase_timestamp VARCHAR(255),
    order_approved_at VARCHAR(255),
    order_delivered_carrier_date VARCHAR(255),
    order_delivered_customer_date VARCHAR(255),
    order_estimated_delivery_date VARCHAR(255)
);

CREATE TABLE stage.products(
    product_id VARCHAR(255),
    product_category_name VARCHAR(255),
    product_name_lenght VARCHAR(255),
    product_description_lenght VARCHAR(255),
    product_photos_qty VARCHAR(255),
    product_weight_g VARCHAR(255),
    product_length_cm VARCHAR(255),
    product_height_cm VARCHAR(255),
    product_width_cm VARCHAR(255)
);

CREATE TABLE stage.order_itens(
    order_id VARCHAR(255),
    order_item_id VARCHAR(255),
    product_id VARCHAR(255),
    seller_id VARCHAR(255),
    shipping_limit_date VARCHAR(255),
    price VARCHAR(255),
    freight_value VARCHAR(255)
);

CREATE TABLE stage.customer(
    customer_id VARCHAR(255),
    customer_unique_id VARCHAR(255),
    customer_zip_code_prefix VARCHAR(255),
    customer_city VARCHAR(255),
    customer_state VARCHAR(255)
);

CREATE TABLE stage.payments(
    order_id VARCHAR(255),
    payment_sequential INT,
    payment_type VARCHAR(255),
    payment_installments VARCHAR(255),
    payment_value VARCHAR(255)
);

CREATE TABLE stage.review(
    review_id VARCHAR(255),
    order_id VARCHAR(255),
    review_score VARCHAR(255),
    review_comment_title VARCHAR(255),
    review_comment_message VARCHAR(255),
    review_creation_date VARCHAR(255),
    review_answer_timestamp VARCHAR(255)
);
    



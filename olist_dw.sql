CREATE SCHEMA dw;

SET search_path TO dw;

CREATE TABLE dw.dim_products (
    sk_produtos BIGINT,
    product_id VARCHAR(255),
    category_name VARCHAR(255),
);

CREATE TABLE dw.ft_orders(
    sk_order BIGINT,
    sk_client BIGINT,
    sk_product BIGINT,
    order_id VARCHAR(255),
    customer_id VARCHAR(255),
    product_id VARCHAR(255),
    order_item_id VARCHAR(255),
    review_id VARCHAR(255),
    order_approved_at DATE,
    order_status VARCHAR(100),
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),
    review INT
);

CREATE TABLE dw.dim_payments(
    sk_payment BIGINT,
    order_id VARCHAR(255),
    payment_sequential INT,
    payment_installments INT,
    payment_type VARCHAR(100),
    payment_value NUMERIC(12,2)
);

CREATE TABLE dw.dim_customers(
    sk_customer BIGINT,
    customer_id VARCHAR(255),
    customer_city VARCHAR(255),
    zip_code_prefix VARCHAR(9),
    customer_state VARCHAR(2),
    custuomer_unique_id VARCHAR(255)
);

create table public.ultima_atualizacao (
data timestamp not null
);
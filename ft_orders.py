import pandas as pd
import os
from engine_olist import enginedw
from  sqlalchemy import text


engine = enginedw()

def orders_itens_insert_stg():
    local = r'C:\Users\Lucas\Documents\Portifólio\Dados'
    arquivo = 'olist_order_items_dataset.csv'

    path = os.path.join(local,arquivo)

    df = pd.read_csv(path)

    df.to_sql(
        'order_itens',
        engine,
        schema='stage',
        if_exists='replace',
        index=False
    )
    print('Sucesso importação dos dados em stg')

def reviews_isert_stg():
    local = r'C:\Users\Lucas\Documents\Portifólio\Dados'
    arquivo = 'order_reviews.csv'

    path = os.path.join(local,arquivo)

    df = pd.read_csv(path)

    df.to_sql(
        'reviews',
        engine,
        schema='stage',
        if_exists='replace',
        index=False
    )
    print('Sucesso importação dos dados em stg')

def orders_insert_stg():
    local = r'C:\Users\Lucas\Documents\Portifólio\Dados'
    arquivo = 'olist_orders_dataset.csv'

    path = os.path.join(local,arquivo)

    df = pd.read_csv(path)

    df.to_sql(
        'orders',
        engine,
        schema='stage',
        if_exists='replace',
        index=False
    )
    print('Sucesso importação dos dados em stg')

def insert_dw():
    sql = '''SELECT 
        o.order_id,
        o.customer_id,
        o.order_status,
        o.order_purchase_timestamp::date,
        oi.order_item_id,
        oi.product_id,
        oi.price,
        oi.freight_value,
        r.review_score
        from stage.orders o
        join stage.reviews r on r.order_id = o.order_id
        join stage.order_itens oi on oi.order_id = o.order_id'''

    df_stg = pd.read_sql_query(sql, engine)

    df_stg['order_status'] = df_stg['order_status'].str.upper()

    customer = '''select customer_id, sk_customer from dw.dim_customers;'''
    df_customer = pd.read_sql_query(customer, engine)

    payments = '''select order_id as fk, sk_payment from dw.dim_payments;'''
    df_payments = pd.read_sql_query(payments, engine)

    products = '''select product_id, sk_products from dw.dim_products;'''
    df_products = pd.read_sql_query(products, engine)

    tempo = '''select sk_tempo, data from public.dim_tempo'''
    df_tempo = pd.read_sql_query(tempo, engine)

    join = df_stg.merge(
        df_tempo, how='left', left_on='order_purchase_timestamp',
        right_on='data').drop(columns=['data', 'order_purchase_timestamp'])

    join1 = join.merge(
        df_customer, how='left', left_on='customer_id',
        right_on='customer_id').drop(columns=['customer_id'])
    
    join2 = join1.merge(
        df_payments, how='left', left_on='order_id',
        right_on='fk').drop(columns=['fk'])
    
    join3 = join2.merge(
    df_products, how='left', left_on='product_id',
    right_on='product_id').drop(columns=['product_id'])

    join3.sort_values(by=['sk_tempo'])
    join3.reset_index()

    try:
        print()
        join3.to_sql('ft_orders',
                      engine,
                      schema='dw',
                      if_exists='replace',
                      index=True,
                      index_label='sk_order')
        
        with engine.connect() as conn:
            conn.execute(text('insert into public.ultima_atualizacao (data) values (now())'))
        print('Sucesso insert ft_orders')
    except:
        print('Erro atualização ft_orders')

def orders():
    orders_itens_insert_stg()
    reviews_isert_stg()
    orders_insert_stg()
    insert_dw()

if __name__ == '__main__':
    orders()
import pandas as pd
import os
from engine_olist import enginedw

engine = enginedw()

def insert_stg():
    local = r'C:\Users\Lucas\Documents\Portifólio\Dados'
    arquivo = 'olist_products_dataset.csv'

    path = os.path.join(local,arquivo)

    df = pd.read_csv(path)

    df.to_sql(
        'products',
        engine,
        schema='stage',
        if_exists='replace',
        index=False
    )
    print('Sucesso importação dos dados em stg')

def insert_dw():
    sql = '''SELECT product_id,product_category_name as category_name from stage.products'''

    df_stg = pd.read_sql_query(sql, engine)

    df_stg['category_name'] = df_stg['category_name'].str.replace('_', ' ').str.upper()

    try:
        print(df_stg)
        df_stg.to_sql('dim_products',
                      engine,
                      schema='dw',
                      if_exists='replace',
                      index=True,
                      index_label='sk_products')
        print('Sucesso insert dim_products')
    except:
        print('Erro atualização dim_products')

def products():
    insert_stg()
    insert_dw()

if __name__ == '__main__':
    products()
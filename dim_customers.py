import pandas as pd
import os
from engine_olist import enginedw

engine = enginedw()

def insert_stg():
    local = r'C:\Users\Lucas\Documents\Portifólio\Dados'
    arquivo = 'dim_olist_customers_dataset.csv'

    path = os.path.join(local,arquivo)

    df = pd.read_csv(path, dtype={'customer_zip_code_prefix': object})

    df.to_sql(
        'customers',
        engine,
        schema='stage',
        if_exists='replace',
        index=False
    )
    print('Sucesso importação dos dados em stg')

def insert_dw():
    sql = '''
SELECT  
	customer_id,
	customer_unique_id,
	customer_zip_code_prefix || '-000' as customer_zip_code_prefix,
	UPPER(customer_city) as customer_city,
	customer_state
FROM stage.customers
'''

    df_stg = pd.read_sql_query(sql, engine)

    try:
        print(df_stg)
        df_stg.to_sql('dim_customers',
                      engine,
                      schema='dw',
                      if_exists='replace',
                      index=True,
                      index_label='sk_customer')
        print('Sucesso insert dim_customers')
    except:
        print('Erro atualização dim_customers')

def customers():
    insert_stg()
    insert_dw()

customers()

# if __name__ == '__main__':
#     produtos()
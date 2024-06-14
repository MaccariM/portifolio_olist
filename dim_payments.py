import pandas as pd
import os
from engine_olist import enginedw

engine = enginedw()

def insert_stg():
    local = r'C:\Users\Lucas\Documents\Portifólio\Dados'
    arquivo = 'olist_order_payments_dataset.csv'

    path = os.path.join(local,arquivo)

    df = pd.read_csv(path)

    df.to_sql(
        'payments',
        engine,
        schema='stage',
        if_exists='replace',
        index=False
    )
    print('Sucesso importação dos dados em stg')

def insert_dw():
    sql = '''
SELECT 
    order_id,
    payment_sequential::INT,
    payment_installments::int,
    CASE 
        WHEN payment_type = 'credit_card' THEN 'CREDITO'
        WHEN payment_type = 'boleto' THEN 'BOLETO'
        WHEN payment_type = 'voucher' THEN 'VOUCHER'
        WHEN payment_type = 'debit_card' THEN 'DÉBITO'
        ELSE 'NÃO DEFINIDO'
    END AS payment_type,
    payment_value::Numeric
FROM stage.payments;

'''

    df_stg = pd.read_sql_query(sql, engine)

    try:
        print(df_stg)
        df_stg.to_sql('dim_payments',
                      engine,
                      schema='dw',
                      if_exists='replace',
                      index=True,
                      index_label='sk_payment')
        print('Sucesso insert dim_payments')
    except:
        print('Erro atualização dim_payments')

def payments():
    insert_stg()
    insert_dw()

if __name__ == '__main__':
    payments()
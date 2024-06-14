import sqlalchemy as db
import os

password = os.environ['localpassword']
ip = os.environ['localip']

def enginedw():
    enginedw = db.create_engine(
        str(f'postgresql://postgres:{password}@{ip}:5432/dw_olist'), isolation_level="AUTOCOMMIT")
    return enginedw

def token_feriado():
    tk = os.environ['TOKEN_API_FERIADOS']
    return tk


engine = enginedw()

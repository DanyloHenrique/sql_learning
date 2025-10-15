# %%

#Trocar as datas do Julian day para {data} na query


import pandas as pd

import sqlalchemy

#conexao com o banco
engine = sqlalchemy.create_engine("sqlite:///database.db")

#lendo a query do arquvio de texto
with open('aula_08/01_etl_projeto.sql') as open_file:
    query = open_file.read()

print(query)

# %%

dates = [
    '2025-01-01'
    '2025-02-01'
    '2025-03-01'
    '2025-04-01'
    '2025-05-01'
    '2025-06-01'
    '2025-07-01'
]

for i in dates:
    #Executa a query e traz dados para o python
    df = pd.read_sql(query.format(date=i), engine)
    
    #pegando os dados do python e manda para o banco na tabela tb_feature_store_cliente
    df.to_sql("tb_feature_store_cliente", engine, index=False, if_exists="append")

    
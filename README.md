Olá, esses scripts correspondem ao projeto do meu portifólio usando dados da Kaggle sobre ecomerces do Brasil entre 2016-2018

O link para downoload dos dados é https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce/data

Sinta-se a vonta de para copiar os códigos e fico a disposição caso precise de alguma ajuda!


0. Antes de começar, 
    1. Granta que tenha um Banco PostgreSQL instalado e configurado
        1.1. Se estiver usando um banco hospedado, será  necessário fazer ajustes do script 'engine_olist' para configurar a cadeia de conexão com o Banco
    2. Garanta que tenha uma chave de API para o serviço https://api.invertexto.com/
    3. Tenha todos os arquivos salvos em um local especificos, confirme  se não houveram alterações nos cabeçalhos das  colunas
    4. Instale o python e as bibliotecas adicionais
        4.1. Pandas
        4.2. SQL Alchemy
            4.2.1. Text 

1. Crie as variaveis de sistema
    1. Crie a variavel de sistema para armazenar a chave secreta de sua API
    2. Crie a variavel de sistema com a senha para acesso ao banco  

2. Execute os scripts SQL no seu SGBD para criar a estrutura do DW
    1. olist_stage
    2. olist_dw

3. Ajuste os caminhos o local de  armazenamento dos arquivos nos respectivos scripts
    1. dim_customers
    2. dim_payments
    3. dim_products
    4. ft_orders
        4.1 Atenção neste pois o arquivo faz importação de mais de um CSV

4. Exectue o arquivo engine_olist para criar as configurações

5. Execute o arquivo olist_atualizacao

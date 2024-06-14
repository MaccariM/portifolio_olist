CREATE TABLE DW.DIM_TEMPO( 
 
 SK_TEMPO INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 DATA date NOT NULL,
 ANO smallint NOT NULL,
 MES smallint NOT NULL,
 DIA smallint NOT NULL,
 DIA_SEMANA smallint NOT NULL,
 DIA_ANO smallint NOT NULL,
 ANO_BISSEXTO char(1) NOT NULL,
 DIA_UTIL char(1) NOT NULL,
 FIM_SEMANA char(1) NOT NULL,
 FERIADO char(1) NULL,
 PRE_FERIADO char(1) NULL,
 POS_FERIADO char(1) NULL,
 NOME_FERIADO varchar(30) NULL,
 TIPO_FERIADO varchar(11) NULL,
 NIVEL_FERIADO VARCHAR(8) NULL,
 NOME_DIA_SEMANA varchar(15) NOT NULL,
 NOME_DIA_SEMANA_ABREV char(3) NOT NULL,
 NOME_MES varchar(15) NOT NULL,
 NOME_MES_ABREV char(3) NOT NULL,
 QUINZENA smallint NOT NULL,
 BIMESTRE smallint NOT NULL,
 TRIMESTRE smallint NOT NULL,
 SEMESTRE smallint NOT NULL,
 NUM_SEMANA_MES smallint NOT NULL,
 NUM_SEMANA_ANO smallint NOT NULL,
 ESTACAO_ANO varchar(15) NOT NULL,
 DATA_POR_EXTENSO varchar(50) NOT NULL);

DO $$
DECLARE
    dataInicial DATE := '2023-01-01';
    dataFinal DATE := '2024-12-31';
    data DATE;
    ano SMALLINT;
    mes SMALLINT;
    dia SMALLINT;
    diaSemana SMALLINT;
    diaUtil CHAR(1);
    fimSemana CHAR(1);
    nomeDiaSemana VARCHAR(15);
    nomeDiaSemanaAbrev CHAR(3);
    nomeMes VARCHAR(15);
    nomeMesAbrev CHAR(3);
    bimestre SMALLINT;
    trimestre SMALLINT;
    NumSemanaMes SMALLINT;
    estacaoAno VARCHAR(15);
    dataPorExtenso VARCHAR(50);
BEGIN
    WHILE dataInicial <= dataFinal LOOP
        data := dataInicial;
        ano := EXTRACT(YEAR FROM data);
        mes := EXTRACT(MONTH FROM data);
        dia := EXTRACT(DAY FROM data);
        diaSemana := EXTRACT(DOW FROM data) + 1;

        fimSemana := CASE WHEN diaSemana IN (1, 7) THEN 'S' ELSE 'N' END;

        nomeMes := CASE mes
            WHEN 1 THEN 'janeiro'
            WHEN 2 THEN 'fevereiro'
            WHEN 3 THEN 'março'
            WHEN 4 THEN 'abril'
            WHEN 5 THEN 'maio'
            WHEN 6 THEN 'junho'
            WHEN 7 THEN 'julho'
            WHEN 8 THEN 'agosto'
            WHEN 9 THEN 'setembro'
            WHEN 10 THEN 'outubro'
            WHEN 11 THEN 'novembro'
            WHEN 12 THEN 'dezembro'
        END;

        nomeMesAbrev := CASE mes
            WHEN 1 THEN 'jan'
            WHEN 2 THEN 'fev'
            WHEN 3 THEN 'mar'
            WHEN 4 THEN 'abr'
            WHEN 5 THEN 'mai'
            WHEN 6 THEN 'jun'
            WHEN 7 THEN 'jul'
            WHEN 8 THEN 'ago'
            WHEN 9 THEN 'set'
            WHEN 10 THEN 'out'
            WHEN 11 THEN 'nov'
            WHEN 12 THEN 'dez'
        END;

        diaUtil := CASE WHEN fimSemana = 'S' THEN 'N' ELSE 'S' END;

        nomeDiaSemana := CASE diaSemana
            WHEN 1 THEN 'domingo'
            WHEN 2 THEN 'segunda-feira'
            WHEN 3 THEN 'terça-feira'
            WHEN 4 THEN 'quarta-feira'
            WHEN 5 THEN 'quinta-feira'
            WHEN 6 THEN 'sexta-feira'
            ELSE 'sábado'
        END;

        nomeDiaSemanaAbrev := CASE diaSemana
            WHEN 1 THEN 'dom'
            WHEN 2 THEN 'seg'
            WHEN 3 THEN 'ter'
            WHEN 4 THEN 'qua'
            WHEN 5 THEN 'qui'
            WHEN 6 THEN 'sex'
            ELSE 'sáb'
        END;

        bimestre := CASE
            WHEN mes IN (1, 2) THEN 1
            WHEN mes IN (3, 4) THEN 2
            WHEN mes IN (5, 6) THEN 3
            WHEN mes IN (7, 8) THEN 4
            WHEN mes IN (9, 10) THEN 5
            ELSE 6
        END;

        trimestre := CASE
            WHEN mes IN (1, 2, 3) THEN 1
            WHEN mes IN (4, 5, 6) THEN 2
            WHEN mes IN (7, 8, 9) THEN 3
            ELSE 4
        END;

        NumSemanaMes := CASE
            WHEN dia < 8 THEN 1
            WHEN dia < 15 THEN 2
            WHEN dia < 22 THEN 3
            WHEN dia < 29 THEN 4
            ELSE 5
        END;

        estacaoAno := CASE
            WHEN data BETWEEN (DATE '2023-09-23' + (ano - 2023) * INTERVAL '1 year') AND (DATE '2023-12-21' + (ano - 2023) * INTERVAL '1 year') THEN 'primavera'
            WHEN data BETWEEN (DATE '2023-03-21' + (ano - 2023) * INTERVAL '1 year') AND (DATE '2023-06-20' + (ano - 2023) * INTERVAL '1 year') THEN 'outono'
            WHEN data BETWEEN (DATE '2023-06-21' + (ano - 2023) * INTERVAL '1 year') AND (DATE '2023-09-22' + (ano - 2023) * INTERVAL '1 year') THEN 'inverno'
            ELSE 'verão'
        END;

        dataPorExtenso := LOWER(nomeDiaSemana || ', ' || dia || ' de ' || nomeMes || ' de ' || ano);

        INSERT INTO DW.DIM_TEMPO (
            DATA, ANO, MES, DIA, DIA_SEMANA, DIA_ANO, ANO_BISSEXTO, DIA_UTIL, FIM_SEMANA, NOME_DIA_SEMANA, 
            NOME_DIA_SEMANA_ABREV, NOME_MES, NOME_MES_ABREV, QUINZENA, BIMESTRE, TRIMESTRE, SEMESTRE, NUM_SEMANA_MES, 
            NUM_SEMANA_ANO, ESTACAO_ANO, DATA_POR_EXTENSO
        ) VALUES (
            data, ano, mes, dia, diaSemana, EXTRACT(DOY FROM data), CASE WHEN MOD(ano, 4) = 0 THEN 'S' ELSE 'N' END, 
            diaUtil, fimSemana, nomeDiaSemana, nomeDiaSemanaAbrev, nomeMes, nomeMesAbrev, 
            CASE WHEN dia < 16 THEN 1 ELSE 2 END, bimestre, trimestre, 
            CASE WHEN mes < 7 THEN 1 ELSE 2 END, NumSemanaMes, EXTRACT(WEEK FROM data), estacaoAno, dataPorExtenso
        );

        dataInicial := dataInicial + INTERVAL '1 day';
    END LOOP;
END $$;

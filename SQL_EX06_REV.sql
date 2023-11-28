USE master
DROP DATABASE EXERC06
CREATE DATABASE EXERC06
USE EXERC06
GO

CREATE TABLE MOTORISTA (
codigo						INT					NOT NULL,
nome						VARCHAR(100)		NOT NULL,
data_nasc					DATE				NOT NULL,
naturalidade				VARCHAR(100)		NOT NULL
PRIMARY KEY (codigo)
)
GO

CREATE TABLE ONIBUS (
placa						CHAR(8)				NOT NULL,
marca						VARCHAR(100)		NOT NULL,
ano							INT					NOT NULL,
descricao					VARCHAR(100)		NOT NULL
PRIMARY KEY (placa)
)
GO

CREATE TABLE VIAGEM (
codigo						INT					NOT NULL,
onibus_placa				CHAR(8)				NOT NULL,
motorista_codigo			INT					NOT NULL,
hora_saida					CHAR(3)				NOT NULL,
hora_Chegada				CHAR(3)				NOT NULL,
destino						VARCHAR(100)		NOT NULL
PRIMARY KEY (codigo),
FOREIGN KEY (onibus_placa) REFERENCES ONIBUS (placa),
FOREIGN KEY (motorista_codigo) REFERENCES MOTORISTA (codigo)
)
GO

INSERT INTO MOTORISTA ( codigo,	nome,	data_nasc,	naturalidade)
VALUES
('12341',	'Julio Cesar',	'1978-04-18',	'São Paulo'),
('12342',	'Mario Carmo',	'2002-07-29',	'Americana'),
('12343',	'Lucio Castro',	'1969-12-01',	'Campinas'),
('12344',	'André Figueiredo',	'1999-05-14',	'São Paulo'),
('12345',	'Luiz Carlos',	'2001-01-09',	'São Paulo')
GO

INSERT INTO ONIBUS (placa,	marca,	ano,	descricao)
VALUES
('adf0965',  	'Mercedes' ,           	'1999',	'Leito'),               
('bhg7654' , 	'Mercedes' ,           	'2002',	'Sem Banheiro'),        
('dtr2093' ,  	'Mercedes' ,           	'2001',	'Ar Condicionado'),     
('gui7625' , 	'Volvo',              	'2001',	'Ar Condicionado') 
GO

INSERT INTO VIAGEM (codigo, onibus_placa, motorista_codigo, hora_saida, hora_Chegada, destino)
VALUES
('101',	'adf0965',  	'12343',	'10h',	'12h',	'Campinas'),
('102',	'gui7625',   	'12341',	'7h',	'12h',	'Araraquara'),
('103',	'bhg7654',   	'12345',	'14h',	'22h',	'Rio de Janeiro'),
('104',	'dtr2093',   	'12344',	'18h',	'21h',	'Sorocaba')
GO

-- Consultar, da tabela viagem, todas as horas de chegada e saída, convertidas em formato HH:mm (108) e seus destinos
SELECT CONVERT (VARCHAR(5), hora_Chegada, 108) as Hora_Chegada, CONVERT (VARCHAR(5), hora_saida, 108) as Hora_Saida
FROM VIAGEM

-- Consultar, com subquery, o nome do motorista que viaja para Sorocaba
SELECT nome
FROM motorista
WHERE codigo IN (
    SELECT motorista_codigo
    FROM viagem
    WHERE destino = 'Sorocaba'
)

-- Consultar, com subquery, a descrição do ônibus que vai para o Rio de Janeiro
SELECT descricao
FROM ONIBUS
WHERE placa IN (
	SELECT onibus_placa
	FROM VIAGEM
	WHERE destino = 'Rio de Janeiro'
	)

-- Consultar, com Subquery, a descrição, a marca e o ano do ônibus dirigido por Luiz Carlos
SELECT descricao, marca, ano
FROM ONIBUS
WHERE placa IN (
	SELECT onibus_placa
	FROM VIAGEM
	WHERE motorista_codigo IN (
		SELECT codigo
		FROM MOTORISTA
		WHERE nome = 'Luiz Carlos'
		)
	)

--Consultar o nome, a idade e a naturalidade dos motoristas com mais de 30 anos
SELECT nome, DATEDIFF(YEAR, data_nasc, GETDATE()) AS Idade, naturalidade
FROM MOTORISTA
WHERE DATEDIFF(YEAR, data_nasc, GETDATE()) > 30



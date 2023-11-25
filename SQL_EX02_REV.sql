USE master
DROP DATABASE EXERC02
CREATE DATABASE EXERC02
USE EXERC02
GO

CREATE TABLE CARRO (
placa					CHAR(8)				NOT NULL,
marca					VARCHAR(20)			NOT NULL,
modelo					VARCHAR(20)			NOT NULL,
cor						VARCHAR(20)			NOT NULL,
ano						INT					NOT NULL,
PRIMARY KEY ( placa )
)
GO

CREATE TABLE PECAS (
codigo					INT					NOT NULL,
nome					VARCHAR(20)			NOT NULL,
valor					INT					NOT NULL,
PRIMARY KEY (codigo)
)
GO

CREATE TABLE CLIENTE (
nome					VARCHAR(100)		NOT NULL,
logradouro_end			VARCHAR(100)		NOT NULL,
numero_end				INT					NOT NULL,
bairro_end				VARCHAR(100)		NOT NULL,
telefone				CHAR(9)				NOT NULL,
carro_placa				CHAR(8)				NOT NULL,
FOREIGN KEY (carro_placa)REFERENCES	CARRO (placa),
PRIMARY KEY (carro_placa)
)
GO

CREATE TABLE SERVIÇO (
carro_placa				CHAR(8)				NOT NULL,
peca_codigo				INT					NOT NULL,
quantidade				INT					NOT NULL,
valor					INT					NOT NULL,
datinha					DATE				NOT NULL,
FOREIGN KEY (carro_placa) REFERENCES CARRO (placa),
FOREIGN KEY (peca_codigo) REFERENCES PECAS (codigo),
PRIMARY KEY (carro_placa, peca_codigo, datinha)
)
GO

--*********************************************************--
---Insert Carro

INSERT INTO CARRO (placa, marca, modelo, cor, ano)
VALUES
('AFT9087',	'VW',	'Gol',	'Preto',	'2007'),
('DXO9876',	'Ford',	'Ka',	'Azul',	'2000'),
('EGT4631',	'Renault',	'Clio',	'Verde',	'2004'),
('LKM7380',	'Fiat',	'Palio',	'Prata',	'1997'),
('BCD7521',	'Ford',	'Fiesta',	'Preto',	'1999')
GO

--*********************************************************--
---Insert Cliente

INSERT INTO CLIENTE (nome, logradouro_end, numero_end, bairro_end, telefone,carro_placa)
VALUES
('João Alves',	'R. Pereira Barreto',	'1258',	'Jd. Oliveiras',	'2154-9658',	'DXO9876'),
('Ana Maria',	'R. 7 de Setembro',	'259',	'Centro',	'9658-8541',	'LKM7380'),
('Clara Oliveira',	'Av. Nações Unidas',	'10254',	'Pinheiros',	'2458-9658',	'EGT4631'),
('José Simões',	'R. XV de Novembro',	'36',	'Água Branca',	'7895-2459',	'BCD7521'),
('Paula Rocha',	'R. Anhaia',	'548',	'Barra Funda',	'6958-2548',	'AFT9087')
GO

--*********************************************************--
---Insert Peças

INSERT INTO PECAS (codigo, nome, valor)
VALUES
('1',	'Vela',	'70'),
('2',	'Correia Dentada',	'125'),
('3', 'Trambulador',	'90'),
('4',	'Filtro de Ar',	'30')
GO

--*********************************************************--
---Insert Servicos

INSERT INTO SERVIÇO (carro_placa, peca_codigo, quantidade, valor, datinha)
VALUES
('DXO9876',	'1',	'4',	'280',	'2020-08-01'),
('DXO9876',	'4',	'1',	'30',	'2020-08-01'),
('EGT4631',	'3',	'1',	'90',	'2020-08-02'),
('DXO9876',	'2',	'1',	'125',	'2020-08-07')
GO

--Consultar em Subqueries
--Telefone do dono do carro Ka, Azul
SELECT c.telefone
FROM CLIENTE c
join CARRO car on car.placa = c.carro_placa
WHERE car.modelo = 'Ka' and car.cor = 'Azul'

--Endereço concatenado do cliente que fez o serviço do dia 2020-08-02
SELECT CONCAT (c.logradouro_end,  ' ' ,c.numero_end, ' ' ,c.bairro_end) AS Endereco
FROM CLIENTE c
join SERVIÇO s on s.carro_placa	= c.carro_placa
WHERE s.datinha = '2020-08-02'

--Consultar:
--Placas dos carros de anos anteriores a 2001
SELECT car.placa
FROM  CARRO car
WHERE car.ano < '2001'

--Marca, modelo e cor, concatenado dos carros posteriores a 2005
SELECT CONCAT (car.marca, ' ' ,car.modelo, ' ' ,car.cor) AS descricao
FROM CARRO car
WHERE car.ano > '2005'

--Código e nome das peças que custam menos de R$80,00
SELECT p.nome, p.codigo
FROM PECAS p
WHERE p.valor < '80'





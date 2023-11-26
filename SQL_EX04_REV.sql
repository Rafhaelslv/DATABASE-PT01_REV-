use master
drop database EXERC04
create database EXERC04
use EXERC04
GO

CREATE TABLE CLIENTE (
cpf				char(12)			NOT NULL,
nome			varchar(255)		NOT NULL,
telefone		char(8)				NOT NULL, 
primary key (cpf)
)
GO

CREATE TABLE FORNECEDOR (
id				int					NOT NULL,
nome			varchar(100)		NOT NULL,
logradouro		varchar(100)		NOT NULL,
numero			char(5)				NOT NULL,
complemento		varchar(255)		NOT NULL,
cidade			varchar(255)		NOT NULL,
primary key(id)
)
GO

CREATE TABLE PRODUTO (
codigo			int					NOT NULL,
descricao		varchar(100)		NOT NULL,
fornecedor_id	int					NOT NULL,
preco			decimal(7,2)		NOT NULL,
primary key(codigo),
foreign key(fornecedor_id) references FORNECEDOR (id)
)
GO

CREATE TABLE venda (
codigo			int					NOT NULL,
produto_codigo	int			NOT NULL,
cliente_cpf		char(12)	NOT NULL,
quantidade		int 				NOT NULL,
valor_total		decimal(9,2)		NOT NULL,
datinha			date				NOT NULL,
primary key(codigo, produto_codigo, cliente_cpf),
foreign key (produto_codigo) references PRODUTO (codigo),
foreign key(cliente_cpf) references CLIENTE (cpf)
)
GO

insert into CLIENTE(cpf, nome, telefone)
values
('345789092-90', 'Julio Cesar', '82736541'),
('251865337-10', 'Maria Antonia', '87652314'),
('876273154-16', 'Luiz Carlos', '61289012'),
('791826398-00', 'Paulo Cesar', '90765273')
GO

insert into FORNECEDOR (id, nome, logradouro,numero,complemento,cidade)
values 
('1',	'LG',	'Rod. Bandeirantes',	'70000',	'Km 70',	'Itapeva'),
('2',	'Asus',	'Av. Nações Unidas',	'10206',	'Sala 225',	'São Paulo'),
('3',	'AMD',	'Av. Nações Unidas',	'10206',	'Sala 1095',	'São Paulo'),
('4',	'Leadership',	'Av. Nações Unidas',	'10206',	'Sala 87',	'São Paulo'),
('5',	'Inno',	'Av. Nações Unidas',	'10206',	'Sala 34',	'São Paulo')
GO

insert into PRODUTO (codigo,descricao, fornecedor_id, preco)
values
('1', 'Monitor 19 pol.',						'1', '449.99'),
('2','Netbook 1GB Ram 4 Gb HD',				'2', '699.99'),
('3','Gravador de DVD - Sata',				'1', '99.99'),
('4','Leitor de CD',						'1','449.99'),
('5','Processador - Phenom X3 - 2.1GHz',	'3','349.99'),
('6','Mouse',								'4','19.99'),
('7','Teclado',								'4','25.99'),
('8','Placa de Video - Nvidia 9800 GTX - 256MB/256 bits','5','599.99')
GO


insert into VENDA (codigo, produto_codigo, cliente_cpf, quantidade, valor_total, datinha)
values
('1',	'1',	'251865337-10',	'1',	'449.99',	'03/09/2009'),
('1',	'4',	'251865337-10',	'1',	'49.99',	'03/09/2009'),
('1',	'5',	'251865337-10',	'1',	'349.99',	'03/09/2009'),
('2',	'6',	'791826398-00',	'4',	'79.96',	'06/09/2009'),
('3',	'8',    '876273154-16',	'1',	'599.99',	'06/09/2009'),
('3',	'3',	'876273154-16',	'1',	'99.99',	'06/09/2009'),
('3',	'7',	'876273154-16',	'1',	'25.99',	'06/09/2009'),
('4',	'2',	'345789092-90',	'2',	'1399.98',	'08/09/2009')
go
--Consultar no formato dd/mm/aaaa:
--Data da Venda 4
SELECT Convert (varchar, vend.datinha, 103)
from VENDA vend 
where vend.codigo= 4;


--Inserir na tabela Fornecedor, a coluna Telefone
--e os seguintes dados:
	--1	7216-5371
	--2	8715-3738
	--4	3654-6289

ALTER TABLE fornecedor 
ADD telefone CHAR(13)

UPDATE FORNECEDOR 
SET telefone = '72165371'
WHERE id = 1

UPDATE  FORNECEDOR 
SET telefone = '87153738'
WHERE id = 2

UPDATE FORNECEDOR  
SET telefone = '36546289'
WHERE id = 4

--Consultar por ordem alfabética de nome, o nome, o enderço concatenado e o telefone dos fornecedores
SELECT nome, CONCAT ( logradouro, ' ' ,numero, ' ' ,complemento, ' ' ,cidade) AS EndCompleto, telefone
FROM FORNECEDOR
ORDER BY nome

--Consultar:
--Produto, quantidade e valor total do comprado por Julio Cesar
SELECT pro.descricao, vd.quantidade, vd.valor_total	
FROM PRODUTO pro
INNER JOIN venda vd on pro.codigo = vd.produto_codigo
INNER JOIN CLIENTE c on c.cpf = vd.cliente_cpf
WHERE c.nome = 'Julio Cesar'

--Data, no formato dd/mm/aaaa e valor total do produto comprado por  Paulo Cesar
SELECT Convert (varchar, vd.datinha, 103) as data, vd.valor_total
FROM venda vd
INNER JOIN CLIENTE c on c.cpf = vd.cliente_cpf
WHERE c.nome = 'Paulo Cesar'

--Consultar, em ordem decrescente, o nome e o preço de todos os produtos 
SELECT descricao, preco
FROM PRODUTO
ORDER BY descricao DESC

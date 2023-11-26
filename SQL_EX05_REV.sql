USE master
DROP DATABASE EXERC05
CREATE DATABASE EXERC05
USE EXERC05
GO

CREATE TABLE FORNECEDORES (
codigo					INT						NOT NULL,
nome					VARCHAR(100)			NOT NULL,
atividade				VARCHAR(100)			NOT NULL,
telefone				CHAR(8)					NOT NULL
PRIMARY KEY (codigo)
)
GO

CREATE TABLE CLIENTE (
codigo					INT						NOT NULL,
nome					VARCHAR(100)			NOT NULL,
logradouro_end			VARCHAR(100)			NOT NULL,
numero_end				INT						NOT NULL,
telefone				CHAR(8)					NOT NULL,
data_nasc				DATE					NOT NULL
PRIMARY KEY (codigo)
)
GO

CREATE TABLE PRODUTO (
codigo					INT						NOT NULL,
nome					VARCHAR(100)			NOT NULL,
valor_unitario			DECIMAL(7,2)			NOT NULL,
quantidae_estoque		INT						NOT NULL,
descricao				VARCHAR(100)			NOT NULL,
codigo_fornecedor		INT						NOT NULL
PRIMARY KEY (codigo),
FOREIGN KEY (codigo_fornecedor) REFERENCES FORNECEDORES (codigo)
)
GO

CREATE TABLE PEDIDO (
codigo					INT						NOT NULL,
codigo_cliente			INT						NOT NULL,
codigo_produto			INT						NOT NULL,
quantidade				INT						NOT NULL,
previsão_entrega		DATE					NOT NULL
PRIMARY KEY (codigo, codigo_cliente, codigo_produto),
FOREIGN KEY (codigo_cliente) REFERENCES CLIENTE (codigo),
FOREIGN KEY (codigo_produto) REFERENCES PRODUTO (codigo)
)
GO

--*********************************************************--
---Insert Fornecedores
INSERT INTO FORNECEDORES (codigo,	nome,	atividade,	telefone)
VALUES
('1001',	'Estrela',	'Brinquedo',	'41525898'),
('1002','Lacta',	'Chocolate',	'42698596'),
('1003', 'Asus',	'Informática',	'52014596'),
('1004',	'Tramontina',	'Utensílios Domésticos',	'50563985'),
('1005',	'Grow',	'Brinquedos',	'47896325'),
('1006', 'Mattel',	'Bonecos',	'59865898')
GO

--*********************************************************--
---Insert Cliente
INSERT INTO CLIENTE (codigo, nome,	logradouro_end,	numero_end,	telefone, data_nasc)
VALUES
('33601',	'Maria Clara',	'R. 1° de Abril',	'870',	'96325874',	'2000-08-15'),
('33602',	'Alberto Souza', 'R. XV de Novembro',	'987',	'95873625',	'1985-02-02'),
('33603',	'Sonia Silva',	'R. Voluntários da Pátria',	'1151',	'75418596',	'1957-08-23'),
('33604',	'José Sobrinho',	'Av. Paulista',	'250',	'85236547',	'1986-12-09'),
('33605', 'Carlos Camargo',	'Av. Tiquatira',	'9652',	'75896325',	'1971-03-25')
GO

--*********************************************************--
---Insert Produto
INSERT INTO PRODUTO (codigo,	nome,	valor_unitario,	quantidae_estoque, descricao, codigo_fornecedor )
VALUES
('1',	'Banco Imobiliário',	'65.00',	'15',	'Versão Super Luxo',	'1001'),
('2',	'Puzzle 5000 peças', '50.00',	'5',	'Mapas Mundo',	'1005'),
('3',	'Faqueiro',	'350.00',	'0',	'120 peças',	'1004'),
('4',	'Jogo para churrasco',	'75.00',	'3',	'7 peças',	'1004'),
('5',	'Tablet',	'750.00',	'29',	'Tablet',	'1003'),
('6',	'Detetive',	'49.00',	'0',	'Nova Versão do Jogo',	'1001'),
('7',	'Chocolate com Paçoquinha',	'6.00',	'0',	'Barra',	'1002'),
('8',	'Galak',	'5.00',	'65',	'Barra',	'1002')
GO



--*********************************************************--
---Insert Pedido
INSERT INTO PEDIDO (codigo,	codigo_cliente,	codigo_produto,	quantidade,	previsão_entrega)
VALUES
('99001',	'33601',	'1',	'1',	'2012-06-07'),
('99001',	'33601',	'2',	'1',	'2012-06-07'),
('99001',	'33601',	'8',	'3',	'2012-06-07'),
('99002'	,'33602',	'2',	'1',	'2012-06-09'),
('99002',	'33602',	'4',	'3',	'2012-06-09'),
('99003'	,'33605',	'5',	'1'	,'2012-06-15')
GO

--Consultar a quantidade, valor total e valor total com desconto (25%) dos itens comprados par Maria Clara.
SELECT (ped.quantidade * pro.valor_unitario) AS Valor_Total, (ped.quantidade * pro.valor_unitario) * 0.75 AS Valor_Desconto 
FROM PEDIDO ped
INNER JOIN CLIENTE c on c.codigo = ped.codigo_cliente
INNER JOIN PRODUTO pro on pro.codigo = ped.codigo_produto
WHERE c.nome = 'Maria Clara'

--Verificar quais brinquedos não tem itens em estoque.
SELECT pro.nome
FROM PRODUTO pro
INNER JOIN FORNECEDORES f on f.codigo = pro.codigo_fornecedor
WHERE pro.quantidae_estoque = 0 AND f.atividade LIKE '%Brinquedo%'

--Alterar para reduzir em 10% o valor das barras de chocolate.
UPDATE PRODUTO 
SET valor_unitario = valor_unitario * 0.9
WHERE descricao LIKE 'Barra'

--Alterar a quantidade em estoque do faqueiro para 10 peças.
UPDATE PRODUTO 
SET quantidae_estoque = 10
WHERE nome LIKE 'Faqueiro'

--Consultar quantos clientes tem mais de 40 anos.
SELECT COUNT(*) AS total_clientes_mais_de_40
FROM CLIENTE
WHERE DATEDIFF(YEAR, data_nasc, GETDATE()) > 40 

--Consultar Nome e telefone dos fornecedores de Brinquedos e Chocolate.
SELECT f.nome, f.telefone
FROM FORNECEDORES f
WHERE f.atividade LIKE '%Brinquedo%' OR f.atividade LIKE '%Chocolate%'

--Consultar nome e desconto de 25% no preço dos produtos que custam menos de R$50,00
SELECT pro.nome, (pro.valor_unitario * 0.75) AS Valor_Com_Desconto
FROM PRODUTO pro
WHERE pro.valor_unitario < 50.00

--Consultar nome e aumento de 10% no preço dos produtos que custam mais de R$100,00
SELECT pro.nome, CONCAT ('R$ ',(pro.valor_unitario * 1.10)) AS Valor_Com_Desconto
FROM PRODUTO pro
WHERE pro.valor_unitario > 100.00

--Consultar desconto de 15% no valor total de cada produto da venda 99001.
SELECT pro.nome, pro.valor_unitario, (pro.valor_unitario * 0.85) AS Valor_Com_Desconto
FROM PRODUTO pro
INNER JOIN PEDIDO ped on ped.codigo_produto = pro.codigo
WHERE ped.codigo = '99001'

--Consultar Código do pedido, nome do cliente e idade atual do cliente
SELECT ped.codigo, c.nome, DATEDIFF(YEAR, c.data_nasc, GETDATE()) AS Idade
FROM CLIENTE c
INNER JOIN PEDIDO ped on ped.codigo_cliente = c.codigo




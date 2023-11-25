USE master
DROP DATABASE EXERC03
CREATE DATABASE EXERC03
USE EXERC03
GO

CREATE TABLE PACIENTES (
cpf						CHAR(11)				NOT NULL,
nome					VARCHAR(100)			NOT NULL,
rua_end					VARCHAR(100)			NOT NULL,
numero_end				INT						NOT NULL,
bairro_end				VARCHAR(100)			NOT NULL,
telefone				CHAR(10)				NULL,
data_nasc				DATE					NOT NULL
PRIMARY KEY (cpf)
)
GO

CREATE TABLE MEDICO (
codigo					INT						NOT NULL,
nome					VARCHAR(100)			NOT NULL,
especialidade			VARCHAR(100)			NOT NULL
PRIMARY KEY (codigo)
)
GO

CREATE TABLE PRONTUARIO (
datinha					DATE					NOT NULL,
cpf_paciente			CHAR(11)				NOT NULL,
codigo_medico			INT						NOT NULL,
diagnostico				VARCHAR(100)			NOT NULL,
medicamento				VARCHAR(100)			NOT NULL
FOREIGN KEY (cpf_paciente) REFERENCES PACIENTES (cpf),
FOREIGN KEY (codigo_medico) REFERENCES MEDICO (codigo),
PRIMARY KEY (datinha, cpf_paciente, codigo_medico)
)
GO

--*********************************************************--
---Insert Pacientes

INSERT INTO PACIENTES (cpf, nome, rua_end, numero_end, bairro_end, telefone, data_nasc)
VALUES
('35454562890',	'Jos� Rubens',	'Campos Salles',	'2750',	'Centro',	'21450998',	'1954-10-18'),
('29865439810',	'Ana Claudia',	'Sete de Setembro',	'178',	'Centro',	'97382764',	'1960-05-29'),
('82176534800',	'Marcos Aur�lio',	'Tim�teo Penteado',	'236',	'Vila Galv�o',	'68172651',	'1980-09-24'),
('12386758770',	'Maria Rita',	'Castello Branco',	'7765',	'Vila Ros�lia', 'NULL',	'1975-03-30'),
('92173458910',	'Joana de Souza',	'XV de Novembro',	'298',	'Centro',	'21276578',	'1944-04-24')
GO
--*********************************************************--
---Insert Medico

INSERT INTO MEDICO (codigo, nome, especialidade)
VALUES
('1',	'Wilson Cesar',	'Pediatra'),
('2',	'Marcia Matos',	'Geriatra'),
('3',	'Carolina Oliveira',	'Ortopedista'),
('4',	'Vinicius Araujo',	'Cl�nico Geral')
GO
--*********************************************************--
---Insert Protuario
INSERT INTO PRONTUARIO (datinha, cpf_paciente, codigo_medico, diagnostico, medicamento)
VALUES
('2020-09-10',	'35454562890',	'2',	'Reumatismo',	'Celebra'),
('2020-09-10',	'92173458910',	'2', 'Renite Al�rgica',	'Allegra'),
('2020-09-12',	'29865439810',	'1',	'Inflama��o de garganta',	'Nimesulida'),
('2020-09-13',	'35454562890',	'2',	'H1N1',	'Tamiflu'),
('2020-09-15',	'82176534800',	'4',	'Gripe',	'Resprin'),
('2020-09-15',	'12386758770',	'3',	'Bra�o Quebrado',	'Dorflex + Gesso')
GO
--Consultar:
--Nome e Endere�o (concatenado) dos pacientes com mais de 50 anos
SELECT CONCAT (p.nome, ' ' ,p.rua_end, ' ' ,p.numero_end, ' ', bairro_end) AS DadosPaciente
FROM PACIENTES p
WHERE DATEDIFF(YEAR, p.data_nasc, GETDATE()) > 50

--Qual a especialidade de Carolina Oliveira
SELECT m.especialidade
FROM MEDICO m
WHERE m.nome = 'Carolina Oliveira'

--Qual medicamento receitado para reumatismo
SELECT p.medicamento
FROM PRONTUARIO p
WHERE p.diagnostico = 'reumatismo'

--Consultar em subqueries:
--Diagn�stico e Medicamento do paciente Jos� Rubens em suas consultas
SELECT p.diagnostico, p.medicamento
FROM PRONTUARIO p
join PACIENTES pac on pac.cpf = p.cpf_paciente
WHERE pac.nome = 'Jos� Rubens'

--Nome e especialidade do(s) M�dico(s) que atenderam Jos� Rubens. Caso a especialidade tenha mais de 3 letras, mostrar apenas as 3 primeiras letras concatenada com um ponto final (.)
SELECT m.nome, CASE
        WHEN LEN(m.especialidade) <= 3 THEN especialidade
        ELSE LEFT(m.especialidade, 3) + '.'
    END AS especialidade_abreviada
FROM MEDICO m	inner join PRONTUARIO p 
on m.codigo =   p.codigo_medico
inner join PACIENTES pac
on pac.cpf = p.cpf_paciente
WHERE pac.nome = 'Jos� Rubens'

--CPF (Com a m�scara XXX.XXX.XXX-XX), Nome, Endere�o completo (Rua, n� - Bairro), Telefone (Caso nulo, mostrar um tra�o (-)) dos pacientes do m�dico Vinicius
SELECT p.nome, SUBSTRING (p.cpf,1,3) + '.' + SUBSTRING(p.cpf,4,3) + '.' + SUBSTRING(p.cpf,7,3) + '.' + SUBSTRING(p.cpf,10,2) AS cpf,
CONCAT(p.rua_end, p.numero_end, p.bairro_end) AS EnderecoCompleto,
CASE
      WHEN LEN(p.telefone) IS NULL THEN  '(-)'
        ELSE p.telefone
    END AS telefone
FROM MEDICO m	inner join PRONTUARIO pro 
on m.codigo =   pro.codigo_medico
inner join PACIENTES p
on p.cpf = pro.cpf_paciente
WHERE m.nome like '%Vinicius%'

--Quantos dias fazem da consulta de Maria Rita at� hoje
SELECT	DATEDIFF(DAY, pro.datinha, GETDATE()) AS Dias
FROM PRONTUARIO pro
join PACIENTES p on p.cpf = pro.cpf_paciente
WHERE  p.nome = 'Maria Rita' 

--Alterar o telefone da paciente Maria Rita, para 98345621
UPDATE PACIENTES
SET telefone = '98345621'
WHERE nome LIKE 'Maria Rita'

--Alterar o Endere�o de Joana de Souza para Volunt�rios da P�tria, 1980, Jd. Aeroporto
UPDATE PACIENTES
SET rua_end = 'Volunt�rios da P�tria', numero_end = '1980', bairro_end = 'Jd. Aeroporto'
WHERE nome LIKE 'Joana de Souza'

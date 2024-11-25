DROP DATABASE IF EXISTS TreeTechnology;
CREATE DATABASE IF NOT EXISTS TreeTechnology;
USE TreeTechnology;

CREATE TABLE IF NOT EXISTS empresa (
id 			 	INT AUTO_INCREMENT,
razao_social 	VARCHAR(100) NOT NULL UNIQUE,
nome_fantasia 	VARCHAR(45) NOT NULL,
cnpj 			VARCHAR(18) NOT NULL UNIQUE,
cep 			VARCHAR(8) NOT NULL,

PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS usuario (
id 					INT AUTO_INCREMENT,
nome 				VARCHAR(45) NOT NULL,
cpf 				CHAR(11) NOT NULL UNIQUE,
email 				VARCHAR(45) NOT NULL UNIQUE,
senha 				VARCHAR(16) NOT NULL,
data_nascimento		DATE NOT NULL,
permissao 			CHAR(7) NOT NULL,
status 				CHAR(10) NOT NULL,
data_contratacao 	DATE NOT NULL,
fkEmpresa 			INT NOT NULL,

PRIMARY KEY (id),
FOREIGN KEY (fkEmpresa) REFERENCES empresa (id),
CONSTRAINT CHECK (permissao IN ('Total', 'Leitura')),
CONSTRAINT CHECK (status IN ('Ativado', 'Desativado'))
);

CREATE TABLE IF NOT EXISTS recomendacao (
id 			INT AUTO_INCREMENT,
descricao 	TEXT NOT NULL,
data_hora 	DATETIME NOT NULL,
fkEmpresa 	INT NOT NULL,

PRIMARY KEY (id),
FOREIGN KEY (fkEmpresa) REFERENCES empresa (id)
);

CREATE TABLE IF NOT EXISTS prompt_entrada (
id 			INT AUTO_INCREMENT,
pergunta 	TEXT NOT NULL,
data_hora 	DATETIME NOT NULL,
fkEmpresa 	INT NOT NULL,

PRIMARY KEY (id),
FOREIGN KEY (fkEmpresa) REFERENCES empresa (id)
);

CREATE TABLE IF NOT EXISTS prompt_saida (
id 				INT AUTO_INCREMENT,
resposta 		TEXT NOT NULL,
data_hora 		DATETIME NOT NULL,
fkPromptEntrada INT NOT NULL,

PRIMARY KEY (id),
FOREIGN KEY (fkPromptEntrada) REFERENCES prompt_entrada (id)
);

CREATE TABLE IF NOT EXISTS notificacao (
id 			INT AUTO_INCREMENT,
titulo 		TEXT NOT NULL,
descricao 	TEXT NOT NULL,
data_hora 	DATETIME NOT NULL,
fkEmpresa 	INT NOT NULL,

PRIMARY KEY (id),
FOREIGN KEY (fkEmpresa) REFERENCES empresa (id)
);

CREATE TABLE IF NOT EXISTS veiculo (
id			    INT NOT NULL UNIQUE AUTO_INCREMENT ,
placa 		  	VARCHAR(7),
modelo		  	VARCHAR(45) NOT NULL,
ano			    INT NOT NULL,
fkEmpresa 		INT NOT NULL,

PRIMARY KEY (id),
FOREIGN KEY (fkEmpresa) REFERENCES empresa (id)
);

CREATE TABLE IF NOT EXISTS rota (
id 				INT NOT NULL AUTO_INCREMENT,
ponto_partida 	VARCHAR(100) NOT NULL,
ponto_destino 	VARCHAR(100) NOT NULL,
fkEmpresa 		INT NOT NULL,

PRIMARY KEY (id),
FOREIGN KEY (fkEmpresa) REFERENCES empresa (id)
);

CREATE TABLE IF NOT EXISTS trajeto (
id 				INT NOT NULL AUTO_INCREMENT,
fkRota 			INT NOT NULL,
fkVeiculo 		INT NOT NULL,

PRIMARY KEY (id, fkRota, fkVeiculo),
FOREIGN KEY (fkRota) REFERENCES rota (id),
FOREIGN KEY (fkVeiculo) REFERENCES veiculo (id)
);

CREATE TABLE IF NOT EXISTS rua_intermediaria (
id 		INT NOT NULL AUTO_INCREMENT,
rua 	VARCHAR(100) NOT NULL,
ordem 	INT NOT NULL,
fkRota 	INT NOT NULL,

PRIMARY KEY (id),
FOREIGN KEY (fkRota) REFERENCES rota (id)
);

CREATE TABLE IF NOT EXISTS acidente_transito (
id 						INT,
data 					DATE NOT NULL,
dia_semana				VARCHAR(45) NOT NULL,
horario 				TIME NOT NULL,
uf 						CHAR(2) NOT NULL,
municipio 				VARCHAR(100) NOT NULL,
causa_acidente 			VARCHAR(100) NOT NULL,
fase_dia 				VARCHAR(45) NOT NULL,
condicao_metereologica 	VARCHAR(45) NOT NULL,
qtd_veiculos_envolvidos INT NOT NULL,

PRIMARY KEY (id),
CONSTRAINT CHECK (fase_dia IN ('Plena Noite', 'Amanhecer', 'Pleno dia', 'Anoitecer')),
CONSTRAINT CHECK (condicao_metereologica IN ('Ceu Claro', 'Chuva', 'Sol', 'Nublado', 'Garoa/Chuvisco'))
);

CREATE TABLE IF NOT EXISTS log (
id 						INT NOT NULL AUTO_INCREMENT,
data_hora 				TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT 'Data e hora da leitura com milissegundos',
status 					VARCHAR(45) NOT NULL,
arquivo_lido 			VARCHAR(45),
titulo 					TEXT NOT NULL,
descricao 				TEXT NOT NULL,

PRIMARY KEY (id)
);

INSERT INTO empresa
(razao_social, nome_fantasia, cnpj, cep)
VALUES
('Tree Technology Brasil Ltda', 'Tree Technology', '39.529.500/0001-50', '03132020'),
('CET - Centro de Ensino Técnico', 'CET - Centro de Ensino Técnico', '42.411.685/0001-09', '03166123');

INSERT INTO usuario
(nome, cpf, email, senha, data_nascimento, permissao, status, data_contratacao, fkEmpresa)
VALUES
('Robson', '49123956846', 'robson@gmail.com', '123','1995-01-12', 'Total', 'Ativado', '2024-11-03', 1),
('Gabriel', '49123956841', 'gabriel@gmail.com', '123','1993-02-02', 'Leitura', 'Ativado', '2023-11-03', 1),
('João', '49123956842', 'joao@gmail.com', '123','1991-09-21', 'Leitura', 'Desativado', '2022-11-03', 1),
('Ronaldo', '49123956843', 'ronaldo@gmail.com', '123','2001-09-21', 'Total', 'Ativado', '2012-11-03', 1),

('Jair', '91723956161', 'jair.j@gmail.com', '321', '1979-05-01', 'Total', 'Ativado', '2015-01-11', 2),
('Angela', '91723956162', 'angela@gmail.com', '321', '2000-05-01', 'Total', 'Ativado', '2022-01-11', 2),
('Alexandre', '91723956168', 'alexandre@gmail.com', '321', '1989-06-14', 'Leitura', 'Ativado', '2023-01-11', 2),
('Edson', '91723956163', 'edson@gmail.com', '321', '1999-01-24', 'Leitura', 'Desativado', '2024-01-11', 2);

INSERT INTO veiculo (placa, modelo, ano, fkEmpresa) VALUES
('ABC1234', 'Modelo X', 2020, 1),
('DEF5678', 'Modelo Y', 2019, 1),
('OKD9021', 'Modelo VQ', 2021, 1),
('GHI9012', 'Modelo Z', 2021, 2),
('MNO7890', 'Modelo V', 2020, 2);
INSERT INTO rota (ponto_partida, ponto_destino, fkEmpresa) VALUES
('Méier (Zona Norte)', 'Avenida Rio Branco', 1),
('Terminal Central, Campinas - SP', 'Parque Empresarial Techno Park, Hortolândia - SP', 2),
('Terminal Urbano Cecap, Guarulhos - SP', 'Avenida Paulista, São Paulo - SP', 2),
('Estação Santo André, Santo André - SP', 'Avenida Engenheiro Luiz Carlos Berrini, São Paulo - SP', 2),
('Parque das Industrias (Nova Veneza), Sumaré - SP', 'Rod. Dom Pedro I São Paulo', 1),
('Avenida do Estado, 5533', 'Rua Haddock Lobo, 593', 1),
('Estação Artur Alvim, São Paulo - SP', 'Alphaville Industrial, Barueri - SP', 1);
INSERT INTO trajeto (fkRota, fkVeiculo) VALUES
(1, 1),
(2, 3),
(3, 4),
(4, 5),
(5, 2),
(6, 3),
(7, 2);
INSERT INTO rua_intermediaria (rua, ordem, fkRota) VALUES
('Avenida Monteiro Lobato, Guarulhos - SP', 1, 3),
('Techno Park, Campinas - SP', 1, 5),
('Av Guilherme Campos, 500', 2, 5),
('Avenida Radial Leste, São Paulo - SP', 1, 7);


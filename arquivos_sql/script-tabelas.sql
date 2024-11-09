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
CONSTRAINT CHECK (permissao IN ('total', 'leitura')),
CONSTRAINT CHECK (status IN ('ativado', 'desativado'))
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
id			INT NOT NULL UNIQUE AUTO_INCREMENT ,
placa 		VARCHAR(7) UNIQUE,
modelo		VARCHAR(45) NOT NULL,
ano			INT NOT NULL,
fkEmpresa 	INT NOT NULL,

PRIMARY KEY (id),
FOREIGN KEY (fkEmpresa) REFERENCES empresa (id)
);

CREATE TABLE IF NOT EXISTS rota (
id 				INT NOT NULL AUTO_INCREMENT,
ponto_partida 	VARCHAR(100) NOT NULL,
ponto_destino 	VARCHAR(100) NOT NULL,

PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS trajeto (
fkRota 			INT NOT NULL,
fkVeiculo 		INT NOT NULL,

PRIMARY KEY (fkRota, fkVeiculo),
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
('Robson', '49123956846', 'robson@gmail.com', '123','1989-12-24', 'total', 'ativado', '2022-11-03', 1),
('Jair', '91723956168', 'jair.j@gmail.com', '321', '1999-02-04', 'total', 'ativado', '2015-01-11', 2);

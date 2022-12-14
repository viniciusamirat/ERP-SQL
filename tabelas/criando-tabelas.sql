CREATE DATABASE ERP;
GO
USE ERP;

CREATE TABLE EMPRESA (
    COD_EMPRESA INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    NOME_EMPRESA VARCHAR(50),
    FANTASIA VARCHAR(50)
);

CREATE TABLE UF (
    COD_UF VARCHAR(2) NOT NULL PRIMARY KEY,
    NOME_UF VARCHAR(30),
);

CREATE TABLE CIDADES (
    COD_CIDADE VARCHAR(7) NOT NULL PRIMARY KEY,
    COD_UF VARCHAR(2) NOT NULL,
    NOME_MUN VARCHAR(50) NOT NULL,
    CONSTRAINT FK_UF FOREIGN KEY (COD_UF) REFERENCES UF(COD_UF)
);

CREATE TABLE CLIENTES (
    COD_CLI INT IDENTITY(1,1) NOT NULL,
    COD_EMPRESA INT NOT NULL,
    RAZAO_CLIENTE VARCHAR(100) NOT NULL,
    FANTASIA VARCHAR(50) NOT NULL,
    ENDERECO VARCHAR(50) NOT NULL,
    NUMERO VARCHAR(10) NOT NULL,
    BAIRRO VARCHAR(20)NOT NULL,
    COD_CIDADE VARCHAR(7) NOT NULL,
    CEP VARCHAR(8),
    CNPJ_CPF VARCHAR(15),
    TIPO_CLIENTE NCHAR(1) CONSTRAINT CK_TP_CLI CHECK (TIPO_CLIENTE IN ('F', 'J')),
    DATA_CADASTRO DATETIME NOT NULL,
    COD_PAGTO INT,
    CONSTRAINT PK_CLI_EMP PRIMARY KEY (COD_CLI, COD_EMPRESA),
    CONSTRAINT FK_CLI_CID FOREIGN KEY (COD_CIDADE) 
    REFERENCES CIDADES(COD_CIDADE),
    CONSTRAINT FK_CLI_EMP FOREIGN KEY (COD_EMPRESA)
    REFERENCES EMPRESA(COD_EMPRESA)
);

CREATE TABLE FORNECEDORES (
    COD_FORNEC INT IDENTITY(1,1) NOT NULL,
    COD_EMPRESA INT NOT NULL,
    RAZAO_FORNEC VARCHAR(100) NOT NULL,
    FANTASIA VARCHAR(50) NOT NULL,
    ENDERECO VARCHAR(50) NOT NULL,
    NUMERO VARCHAR(10) NOT NULL,
    BAIRRO VARCHAR(20)NOT NULL,
    COD_CIDADE VARCHAR(7) NOT NULL,
    CEP VARCHAR(8),
    CNPJ_CPF VARCHAR(15),
    TIPO_FORNEC NCHAR(1) CONSTRAINT CK_TP_FORNEC CHECK (TIPO_FORNEC IN ('F', 'J')),
    DATA_CADASTRO DATETIME NOT NULL,
    COD_PAGTO INT,
    CONSTRAINT PK_FORNEC_EMP PRIMARY KEY (COD_FORNEC, COD_EMPRESA),
    CONSTRAINT FK_FORNEC_CID FOREIGN KEY (COD_CIDADE)
    REFERENCES CIDADES(COD_CIDADE),
    CONSTRAINT FK_FORNEC_EMP FOREIGN KEY (COD_EMPRESA)
    REFERENCES EMPRESA(COD_EMPRESA)
);

CREATE TABLE TIPO_MATERIAL (
    COD_TIPO_MAT INT NOT NULL,
    COD_EMPRESA INT NOT NULL,
    DESC_TIPO_TPMAT VARCHAR(20) NOT NULL,
    CONSTRAINT PK_TPMAT_EMP PRIMARY KEY (COD_TIPO_MAT, COD_EMPRESA),
    CONSTRAINT FK_TPMAT_EMP FOREIGN KEY (COD_EMPRESA)
    REFERENCES EMPRESA(COD_EMPRESA)
);

CREATE TABLE MATERIAL (
    COD_MATERIAL INT NOT NULL,
    COD_EMPRESA INT NOT NULL,
    DESCRICAO VARCHAR(100) NOT NULL,
    PRECO_UNIT DECIMAL(10,2) NOT NULL,
    COD_TIPO_MAT INT NOT NULL,
    ID_FORNEC INT,
    CONSTRAINT PK_MAT_EMP PRIMARY KEY (COD_MATERIAL, COD_EMPRESA),
    CONSTRAINT FK_TPMAT_EMP2 FOREIGN KEY (COD_TIPO_MAT, COD_EMPRESA)
    REFERENCES TIPO_MATERIAL(COD_TIPO_MAT, COD_EMPRESA)

);

CREATE INDEX IX_MAT ON MATERIAL(COD_EMPRESA, COD_TIPO_MAT);

CREATE TABLE ORDEM_PRODUCAO (
    ID_ORDEM INT IDENTITY(1,1) NOT NULL,
    COD_EMPRESA INT NOT NULL,
    COD_MAT_PROD INT NOT NULL,
    QTD_PLAN DECIMAL(10,2) NOT NULL,
    QTD_PROD DECIMAL(10,2) NOT NULL,
    DATA_INI DATE,
    DATA_FIM DATE,
    SITUACAO NCHAR(1) CONSTRAINT CK_SITU CHECK (SITUACAO IN ('A', 'P', 'F')), --ABERTA, PLANEJADA, FECHADA
    CONSTRAINT PK_ORDEM_EMP PRIMARY KEY (ID_ORDEM, COD_EMPRESA),
    CONSTRAINT FK_EMP_MAT FOREIGN KEY (COD_MAT_PROD, COD_EMPRESA)
    REFERENCES MATERIAL(COD_MATERIAL, COD_EMPRESA)
);

CREATE TABLE APONTAMENTOS (
    ID_APON INT IDENTITY(1,1) NOT NULL,
    COD_EMPRESA INT NOT NULL,
    ID_ORDEM INT NOT NULL,
    COD_MAT_PROD INT,
    QTD_APON DECIMAL(10,2),
    DATA_APON DATETIME NOT NULL,
    CONSTRAINT PK_APON_EMP PRIMARY KEY (ID_APON, COD_EMPRESA),
    CONSTRAINT FK_EMP_MAT2 FOREIGN KEY (COD_MAT_PROD, COD_EMPRESA)
    REFERENCES MATERIAL(COD_MATERIAL, COD_EMPRESA),
    CONSTRAINT FK_EMP_ORDEM FOREIGN KEY (ID_ORDEM, COD_EMPRESA)
    REFERENCES ORDEM_PRODUCAO (ID_ORDEM, COD_EMPRESA)
);

CREATE TABLE FICHA_TECNICA (
    ID_REF INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    COD_EMPRESA INT NOT NULL,
    COD_MAT_PROD INT NOT NULL,
    COD_MAT_NECESS INT NOT NULL,
    QTD_NECESS DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_EMP_MATPROD FOREIGN KEY (COD_MAT_PROD, COD_EMPRESA)
    REFERENCES MATERIAL(COD_MATERIAL, COD_EMPRESA),
    CONSTRAINT FK_EMP_MATNECESS FOREIGN KEY (COD_MAT_NECESS, COD_EMPRESA)
    REFERENCES MATERIAL(COD_MATERIAL, COD_EMPRESA)
);

CREATE TABLE CONSUMO (
    COD_EMPRESA INT NOT NULL,
    ID_APON INT NOT NULL,
    COD_MAT_NECESS INT NOT NULL,
    QTD_CONSUMIDA DECIMAL(10,2) NOT NULL,
    LOTE VARCHAR(20) NOT NULL,
    CONSTRAINT FK_EMP_MAT3 FOREIGN KEY (COD_MAT_NECESS, COD_EMPRESA)
    REFERENCES MATERIAL(COD_MATERIAL, COD_EMPRESA),
    CONSTRAINT FK_EMP_APON FOREIGN KEY (ID_APON, COD_EMPRESA)
    REFERENCES APONTAMENTOS(ID_APON, COD_EMPRESA)
);

CREATE TABLE ESTOQUE (
    COD_EMPRESA INT NOT NULL,
    COD_MATERIAL INT NOT NULL,
    QTD_SALDO DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_EMP_MAT4 FOREIGN KEY (COD_MATERIAL, COD_EMPRESA)
    REFERENCES MATERIAL(COD_MATERIAL, COD_EMPRESA),
    CONSTRAINT PK_EMP_MAT PRIMARY KEY (COD_EMPRESA, COD_MATERIAL)
);

CREATE TABLE ESTOQUE_LOTE (
    COD_EMPRESA INT NOT NULL,
    COD_MATERIAL INT NOT NULL,
    LOTE VARCHAR(20) NOT NULL,
    QTD_LOTE DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_EMP_MAT_LOTE PRIMARY KEY (COD_EMPRESA, COD_MATERIAL, LOTE),
    CONSTRAINT FK_EMP_MAT5 FOREIGN KEY (COD_MATERIAL, COD_EMPRESA)
    REFERENCES MATERIAL(COD_MATERIAL, COD_EMPRESA)
);

CREATE TABLE ESTOQUE_MOV (
    ID_MOV INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    COD_EMPRESA INT NOT NULL,
    TIPO_MOV NCHAR(1) CONSTRAINT CK_TP_MOV CHECK (TIPO_MOV IN ('S', 'E')),
    COD_MATERIAL INT NOT NULL,
    LOTE VARCHAR(20) NOT NULL,
    QTD DECIMAL(10,2) NOT NULL,
    DATA_MOV DATE NOT NULL,
    HORA_MOV DATETIME NOT NULL,
    CONSTRAINT FK_EMP_MAT6 FOREIGN KEY (COD_MATERIAL, COD_EMPRESA)
    REFERENCES MATERIAL(COD_MATERIAL, COD_EMPRESA),
);

CREATE TABLE PED_COMPRAS (
    NUM_PEDIDO INT NOT NULL,
    COD_EMPRESA INT NOT NULL,
    ID_FORNEC INT NOT NULL,
    COD_PAGTO INT NOT NULL,
    DATA_PEDIDO DATE NOT NULL,
    DATA_ENTEGA DATE NOT NULL,
    SITUACAO NCHAR(1) NOT NULL,
    TOTAL_PED DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_EMP_FORNEC FOREIGN KEY (ID_FORNEC, COD_EMPRESA)
    REFERENCES FORNECEDORES(COD_FORNEC, COD_EMPRESA),
    CONSTRAINT PK_EMP_FORNEC PRIMARY KEY (COD_EMPRESA, NUM_PEDIDO)
);

CREATE TABLE PED_COMPRAS_ITENS (
    NUM_PEDIDO INT NOT NULL,
    COD_EMPRESA INT NOT NULL,
    SEQ_MAT INT NOT NULL,
    COD_MATERIAL INT NOT NULL,
    QTD INT NOT NULL,
    VALOR_UNIT DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_EMP_PED FOREIGN KEY (COD_EMPRESA, NUM_PEDIDO)
    REFERENCES PED_COMPRAS(COD_EMPRESA, NUM_PEDIDO),
    CONSTRAINT FK_EMP_MAT7 FOREIGN KEY (COD_MATERIAL, COD_EMPRESA)
    REFERENCES MATERIAL(COD_MATERIAL, COD_EMPRESA),
    CONSTRAINT PK_EMP_PED PRIMARY KEY (COD_EMPRESA, NUM_PEDIDO, SEQ_MAT)
);

CREATE TABLE CENTRO_CUSTO (
    COD_CC VARCHAR(4) NOT NULL,
    COD_EMPRESA INT NOT NULL,
    NOME_CC VARCHAR(20) NOT NULL,
    CONSTRAINT PK_EMP_CC PRIMARY KEY (COD_EMPRESA, COD_CC),
    CONSTRAINT FK_EMP FOREIGN KEY (COD_EMPRESA)
    REFERENCES EMPRESA(COD_EMPRESA)
);

CREATE TABLE CARGOS (
    COD_CARGO INT IDENTITY(1,1) NOT NULL,
    COD_EMPRESA INT NOT NULL,
    NOME_CARGO VARCHAR(50) NOT NULL,
    CONSTRAINT PK_EMP_CARGO PRIMARY KEY (COD_EMPRESA, COD_CARGO),
    CONSTRAINT FK_EMP2 FOREIGN KEY (COD_EMPRESA)
    REFERENCES EMPRESA(COD_EMPRESA)
);

CREATE TABLE FUNCIONARIO (
	MATRICULA INT  NOT NULL,
	COD_EMPRESA INT NOT NULL,
    COD_CC VARCHAR(4) NOT NULL,
	NOME   VARCHAR(50) NOT NULL,
	RG     VARCHAR(15) NOT NULL,
	CPF    VARCHAR(15) NOT NULL,
	ENDERECO  VARCHAR(50)NOT NULL,
	NUMERO VARCHAR(10) NOT NULL,
	BAIRRO VARCHAR(50) NOT NULL,
	COD_CIDADE VARCHAR(7) NOT NULL,
	DATA_ADMISS DATE NOT NULL,
	DATE_DEMISS DATE,
	DATA_NASC DATE NOT NULL,
	TELEFONE VARCHAR(15) NOT NULL,
	COD_CARGO INT NOT NULL,
	CONSTRAINT FK_EMP_CC FOREIGN KEY (COD_EMPRESA,COD_CC) 
	REFERENCES CENTRO_CUSTO(COD_EMPRESA,COD_CC),
	CONSTRAINT FK_CID FOREIGN KEY (COD_CIDADE) 
	REFERENCES CIDADES(COD_CIDADE),
	CONSTRAINT FK_EMP_CARGO FOREIGN KEY (COD_EMPRESA,COD_CARGO) 
	REFERENCES CARGOS(COD_EMPRESA,COD_CARGO),
	CONSTRAINT PK_FUNC1 PRIMARY KEY (COD_EMPRESA,MATRICULA),
);

CREATE TABLE SALARIO (
    MATRICULA INT NOT NULL,
    COD_EMPRESA INT NOT NULL,
    SALARIO DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_EMP_MATRI FOREIGN KEY (COD_EMPRESA, MATRICULA)
    REFERENCES FUNCIONARIO(COD_EMPRESA, MATRICULA),
    CONSTRAINT PK_EMP_MATRI PRIMARY KEY (COD_EMPRESA, MATRICULA)
);

CREATE TABLE FOLHA_PAGTO (
    MATRICULA INT NOT NULL,
    COD_EMPRESA INT NOT NULL,
    TIPO_PAGTO CHAR(1) NOT NULL,
    TIPO CHAR(1),
    EVENTO VARCHAR(30) NOT NULL,
    MES_REF VARCHAR(2) NOT NULL,
    ANO_REF VARCHAR(4) NOT NULL,
    DATA_PAGTO DATE NOT NULL,
    VALOR DECIMAL(10,2),
    CONSTRAINT FK_EMP_MATRI2 FOREIGN KEY (COD_EMPRESA, MATRICULA)
    REFERENCES FUNCIONARIO(COD_EMPRESA, MATRICULA)
);

CREATE INDEX IX_FOLHA ON FOLHA_PAGTO(COD_EMPRESA, MATRICULA);

CREATE TABLE USUARIOS (
    COD_EMPRESA INT NOT NULL,
    LOGIN VARCHAR(30) NOT NULL PRIMARY KEY,
    MATRICULA INT NOT NULL,
    SENHA VARCHAR(32) NOT NULL,
    SITUACAO CHAR(1) NOT NULL,
    CONSTRAINT FK_EMP_MATRI3 FOREIGN KEY (COD_EMPRESA, MATRICULA)
    REFERENCES FUNCIONARIO(COD_EMPRESA, MATRICULA)
);

CREATE TABLE CONTAS_RECEBER (
    ID_DOC INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    COD_EMPRESA INT NOT NULL,
    ID_CLIENTE INT NOT NULL,
    ID_DOC_ORIG INT NOT NULL,
    PARC INT NOT NULL,
    DATA_VENC DATE NOT NULL,
    DATA_PAGTO DATE,
    VALOR DECIMAL(10,2),
    CONSTRAINT FK_EMP_CLI FOREIGN KEY (ID_CLIENTE, COD_EMPRESA)
    REFERENCES CLIENTES(COD_CLI, COD_EMPRESA)
);

CREATE TABLE CONTAS_PAGAR (
	ID_DOC INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	COD_EMPRESA INT NOT NULL,
    ID_FORNEC INT NOT NULL,
	ID_DOC_ORIG INT NOT NULL,
	PARC INT NOT NULL,
	DATA_VENC DATE NOT NULL,
	DATA_PAGTO DATE ,
	VALOR DECIMAL(10,2),
	CONSTRAINT FK_EMP_FORNEC2 FOREIGN KEY (ID_FORNEC, COD_EMPRESA) 
	REFERENCES FORNECEDORES(COD_FORNEC, COD_EMPRESA)
);

CREATE TABLE COND_PAGTO(
    COD_PAGTO INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    NOME_CP VARCHAR(50) NOT NULL
);

CREATE TABLE COND_PAGTO_DET (
	COD_PAGTO INT NOT NULL,
	PARC INT NOT NULL,
	DIAS INT NOT NULL,
	PCT DECIMAL(10,2)NOT NULL,
	CONSTRAINT FK_PAGTO FOREIGN KEY (COD_PAGTO) 
	REFERENCES COND_PAGTO(COD_PAGTO)
);

CREATE TABLE PED_VENDAS (
	NUM_PEDIDO INT  NOT NULL,
	COD_EMPRESA INT NOT NULL,
	ID_CLIENTE INT NOT NULL,
	COD_PAGTO INT NOT NULL, 
	DATA_PEDIDO DATE NOT NULL,
	DATA_ENTREGA DATE NOT NULL,
	SITUACAO NCHAR(1) NOT NULL,
	TOTAL_PED DECIMAL(10,2),
	CONSTRAINT FK_EMP_CLI2 FOREIGN KEY (ID_CLIENTE, COD_EMPRESA) 
	REFERENCES CLIENTES(COD_CLI, COD_EMPRESA),
	CONSTRAINT FK_PAGTO2 FOREIGN KEY (COD_PAGTO) 
	REFERENCES COND_PAGTO(COD_PAGTO),
	CONSTRAINT PK_EMP_PED2 PRIMARY KEY (COD_EMPRESA,NUM_PEDIDO)
);

CREATE TABLE PED_VENDAS_ITENS (
	NUM_PEDIDO INT NOT NULL,
	COD_EMPRESA INT NOT NULL,
	SEQ_MAT INT NOT NULL,
	COD_MATERIAL INT NOT NULL,
	QTD INT NOT NULL,
	VALOR_UNIT DECIMAL(10,2) NOT NULL,
	CONSTRAINT FK_EMP_PED2 FOREIGN KEY (COD_EMPRESA,NUM_PEDIDO) 
	REFERENCES PED_VENDAS(COD_EMPRESA,NUM_PEDIDO),
	CONSTRAINT PK_EMP_PED_SEQ PRIMARY KEY (COD_EMPRESA,NUM_PEDIDO,SEQ_MAT)
);

CREATE TABLE VENDEDORES(
    COD_EMPRESA INT NOT NULL,
	MATRICULA  INT NOT NULL,
 	CONSTRAINT FK_VEND1 FOREIGN KEY (COD_EMPRESA,MATRICULA) 
	REFERENCES FUNCIONARIO(COD_EMPRESA,MATRICULA)
);

CREATE TABLE GERENTES (
    COD_EMPRESA INT NOT NULL,
	MATRICULA INT NOT NULL,
 	CONSTRAINT FK_GER1 FOREIGN KEY (COD_EMPRESA,MATRICULA) 
	REFERENCES FUNCIONARIO(COD_EMPRESA,MATRICULA)
);

CREATE TABLE CANAL_VENDAS_G_V (
	COD_EMPRESA INT NOT NULL,
	MATRICULA_GER INT NOT NULL,
	MATRICULA_VEND INT,
	CONSTRAINT FK_CGV1 FOREIGN KEY (COD_EMPRESA,MATRICULA_GER) 
	REFERENCES FUNCIONARIO(COD_EMPRESA,MATRICULA),
	CONSTRAINT FK_CGV2 FOREIGN KEY (COD_EMPRESA,MATRICULA_VEND) 
	REFERENCES FUNCIONARIO(COD_EMPRESA,MATRICULA),
	CONSTRAINT PK_CGV1 PRIMARY KEY (COD_EMPRESA,MATRICULA_GER,MATRICULA_VEND)
);


CREATE TABLE CANAL_VENDAS_V_C (
	COD_EMPRESA INT NOT NULL,
	MATRICULA_VEND INT NOT NULL,
	ID_CLIENTE INT NOT NULL,
	CONSTRAINT FK_CVC1 FOREIGN KEY (COD_EMPRESA,MATRICULA_VEND) 
	REFERENCES FUNCIONARIO(COD_EMPRESA,MATRICULA),
	CONSTRAINT FK_CVC2 FOREIGN KEY (ID_CLIENTE, COD_EMPRESA) 
	REFERENCES CLIENTES(cod_cli, COD_EMPRESA)
);

CREATE TABLE META_VENDAS (
	COD_EMPRESA INT NOT NULL,
	MATRICULA_VEND INT NOT NULL,
	ANO VARCHAR(4) NOT NULL,
	MES VARCHAR(2) NOT NULL,
	VALOR DECIMAL(10,2),
	CONSTRAINT FK_MV1 FOREIGN KEY (COD_EMPRESA,MATRICULA_VEND) 
	REFERENCES FUNCIONARIO(COD_EMPRESA,MATRICULA)
);

CREATE TABLE CFOP (
	COD_CFOP VARCHAR(5) NOT NULL PRIMARY KEY,
	DESC_CFOP VARCHAR(255) NOT NULL
);

CREATE TABLE NOTA_FISCAL (
	COD_EMPRESA INT NOT NULL,
	NUM_NF INT  NOT NULL ,
	TIP_NF CHAR(1) NOT NULL, --E ENTRADA, S- SAIDA
	COD_CFOP VARCHAR(5) NOT NULL,
	ID_CLIFOR INT NOT NULL,
	COD_PAGTO INT NOT NULL, 
	DATA_EMISSAO DATETIME NOT NULL,
	DATA_ENTREGA DATE NOT NULL,
	TOTAL_NF DECIMAL(10,2),
	INTEGRADA_FIN CHAR(1) DEFAULT('N'),
	INTEGRADA_SUP CHAR(1) DEFAULT('N'),
	CONSTRAINT FK_NF1 FOREIGN KEY (COD_CFOP) 
	REFERENCES CFOP(COD_CFOP),
	CONSTRAINT FK_NF2 FOREIGN KEY (COD_PAGTO) 
	REFERENCES COND_PAGTO(COD_PAGTO),
	CONSTRAINT PK_NF1 PRIMARY KEY (COD_EMPRESA,NUM_NF)
);

CREATE TABLE NOTA_FISCAL_ITENS (
	COD_EMPRESA INT NOT NULL,
	NUM_NF INT NOT NULL,
	SEQ_MAT INT NOT NULL,
	COD_MAT INT NOT NULL,
	QTD     INT NOT NULL,
	VAL_UNIT DECIMAL(10,2) NOT NULL,
	PED_ORIG  INT NOT NULL,
	CONSTRAINT FK_NFIT1 FOREIGN KEY (COD_EMPRESA,NUM_NF) 
	REFERENCES NOTA_FISCAL(COD_EMPRESA,NUM_NF),
	CONSTRAINT FK_NFIT2 FOREIGN KEY (COD_MAT, COD_EMPRESA) 
	REFERENCES MATERIAL(COD_MATERIAL, COD_EMPRESA)
);

CREATE TABLE PARAM_INSS (
    VIGENCIA_INI DATE,
    VIGENCIA_FIM DATE,
    VALOR_DE DECIMAL(10,2) NOT NULL,
    VALOR_ATE DECIMAL(10,2) NOT NULL,
    PCT DECIMAL(10,2) NOT NULL
);


CREATE TABLE PARAM_IRRF (
    VIGENCIA_INI DATE,
    VIGENCIA_FIM DATE,
    VALOR_DE DECIMAL(10,2) NOT NULL,
    VALOR_ATE DECIMAL(10,2) NOT NULL,
    PCT DECIMAL(10,2) NOT NULL,
    VAL_ISENT DECIMAL(10,2)
);



CREATE TABLE AUDITORIA_SALARIO (
    COD_EMPRESA INT NOT NULL,
	MATRICULA VARCHAR(30) NOT NULL,
	SAL_ANTES DECIMAL(10, 2) NOT NULL,
	SAL_DEPOIS DECIMAL(10, 2) NOT NULL,
	USUARIO VARCHAR(20) NOT NULL,
	DATA_ATUALIZACAO DATETIME NOT NULL
);


CREATE TABLE PARAMETROS (
    COD_EMPRESA INT NOT NULL,
    PARAM VARCHAR(50) NOT NULL,
    VALOR INT NOT NULL,
    CONSTRAINT FK_PARAM1 FOREIGN KEY (COD_EMPRESA) 
    REFERENCES EMPRESA(COD_EMPRESA),
    CONSTRAINT PK_PARAM1 PRIMARY KEY (COD_EMPRESA,PARAM)
);

ALTER TABLE APONTAMENTOS ADD LOGIN VARCHAR(30) NOT NULL;

ALTER TABLE APONTAMENTOS ADD LOTE VARCHAR(20) NOT NULL;

ALTER TABLE ESTOQUE_MOV ADD LOGIN VARCHAR(30) NOT NULL;





--NAO APLICADOS EXEMPLOS
ALTER TABLE APONTAMENTOS ADD CONSTRAINT FK_APONT3
FOREIGN KEY (LOGIN) REFERENCES USUARIOS(LOGIN);

--REMOVENDO CONSTRAINT PARA TESTE
ALTER TABLE CONSUMO DROP CONSTRAINT  FK_CONS2
ALTER TABLE APONTAMENTOS DROP CONSTRAINT  FK_APONT3

ALTER TABLE ESTOQUE_MOV ADD CONSTRAINT FK_ESTM2
FOREIGN KEY (LOGIN) REFERENCES USUARIOS(LOGIN);
--REMOVENDO FK LOGIN PARA TESTES 
ALTER TABLE ESTOQUE_MOV DROP CONSTRAINT  FK_ESTM2
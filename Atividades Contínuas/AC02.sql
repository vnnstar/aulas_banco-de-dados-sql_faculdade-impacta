-- Vinicius Dos Reis Oliveira , RA: 1701731
CREATE DATABASE AC02VINICIUSREIS
GO

USE AC02VINICIUSREIS
GO

CREATE TABLE TB_USUARIO(
	ID INT IDENTITY,
	LOGUIN NVARCHAR (40) NOT NULL,
	SENHA NVARCHAR (15) NOT NULL,
	DT_EXPIRACAO DATE DEFAULT '1900-01-01',

	CONSTRAINT UQ_LOGUIN UNIQUE (LOGUIN),
	CONSTRAINT PK_ID PRIMARY KEY (ID)

);

CREATE TABLE TB_COORDENADOR(
	ID SMALLINT IDENTITY,
	ID_USUARIO INT,
	NOME VARCHAR (50) NOT NULL,
	EMAIL NVARCHAR (40) NOT NULL,
	CELULAR VARCHAR (11) NOT NULL,
	
	CONSTRAINT PK_ID_COORDENADOR PRIMARY KEY (ID),
	CONSTRAINT FK_ID_COORDENADOR FOREIGN KEY (ID_USUARIO) REFERENCES TB_USUARIO (ID),
	CONSTRAINT UQ_EMAIL_COORDENADOR UNIQUE (EMAIL),
	CONSTRAINT UQ_CELULAR_COORDENADOR UNIQUE (CELULAR)
);

CREATE TABLE TB_ALUNO(
	ID INT IDENTITY,
	ID_USUARIO INT,
	NOME VARCHAR (50) NOT NULL,
	EMAIL NVARCHAR (40) NOT NULL,
	CELULAR VARCHAR (11) NOT NULL,
	RA VARCHAR (10) NOT NULL,
	FOTO VARCHAR (400),

	CONSTRAINT PK_ID_ALUNO PRIMARY KEY (ID),
	CONSTRAINT FK_ID_ALUNO FOREIGN KEY (ID_USUARIO) REFERENCES TB_USUARIO (ID),
	CONSTRAINT UQ_EMAIL_ALUNO UNIQUE (EMAIL),
	CONSTRAINT UQ_CELULAR_ALUNO UNIQUE (CELULAR)

);

CREATE TABLE TB_PROFESSOR(
	ID SMALLINT IDENTITY,
	ID_USUARIO INT,
	EMAIL NVARCHAR (40) NOT NULL,
	CELULAR VARCHAR (11) NOT NULL,
	APELIDO VARCHAR (20) NOT NULL,

	CONSTRAINT PK_ID_PROFESSOR PRIMARY KEY (ID),
	CONSTRAINT FK_ID_PROFESSOR FOREIGN KEY (ID_USUARIO) REFERENCES TB_USUARIO (ID),
	CONSTRAINT UQ_EMAIL_PROFESSOR UNIQUE (EMAIL),
	CONSTRAINT UQ_CELULAR_PROFESSOR UNIQUE (CELULAR)

);

CREATE TABLE TB_CURSO(
	ID SMALLINT IDENTITY,
	NOME VARCHAR (50) NOT NULL,

	CONSTRAINT PK_ID_CURSO PRIMARY KEY (ID),
	CONSTRAINT UQ_NOME_CURSO UNIQUE (NOME)

);

CREATE TABLE TB_DISCIPLINA(
	ID SMALLINT IDENTITY,
	NOME VARCHAR (50) NOT NULL,
	DT DATETIME DEFAULT GETDATE() NOT NULL,
	STATUS_ATUAL VARCHAR (8) DEFAULT 'Aberta',
	PLANO_DE_ENSINO VARCHAR(MAX) NOT NULL,
	CARGA_HORARIA VARCHAR (2) NOT NULL,
	COMPETENCIAS VARCHAR (2000) NOT NULL,
	HABILIDADES VARCHAR (1000) NOT NULL,
	EMENTA VARCHAR (3000) NOT NULL,
	CONTEUDO_PROGRAMATICO VARCHAR (MAX) NOT NULL,
	BIBLIOGRAFIA_BASICA NVARCHAR (1000) NOT NULL,
	BIBLIOGRAFIA_COMPLEMENTAR NVARCHAR (1000) NOT NULL,
	PERCENTUAL_PRATICO TINYINT NOT NULL,
	PERCENTUAL_TEORICO TINYINT NOT NULL,
	ID_COORDENADOR SMALLINT,

	CONSTRAINT PK_ID_DISCIPLINA PRIMARY KEY (ID),
	CONSTRAINT FK_ID_DISCIPLINA FOREIGN KEY (ID_COORDENADOR) REFERENCES TB_COORDENADOR (ID),
	CONSTRAINT UQ_NOME_DISCIPLINA UNIQUE (NOME),
	CONSTRAINT CK_STATUS_ATUAL CHECK (STATUS_ATUAL LIKE 'Aberta'AND STATUS_ATUAL LIKE 'Fechada' AND STATUS_ATUAL LIKE 'ABERTA' AND STATUS_ATUAL LIKE 'FECHADA' AND STATUS_ATUAL LIKE 'aberta' AND STATUS_ATUAL LIKE 'fechada'),
	CONSTRAINT CK_CARGA_HORARIA CHECK (CARGA_HORARIA LIKE '40' AND CARGA_HORARIA LIKE '80'),
	CONSTRAINT CK_PERCENT_P CHECK (PERCENTUAL_PRATICO >= 0 AND PERCENTUAL_PRATICO <= 100),
	CONSTRAINT CK_PERCENT_T CHECK (PERCENTUAL_TEORICO >= 0 AND PERCENTUAL_TEORICO <= 100)

);

CREATE TABLE TB_DISCIPLINA_OFERTADA(
	ID SMALLINT IDENTITY,
	ID_COORDENADOR SMALLINT,
	DT_INICIO_MATRICULA DATETIME,
	DT_FIM_MATRICULA DATETIME,
	ID_DISCIPLINA SMALLINT,
	ID_CURSO SMALLINT,
	ANO SMALLINT NOT NULL,
	SEMESTRE CHAR (1) NOT NULL,
	TURMA CHAR (1) NOT NULL,
	ID_PROFESSOR SMALLINT,
	METODOLOGIA VARCHAR(2000),
	RECURSOS VARCHAR (1000),
	CRITERIO_AVALIACAO VARCHAR (2000),
	PLANO_DE_AULAS VARCHAR (3000)

	CONSTRAINT PK_ID_DISCIPLINA_OFERTADA PRIMARY KEY (ID)
	CONSTRAINT FK_ID_DISC_OFER_COORD FOREIGN KEY (ID_COORDENADOR) REFERENCES TB_COORDENADOR (ID),
	CONSTRAINT FK_ID_DISC_OFER_DISCIPLINA FOREIGN KEY (ID_DISCIPLINA) REFERENCES TB_DISCIPLINA (ID),
	CONSTRAINT FK_ID_DISC_OFER_CURSO FOREIGN KEY (ID_CURSO) REFERENCES TB_CURSO (ID),
	CONSTRAINT FK_ID_DISC_OFER_PROF FOREIGN KEY (ID_PROFESSOR) REFERENCES TB_PROFESSOR (ID),
	CONSTRAINT CK_ANO CHECK (ANO >= 1900 AND ANO <=2100),
	CONSTRAINT CK_SEMESTRE CHECK (SEMESTRE LIKE '1' AND SEMESTRE LIKE '2'),
	CONSTRAINT CK_TURMA CHECK (TURMA LIKE '[AZ]')

);

CREATE TABLE TB_SOLICITACAO_MATRICULA(
	ID INT IDENTITY,
	ID_ALUNO INT,
	ID_DISCIPLINA_OFERTADA SMALLINT,
	DT_SOLICITACAO DATETIME DEFAULT GETDATE(),
	ID_COORDENADOR SMALLINT,
	MATRICULA_STATUS VARCHAR (10) DEFAULT 'Solicitada',

	CONSTRAINT PK_ID_SOLIC_MATRICULA PRIMARY KEY (ID),
	CONSTRAINT FK_ID_SOLIC_MATRI_ALUNO FOREIGN KEY (ID_ALUNO) REFERENCES TB_ALUNO (ID),
	CONSTRAINT FK_ID_SOLIC_MATRI_DISC_OFER FOREIGN KEY (ID_DISCIPLINA_OFERTADA) REFERENCES TB_DISCIPLINA_OFERTADA (ID),
	CONSTRAINT FK_ID_SOLIC_MAATRI_COORD FOREIGN KEY (ID_COORDENADOR) REFERENCES TB_COORDENADOR (ID),
	CONSTRAINT CK_DT_SOLICITACAO CHECK (MATRICULA_STATUS LIKE 'Solicitada' AND MATRICULA_STATUS LIKE 'Aprovada' AND MATRICULA_STATUS LIKE 'Rejeitada' AND MATRICULA_STATUS LIKE 'Cancelada' AND MATRICULA_STATUS LIKE 'SOLICITADA' AND MATRICULA_STATUS LIKE 'APROVADA' AND MATRICULA_STATUS LIKE 'REJEITADA' AND MATRICULA_STATUS LIKE 'CANCELADA' AND MATRICULA_STATUS LIKE 'aprovada' AND MATRICULA_STATUS LIKE 'solicitada' AND MATRICULA_STATUS LIKE 'rejeitada' AND MATRICULA_STATUS LIKE 'cancelada'),

);

CREATE TABLE TB_ATIVIDADE(
	ID INT IDENTITY,
	TITULO NVARCHAR (50) NOT NULL,
	DESCRICAO VARCHAR (500),
	CONTEUDO NVARCHAR (MAX) NOT NULL,
	TIPO VARCHAR (16) NOT NULL,
	EXTRAS NVARCHAR (250),
	ID_PROFESSOR SMALLINT,

	CONSTRAINT PK_ID_ATIVIDADE PRIMARY KEY (ID),
	CONSTRAINT FK_ID_PROF_ATIVIDAE FOREIGN KEY (ID_PROFESSOR) REFERENCES TB_PROFESSOR (ID),
	CONSTRAINT UQ_TITULO UNIQUE (TITULO),
	CONSTRAINT CK_TIPO CHECK (TIPO LIKE 'RESPOSTA ABERTA' AND TIPO LIKE 'TESTE' AND TIPO LIKE 'resposta aberta' AND TIPO LIKE 'teste' AND TIPO LIKE 'Resposta Aberta' AND TIPO LIKE 'Teste')

);

CREATE TABLE TB_ATIVIDADE_VINCULADA(
	ID INT IDENTITY,
	ID_ATIVIDADE INT,
	ID_PROFESSOR SMALLINT,
	ID_DISCIPLINA_OFERTADA SMALLINT,
	ROTULO VARCHAR (15) NOT NULL,
	ATIVIDADE_STATUS  VARCHAR (20) NOT NULL,
	DT_INICIO_REPOSTAS DATETIME NOT NULL,
	DT_FIM_RESPOSTAS DATETIME NOT NULL,

	CONSTRAINT PK_ID_ATIV_VINCULADA PRIMARY KEY (ID),
	CONSTRAINT FK_ID_ATIV_VINC_ATIVIDADE FOREIGN KEY (ID_ATIVIDADE) REFERENCES TB_ATIVIDADE (ID),
	CONSTRAINT FK_ID_ATIV_VINC_PROF FOREIGN KEY (ID_PROFESSOR) REFERENCES TB_PROFESSOR (ID),
	CONSTRAINT FK_ID_ATIV_VINC_DISC_OFER FOREIGN KEY (ID_DISCIPLINA_OFERTADA) REFERENCES TB_DISCIPLINA_OFERTADA (ID),
	CONSTRAINT CK_ATIV_STATUS CHECK (ATIVIDADE_STATUS LIKE 'Disponibilizada' AND ATIVIDADE_STATUS LIKE 'Aberta' AND ATIVIDADE_STATUS LIKE 'Fechada' AND ATIVIDADE_STATUS LIKE 'Encerrada' AND ATIVIDADE_STATUS LIKE 'Prorrogada' AND ATIVIDADE_STATUS LIKE 'DISPONIBILIZADA' AND ATIVIDADE_STATUS LIKE 'ABERTA' AND ATIVIDADE_STATUS LIKE 'FECHADA' AND ATIVIDADE_STATUS LIKE 'ENCERRADA' AND ATIVIDADE_STATUS LIKE 'PRORROGADA')
	
);

CREATE TABLE TB_ENTREGA(
	ID INT IDENTITY,
	ID_ALUNO INT,
	ID_ATIVIDADE_VINCULADA INT,
	TITULO VARCHAR (500) NOT NULL,
	RESPOSTA NVARCHAR (1000) NOT NULL,
	DT_ENTREGA DATETIME DEFAULT GETDATE(),
	ENTREGA_STATUS VARCHAR (9) DEFAULT 'Entregue',
	ID_PROFESSOR SMALLINT,
	NOTA DECIMAL (4,2),
	DT_AVALIACAO DATETIME,
	OBS VARCHAR (300),

	CONSTRAINT PK_ID_ENTREGA PRIMARY KEY (ID),
	CONSTRAINT FK_ID_ENTREGA_ALU FOREIGN KEY (ID_ALUNO) REFERENCES TB_ALUNO (ID),
	CONSTRAINT FK_ID_ENTREGA_ATIV_VINC FOREIGN KEY (ID_ATIVIDADE_VINCULADA) REFERENCES TB_ATIVIDADE_VINCULADA (ID),
	CONSTRAINT FK_ID_ENTREGA_PROF FOREIGN KEY (ID_PROFESSOR) REFERENCES TB_PROFESSOR (ID),
	CONSTRAINT CK_ENTREGA_STATUS CHECK (ENTREGA_STATUS LIKE 'ENTREGUE' AND ENTREGA_STATUS LIKE 'CORRIGIDO' AND ENTREGA_STATUS LIKE 'Entregue' AND ENTREGA_STATUS LIKE 'Corrigido' AND ENTREGA_STATUS LIKE 'entregue' AND ENTREGA_STATUS LIKE 'corrigido'),
	CONSTRAINT CK_NOTA CHECK (NOTA >= 0 AND NOTA <= 10)

);

CREATE TABLE TB_MENSAGEM(
	ID BIGINT IDENTITY,
	ID_ALUNO INT,
	ID_PROFESSOR SMALLINT,
	ASSUNTO  VARCHAR (40) NOT NULL,
	REFERENCIA VARCHAR (150) NOT NULL,
	CONTEUDO VARCHAR (MAX) NOT NULL,
	MENSAGEM_STATUS VARCHAR (10) DEFAULT 'Enviado',
	DT_ENVIO DATETIME DEFAULT GETDATE(),
	DT_RESPOSTA DATETIME,
	RESPOSTA VARCHAR (MAX),

	CONSTRAINT PK_ID_MENSAGEM PRIMARY KEY (ID),
	CONSTRAINT FK_ID_MENS_ALU FOREIGN KEY (ID_ALUNO) REFERENCES TB_ALUNO (ID),
	CONSTRAINT FK_ID_MENS_PROF FOREIGN KEY (ID_PROFESSOR) REFERENCES TB_PROFESSOR (ID),
	CONSTRAINT CK_MENS_STATUS CHECK (MENSAGEM_STATUS LIKE 'ENVIADO' AND MENSAGEM_STATUS LIKE 'LIDO' AND MENSAGEM_STATUS LIKE 'RESPONDIDO' AND MENSAGEM_STATUS LIKE 'Enviado' AND MENSAGEM_STATUS LIKE 'Lido' AND MENSAGEM_STATUS LIKE 'Respondido' AND MENSAGEM_STATUS LIKE 'enviado' AND MENSAGEM_STATUS LIKE 'lido' AND MENSAGEM_STATUS LIKE 'respondido')

);
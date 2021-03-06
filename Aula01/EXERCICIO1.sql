CREATE TABLE TB_CLIENTES(
	ID_CLIENTE INT IDENTITY,
	NOME VARCHAR(40) NOT NULL,
	EMAIL NVARCHAR(50) NOT NULL,
	SENHA NVARCHAR (10) NOT NULL,
	RUA VARCHAR(100),
	CIDADE VARCHAR (25),
	BAIRRO VARCHAR (70),
	CEP CHAR(8),
	ESTADO VARCHAR(25),

	CONSTRAINT PK_CLIENTE PRIMARY KEY (ID_CLIENTE)
);

CREATE TABLE TB_PEDIDOS(
	ID_PEDIDO BIGINT IDENTITY,
	DATA_PEDIDO DATETIME DEFAULT GETDATE() NOT NULL,
	ID_CLI INT,
	STATUS_PEDIDO CHAR(9) DEFAULT ('APROVADO'),

	CONSTRAINT PK_PEDIDO PRIMARY KEY (ID_PEDIDO),
	CONSTRAINT FK_IDCLIENTE FOREIGN KEY (ID_CLI) REFERENCES TB_CLIENTES (ID_CLIENTE)
);
	
CREATE TABLE TB_CATEGORIAS(
	ID_CAT SMALLINT,
	NM_CATEGORIA VARCHAR(40),

	CONSTRAINT PK_CAT PRIMARY KEY (ID_CAT)
);

CREATE TABLE TB_PRODUTOS(
	ID_PRODUTO SMALLINT IDENTITY,
	ID_CATEGORIA SMALLINT,
	NM_PRODUTO VARCHAR(40),
	VALOR_PRECO DECIMAL(15,2) DEFAULT 0,
	N_QUANTIDADE DECIMAL(10,2) DEFAULT 0,
	DESCRICAO NVARCHAR(200),
	FOTO NVARCHAR(300),

	CONSTRAINT PK_PRODUTO PRIMARY KEY (ID_PRODUTO),
	CONSTRAINT FK_CATEGORIA FOREIGN KEY (ID_CATEGORIA) REFERENCES TB_CATEGORIAS (ID_CAT),
	CONSTRAINT UQ_PRODUTO UNIQUE (NM_PRODUTO),
	CONSTRAINT CK_VALOR CHECK (VALOR_PRECO >=0),
	CONSTRAINT CK_QUANT CHECK (N_QUANTIDADE >=0)
);

CREATE TABLE TB_ITENS_PEDIDO(
	ID_ITEM SMALLINT IDENTITY,
	ID_PEDIDO BIGINT,
	ID_PRODUTO SMALLINT,
	PRODUTO VARCHAR(30),
	QUANTIDADE DECIMAL (10,2),
	VALOR DECIMAL(15,2),
	SUBTOTAL DECIMAL(20,2),

	CONSTRAINT PK_ITEM PRIMARY KEY (ID_ITEM),
	CONSTRAINT FK_PEDIDO FOREIGN KEY (ID_PEDIDO) REFERENCES TB_PEDIDOS (ID_PEDIDO),
	CONSTRAINT FK_PRODUTO FOREIGN KEY (ID_PRODUTO) REFERENCES TB_PRODUTOS (ID_PRODUTO),
	CONSTRAINT CK_VALOR_PEDIDO CHECK (VALOR >=0),
	CONSTRAINT CK_QUANT_PEDIDO CHECK (QUANTIDADE >=0),
	CONSTRAINT CK_TOTAL_PEDIDO CHECK (SUBTOTAL >=0)

);

DROP TABLE TB_CATEGORIAS

	

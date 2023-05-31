/*
Banco de Dados, PSET1
Gustavo Raasch Müller - CC1N
gusrmuller@gmail.com
*/


-- Exclui o banco de dados "uvv" caso exista
drop database if exists uvv;

-- Exclui o usuário "gustavo" caso exista
drop user if exists gustavo;

-- Cria o usuário "gustavo" com permissão para criar banco de dados, criar usuário/role e com a senha criptografada
create user gustavo with createdb createrole encrypted password 'raiz';

-- Cria o banco de dados com nome "uvv" e com o usuário "gustavo" como dono
create database uvv with 
owner = gustavo
template = template0
encoding = 'UTF8'
lc_collate = 'pt_BR.UTF-8'
lc_ctype = 'pt_BR.UTF-8'
allow_connections = true;

-- Se conecta ao banco de dados "uvv", com o usuário "gustavo", sem precisar de senha quando rodar o script
\c "dbname = uvv user = gustavo password = raiz"

-- Cria o schema "lojas" dando autorização para o usuário "gustavo"
create schema lojas authorization gustavo;

-- Altera o search_path para o schema "lojas", tornando esse o schema padrão
ALTER USER gustavo
SET SEARCH_PATH TO lojas, "$user", public;

-- Cria a tabela produtos, com a PK produto_id
CREATE TABLE lojas.produtos (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT produtos_pk PRIMARY KEY (produto_id)
);
COMMENT ON TABLE lojas.produtos IS 'Tabela que representa um produto';
COMMENT ON COLUMN lojas.produtos.produto_id IS 'Representa o número de identificação do produto';
COMMENT ON COLUMN lojas.produtos.nome IS 'Nome do produto';
COMMENT ON COLUMN lojas.produtos.preco_unitario IS 'Preço de cada unidade do produto';
COMMENT ON COLUMN lojas.produtos.detalhes IS 'Detalhes de determinado produto';
COMMENT ON COLUMN lojas.produtos.imagem IS 'Imagem do produto representada em binário';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type IS 'Representa o tipo de mídia da imagem';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo IS 'Representa o caminho pro diretório da imagem';
COMMENT ON COLUMN lojas.produtos.imagem_charset IS 'Representa a forma de codificação dos caracteres da respectiva imagem';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'Última data em que a imagem foi atualizada';

-- Cria a check constraint que determina que o preço unitario não pode ser negativo
ALTER TABLE lojas.produtos
ADD CONSTRAINT check_preco_unitario_produtos
CHECK (preco_unitario >= 0);


-- Cria a tabela lojas com a PK loja_id
CREATE TABLE lojas.lojas (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo BYTEA,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT lojas_pk PRIMARY KEY (loja_id)
);
COMMENT ON TABLE lojas.lojas IS 'Tabela que representa lojas';
COMMENT ON COLUMN lojas.lojas.loja_id IS 'Número de identificação da loja';
COMMENT ON COLUMN lojas.lojas.nome IS 'Nome da loja';
COMMENT ON COLUMN lojas.lojas.endereco_web IS 'URL do site da loja';
COMMENT ON COLUMN lojas.lojas.endereco_fisico IS 'Endereço físico da loja';
COMMENT ON COLUMN lojas.lojas.latitude IS 'Coordenadas da latitude da loja';
COMMENT ON COLUMN lojas.lojas.longitude IS 'Coordenadas da longitude da loja';
COMMENT ON COLUMN lojas.lojas.logo IS 'Representa o logo da loja em binário';
COMMENT ON COLUMN lojas.lojas.logo_mime_type IS 'Representa o tipo de mídia da logo';
COMMENT ON COLUMN lojas.lojas.logo_arquivo IS 'Representa o caminho pro diretório onde está armazenada a logo';
COMMENT ON COLUMN lojas.lojas.logo_charset IS 'Tipo de codificação de caracteres da logo';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'Última data que a logo foi atualizada';

-- Cria a check constraint que determina que pelo menos um dos endereços sejam preenchidos
ALTER TABLE lojas.lojas
ADD CONSTRAINT check_endereco
CHECK (endereco_fisico IS NOT NULL OR endereco_web IS NOT NULL);


-- Cria a tabela estoques com a PK estoque_id
CREATE TABLE lojas.estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT estoques_pk PRIMARY KEY (estoque_id)
);
COMMENT ON TABLE lojas.estoques IS 'Tabela que representa o estoque de uma loja';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'Representa o número de identificação de um local de estoque';
COMMENT ON COLUMN lojas.estoques.loja_id IS 'Representa o numero de identificação de uma loja';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'Representa o número de identificação de um produto que está no estoque';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'Representa a quantidade de certo produto que está no estoque';

-- Cria a check constraint que determina que a quantidade não pode ser negativa
ALTER TABLE lojas.estoques
ADD CONSTRAINT check_quantidade_estoques
CHECK (quantidade >= 0);

-- Cria a FK relacionando a tabela estoques com a tabela produtos
ALTER TABLE lojas.estoques 
ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Cria a FK relacionando a tabela estoques com a tabela lojas
ALTER TABLE lojas.estoques 
ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- Cria a tabela clientes com a PK cliente_id
CREATE TABLE lojas.clientes (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT clientes_pk PRIMARY KEY (cliente_id)
);
COMMENT ON TABLE lojas.clientes IS 'Tabela que representa os clientes de uma loja';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'Número de identificação de um cliente';
COMMENT ON COLUMN lojas.clientes.email IS 'Email de um cliente';
COMMENT ON COLUMN lojas.clientes.nome IS 'Nome do cliene';
COMMENT ON COLUMN lojas.clientes.telefone1 IS 'Número de telefone 1 do cliente';
COMMENT ON COLUMN lojas.clientes.telefone2 IS 'Número de telefone 2 do cliente';
COMMENT ON COLUMN lojas.clientes.telefone3 IS 'Número de telefone 3 do cliente';

-- Cria a tabela envios com a PK envio_id
CREATE TABLE lojas.envios (
                envio_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT envios_pk PRIMARY KEY (envio_id)
);
COMMENT ON TABLE lojas.envios IS 'Tabela que representa os envios dos produtos';
COMMENT ON COLUMN lojas.envios.envio_id IS 'Representa o número de identificação de um envio';
COMMENT ON COLUMN lojas.envios.loja_id IS 'Representa o número de identificação da loja que enviou';
COMMENT ON COLUMN lojas.envios.cliente_id IS 'Número de identificação do cliente que irá receber';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'Endereço de entrega do produto';
COMMENT ON COLUMN lojas.envios.status IS 'Status de entrega do produto (enviado, em transito, recebido)';

-- Cria a FK relacionando a tabela envios com a tabela lojas
ALTER TABLE lojas.envios 
ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Cria a FK relacionando a tabela envios com a tabela clientes
ALTER TABLE lojas.envios 
ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Cria a check constraint que determina os valores aceitos para a coluna status
ALTER TABLE lojas.envios
ADD CONSTRAINT check_status_pedidos
CHECK (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));


-- Cria a tabela pedidos com a PK pedido_id
CREATE TABLE lojas.pedidos (
                pedido_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status VARCHAR(15) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                CONSTRAINT pedidos_pk PRIMARY KEY (pedido_id)
);
COMMENT ON TABLE lojas.pedidos IS 'Tabela que representa os pedidos de uma loja';
COMMENT ON COLUMN lojas.pedidos.pedido_id IS 'Número de identificação de um pedido';
COMMENT ON COLUMN lojas.pedidos.data_hora IS 'Horário em que o pedido foi feito';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'Número de identificação do cliente que fez o pedido';
COMMENT ON COLUMN lojas.pedidos.status IS 'Status do pedido (cancelado, pago, envaido, aberto, reembolsado)';
COMMENT ON COLUMN lojas.pedidos.loja_id IS 'Número de identificação da loja que recebeu o pedido';

-- Cria a FK relacionando a tabela pedidos com a tabela lojas
ALTER TABLE lojas.pedidos 
ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Cria a FK relacionando a tabela pedidos com a tabela clientes
ALTER TABLE lojas.pedidos 
ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Cria a check constraint que determina os valores aceitos para a coluna status
ALTER TABLE lojas.pedidos
ADD CONSTRAINT check_status_pedidos
CHECK (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));


-- Cria a tabela pedidos_itens com a PK composta pedido_id e produito_id
CREATE TABLE lojas.pedidos_itens (
                pedido_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                envio_id NUMERIC(38),
                CONSTRAINT pedidos_itens_pk PRIMARY KEY (pedido_id, produto_id)
);
COMMENT ON TABLE lojas.pedidos_itens IS 'Tabela que representa os itens de determinado pedido';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id IS 'Número de identificação do pedido';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id IS 'Número de identificação dos produtos';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'Número da ordem do produto na lista do pedido';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario IS 'Preço de cada unidade dos produtos que estão no pedido';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade IS 'Quantidade de produtos que foram pedidos';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id IS 'Número de identificação do envio do pedido';

-- Cria a FK relacionando a tabela pedidos_itens com a tabela produtos
ALTER TABLE lojas.pedidos_itens 
ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Cria a FK relacionando a tabela pedidos_itens com a tabela envios
ALTER TABLE lojas.pedidos_itens 
ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Cria a FK relacionando a tabela pedidos_itens com a tabela pedidos
ALTER TABLE lojas.pedidos_itens 
ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Cria a check constraint que determina que a quantidade não pode ser negativa
ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT check_quantidade_pedidos
CHECK (quantidade >= 0);

-- Cria a check constraint que determina que o preço unitário não pode ser negativo
ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT check_preco_unitario_pedidos
CHECK (preco_unitario >= 0);
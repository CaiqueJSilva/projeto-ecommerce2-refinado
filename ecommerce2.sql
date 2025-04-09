create database ecommerce2;
use ecommerce2;	

-- criar tabela cliente (agora com PJ/PF)
create table clients(
	idClient int auto_increment primary key,
    clientType enum('PF', 'PJ') not null,
    Fname varchar(50) not null,
    Minit char(3),
    Lname varchar(50) not null,
    CPF char(11),
    CNPJ char(15),
    Address varchar(255),
    constraint unique_cpf_client unique (CPF),
    constraint unique_cnpj_client unique (CNPJ),
    constraint check_pj_pf check (
        (clientType = 'PF' AND CPF IS NOT NULL AND CNPJ IS NULL) OR
        (clientType = 'PJ' AND CNPJ IS NOT NULL AND CPF IS NULL)
    )
);


ALTER TABLE clients MODIFY COLUMN Lname VARCHAR(50);



-- criar tabela produto
create table product(
	idProduct int auto_increment primary key,
    Pname varchar(50) not null,
    Classification_kids bool default false,
    Category enum('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') not null,
    Avaliação float default 0,
    size varchar(10)
);

-- tabela de formas de pagamento (agora permitindo múltiplas formas por cliente)
create table payments (
	idPayment int auto_increment primary key,
    idClient int not null,
    typePayment enum('Dinheiro', 'Boleto', 'Cartão de Crédito', 'Cartão de Débito', 'PIX', 'Dois Cartões') not null,
    cardNumber varchar(20),
    cardName varchar(100),
    cardExpiry date,
    cardCVV varchar(4),
    PIXkey varchar(100),
    limitAvailable float,
    isActive bool default true,
    constraint fk_payment_client foreign key (idClient) references clients(idClient)
);

-- criar tabela pedido (com informações de entrega)
create table orders( 
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado', 'Confirmado', 'Em Processamento', 'Em separação', 'Enviado', 'Entregue') default 'Em Processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    trackingCode varchar(50),
    deliveryStatus enum('Preparando', 'Enviado', 'Em trânsito', 'Entregue', 'Devolvido') default 'Preparando',
    deliveryDate datetime,
    constraint fk_orders_client foreign key (idOrderClient) references clients(idClient) on update cascade
);

-- criar tabela estoque
create table productStorage(
	idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity float default 0
);
    
-- criar tabela fornecedor 
create table supplier(
	idSupplier int auto_increment primary key,
    socialName varchar(255) not null,
    CNPJ char(15) not null, 
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);

-- criar tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
	socialName varchar(255) not null,
    abstName varchar(255),
	CNPJ char(15),
    CPF char(11),
    location varchar(255),
	contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);

create table productSeller(
	idPseller int,
	idPproduct int,
	prodQuantity int default 1,
	primary key (idPseller, idPproduct),
	constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
	constraint fk_product_product foreign key (idPproduct) references product(idProduct) 
);

create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_product foreign key (idPOproduct) references product(idProduct),
	constraint fk_productorder_order foreign key (idPOorder) references orders(idOrder) 
);

create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null, 
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
	constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage) 
);

create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
);
-- Inserção de dados no modelo refinado
use ecommerce2;

-- Inserção de clientes (PF e PJ)
insert into Clients (clientType, Fname, Minit, Lname, CPF, CNPJ, Address) values
    ('PF', 'Maria', 'M', 'Silva', '12345678901', null, 'rua silva de prata 29, Carangola - Cidade das flores'),
    ('PF', 'Mateus', 'O', 'Pimentel', '98765432109', null, 'rua alameda 289, Centro - Cidade das flores'),
    ('PF', 'Ricardo', 'F', 'Silva', '45678913201', null, 'avenida alameda vinha 1009, Centro - Cidade das flores'),
    ('PF', 'Julia', 'S', 'França', '78912345601', null, 'rua laranjeiras 861, Centro - Cidade das flores'),
    ('PJ', 'Tech Solutions', null, null, null, '123456789012345', 'avenida koller 19, Centro - Cidade das flores'),
    ('PJ', 'Cruz & Associados', null, null, null, '654987321012345', 'rua alameda das flores 28, Centro - Cidade das flores');

-- Inserção de produtos
insert into product (Pname, Classification_kids, category, avaliação, size) values
    ('Fone de ouvido', false, 'Eletrônico', '4', null),
    ('Barbie Elsa', true, 'Brinquedos', '3', null),
    ('Body Carters', true, 'Vestimenta', '5', null),
    ('Microfone vedo - Youtuber', false, 'Eletrônico', '4', null),
    ('Sofá retrátil', false, 'Móveis', '3', '3x57x80'),
    ('Farinha de arroz', false, 'Alimentos', '2', null),
    ('Fire Stick Amazon', false, 'Eletrônico', '3', null);

-- Inserção de formas de pagamento
insert into payments (idClient, typePayment, cardNumber, cardName, cardExpiry, cardCVV, limitAvailable) values
    (19, 'Cartão de Crédito', '1234567812345678', 'MARIA M SILVA', '2025-12-01', '123', 5000.00),
    (20, 'PIX', null, null, null, null, null),
    (21, 'Cartão de Débito', '9876543298765432', 'MATEUS O PIMENTEL', '2024-10-01', '456', 3000.00),
    (22, 'Boleto', null, null, null, null, null),
    (23, 'Cartão de Crédito', '5555666677778888', 'TECH SOLUTIONS LTDA', '2026-05-01', '789', 15000.00);
    
SELECT idClient, Fname, Lname, clientType FROM clients;

-- Inserção de pedidos com informações de entrega
INSERT INTO orders (idOrderClient, orderStatus, orderDescription, sendValue, trackingCode, deliveryStatus) VALUES
    (19, 'Confirmado', 'compra via aplicativo', 15.00, 'BR123456789', 'Enviado'),
    (20, 'Em Processamento', 'compra via web site', 25.00, null, 'Preparando'),
    (23, 'Confirmado', 'compra corporativa', 0.00, 'BR987654321', 'Em trânsito'),
    (19, 'Confirmado', 'reposição de estoque', 10.00, 'BR456123789', 'Entregue'),
    (21, 'Cancelado', 'compra via aplicativo', null, null, null);
    
SELECT idClient, 
       CONCAT(Fname, ' ', COALESCE(Lname, '')) AS nome_cliente, 
       clientType 
FROM clients 
ORDER BY idClient;

-- Inserção de produtos nos pedidos
insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values
    (1, 6, 2, 'Disponível'),
    (5, 6, 1, 'Disponível'),
    (3, 7, 3, 'Disponível'),
    (7, 8, 5, 'Disponível'),
    (2, 9, 1, 'Disponível');
    
SELECT idOrder, idOrderClient, orderStatus 
FROM orders 
ORDER BY idOrder;

-- Inserção de estoque
insert into productStorage (storageLocation, quantity) values
    ('Rio de janeiro', 1000),
    ('Rio de janeiro', 500),
    ('São Paulo', 10),
    ('São Paulo', 100),
    ('São Paulo', 10),
    ('Brasilia', 60);

-- Inserção de fornecedores
insert into supplier (SocialName, CNPJ, contact) values
    ('Almeida e filhos', '123456789123456', '21985474'),
    ('Eletronicos Silva', '854519649143457', '21985484'),
    ('Eletronicos Valma', '934567893934695', '21975474');

-- Inserção de relação produto-fornecedor
insert into productSupplier (idPsSupplier, idPsProduct, quantity) values
    (1, 1, 500),
    (1, 2, 400),
    (2, 4, 633),
    (3, 3, 5),
    (2, 5, 10);

-- Inserção de vendedores
insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values
    ('Tech eletronics', null, '123456789456321', null, 'Rio de Janeiro', '219946287'),
    ('Botique Durgas', null, null, '12345678301', 'Rio de janeiro', '219567895'),
    ('Kids World', null, '456789123654485', null, 'São Paulo', '1198657484');

-- Inserção de relação produto-vendedor
insert into productSeller (idPseller, idPproduct, prodQuantity) values
    (1, 6, 80),
    (2, 7, 10);

-- Queries de consulta
-- Contagem de clientes
SELECT clientType, COUNT(*) as total FROM clients GROUP BY clientType;

-- Pedidos com status de entrega
SELECT 
    c.idClient,
    CONCAT(c.Fname, ' ', c.Lname) as Client,
    o.idOrder as OrderID,
    o.orderStatus as OrderStatus,
    o.trackingCode as Tracking,
    o.deliveryStatus as DeliveryStatus
FROM clients c
JOIN orders o ON c.idClient = o.idOrderClient;

-- Formas de pagamento por cliente
SELECT 
    c.idClient,
    CONCAT(c.Fname, ' ', c.Lname) as Client,
    p.typePayment as PaymentMethod,
    p.cardNumber as CardNumber,
    p.limitAvailable as CreditLimit
FROM clients c
JOIN payments p ON c.idClient = p.idClient
WHERE p.isActive = TRUE;

-- Produtos em estoque por localização
SELECT 
    p.Pname as Product,
    ps.storageLocation as Location,
    ps.quantity as Quantity
FROM product p
JOIN storageLocation sl ON p.idProduct = sl.idLproduct
JOIN productStorage ps ON sl.idLstorage = ps.idProdStorage;
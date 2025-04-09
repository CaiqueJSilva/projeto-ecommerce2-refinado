Alterações Realizadas no Refinamento do Modelo E-commerce

📌 Melhorias Implementadas no Modelo
1. Clientes PJ/PF
Adicionada distinção entre Pessoa Física (PF) e Pessoa Jurídica (PJ)

Campo clientType com enumeração ('PF', 'PJ')

Restrição CHECK para garantir que:

PF tenha apenas CPF (CNPJ nulo)

PJ tenha apenas CNPJ (CPF nulo)

Removida obrigatoriedade de Lname para PJ

2. Sistema de Pagamentos
Tabela payments reformulada para permitir múltiplos métodos por cliente

Tipos de pagamento expandidos:

'Dinheiro', 'Boleto', 'Cartão de Crédito', 'Cartão de Débito', 'PIX', 'Dois Cartões'

Campos adicionais para cada método:

Dados de cartão (número, nome, validade, CVV)

Chave PIX

Limite disponível

3. Gestão de Entregas
Adicionados campos na tabela orders:

trackingCode: código de rastreio

deliveryStatus: estágio da entrega ('Preparando', 'Enviado', 'Em trânsito', 'Entregue', 'Devolvido')

deliveryDate: data/hora da entrega

Status de pedido expandidos

4. Outras Melhorias
Aumento dos campos de texto:

Fname e Lname aumentados para VARCHAR(50)

Address aumentado para VARCHAR(255)

Correção de nomenclatura:

Classicification_kids → Classification_kids

Padronização de constraints:

Nomes mais descritivos para foreign keys

Validação de dados mais robusta

🔄 Mudanças na Estrutura do Banco
diff
Copy
CREATE TABLE clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
+   clientType ENUM('PF', 'PJ') NOT NULL,
    Fname VARCHAR(50) NOT NULL,
    Minit CHAR(3),
-   Lname VARCHAR(20) NOT NULL,
+   Lname VARCHAR(50),
-   CPF CHAR(11) NOT NULL,
+   CPF CHAR(11),
+   CNPJ CHAR(15),
    Address VARCHAR(255),
-   CONSTRAINT unique_cpf_client UNIQUE (CPF)
+   CONSTRAINT unique_cpf_client UNIQUE (CPF),
+   CONSTRAINT unique_cnpj_client UNIQUE (CNPJ),
+   CONSTRAINT check_pj_pf CHECK (...)
);
📊 Benefícios do Refinamento
Flexibilidade: Suporte completo a clientes PJ e PF

Pagamentos: Múltiplos métodos de pagamento por cliente

Rastreabilidade: Monitoramento completo do status de entregas

Validação: Verificações mais robustas de integridade

Usabilidade: Campos ampliados para dados reais

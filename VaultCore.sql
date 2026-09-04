DROP TABLE IF EXISTS account_owners;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS customer_profiles;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS account_types;

CREATE TABLE account_types (
    ID INT(11) NOT NULL AUTO_INCREMENT,
    TYPE_ACCOUNT VARCHAR(50) NOT NULL,
    DESCRIPTION VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (ID),
    UNIQUE KEY TYPE_ACCOUNT (TYPE_ACCOUNT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE customers (
    id INT(11) NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) DEFAULT NULL,
    phone VARCHAR(20) DEFAULT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP(),
    PRIMARY KEY (id),
    UNIQUE KEY email (email),
    UNIQUE KEY phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE accounts (
    ID INT(11) NOT NULL AUTO_INCREMENT,
    ACCOUNT_NUMBER VARCHAR(12) NOT NULL,
    BALANCE DECIMAL(15,2) NOT NULL,
    STATUS ENUM('ACTIVE','BLOCKED','CLOSED') DEFAULT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP(),
    account_type_id INT(11) DEFAULT NULL,
    PRIMARY KEY (ID),
    UNIQUE KEY ACCOUNT_NUMBER (ACCOUNT_NUMBER),
    KEY fk_account_type (account_type_id),
    CONSTRAINT fk_account_type
        FOREIGN KEY (account_type_id)
        REFERENCES account_types (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE account_owners (
    id INT(11) NOT NULL AUTO_INCREMENT,
    customer_id INT(11) NOT NULL,
    account_id INT(11) NOT NULL,
    PRIMARY KEY (id),
    KEY customer_id (customer_id),
    KEY account_id (account_id),
    CONSTRAINT account_owners_ibfk_1
        FOREIGN KEY (customer_id)
        REFERENCES customers (id),
    CONSTRAINT account_owners_ibfk_2
        FOREIGN KEY (account_id)
        REFERENCES accounts (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE customer_profiles (
    id INT(11) NOT NULL AUTO_INCREMENT,
    customer_id INT(11) NOT NULL,
    national_id VARCHAR(20) NOT NULL,
    address TEXT DEFAULT NULL,
    date_of_birth DATE DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY customer_id (customer_id),
    UNIQUE KEY national_id (national_id),
    CONSTRAINT customer_profiles_ibfk_1
        FOREIGN KEY (customer_id)
        REFERENCES customers (id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE transactions (
    id INT(11) NOT NULL AUTO_INCREMENT,
    sender_account_id INT(11) DEFAULT NULL,
    receiver_account_id INT(11) DEFAULT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_type ENUM('DEPOSIT','WITHDRAW','TRANSFER') NOT NULL,
    status ENUM('PENDING','COMPLETED','FAILED','CANCELLED') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP(),
    PRIMARY KEY (id),
    KEY sender_account_id (sender_account_id),
    KEY receiver_account_id (receiver_account_id),
    KEY idx_transactions_status (status),
    KEY idx_transactions_created_at (created_at),
    CONSTRAINT transactions_ibfk_1
        FOREIGN KEY (sender_account_id)
        REFERENCES accounts (ID),
    CONSTRAINT transactions_ibfk_2
        FOREIGN KEY (receiver_account_id)
        REFERENCES accounts (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE audit_logs (
    id INT(11) NOT NULL AUTO_INCREMENT,
    action VARCHAR(100) NOT NULL,
    description TEXT DEFAULT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP(),
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

INSERT INTO account_types VALUES
(1,'SAVINGS','Personal savings account'),
(2,'CURRENT','Daily transactons account'),
(3,'BUSINESS','Business banking account');

INSERT INTO customers VALUES
(1,'Arman','Kazemi','arman.k@example.com','09121110001','2026-09-04 13:14:48'),
(2,'Nima','Rahmani','nima.r@example.com','09121110002','2026-09-04 13:14:48'),
(3,'Yasmin','Moradi','yasmin.m@example.com','09121110003','2026-09-04 13:14:48'),
(4,'Pouya','Ebrahimi','pouya.e@example.com','09121110004','2026-09-04 13:14:48'),
(5,'Saleh','Hardani','saleh.j@example.com','09121110005','2026-09-04 13:14:48');

INSERT INTO accounts VALUES
(1,'621000000001',12000.00,'ACTIVE','2026-09-04 13:15:46',1),
(2,'621000000002',7800.50,'ACTIVE','2026-09-04 13:15:46',1),
(3,'621000000003',45500.00,'ACTIVE','2026-09-04 13:15:46',2),
(4,'621000000004',3200.00,'BLOCKED','2026-09-04 13:15:46',1),
(5,'621000000005',18500.75,'ACTIVE','2026-09-04 13:15:46',3),
(6,'621000000006',950.00,'CLOSED','2026-09-04 13:15:46',2);

INSERT INTO account_owners VALUES
(1,1,1),
(2,1,2),
(3,2,3),
(4,3,4),
(5,4,5),
(6,5,6),
(7,2,5);

INSERT INTO customer_profiles VALUES
(1,1,'1002456781','Tehran','1998-04-12'),
(2,2,'1002456782','Ahvaz','1997-09-21'),
(3,3,'1002456783','Shiraz','1999-01-08'),
(4,4,'1002456784','Isfahan','1996-11-15'),
(5,5,'1002456785','Baghmalek','1998-06-30');

INSERT INTO transactions VALUES
(1,1,3,500.00,'TRANSFER','COMPLETED','2026-09-04 13:17:27'),
(2,3,5,1250.00,'TRANSFER','COMPLETED','2026-09-04 13:17:27'),
(3,NULL,1,2000.00,'DEPOSIT','COMPLETED','2026-09-04 13:17:27'),
(4,2,NULL,300.00,'WITHDRAW','COMPLETED','2026-09-04 13:17:27'),
(5,4,1,700.00,'TRANSFER','FAILED','2026-09-04 13:17:27'),
(6,5,2,1500.00,'TRANSFER','PENDING','2026-09-04 13:17:27'),
(7,1,3,500.00,'TRANSFER','COMPLETED','2026-09-04 13:36:48'),
(8,2,5,250.00,'TRANSFER','COMPLETED','2026-09-04 13:40:20');

INSERT INTO audit_logs VALUES
(1,'ACCOUNT_CREATED','Account 621000000001 was created','2026-09-04 13:18:01'),
(2,'ACCOUNT_CREATED','Account 621000000002 was created','2026-09-04 13:18:01'),
(3,'TRANSACTION_COMPLETED','Transfer from account 1 to account 3 completed','2026-09-04 13:18:01'),
(4,'TRANSACTION_FAILED','Transfer from account 4 failed','2026-09-04 13:18:01'),
(5,'ACCOUNT_BLOCKED','Account 4 status changed to blocked','2026-09-04 13:18:01'),
(6,'TRANSACTION_CREATED','Transaction ID 8 was created','2026-09-04 13:40:20');

DELIMITER //

CREATE TRIGGER transaction_audit
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (action, description)
    VALUES (
        'TRANSACTION_CREATED',
        CONCAT('Transaction ID ', NEW.id, ' was created')
    );
END //

CREATE PROCEDURE transfer_money(
    IN sender_id INT,
    IN receiver_id INT,
    IN transfer_amount DECIMAL(15,2)
)
BEGIN
    DECLARE sender_balance DECIMAL(15,2);

    SELECT BALANCE
    INTO sender_balance
    FROM accounts
    WHERE ID = sender_id;

    IF sender_balance < transfer_amount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient balance';
    END IF;

    START TRANSACTION;

    UPDATE accounts
    SET BALANCE = BALANCE - transfer_amount
    WHERE ID = sender_id;

    UPDATE accounts
    SET BALANCE = BALANCE + transfer_amount
    WHERE ID = receiver_id;

    INSERT INTO transactions (
        sender_account_id,
        receiver_account_id,
        amount,
        transaction_type,
        status
    )
    VALUES (
        sender_id,
        receiver_id,
        transfer_amount,
        'TRANSFER',
        'COMPLETED'
    );

    COMMIT;
END //

DELIMITER ;

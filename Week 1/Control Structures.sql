
-- =========================================
-- DROP TABLES (optional safe rerun)
-- =========================================
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE loans';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE customers';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- =========================================
-- CREATE TABLES
-- =========================================
CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    age NUMBER,
    balance NUMBER,
    isvip VARCHAR2(10)
);

CREATE TABLE loans (
    loan_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    interest_rate NUMBER,
    due_date DATE
);

-- =========================================
-- INSERT SAMPLE DATA
-- =========================================
INSERT INTO customers VALUES (1, 'Arun', 65, 12000, 'FALSE');
INSERT INTO customers VALUES (2, 'Ravi', 45, 8000, 'FALSE');
INSERT INTO customers VALUES (3, 'Meena', 70, 20000, 'FALSE');

INSERT INTO loans VALUES (101, 1, 10, SYSDATE + 10);
INSERT INTO loans VALUES (102, 2, 12, SYSDATE + 40);
INSERT INTO loans VALUES (103, 3, 11, SYSDATE + 5);

COMMIT;

-- =========================================
-- SCENARIO 1: Age > 60 → Discount interest
-- =========================================
BEGIN
    FOR c IN (SELECT customer_id, age FROM customers) LOOP
        
        IF c.age > 60 THEN
            UPDATE loans
            SET interest_rate = interest_rate - 1
            WHERE customer_id = c.customer_id;
        END IF;

    END LOOP;

    COMMIT;
END;
/

-- =========================================
-- SCENARIO 2: Balance > 10000 → VIP
-- =========================================
BEGIN
    FOR c IN (SELECT customer_id, balance FROM customers) LOOP
        
        IF c.balance > 10000 THEN
            UPDATE customers
            SET isvip = 'TRUE'
            WHERE customer_id = c.customer_id;
        END IF;

    END LOOP;

    COMMIT;
END;
/

-- =========================================
-- SCENARIO 3: Loan reminder (next 30 days)
-- =========================================
BEGIN
    FOR l IN (
        SELECT c.name, l.loan_id, l.due_date
        FROM customers c
        JOIN loans l ON c.customer_id = l.customer_id
        WHERE l.due_date BETWEEN SYSDATE AND SYSDATE + 30
    ) LOOP
        
        DBMS_OUTPUT.PUT_LINE(
            'Reminder: ' || l.name ||
            ' | Loan ID: ' || l.loan_id ||
            ' | Due Date: ' || l.due_date
        );

    END LOOP;
END;
/

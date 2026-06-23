-- =========================================
-- TABLES
-- =========================================

CREATE TABLE accounts (
    account_id NUMBER PRIMARY KEY,
    account_type VARCHAR2(20),
    balance NUMBER
);

CREATE TABLE employees (
    emp_id NUMBER PRIMARY KEY,
    emp_name VARCHAR2(50),
    department VARCHAR2(30),
    salary NUMBER
);

-- =========================================
-- SAMPLE DATA
-- =========================================

INSERT INTO accounts VALUES (101, 'SAVINGS', 10000);
INSERT INTO accounts VALUES (102, 'SAVINGS', 20000);
INSERT INTO accounts VALUES (103, 'CURRENT', 15000);

INSERT INTO employees VALUES (1, 'Arun', 'IT', 50000);
INSERT INTO employees VALUES (2, 'Ravi', 'IT', 60000);
INSERT INTO employees VALUES (3, 'Meena', 'HR', 45000);

COMMIT;

-- =========================================
-- SCENARIO 1
-- Process Monthly Interest
-- =========================================

CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest
AS
BEGIN
    UPDATE accounts
    SET balance = balance + (balance * 0.01)
    WHERE account_type = 'SAVINGS';

    COMMIT;
END;
/

BEGIN
    ProcessMonthlyInterest;
    DBMS_OUTPUT.PUT_LINE('Monthly Interest Processed');
END;
/

-- =========================================
-- SCENARIO 2
-- Update Employee Bonus
-- =========================================

CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus(
    p_department IN VARCHAR2,
    p_bonus_percent IN NUMBER
)
AS
BEGIN
    UPDATE employees
    SET salary = salary + (salary * p_bonus_percent / 100)
    WHERE department = p_department;

    COMMIT;
END;
/

BEGIN
    UpdateEmployeeBonus('IT', 10);
    DBMS_OUTPUT.PUT_LINE('Employee Bonus Updated');
END;
/

-- =========================================
-- SCENARIO 3
-- Transfer Funds
-- =========================================

CREATE OR REPLACE PROCEDURE TransferFunds(
    p_from_account IN NUMBER,
    p_to_account IN NUMBER,
    p_amount IN NUMBER
)
AS
    v_balance NUMBER;
BEGIN
    SELECT balance
    INTO v_balance
    FROM accounts
    WHERE account_id = p_from_account;

    IF v_balance >= p_amount THEN
        UPDATE accounts
        SET balance = balance - p_amount
        WHERE account_id = p_from_account;

        UPDATE accounts
        SET balance = balance + p_amount
        WHERE account_id = p_to_account;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Transfer Successful');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Insufficient Balance');
    END IF;
END;
/

BEGIN
    TransferFunds(101, 102, 500);
END;
/

-- =========================================
-- VIEW RESULTS
-- =========================================

SELECT * FROM accounts;
SELECT * FROM employees;

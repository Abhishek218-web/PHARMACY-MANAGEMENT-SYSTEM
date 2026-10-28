SET SERVEROUTPUT ON;

-- Table to store medicine details
CREATE TABLE medicines (
    medicine_id NUMBER PRIMARY KEY,
    medicine_name VARCHAR2(100) NOT NULL,
    category VARCHAR2(50),
    price NUMBER(10,2) NOT NULL,
    stock_quantity NUMBER NOT NULL,
    expiry_date DATE
);

-- Table to store sales details
CREATE TABLE sales (
    sale_id NUMBER PRIMARY KEY,
    medicine_id NUMBER REFERENCES medicines(medicine_id),
    quantity NUMBER NOT NULL,
    total_amount NUMBER(10,2),
    sale_date DATE DEFAULT SYSDATE
);
INSERT INTO medicines VALUES
(101, 'Paracetamol', 'Tablet', 2.50, 100, DATE '2027-12-31');

INSERT INTO medicines VALUES
(102, 'Amoxicillin', 'Capsule', 5.00, 50, DATE '2027-06-30');

INSERT INTO medicines VALUES
(103, 'Cough Syrup', 'Syrup', 80.00, 8, DATE '2027-01-15');

INSERT INTO medicines VALUES
(104, 'Vitamin C', 'Supplement', 3.00, 30, DATE '2028-03-31');

COMMIT;
CREATE OR REPLACE FUNCTION calculate_total (
    p_medicine_id IN NUMBER,
    p_quantity IN NUMBER
)
RETURN NUMBER
IS
    v_price NUMBER(10,2);
BEGIN
    SELECT price
    INTO v_price
    FROM medicines
    WHERE medicine_id = p_medicine_id;

    RETURN v_price * p_quantity;
END;
/
CREATE OR REPLACE TRIGGER validate_pharmacy_sale
BEFORE INSERT ON sales
FOR EACH ROW
DECLARE
    v_stock NUMBER;
    v_expiry DATE;
BEGIN
    SELECT stock_quantity, expiry_date
    INTO v_stock, v_expiry
    FROM medicines
    WHERE medicine_id = :NEW.medicine_id;

    IF v_expiry < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(
            -20001, 'Cannot sell expired medicine.'
        );
    END IF;

    IF :NEW.quantity <= 0 THEN
        RAISE_APPLICATION_ERROR(
            -20002, 'Quantity must be greater than zero.'
        );
    END IF;

    IF v_stock < :NEW.quantity THEN
        RAISE_APPLICATION_ERROR(
            -20003, 'Insufficient medicine stock.'
        );
    END IF;
END;
/
CREATE OR REPLACE TRIGGER deduct_pharmacy_stock
AFTER INSERT ON sales
FOR EACH ROW
BEGIN
    UPDATE medicines
    SET stock_quantity = stock_quantity - :NEW.quantity
    WHERE medicine_id = :NEW.medicine_id;
END;
/
CREATE OR REPLACE PROCEDURE add_medicine (
    p_id IN NUMBER,
    p_name IN VARCHAR2,
    p_category IN VARCHAR2,
    p_price IN NUMBER,
    p_stock IN NUMBER,
    p_expiry IN DATE
)
IS
BEGIN
    INSERT INTO medicines (
        medicine_id,
        medicine_name,
        category,
        price,
        stock_quantity,
        expiry_date
    )
    VALUES (
        p_id,
        p_name,
        p_category,
        p_price,
        p_stock,
        p_expiry
    );

    DBMS_OUTPUT.PUT_LINE('Medicine added successfully.');
END;
/
CREATE OR REPLACE PROCEDURE sell_medicine (
    p_sale_id IN NUMBER,
    p_medicine_id IN NUMBER,
    p_quantity IN NUMBER
)
IS
    v_total NUMBER(10,2);
BEGIN
    v_total := calculate_total(
        p_medicine_id,
        p_quantity
    );

    INSERT INTO sales (
        sale_id,
        medicine_id,
        quantity,
        total_amount
    )
    VALUES (
        p_sale_id,
        p_medicine_id,
        p_quantity,
        v_total
    );

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Sale completed successfully.');
    DBMS_OUTPUT.PUT_LINE('Total amount: Rs. ' || v_total);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Sale failed: ' || SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE show_low_stock
IS
    CURSOR medicine_cursor IS
        SELECT medicine_id, medicine_name, stock_quantity
        FROM medicines
        WHERE stock_quantity < 10;

    v_id medicines.medicine_id%TYPE;
    v_name medicines.medicine_name%TYPE;
    v_stock medicines.stock_quantity%TYPE;
BEGIN
    OPEN medicine_cursor;

    LOOP
        FETCH medicine_cursor INTO v_id, v_name, v_stock;
        EXIT WHEN medicine_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'ID: ' || v_id ||
            ' | Medicine: ' || v_name ||
            ' | Stock: ' || v_stock
        );
    END LOOP;

    CLOSE medicine_cursor;
END;
/
CREATE OR REPLACE PROCEDURE show_expired_medicines
IS
    CURSOR expired_cursor IS
        SELECT medicine_id, medicine_name, expiry_date
        FROM medicines
        WHERE expiry_date < TRUNC(SYSDATE);

BEGIN
    FOR medicine_record IN expired_cursor
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'ID: ' || medicine_record.medicine_id ||
            ' | Medicine: ' || medicine_record.medicine_name ||
            ' | Expired on: ' ||
            TO_CHAR(medicine_record.expiry_date, 'DD-MON-YYYY')
        );
    END LOOP;
END;
/
SELECT * FROM medicines
ORDER BY medicine_id;
SELECT
    s.sale_id,
    m.medicine_name,
    s.quantity,
    s.total_amount,
    s.sale_date
FROM sales s
JOIN medicines m
    ON s.medicine_id = m.medicine_id
ORDER BY s.sale_id;
SELECT
    medicine_id,
    medicine_name,
    stock_quantity
FROM medicines
ORDER BY medicine_id;
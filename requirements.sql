--1) Procedure which does group by information 
CREATE OR REPLACE PROCEDURE get_customer_order_totals (
    p_start_date IN DATE,
    p_end_date IN DATE
)
IS
BEGIN
    FOR r IN (
        SELECT c.customer_id, c.firstname, c.lastname, SUM(o.totalamount) as total_orders
        FROM customers c
        INNER JOIN orders o ON c.customer_id = o.customer_id
        WHERE o.orderdate BETWEEN p_start_date AND p_end_date
        GROUP BY c.customer_id, c.firstname, c.lastname
        ORDER BY total_orders DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Customer ID: ' || r.customer_id || ', Name: ' || r.firstname || ' ' || r.lastname || ', Total Orders: ' || r.total_orders);
    END LOOP;
END;

--2) Function which counts the number of records
CREATE OR REPLACE FUNCTION count_records(
    p_table_name IN VARCHAR2
) RETURN NUMBER
IS
    l_count NUMBER;
BEGIN
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || p_table_name INTO l_count;
    RETURN l_count;
END;

--3) Procedure which uses SQL%ROWCOUNT to determine the number of rows affected
CREATE OR REPLACE PROCEDURE update_stock (
    p_publisher_id IN NUMBER,
    p_stock_change IN NUMBER
) AS
BEGIN
    UPDATE books
    SET stock = stock + p_stock_change
    WHERE publisher_id = p_publisher_id;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' book(s) updated.');
END;


--4) Trigger before insert on any entity which will show the current number of rows in the table
CREATE OR REPLACE TRIGGER trg_count_rows
BEFORE INSERT ON books
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM books;
    DBMS_OUTPUT.PUT_LINE('Number of rows in the table before insert: ' || v_count);
END;

--5) User-defined exception which disallows to enter title of item (e.g. book) to be less than 5 characters
CREATE OR REPLACE PROCEDURE Insert_Book(
  p_title IN VARCHAR2,
  p_author_id IN NUMBER,
  p_publisher_id IN NUMBER,
  p_publishdate IN DATE,
  p_pages IN NUMBER,
  p_price IN NUMBER,
  p_isbn IN VARCHAR2,
  p_cover IN VARCHAR2,
  p_stock IN number
)
IS
  EX_title_too_short EXCEPTION;
  EX_invalid_isbn EXCEPTION;
BEGIN
  IF LENGTH(p_title) < 5 THEN
    RAISE EX_title_too_short;
  ELSIF LENGTH(p_isbn) < 13 THEN
    RAISE EX_invalid_isbn;
  ELSE
    INSERT INTO Books(
      title,
      author_id,
      publisher_id,
      publishdate,
      pages,
      price,
      isbn,
      cover,
      stock
    ) VALUES (
      p_title,
      p_author_id,
      p_publisher_id,
      p_publishdate,
      p_pages,
      p_price,
      p_isbn,
      p_cover,
      p_stock
    );
  END IF;
EXCEPTION
  WHEN EX_title_too_short THEN
    DBMS_OUTPUT.PUT_LINE('Book title must be at least 5 characters long.');
  WHEN EX_invalid_isbn THEN
    DBMS_OUTPUT.PUT_LINE('Book ISBN must be at least 13 characters long.');
END;

--PROCEDURES
--1)
create or replace PROCEDURE get_books_by_publisher(publisher_name IN VARCHAR, book_list OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN book_list FOR
  SELECT *
  FROM Book b
  JOIN Publisher p ON b.PublisherID = p.PublisherID
  WHERE p.Name = publisher_name;
END;

--2)
create or replace PROCEDURE group_by_info
IS
  CURSOR c_grouped_data IS
    SELECT author_id, publisher_id, AVG(price) AS average
    FROM books
    GROUP BY author_id, publisher_id;
BEGIN
  FOR r_grouped_data IN c_grouped_data LOOP
    DBMS_OUTPUT.PUT_LINE('Author ID: ' || r_grouped_data.author_id || ', Publisher ID: ' || r_grouped_data.publisher_id || ', Average Price: ' || r_grouped_data.average);
  END LOOP;
END;

--FUNCTIONS
--3)
create or replace FUNCTION calculate_book_revenue(book_id IN INT)
RETURN DECIMAL(10, 2)
IS
  total_revenue DECIMAL(10, 2);
BEGIN
  SELECT SUM(Price * Quantity) INTO total_revenue
  FROM Sale
  WHERE BookID = book_id;
  RETURN total_revenue;
END;

--4)
create or replace FUNCTION check_phone(publisher_id IN NUMBER)
RETURN VARCHAR2
IS
  publisher_phone VARCHAR2(255);
BEGIN
  SELECT phone INTO publisher_phone FROM publishers WHERE publisher_id = check_phone.publisher_id;
  
  IF publisher_phone IS NOT NULL THEN
    RETURN 'Phone number is valid.';
  ELSE
    RETURN 'Phone number is missing.';
  END IF;
END;

--5)
create or replace FUNCTION count_records
RETURN NUMBER
IS
  record_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO record_count FROM orders;
  RETURN record_count;
END;

--6)
create or replace FUNCTION get_average_salary_by_role(IN role_name VARCHAR(50))
RETURNS DECIMAL(10, 2)
BEGIN
  DECLARE avg_salary DECIMAL(10, 2);
  SELECT AVG(e.Salary) INTO avg_salary
  FROM Employee e
  JOIN EmployeeRole er ON e.EmployeeID = er.EmployeeID
  JOIN Role r ON er.RoleID = r.RoleID
  WHERE r.Name = role_name;
  RETURN avg_salary;
END;

--7)
create or replace FUNCTION get_avg_salary_by_role(role_name VARCHAR(50))
RETURNS DECIMAL(10, 2)
BEGIN
  DECLARE avg_salary DECIMAL(10, 2);
  SELECT AVG(e.Salary) INTO avg_salary
  FROM Employee e
  JOIN EmployeeRole er ON e.EmployeeID = er.EmployeeID
  JOIN Role r ON er.RoleID = r.RoleID
  WHERE r.Name = role_name;
  RETURN avg_salary;
END;

--TRIGGERS
--8)
create or replace TRIGGER check_phone_number
BEFORE INSERT ON PUBLISHERS
FOR EACH ROW
DECLARE
  invalid_number EXCEPTION;
BEGIN
  IF (:NEW.PHONE NOT LIKE '+7%' AND :NEW.PHONE NOT LIKE '8%') THEN
    RAISE invalid_number;
  END IF;
EXCEPTION
  WHEN invalid_number THEN
    raise_application_error(-20001, 'Your Phone Number is not our region');
END;

--9)
create or replace TRIGGER check_phone_number2
BEFORE INSERT ON PUBLISHERS
FOR EACH ROW
DECLARE
  invalid_number EXCEPTION;

BEGIN
  IF (:NEW.PHONE NOT LIKE '+77' AND :NEW.PHONE NOT LIKE '87' and (length(:new.phone) <> 11)) THEN
    RAISE invalid_number;
  END IF;
EXCEPTION
  WHEN invalid_number THEN
    raise_application_error(-20001, 'Your Phone Number is not our region');
END;

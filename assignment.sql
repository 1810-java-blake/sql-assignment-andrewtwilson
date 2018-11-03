-- Part I – Working with an existing database

-- 1.0	Setting up Oracle Chinook
-- In this section you will begin the process of working with the Oracle Chinook database
-- Task – Open the Chinook_Oracle.sql file and execute the scripts within.
-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Oracle Chinook database.
-- 2.1 SELECT
-- Task – Select all records from the Employee table.
SELECT * FROM employee;
-- Task – Select all records from the Employee table where last name is King.
SELECT * FROM employee 
WHERE lastname='King';
-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
SELECT * FROM employee 
WHERE lastname='King' AND reportsto=null;
-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
SELECT * FROM album
ORDER BY title DESC;
-- Task – Select first name from Customer and sort result set in ascending order by city
SELECT firstname from customer
ORDER BY city ASC;
-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table
INSERT INTO genre
VALUES (26, 'Drewsblues');
INSERT INTO genre
VALUES (27, 'Another Genre');
-- Task – Insert two new records into Employee table
INSERT INTO employee
VALUES (9, 'Wilson', 'Andrew', 'IT Staff', 6, '1992-09-21 00:00:00', '1990-01-01 00:00:00', '448 Melvill Cres.', 'Philomath', 'OR', 'US', 'K3J 9D9', '+1 (615) 517-9958', '+1 (923) 436-4575', 'wilson@gmail.com');
INSERT INTO employee
VALUES (10, 'Willy', 'Drew', 'Boss', null, '1700-03-24 00:00:00', '1700-03-25 00:00:00', '1000 Main', 'Dallas', 'TX', 'US', 'A9G 2D8', '+1 (100) 911-9911', '+1 (103) 230-1309', 'boss@gmail.com');
-- Task – Insert two new records into Customer table
INSERT INTO customer
VALUES (60, 'John', 'Smith', null, '240 1st St.', 'Raleigh', 'NC', 'US', '29043', '+1 (232) 232-2316', null, 'adkjl@gmail.com', 2);
INSERT INTO customer
VALUES (61, 'James', 'Dula', null, '232 2nd ST.', 'Columbia', 'SC', 'US', '28380', '+1 (890) 294-1990', null, 'kljj@gmail.com', 3);
-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
UPDATE customer
SET firstname='Robert'
WHERE customerid=32;
UPDATE customer
SET lastname='Walter'
WHERE customerid=32;
-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
UPDATE artist
SET name='CCR'
WHERE name='Creedence Clearwater Revival';
-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
SELECT * FROM invoice
WHERE billingaddress LIKE 'T%';
-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
SELECT * FROM invoice
WHERE total BETWEEN 15 AND 50;
-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
SELECT * FROM employee
WHERE hiredate BETWEEN '2003-06-01 00:00:00' AND '2004-03-01 00:00:00';
-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
ALTER TABLE invoice DROP 
CONSTRAINT fk_invoicecustomerid;

ALTER TABLE invoice ADD 
CONSTRAINT fk_invoicecustomerid
FOREIGN KEY (customerid)
REFERENCES customer (customerid)
ON DELETE CASCADE;

ALTER TABLE invoiceline DROP 
CONSTRAINT fk_invoicelineinvoiceid;

ALTER TABLE invoiceline ADD 
CONSTRAINT fk_invoicelineinvoiceid
FOREIGN KEY (invoiceid)
REFERENCES invoice (invoiceid)
ON DELETE CASCADE;

DELETE FROM customer
WHERE firstname='Robert' AND lastname='Walter';
-- 3.0	SQL Functions
-- In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
CREATE OR REPLACE FUNCTION my_time()
RETURNS timestamp AS $$
BEGIN
	RETURN now()::timestamp;
END;
$$ LANGUAGE plpgsql;
-- Task – create a function that returns the length of a mediatype from the mediatype table
CREATE OR REPLACE FUNCTION length_of_mediatype(mediaid INTEGER)
RETURNS INTEGER AS $$
DECLARE
	medianame VARCHAR;
BEGIN
	SELECT name FROM mediatype
	INTO medianame
	WHERE mediatypeid = mediaid;

	RETURN length(medianame);
END;
$$ LANGUAGE plpgsql;
-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
CREATE OR REPLACE FUNCTION invoice_average_total()
RETURNS NUMERIC AS $$
DECLARE
	average NUMERIC;
BEGIN
	SELECT avg(total) FROM invoice
	INTO average;
	
	RETURN average;
END;
$$ LANGUAGE plpgsql;
-- Task – Create a function that returns the most expensive track
CREATE OR REPLACE FUNCTION most_expensive_track()
RETURNS VARCHAR AS $$
DECLARE
	amount NUMERIC;
	expensive_track VARCHAR;
BEGIN
	SELECT max(unitprice) FROM track
	INTO amount;
	
	SELECT name FROM track
	INTO expensive_track
	WHERE unitprice = amount;
	
	RETURN expensive_track;
END;
$$ LANGUAGE plpgsql;
-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
CREATE OR REPLACE FUNCTION invoiceline_avg_price()
RETURNS NUMERIC AS $$
DECLARE
	average NUMERIC;
BEGIN
	SELECT avg(unitprice) FROM invoiceline
	INTO average;
	
	RETURN average;
END;
$$ LANGUAGE plpgsql;
-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees who are born after 1968.
CREATE OR REPLACE FUNCTION born_after()
RETURNS TABLE (
id INTEGER
) 
AS $$
BEGIN
	RETURN QUERY SELECT employeeid FROM employee
	WHERE (birthdate > '1969-01-01 00:00:00');
END;
$$ LANGUAGE plpgsql;
-- 4.0 Stored Procedures
--  In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
-- 4.1 Basic Stored Procedure
-- Task – Create a stored procedure that selects the first and last names of all the employees.
CREATE OR REPLACE FUNCTION first_and_last()
RETURNS TABLE (
first VARCHAR,
last VARCHAR
) 
AS $$
BEGIN
	RETURN QUERY SELECT firstname, lastname FROM employee;
END;
$$ LANGUAGE plpgsql;
-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
CREATE OR REPLACE FUNCTION edit_employee(
	id INTEGER,
	ln VARCHAR(20),
	fn VARCHAR(20),
	t VARCHAR(30),
	rt INTEGER,
	bd TIMESTAMP,
	hd TIMESTAMP,
	a VARCHAR(70),
	ci VARCHAR(40),
	s VARCHAR(40),
	co VARCHAR(40),
	pc VARCHAR(10),
	p VARCHAR(24),
	f VARCHAR(24),
	e VARCHAR(60))
RETURNS VOID AS $$
BEGIN
	UPDATE employee
	SET lastname=ln,
        firstname=fn,
        title=t,
        reportsto=rt,
        birthdate=bd,
        hiredate=hd,
        address=a,
        city=ci,
        state=s,
        country=co,
        postalcode=pc,
        phone=p,
        fax=f,
        email=e
	 WHERE employee.employeeid = id;
END;
$$ LANGUAGE plpgsql;
-- Task – Create a stored procedure that returns the managers of an employee.
CREATE OR REPLACE FUNCTION find_manager(id INTEGER)
RETURNS TABLE (
managerid INTEGER
) 
AS $$
BEGIN
	SELECT reportsto FROM employee
	AS boss
	WHERE employeeid = id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM first_and_last();
-- 4.3 Stored Procedure Output Parameters
-- Task – Create a stored procedure that returns the name and company of a customer.
CREATE OR REPLACE FUNCTION find_manager(id INTEGER)
RETURNS TABLE (
managerid INTEGER,
managerlastname VARCHAR(20),
manageridfirstname VARCHAR(20)
) 
AS $$
BEGIN
	RETURN QUERY SELECT employeeid, lastname, firstname FROM employee
	WHERE employeeid = (
		SELECT reportsto FROM employee
		AS boss
		WHERE employeeid = id
		);
END;
$$ LANGUAGE plpgsql;
-- 5.0 Transactions
-- In this section you will be working with transactions. Transactions are usually nested within a stored procedure. You will also be working with handling errors in your SQL.
-- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
ALTER TABLE invoice DROP 
CONSTRAINT fk_invoicecustomerid;

ALTER TABLE invoice ADD 
CONSTRAINT fk_invoicecustomerid
FOREIGN KEY (customerid)
REFERENCES customer (customerid)
ON DELETE CASCADE;

ALTER TABLE invoiceline DROP 
CONSTRAINT fk_invoicelineinvoiceid;

ALTER TABLE invoiceline ADD 
CONSTRAINT fk_invoicelineinvoiceid
FOREIGN KEY (invoiceid)
REFERENCES invoice (invoiceid)
ON DELETE CASCADE;

CREATE OR REPLACE FUNCTION delete_invoice(id INTEGER)
RETURNS VOID
AS $$
BEGIN
	DELETE FROM invoice
	WHERE invoiceid = id;
END;
$$ LANGUAGE plpgsql;
-- Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
CCREATE OR REPLACE FUNCTION new_customer(
	id INTEGER,
	fn VARCHAR(20),
	ln VARCHAR(20),
	c VARCHAR(80),
	a VARCHAR(70),
	ci VARCHAR(40),
	s VARCHAR(40),
	co VARCHAR(40),
	pc VARCHAR(10),
	p VARCHAR(24),
	f VARCHAR(24),
	e VARCHAR(60),
	sid INTEGER
)
RETURNS VOID
AS $$
DECLARE 
	c1 INTEGER;
BEGIN
	SELECT customerid INTO c1 FROM customer
	WHERE customerid = id;
	
	IF c1 != null THEN 
		INSERT INTO customer
		VALUES (id, fn, ln, c, a, ci, s, co, pc, p, f, e, sid);
	END IF;
END;
$$ LANGUAGE plpgsql;
-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
CREATE OR REPLACE FUNCTION employee_trigger()
RETURNS TRIGGER AS $$
BEGIN
	-- Put your code here.
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_on_new_employee
AFTER INSERT ON employee
FOR EACH ROW
EXECUTE PROCEDURE employee_trigger();
-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table
CREATE OR REPLACE FUNCTION update_album()
RETURNS TRIGGER AS $$
BEGIN
	IF(TG_OP = 'INSERT') THEN
		-- Put your code here.
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_on_album_update
AFTER UPDATE ON album
FOR EACH ROW
EXECUTE PROCEDURE update_album();
-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
CREATE OR REPLACE FUNCTION delete_customer()
RETURNS TRIGGER AS $$
BEGIN
--  Put your code here.
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_on_customer_delete
AFTER DELETE ON customer
FOR EACH ROW
EXECUTE PROCEDURE delete_customer();
-- 6.2 Before
-- Task – Create a before trigger that restricts the deletion of any invoice that is priced over 50 dollars.
CREATE OR REPLACE FUNCTION delete_invoice_check()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.total > 50 THEN
	RAISE EXCEPTION 'This invoice is priced over 50 dollars!';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_on_invoice_delete
BEFORE DELETE ON invoice
FOR EACH ROW
EXECUTE PROCEDURE delete_invoice_check();
-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
SELECT customer.firstname, customer.lastname, invoice.invoiceid
FROM customer
INNER JOIN invoice
ON customer.customerid = invoice.customerid;
-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
SELECT customer.customerid, customer.firstname, customer.lastname, invoice.invoiceid, invoice.total
FROM customer
FULL OUTER JOIN invoice
ON customer.customerid = invoice.customerid;
-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
SELECT artist.name, album.title
FROM album
RIGHT JOIN artist
ON artist.artistid = album.artistid;
-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
SELECT * FROM album
CROSS JOIN artist
ORDER BY name ASC;
-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
SELECT * FROM employee
AS e1
INNER JOIN employee as e2
ON e1.reportsto = e2.reportsto;
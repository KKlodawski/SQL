--Z1
CREATE TRIGGER zad1 
ON emp
FOR DELETE
AS 
ROLLBACK

--Z2
CREATE TRIGGER zad2
ON emp 
FOR INSERT
AS
DECLARE @comm INT, @empno INT
SELECT @comm = comm, @empno = empno FROM inserted
IF @comm IS NULL
	UPDATE emp SET comm = 0 WHERE empno = @empno

------------

CREATE TRIGGER zad2a1
ON emp
FOR INSERT
AS
UPDATE emp
SET comm = 0
WHERE comm IS NULL
AND empno IN (SELECT empno FROM inserted)

--Z3
CREATE TRIGGER zad3
ON emp
AFTER INSERT, UPDATE
AS
DECLARE @sal INT
SELECT @sal = sal FROM inserted
IF @sal < 1000
	ROLLBACK
	RAISERROR('Zla wartosc',1,2);


INSERT INTO emp VALUES(234,'AWD','JBO', NULL, 10-10-2000, 900, 10, 10)
SELECT * FROM emp
DROP TRIGGER zad3

UPDATE emp SET sal = 1002 WHERE empno=7369
UPDATE emp SET sal = sal+1 WHERE deptno=20

--Z4
CREATE TABLE budzet (wartosc INT NOT NULL)
INSERT INTO budzet (wartosc)
SELECT SUM(sal) FROM emp
SELECT * FROM budzet

CREATE TRIGGER Z4
ON emp
AFTER INSERT, DELETE, UPDATE
AS BEGIN
	DECLARE @zmniejsz INT,@zwieksz INT
	SELECT @zmniejsz = SUM(sal) FROM deleted
	SELECT @zwieksz = SUM(sal) FROM inserted
	UPDATE budzet SET wartosc = wartosc - ISNULL(@zmniejsz,1) + ISNULL(@zwieksz,0)
END

DELETE FROM budzet WHERE wartosc = 25496
DROP TRIGGER Z4

--Z5
CREATE TRIGGER Z5
ON dept 
FOR UPDATE 
AS BEGIN
	IF UPDATE(dname) BEGIN
		ROLLBACK
		RAISERROR('Nie mozna zmieniac nazw działó',1,2)
	END
END

---
CREATE TRIGGER Z5a1
ON DEPT
FOR UPDATE
AS BEGIN
IF EXISTS (
	SELECT 'X' FROM inserted
	INNER JOIN deleted ON inserted.deptno = deleted.DEPTNO
	WHERE inserted.DNAME <> deleted.DNAME) BEGIN
		ROLLBACK
		RAISERROR('Nie mozna zmieniac nazw działów!', 1,2)
	END
END

--Z6

CREATE TRIGGER Z6
ON dept
FOR DELETE, UPDATE
AS BEGIN 
	DECLARE @sal INT
	SELECT @sal = sal FROM deleted
	IF @sal > 0 
	BEGIN
		ROLLBACK
	end
	IF EXISTS (
	
	END
END



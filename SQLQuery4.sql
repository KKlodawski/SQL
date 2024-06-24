-- Z1
DECLARE kurs CURSOR FOR SELECT empno, ename, sal FROM emp WHERE sal<1000 OR sal>1500
DECLARE @empno INT, @ename VARCHAR(10), @sal int

OPEN kurs
FETCH NEXT FROM kurs INTO @empno, @ename, @sal
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @sal < 1000 BEGIN
		SET @sal = @sal * 1.1
		UPDATE emp SET sal = @sal WHERE CURRENT OF kurs
		PRINT 'Zwiekszono: ' + @ename + ' ' + CONVERT(VARCHAR,@sal)
	END
	IF @sal > 1500 BEGIN
		SET @sal = @sal * 0.9
		UPDATE emp SET sal = @sal WHERE empno = @empno
		PRINT 'Zmniejszono: ' + @ename + ' ' + CONVERT(VARCHAR,@sal)
	END
	FETCH NEXT FROM kurs INTO @empno, @ename, @sal
END
CLOSE kurs
DEALLOCATE kurs

--Z2
CREATE PROCEDURE pensje
	@minimalna INT,
	@maksymalna INT
AS BEGIN
	DECLARE kurs CURSOR FOR SELECT empno, ename, sal FROM emp
	DECLARE @empno INT, @ename VARCHAR(10), @sal int

	OPEN kurs
	FETCH NEXT FROM kurs INTO @empno, @ename, @sal
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @sal < @minimalna BEGIN
			SET @sal = @sal * 1.1
			UPDATE emp SET sal = @sal WHERE CURRENT OF kurs
			PRINT 'Zwiekszono: ' + @ename + ' ' + CONVERT(VARCHAR,@sal)
		END
		IF @sal > @maksymalna BEGIN
			SET @sal = @sal * 0.9
			UPDATE emp SET sal = @sal WHERE empno = @empno
			PRINT 'Zmniejszono: ' + @ename + ' ' + CONVERT(VARCHAR,@sal)
		END
		FETCH NEXT FROM kurs INTO @empno, @ename, @sal
	END
	CLOSE kurs
	DEALLOCATE kurs
END
--

EXEC pensje 1000,1500

--Z3
CREATE PROCEDURE aver
	@deptno INT
AS BEGIN
	UPDATE emp
	SET comm = sal*0.05
	WHERE sal<(SELECT AVG(sal) FROM emp WHERE deptno=@deptno) AND deptno=@deptno
END
			
CREATE PROCEDURE aver
	@deptno INT
AS BEGIN
	DECLARE @avg NUMERIC(10,2)
	SELECT @avg=AVG(sal) FROM emp WHERE deptno=@deptno
	UPDATE emp SET comm=sal*0.05
	WHERE sal<@avg AND deptno=@deptno
END
--Z4
CREATE TABLE Magazyn (
    IdPozycji INT,
	Nazwa VARCHAR(20),
	Ilosc INT,
	
	PRIMARY KEY(IdPozycji)
);

INSERT INTO Magazyn VALUES(0, 'ABC', 30);
INSERT INTO Magazyn VALUES(1, 'ABCE', 20);
INSERT INTO Magazyn VALUES(2, 'ABCG', 10);
INSERT INTO Magazyn VALUES(3, 'ACC', 50);
INSERT INTO Magazyn VALUES(4, 'AGE', 5);

CREATE PROCEDURE Z4
	
AS BEGIN 
	DECLARE @max INT,
			@id INT
	SELECT @max=Ilosc, @id=IdPozycji FROM Magazyn WHERE Ilosc=(SELECT MAX(ilosc) FROM Magazyn)
	IF(@max >= 5) 
		UPDATE Magazyn SET ilosc=@max-5 WHERE IdPozycji=@id
	ELSE
		PRINT 'Zbyt malo towaru'
END

EXEC Z4
SELECT * FROM Magazyn

--Z5
CREATE PROCEDURE Z5
	@value INT
AS BEGIN 
	DECLARE @max INT,
			@id INT
	SELECT @max=Ilosc, @id=IdPozycji FROM Magazyn WHERE Ilosc=(SELECT MAX(ilosc) FROM Magazyn)
	IF(@max >= 5) 
		UPDATE Magazyn SET ilosc=@max-@value WHERE IdPozycji=@id
	ELSE
		PRINT 'Zbyt malo towaru'
END

EXEC Z5 4
SELECT * FROM Magazyn
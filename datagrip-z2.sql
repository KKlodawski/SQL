DECLARE
    CURSOR z1 IS SELECT empno, ename, sal FROM emp WHERE sal<1000 OR sal>1500;
    id INT;
    name VARCHAR(50);
    tmpsal int;
BEGIN
    OPEN z1;
    LOOP
    FETCH z1 INTO id, name, tmpsal;
    IF tmpsal < 1000 THEN
		tmpsal := tmpsal * 1.1;
		UPDATE emp SET sal = tmpsal WHERE empno = id;
		dbms_output.put_line('Zwiekszono: ' || name || ' ' || tmpsal);
	END IF;
	IF tmpsal > 1500 THEN
		tmpsal := tmpsal * 0.9;
		UPDATE emp SET sal = tmpsal WHERE empno = id;
		dbms_output.put_line('Zmniejszono: ' || name || ' ' || tmpsal);
	END IF;
    EXIT WHEN z1%NOTFOUND;
    END LOOP;
end;

SELECT * FROM emp;

--z2
CREATE PROCEDURE pensje (minimalna INT,maksymalna INT) AS
    CURSOR z2 IS SELECT empno, ename, sal FROM emp;
        id INT;
        name VARCHAR(10);
        tmpsal int;
BEGIN

	OPEN z2;
	LOOP
	    FETCH z2 INTO id, name, tmpsal;
		IF tmpsal < minimalna THEN
			tmpsal := tmpsal * 1.1;
			UPDATE emp SET sal = tmpsal WHERE EMPNO = id;
			dbms_output.put_line('Zwiekszono: ' || name || ' ' || tmpsal);
        END IF;
		IF tmpsal > maksymalna THEN
			tmpsal := tmpsal * 0.9;
			UPDATE emp SET sal = tmpsal WHERE empno = id;
			dbms_output.put_line('Zmniejszono: ' || name || ' ' || tmpsal);
		END IF;
		EXIT WHEN z2%NOTFOUND;
	END LOOP;
END;

DROP PROCEDURE pensje;


BEGIN
    pensje(500,1500);
end;

--z3

CREATE PROCEDURE aver (dept INT) AS
    avg NUMERIC(10,2);
BEGIN
    SELECT AVG(sal) INTO avg FROM emp WHERE deptno=dept;
	UPDATE emp SET comm=sal*0.05 WHERE sal<avg AND deptno=dept;
END;

DROP PROCEDURE aver;
SELECT * FROM emp;

BEGIN
    aver(20);
end;

--z5
CREATE PROCEDURE zmniejsz
AS
    maxId INT;
    stan INT;
BEGIN
    SELECT max(idpozycji), ilosc INTO maxId, stan FROM magazyn
    WHERE Ilosc = (SELECT max(ilosc) FROM magazyn)
    group by ilosc;
    if(stan >= 5) THEN
        UPDATE magazyn SET ilosc = ilosc - 5 WHERE IDPOZYCJI = maxId;
    else
        raise_application_error(-20500,'Niewystarczajaca ilość towaru!');
    end if;
end;

DROP PROCEDURE zmniejsz;
SELECT * FROM MAGAZYN;
begin
    zmniejsz();
end;





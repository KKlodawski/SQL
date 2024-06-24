--Zad1
DECLARE
    ile INTEGER;
BEGIN
    SELECT COUNT(*) INTO ile FROM EMP;
    dbms_output.put_line('W tabeli jest ' || ile || ' osob');
end;

SELECT * FROM emp;

--Zad2
DECLARE
    ile INTEGER;
BEGIN
    SELECT COUNT(*) INTO ile FROM EMP;
    if ile < 16 THEN
        INSERT INTO emp values (1111,'Kowalski','a',null,CURRENT_DATE,1500,0,20);
        DBMS_OUTPUT.PUT_LINE('Wstawiono użytkownika kowalski');
    else
        dbms_output.PUT_LINE('Nie wstawiono uzytkownika');
    end if;
end;

DELETE FROM emp WHERE empno = 1111;

--Zad3
CREATE PROCEDURE wstaw_do_dzialu
    (nr_dzialu IN VARCHAR2, nazwa IN VARCHAR2, lokalizacja IN VARCHAR2)
as
    counter INT;
BEGIN
    SELECT count(*) into counter FROM dept WHERE dept.DEPTNO = nr_dzialu OR dept.loc = lokalizacja;
    IF counter > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nie wstawiono rekordu');
    else
        INSERT INTO dept VALUES (nr_dzialu,nazwa, lokalizacja);
        DBMS_OUTPUT.PUT_LINE('Wstawiono rekord');
    end if;
end;
DROP PROCEDURE wstaw_do_dzialu;
SELECT * FROm dept;

BEGIN
    wstaw_do_dzialu(50,'ABC', 'WARSZAWA');
end;

--Zad4
CREATE PROCEDURE wstaw_prac
    (nr_dzialu IN INT, nazwisko IN VARCHAR2)
AS
    dzial INT;
    pensja INT;
    newEmpno INT;
BEGIN
    SELECT COUNT(*) INTO dzial FROM dept WHERE DEPTNO = nr_dzialu;
    if dzial = 1 THEN
        SELECT MIN(sal) INTO pensja FROM emp WHERE deptno = nr_dzialu;
        SELECT MAX(empno)+1 INTO newEmpno FROM emp;
        INSERT INTO emp VALUES (newEmpno,nazwisko,null,null,current_date,pensja,0, nr_dzialu);
    else
        RAISE_APPLICATION_ERROR(-20500,'Podany dział nie istnieje!');
    end if;
end;

SELECT * FROM emp;

BEGIN
    wstaw_prac(40,'Kowalski');
end;

--Zad5
SELECT * FROM magazyn;

CREATE TABLE magazyn (
    IdPozycji INT,
    Nazwa VARCHAR2(50),
    Ilosc INT,
    PRIMARY KEY (IdPozycji)
);

INSERT INTO magazyn VALUES (1,'A',50);
INSERT INTO magazyn VALUES (2,'B',10);
INSERT INTO magazyn VALUES (3,'C',5);
INSERT INTO magazyn VALUES (4,'D',40);
INSERT INTO magazyn VALUES (5,'E',33);
INSERT INTO magazyn VALUES (6,'F',101);
INSERT INTO magazyn VALUES (7,'G',101);

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

begin
    zmniejsz();
end;
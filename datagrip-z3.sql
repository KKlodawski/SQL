CREATE OR REPLACE TRIGGER zad1
BEFORE DELETE
ON emp
BEGIN
    raise_application_error(-20500,'Records cannot be deleted');
end;

SELECT * FROM emp;
DROP TRIGGER zad1;
DELETE FROM EMP WHERE empno = 7369;

--z2
CREATE TRIGGER Z2
BEFORE INSERT OR UPDATE OF sal
ON emp
FOR EACH ROW
BEGIN
   IF :NEW.sal <= 1000 THEN
       raise_application_error(-20500,'Za mala pensja');
   end if;

end;

INSERT INTO emp VALUES (1,'a','b',null,null,1700,null,10);
--Z3
CREATE TABLE budzet (wartosc INT NOT NULL);
INSERT INTO budzet (wartosc)
SELECT SUM(sal) FROM emp;
UPDATE emp SET sal = 1300 WHERE empno = 1;
SELECT * FROM budzet;

CREATE OR REPLACE TRIGGER Z3
    AFTER INSERT OR UPDATE OF SAL
    ON EMP
FOR EACH ROW
DECLARE tmp INT;
BEGIN
    tmp := nvl(:NEW.sal,0) - nvl(:OLD.sal,0);
    UPDATE budzet SET wartosc = wartosc + tmp;
end;
--Z4
CREATE TRIGGER Z4
    BEFORE DELETE OR UPDATE OF ename OR INSERT
    ON emp
FOR EACH ROW
    DECLARE tmp INT;
BEGIN
    IF DELETING AND :OLD.sal > 0 THEN
        raise_application_error(-20500,'Nie mo?na usun?? tego rekordu!');
    end if;
    IF UPDATING AND :OLD.ename != :NEW.ename THEN
        raise_application_error(-20500,'Nie mo?na modyfikowa? nazwisk pracowników!');
    end if;
    IF INSERTING THEN
        SELECT count(ename) into tmp FROM emp WHERE ename = :NEW.ename;
        IF tmp >= 1 THEN
            raise_application_error(-20500,'Taki pracownik ju? istnieje!');
        end if;
    end if;
end;
DROP TRIGGER Z4;
DELETE FROM emp WHERE EMPNO=1;
UPDATE emp SET ename = 'BBB' WHERE empno = 1;
INSERT INTO emp VALUES (2,'a','b',null,null,1700,null,10);

--Z5
CREATE OR REPLACE TRIGGER zad5
    BEFORE UPDATE OF SAL OR DELETE
    ON EMP
FOR EACH ROW
BEGIN
    IF UPDATING AND nvl(:NEW.sal,0)-nvl(:OLD.sal,0) < 0 THEN
        raise_application_error(-20500,'Nie mo?na zmniejsza? pensji!');
    end if;
    IF DELETING THEN
        raise_application_error(-20500,'Nie mo?na usuwa? pracowników!');
    end if;
end;
DROP TRIGGER zad5;
SELECT * FROM emp;
UPDATE emp SET sal = 2800 WHERE empno = 1;






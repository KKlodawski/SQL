CREATE OR REPLACE PROCEDURE lookup
    AS
    CURSOR stud IS (SELECT IDSTUDENTA, Imie, Nazwisko, NRINDEKSU FROM student WHERE rok = 2);
    srednia NUMBER;
    studid INT;
    IMIE Varchar2(32);
    NAZWISKO Varchar2(64);
    indeks VARCHAR2(10);

BEGIN
    OPEN stud;
    LOOP
        FETCH stud INTO studid, IMIE, NAZWISKO, indeks;

        SELECT avg(WARTOSC) into srednia FROM OCENA WHERE IDSTUDENTA = studid;
        if studid IS NOT NULL THEN
            dbms_output.PUT_LINE('Student ' || IMIE || ' ' || NAZWISKO || ' ' || indeks || ' ma średnią ocen: ' || srednia);

            if srednia < 2.5 THEN
                DELETE FROM OCENA WHERE IDSTUDENTA = studid;
                DELETE FROM STUDENT WHERE IDSTUDENTA = studid;
            end if;

        end if;

        studid := null;
        EXIT WHEN stud%NOTFOUND;
    end loop;

end;


CREATE OR REPLACE TRIGGER checkgrade
    BEFORE DELETE OR UPDATE OF IdStudenta, Przedmiot
    ON OCENA
FOR EACH ROW

BEGIN
    IF DELETING THEN
        raise_application_error(-20500, 'Nie można usuwać ocen!');
    end if;
    IF UPDATING AND :NEW.IdStudenta <> :OLD.IdStudenta OR :NEW.Przedmiot <> :OLD.Przedmiot THEN
        raise_application_error(-20500, 'Ocenom nie można zmieniać właściciela czy też nazwy przedmiotu!');
    end if;

end;
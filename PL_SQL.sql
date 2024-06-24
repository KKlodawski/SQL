CREATE TABLE TeamSummary
(
    teamName VARCHAR(20) NOT NULL,
    fullTeam VARCHAR(20) NOT NULL,
    reserve  INT         NOT NULL
);

CREATE TABLE TeamSize (
    Tsize INT
);
INSERT INTO TeamSize VALUES (0);
DROP TABLE TeamSummary;

-- Dodaje lub aktualizuje rekordy w tabeli TeamSummary
-- które pokazują czy dana drużyna ma cały zespół pozwalający przystąpić do zawodów (podany reqSize)
-- oraz ilość graczy rezerwowych
-- przy założeniu, że wszystkie osoby mają poprawnie wpisaną drużynę a każda drużyna ma założyciela i trenera
-- ( trener i założyciel mają wpisaną drużynę ale nie są brani pod uwagę przy wymaganiach)
CREATE OR REPLACE PROCEDURE podsumowanie_druzyn (reqSize INT)
AS
    CURSOR teams IS (SELECT nazwa, count(id_osoba)-2 FROM DRUZYNA INNER JOIN osoba ON druzyna.ID_DRUZYNY = osoba.DRUZYNA GROUP BY nazwa);
    name     VARCHAR(20);
    quantity INT;
    tmpSize INT;

BEGIN
    OPEN teams;
    UPDATE TeamSize SET Tsize = reqSize;
    LOOP
        FETCH teams INTO name,quantity;

        SELECT count(teamName) INTO tmpSize FROM TeamSummary WHERE teamName = name;
        IF tmpSize > 0 THEN
            IF quantity >= reqSize THEN
                UPDATE TeamSummary SET fullTeam = 'True', reserve = quantity - reqSize WHERE teamName = name;
            ELSE
                UPDATE TeamSummary SET fullTeam = 'False', reserve = 0 WHERE teamName = name;
            end if;
        ELSE
            IF quantity >= reqSize THEN
                INSERT INTO TeamSummary VALUES (name, 'True', quantity - reqSize);
            ELSE
                INSERT INTO TeamSummary VALUES (name, 'False', 0);
            end if;
        end if;

        EXIT WHEN teams%NOTFOUND;
    end loop;
end;

begin
    podsumowanie_druzyn(6);
end;

select *
from TEAMSUMMARY;

-- procedura sprawdza czy każda osoba ma ksywkę, jeżeli nie wpisuje ich ksywkę jako pierwszą literę imienia i nazwiska
-- oraz sprawdza czy osoba która nie na wpisanej drużyny jest założycielem lub trenerem jakiejś drużyny oraz uzupełnia rubrykę
CREATE OR REPLACE PROCEDURE fixNickAndTeam
AS
    CURSOR ppl IS (SELECT ID_OSOBA, imie,nazwisko,ksywka,druzyna FROM OSOBA);
    id INT;
    name VARCHAR(20);
    surname VARCHAR(20);
    nick VARCHAR(20);
    team INT;
    found INT;
BEGIN
    OPEN ppl;
    LOOP
        FETCH ppl INTO id,name,surname,nick,team;
        IF nick IS NULL OR nick = ' ' THEN
            UPDATE OSOBA SET KSYWKA = CONCAT(substr(name,1,1),substr(surname,1,1)) WHERE ID_OSOBA = id;
        end if;

        SELECT count(ID_DRUZYNY) INTO found FROM DRUZYNA WHERE TRENER = id OR ZALOZYCIEL = id;

        if found > 0 THEN
            SELECT ID_DRUZYNY INTO found FROM DRUZYNA WHERE TRENER = id OR ZALOZYCIEL = id;
        ELSE
            found := null;
        end if;

        if found IS NOT NULL THEN
            UPDATE OSOBA SET DRUZYNA = found WHERE ID_OSOBA = id;
        end if;

        EXIT WHEN ppl%NOTFOUND;
    end loop;

end;

begin
    fixNickAndTeam();
end;
SELECT * FROM osoba;
rollback;

--Trigger sprawdza czy nowo dodana osoba posiada ksywkę jeżeli nie ustawia ją na pierwszą literę imienia i nazwiska
CREATE OR REPLACE TRIGGER newMember
    BEFORE INSERT ON OSOBA
FOR EACH ROW
BEGIN
    if :NEW.Ksywka = null OR :NEW.Ksywka = ' ' THEN
        :NEW.Ksywka := CONCAT(substr(:NEW.Imie,1,1),substr(:NEW.Nazwisko,1,1));
    end if;
end;

INSERT INTO OSOBA VALUES (101,'ABC','BAC',' ',null,null);
SELECT * FROM osoba;


--Trigger sprawdza czy nowo dodany mecz znajduje się w odpowiednich dla turnieju ramach czasowych
-- oraz czy drużyna nie walczy na samą siebie
CREATE OR REPLACE TRIGGER newMatch
    BEFORE INSERT ON MECZE
FOR EACH ROW
    DECLARE
    beginDate DATE;
    endDate DATE;
BEGIN
    SELECT DATA_ROZPOCZECIA, DATA_ZAKONCZENIA INTO beginDate, endDate FROM TURNIEJ WHERE ID_TURNIEJU = :NEW.Turniej;
    If :NEW.DRUZYNA1 = :NEW.DRUZYNA2 THEN
        raise_application_error(-20500, 'W jednym meczu dana drużyna nie może walczyć ze samym sobą!');
    end if;

    if :NEW.Data < beginDate OR :NEW.Data > endDate THEN
        raise_application_error(-20500, 'Mecz musi odbyć się w ramach czasowych turnieju!');
    end if;
end;

SELECT * FROM turniej;
SELECT * FROM mecze;
INSERT INTO MECZE VALUES (10,1,2,1,'1:2','2022-04-01','TEST');



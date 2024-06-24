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


CREATE PROCEDURE podsumowanie 
	@reqSize INT
AS BEGIN
	DECLARE teams CURSOR FOR (SELECT nazwa, count(id_osoba)-2 FROM DRUZYNA INNER JOIN osoba ON druzyna.ID_DRUZYNY = osoba.DRUZYNA GROUP BY nazwa);
    DECLARE @name VARCHAR(20), @quantity INT, @tmpSize INT;
	UPDATE TeamSize SET Tsize = @reqSize;
    OPEN teams;
    FETCH NEXT FROM teams INTO @name, @quantity;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @tmpSize = count(teamName) FROM TeamSummary WHERE teamName = @name;
        IF @tmpSize > 0
            IF @quantity >= @reqSize 
                UPDATE TeamSummary SET fullTeam = 'True', reserve = @quantity - @reqSize WHERE teamName = @name;
            ELSE 
                UPDATE TeamSummary SET fullTeam = 'False', reserve = 0 WHERE teamName = @name;
        ELSE
            IF @quantity >= @reqSize
                INSERT INTO TeamSummary VALUES (@name, 'True', @quantity - @reqSize);
            ELSE
                INSERT INTO TeamSummary VALUES (@name, 'False', 0);
        FETCH NEXT FROM teams INTO @name, @quantity;
    END
    CLOSE teams;
    DEALLOCATE teams;
END

DROP PROCEDURE podsumowanie
SELECT * FROM TeamSummary;
SELECT nazwa, count(id_osoba)-2 FROM DRUZYNA INNER JOIN osoba ON druzyna.ID_DRUZYNY = osoba.DRUZYNA GROUP BY nazwa
EXEC podsumowanie 5;


CREATE PROCEDURE fixNickAndTeam

AS BEGIN
	DECLARE ppl CURSOR FOR (SELECT ID_OSOBA, imie,nazwisko,ksywka,druzyna FROM OSOBA);
	DECLARE @id INT, @name VARCHAR(20), @surname VARCHAR(20), @nick VARCHAR(20), @team INT, @found INT;
	
	OPEN ppl;
	FETCH NEXT FROM ppl INTO @id,@name,@surname,@nick,@team;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @nick IS NULL OR @nick = ' ' BEGIN
			UPDATE OSOBA SET KSYWKA = CONCAT(substring(@name,1,1),substring(@surname,1,1)) WHERE ID_OSOBA = @id;
		END

		SELECT @found = count(ID_DRUZYNY) FROM DRUZYNA WHERE TRENER = @id OR ZALOZYCIEL = @id;

		if @found > 0 BEGIN
			SELECT @found = ID_DRUZYNY FROM DRUZYNA WHERE TRENER = @id OR ZALOZYCIEL = @id;
		END
		ELSE BEGIN
			SET @found = null;
		END
    
		if @found IS NOT NULL BEGIN
			UPDATE OSOBA SET DRUZYNA = @found WHERE ID_OSOBA = @id;
		end
		FETCH NEXT FROM ppl INTO @id,@name,@surname,@nick,@team;
	END
	CLOSE ppl;
    DEALLOCATE ppl;
END

DROP PROCEDURE fixNickAndTeam;
EXEC fixNickAndTeam;
SELECT * FROM osoba;

CREATE TRIGGER newMember
	ON OSOBA
	FOR INSERT
AS BEGIN
	DECLARE @ksywka VARCHAR(20), @imie VARCHAR(20), @nazwisko VARCHAR(20), @id INT;
	SELECT @ksywka = ksywka, @imie = imie, @nazwisko = nazwisko, @id = Id_Osoba FROM INSERTED;
	if @ksywka = null OR @ksywka = ' ' BEGIN
		SET @ksywka = CONCAT(substring(@imie,1,1),substring(@nazwisko,1,1));
	END
	UPDATE OSOBA SET ksywka = @ksywka WHERE Id_OSOba = @id;
END

INSERT INTO OSOBA VALUES (101,'ABC','BAC',' ',null,null);
SELECT * FROM osoba;

CREATE TRIGGER newMatch
	ON MECZE
	FOR INSERT
AS BEGIN
	DECLARE @druzyna1 INT, @druzyna2 INT, @turniej INT, @data DATE;
	DECLARE @datarozp DATE, @datazakon DATE;

	SELECT @druzyna1 = druzyna1, @druzyna2 = druzyna2, @turniej = turniej, @data = data FROM INSERTED;
	SELECT @datarozp = DATA_ROZPOCZECIA, @datazakon = DATA_ZAKONCZENIA FROM Turniej WHERE Id_turnieju = @turniej;

	if @druzyna1 = @druzyna2 BEGIN
		ROLLBACK
		RAISERROR('W jednym meczu dana drużyna nie może walczyć ze samym sobą!',1,2);
	END

	if @data < @datarozp OR @data > @datazakon BEGIN
		ROLLBACK
		RAISERROR('Mecz musi odbyć się w ramach czasowych turnieju!',1,2);
	END
END
DROP TRIGGER newMatch;
INSERT INTO MECZE VALUES (11,1,2,1,'1:2','2022-01-20','TEST');
INSERT INTO MECZE VALUES (13,1,2,1,'1:2','2022-04-01','TEST');

SELECT * FROM MECZE;
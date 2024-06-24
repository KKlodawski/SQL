--Z1
CREATE PROCEDURE updatePrice 
AS 
DECLARE prices CURSOR FOR SELECT idKategoria , count(idkategoria) FROM rezerwacja
INNER JOIN pokoj ON rezerwacja.nrPokoju = pokoj.nrPokoju
GROUP BY idkategoria
DECLARE
@idkategoria INT,
@counts INT
OPEN prices 
FETCH NEXT FROM prices INTO @idkategoria,@counts
while @@FETCH_STATUS = 0
	BEGIN
		IF @counts >= 5
			BEGIN
				UPDATE kategoria SET cena = cena*1.1 WHERE IdKategoria = @idkategoria
			END
		IF @counts <= 0
			BEGIN
				UPDATE kategoria SET cena = cena*0.9 WHERE IdKategoria = @idkategoria
			END
		FETCH NEXT FROM prices INTO @idkategoria,@counts
	END
CLOSE prices
DEALLOCATE prices

--Z2
CREATE TRIGGER checkAvable
ON rezerwacja
FOR INSERT 
AS
DECLARE 
@dataOd DATE,
@dataDo DATE,
@nrpokoju INT
SELECT @dataDo = dataDo, @dataOd = dataOd, @nrpokoju = nrpokoju FROM inserted
	BEGIN
		IF EXISTS (SELECT idrezerwacja FROM rezerwacja WHERE 
		(dataod <= @dataDo AND datado >= @dataDo OR dataod <= @dataOd AND datado >= @dataOd) 
		AND NrPokoju = @nrpokoju )
			BEGIN
				ROLLBACK
				RAISERROR('Data rezerwacji jest już zajęta!',1,2)
			END
	END

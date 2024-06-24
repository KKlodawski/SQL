USE [2019SBD]

sp_help Rezerwacja

--1
SELECT * FROM gosc 
ORDER BY nazwisko, imie;
--2
SELECT DISTINCT Procent_rabatu FROM gosc
ORDER BY Procent_rabatu DESC;
--3
SELECT rezerwacja.* FROM rezerwacja
INNER JOIN gosc ON gosc.idgosc = rezerwacja.idgosc 
WHERE imie LIKE 'Ferdynand' AND nazwisko LIKE 'Kiepski';
--4
SELECT imie, nazwisko, nrpokoju FROM rezerwacja
INNER JOIN gosc ON gosc.idgosc = rezerwacja.idgosc 
WHERE Year(DataOd)=2008 AND nazwisko LIKE 'K%' or nazwisko LIKE 'L%';
--5
SELECT DISTINCT nrPokoju FROM rezerwacja
INNER JOIN gosc ON gosc.idgosc = rezerwacja.idgosc 
WHERE imie LIKE 'Andrzej' AND nazwisko LIKE 'Nowak';
--6
SELECT COUNT(nrpokoju),nazwa FROM pokoj
INNER JOIN kategoria ON pokoj.idkategoria = kategoria.idkategoria
GROUP BY nazwa
--7
SELECT * FROM gosc 
INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc 
UNION
SELECT idgosc, imie, nazwisko, procent_rabatu, NULL,NULL,NULL,NULL,NULL,NULL FROM gosc 
WHERE idgosc NOT IN (SELECT gosc.idgosc FROM gosc 
INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.idgosc )
--8
SELECT imie, nazwisko FROM rezerwacja
INNER JOIN gosc ON gosc.idgosc = rezerwacja.idgosc 
WHERE NrPokoju = 101 AND Zaplacona = 1
--9
SELECT Concat(nazwisko,' ',imie) AS dane FROM gosc